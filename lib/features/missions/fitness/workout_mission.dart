import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/fitness_exercise.dart';
import '../math_mission.dart';
import 'fitness_engine.dart';

class WorkoutMission extends StatefulWidget {
  final FitnessExercise exercise;
  final int reps;
  final VoidCallback onSolved;

  const WorkoutMission({
    super.key,
    required this.exercise,
    required this.reps,
    required this.onSolved,
  });

  @override
  State<WorkoutMission> createState() => _WorkoutMissionState();
}

class _WorkoutMissionState extends State<WorkoutMission> {
  static const _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };
  static const _idleLimit = Duration(seconds: 45);
  static const _frameGapMs = 80; // ~12 frames per second

  late final RepCounter _counter = RepCounter(widget.exercise);
  final PoseDetector _detector = PoseDetector(
    options: PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
      model: PoseDetectionModel.base,
    ),
  );

  CameraController? _cam;
  CameraDescription? _camera;
  Timer? _idleTimer;
  DateTime _lastFrame = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastProgress = DateTime.now();

  bool _busy = false;
  bool _finished = false;
  bool _cleaned = false;
  bool _showFallback = false;
  bool _useMath = false;

  int _count = 0;
  int? _angle;
  String _hint = 'Starting camera...';
  bool _hintOk = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _idleTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_finished &&
          !_showFallback &&
          DateTime.now().difference(_lastProgress) >= _idleLimit) {
        setState(() => _showFallback = true);
      }
    });
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cams = await availableCameras();
      if (cams.isEmpty) {
        _fail('No camera found on this phone.');
        return;
      }
      final cam = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cams.first,
      );
      final c = CameraController(
        cam,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );
      await c.initialize();
      if (!mounted || _finished) {
        await c.dispose();
        return;
      }
      _cam = c;
      _camera = cam;
      await c.startImageStream(_onFrame);
      _lastProgress = DateTime.now();
      setState(() => _hint = 'Get into the start position: ${widget.exercise.startPose}');
    } on CameraException catch (e) {
      _fail(e.code == 'CameraAccessDenied'
          ? 'Camera permission denied. Allow it in Settings or use math.'
          : 'Camera error: ${e.description ?? e.code}');
    } catch (e) {
      _fail('Could not start the camera.');
    }
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _error = message;
      _showFallback = true;
    });
  }

  InputImage? _toInputImage(CameraImage image) {
    final cam = _camera;
    final ctrl = _cam;
    if (cam == null || ctrl == null) return null;

    var comp = _orientations[ctrl.value.deviceOrientation];
    if (comp == null) return null;
    comp = cam.lensDirection == CameraLensDirection.front
        ? (cam.sensorOrientation + comp) % 360
        : (cam.sensorOrientation - comp + 360) % 360;

    final rotation = InputImageRotationValue.fromRawValue(comp);
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (rotation == null ||
        format != InputImageFormat.nv21 ||
        image.planes.length != 1) {
      return null;
    }
        final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format!,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  Future<void> _onFrame(CameraImage image) async {
    if (_busy || _finished) return;
    final now = DateTime.now();
    if (now.difference(_lastFrame).inMilliseconds < _frameGapMs) return;
    _busy = true;
    _lastFrame = now;

    try {
      final input = _toInputImage(image);
      if (input == null) return;

      final poses = await _detector.processImage(input);
      if (!mounted || _finished) return;

      if (poses.isEmpty) {
        _counter.lost();
        _status(angle: null, hint: 'No person detected. Step into the frame.', ok: false);
        return;
      }

      final reading = PoseAnalyzer.read(widget.exercise, poses.first.landmarks);
      final signal = reading.signal;
      if (signal == null) {
        _counter.lost();
        _status(angle: null, hint: reading.hint, ok: false);
        return;
      }

      if (_counter.update(signal, now)) {
        HapticFeedback.mediumImpact();
        _lastProgress = now;
        if (_showFallback && mounted) setState(() => _showFallback = false);
      }

      _status(
        angle: kDebugMode ? signal.round() : null,
        hint: _counter.armed
            ? 'Keep going!'
            : 'Get into the start position: ${widget.exercise.startPose}',
        ok: _counter.armed,
      );

      if (_counter.count >= widget.reps) _finish();
    } catch (_) {
      // Ek kharab frame poori workout na roke.
    } finally {
      _busy = false;
    }
  }

  /// Sirf badalne par rebuild (performance).
  void _status({required int? angle, required String hint, required bool ok}) {
    if (!mounted) return;
    final count = _counter.count;
    if (count == _count && angle == _angle && hint == _hint && ok == _hintOk) {
      return;
    }
    setState(() {
      _count = count;
      _angle = angle;
      _hint = hint;
      _hintOk = ok;
    });
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    if (mounted) setState(() => _count = _counter.count);
    HapticFeedback.heavyImpact();
    widget.onSolved();
  }

  void _switchToMath() {
    _finished = true;
    _cleanup();
    setState(() => _useMath = true);
  }

  Future<void> _cleanup() async {
    if (_cleaned) return;
    _cleaned = true;
    final c = _cam;
    _cam = null;
    try {
      if (c != null) {
        if (c.value.isStreamingImages) await c.stopImageStream();
        await c.dispose();
      }
      await _detector.close();
    } catch (_) {}
  }

  @override
  void dispose() {
    _finished = true;
    _idleTimer?.cancel();
    _cleanup();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_useMath) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Camera skipped. Solve 5 questions instead.',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 16),
          MathMission(total: 5, onSolved: widget.onSolved),
        ],
      );
    }

    final c = _cam;
    final e = widget.exercise;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text(e.title,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600)),
                Text('$_count / ${widget.reps}',
                    style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        height: 1.1)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: (_count / widget.reps).clamp(0.0, 1.0),
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
          color: AppColors.orange,
          backgroundColor: AppColors.border,
        ),
        const SizedBox(height: 14),
        if (c != null && c.value.isInitialized)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 360),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 1 / c.value.aspectRatio,
                  child: CameraPreview(c),
                ),
              ),
            ),
          )
        else if (_error == null)
          const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          ),
        const SizedBox(height: 12),
        Text(
          _error ?? _hint,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _error != null
                ? Colors.red.shade600
                : (_hintOk ? const Color(0xFF16A34A) : AppColors.orange),
          ),
        ),
        if (_angle != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Angle: $_angle°   (rest ${e.restIsHigh ? "≥" : "≤"}${e.restAngle.round()}, '
              'active ${e.restIsHigh ? "≤" : "≥"}${e.activeAngle.round()})',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
        const SizedBox(height: 6),
        Text(
          e.tip,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        if (_showFallback) ...[
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _switchToMath,
            child: const Text('Camera not working? Solve math instead'),
          ),
        ],
      ],
    );
  }
}