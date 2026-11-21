import 'dart:async';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/fitness_exercise.dart';
import '../math_mission.dart';
import 'fitness_engine.dart';
import 'pose_painter.dart';

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

class _Hud {
  final int count;
  final String hint;
  final bool good;
  final double calibration;
  final String debug;
  const _Hud({
    required this.count,
    required this.hint,
    required this.good,
    required this.calibration,
    required this.debug,
  });
}

class _WorkoutMissionState extends State<WorkoutMission> {
  static const _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };
  static const _idleLimit = Duration(seconds: 60);
  static const _frameGapMs = 60; // ~15 frames per second
  static const _hudGapMs = 150;
  static const _darkLevel = 45; // 0 se 255

  late final RepEngine _engine = RepEngine(widget.exercise);
  final PoseDetector _detector = PoseDetector(
    options: PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
      model: PoseDetectionModel.base,
    ),
  );
  final ValueNotifier<PoseOverlay?> _overlay = ValueNotifier(null);

  CameraController? _cam;
  CameraDescription? _camera;
  Timer? _idleTimer;
  Timer? _fpsTimer;
  final DateTime _epoch = DateTime.fromMillisecondsSinceEpoch(0);
  late DateTime _lastFrame = _epoch;
  late DateTime _lastHud = _epoch;
  DateTime _lastProgress = DateTime.now();

  bool _busy = false;
  bool _finished = false;
  bool _cleaned = false;
  bool _showFallback = false;
  bool _useMath = false;
  int _fpsCount = 0;
  int _fps = 0;
  String? _error;

  _Hud _hud = const _Hud(
    count: 0,
    hint: 'Starting camera...',
    good: false,
    calibration: 0,
    debug: '',
  );

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
    _fpsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _fps = _fpsCount;
      _fpsCount = 0;
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
      setState(() => _hud = _Hud(
            count: 0,
            hint: widget.exercise.startPose,
            good: false,
            calibration: 0,
            debug: '',
          ));
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
    // `format == null` check lets Dart promote `format` to non-nullable below.
    if (rotation == null ||
        format == null ||
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
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  /// Frame ki roshni 0 se 255 (sirf kuch pixels dekh kar, tez).
  double _brightness(CameraImage image) {
    final bytes = image.planes.first.bytes;
    final n = math.min(bytes.length, image.width * image.height);
    var sum = 0;
    var cnt = 0;
    for (var i = 0; i < n; i += 97) {
      sum += bytes[i];
      cnt++;
    }
    return cnt == 0 ? 255 : sum / cnt;
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
      _fpsCount++;

      if (poses.isEmpty) {
        _overlay.value = null;
        _engine.lost();
        _publish(
          now,
          hint: _brightness(image) < _darkLevel
              ? 'Too dark. Turn on a light.'
              : 'No person detected. Step into the frame.',
          good: false,
        );
        return;
      }

      // ML Kit ek waqt mein sab se numaya insan hi deta hai.
      final pose = poses.first;
      final meta = input.metadata!;
      _overlay.value = PoseOverlay(pose, meta.size, meta.rotation);

      final frame = PoseAnalyzer.read(widget.exercise, pose.landmarks);
      final raw = frame.raw;
      if (raw == null) {
        _engine.lost();
        _publish(
          now,
          hint: _brightness(image) < _darkLevel
              ? 'Too dark. Turn on a light.'
              : frame.hint,
          good: false,
        );
        return;
      }

      final wasCalibrated = _engine.calibrated;
      if (_engine.update(raw, now)) {
        HapticFeedback.mediumImpact();
        _lastProgress = now;
      }
      if (!wasCalibrated && _engine.calibrated) {
        HapticFeedback.lightImpact();
        _lastProgress = now;
      }

      _publish(now, hint: _engine.hint, good: _engine.calibrated);
      if (_engine.count >= widget.reps) _finish();
    } catch (_) {
      // Ek kharab frame poori workout na roke.
    } finally {
      _busy = false;
    }
  }

  /// HUD sirf zaroorat par (ya har 150ms) update hota hai.
  void _publish(DateTime now, {required String hint, required bool good}) {
    if (!mounted) return;
    final count = _engine.count;
    final changed =
        count != _hud.count || hint != _hud.hint || good != _hud.good;
    if (!changed && now.difference(_lastHud).inMilliseconds < _hudGapMs) {
      return;
    }
    _lastHud = now;
    final e = widget.exercise;

    setState(() {
      if (count != _hud.count) _showFallback = false;
      _hud = _Hud(
        count: count,
        hint: hint,
        good: good,
        calibration: _engine.calibrationProgress,
        debug: kDebugMode
            ? '${_engine.phaseLabel}   p=${_engine.progress.toStringAsFixed(2)}'
                '   (rest ≤${e.restAt}, active ≥${e.activeAt})   $_fps fps'
            : '',
      );
    });
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    if (mounted) {
      setState(() => _hud = _Hud(
            count: _engine.count,
            hint: 'Done!',
            good: true,
            calibration: 1,
            debug: '',
          ));
    }
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
    _fpsTimer?.cancel();
    _cleanup();
    _overlay.dispose();
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
    final cam = _camera;
    final e = widget.exercise;
    final h = _hud;
    final ready = c != null && cam != null && c.value.isInitialized;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (ready)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 420),
            child: Center(
              child: AspectRatio(
                aspectRatio: 1 / c.value.aspectRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CameraPreview(c),
                      CustomPaint(
                        painter: PosePainter(_overlay, cam.lensDirection),
                      ),
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: _CounterBadge(
                            label: e.title,
                            count: h.count,
                            total: widget.reps,
                          ),
                        ),
                      ),
                      if (h.calibration < 1)
                        Positioned(
                          bottom: 18,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: _CalibrationPill(progress: h.calibration),
                          ),
                        ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: LinearProgressIndicator(
                          value: (h.count / widget.reps).clamp(0.0, 1.0),
                          minHeight: 8,
                          color: AppColors.orange,
                          backgroundColor: Colors.black26,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        else if (_error == null)
          const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          ),
        const SizedBox(height: 10),
        Text(
          _error ?? h.hint,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _error != null
                ? Colors.red.shade600
                : (h.good ? const Color(0xFF16A34A) : AppColors.orange),
          ),
        ),
        if (h.debug.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              h.debug,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          e.tip,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        if (_showFallback) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _switchToMath,
            child: const Text('Camera not working? Solve math instead'),
          ),
        ],
      ],
    );
  }
}

class _CounterBadge extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  const _CounterBadge(
      {required this.label, required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          Text('$count / $total',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  height: 1.1)),
        ],
      ),
    );
  }
}

class _CalibrationPill extends StatelessWidget {
  final double progress;
  const _CalibrationPill({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              value: progress == 0 ? null : progress,
              strokeWidth: 3,
              color: AppColors.orange,
              backgroundColor: Colors.white24,
            ),
          ),
          const SizedBox(width: 10),
          const Text('Hold still...',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
        ],
      ),
    );
  }
}