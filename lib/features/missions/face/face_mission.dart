import 'dart:async';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/camera_input.dart';
import '../math_mission.dart';
import 'face_engine.dart';

class FaceMission extends StatefulWidget {
  final VoidCallback onSolved;
  const FaceMission({super.key, required this.onSolved});

  @override
  State<FaceMission> createState() => _FaceMissionState();
}

class _Hud {
  final FaceStep step;
  final double hold;
  final String instruction;
  final String warning;
  final String debug;
  const _Hud({
    required this.step,
    required this.hold,
    required this.instruction,
    this.warning = '',
    this.debug = '',
  });
}

class _FaceMissionState extends State<FaceMission> {
  static const _frameGapMs = 70; // ~14 frames per second
  static const _hudGapMs = 100;
  static const _darkLevel = 45; // 0 se 255
  static const _idleLimit = Duration(seconds: 60);
  static const _green = Color(0xFF16A34A);

  final FaceEngine _engine = FaceEngine();
  final FaceDetector _detector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.fast,
      minFaceSize: 0.2,
    ),
  );

  CameraController? _cam;
  CameraDescription? _camera;
  Timer? _idleTimer;
  DateTime _lastFrame = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastHud = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastProgress = DateTime.now();

  bool _busy = false;
  bool _finished = false;
  bool _cleaned = false;
  bool _showFallback = false;
  bool _useMath = false;
  String? _error;

  late _Hud _hud = _Hud(
    step: FaceStep.eyes,
    hold: 0,
    instruction: 'Starting camera...',
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
            step: _engine.step,
            hold: 0,
            instruction: _engine.instruction,
          ));
    } on CameraException catch (e) {
      _fail(e.code == 'CameraAccessDenied'
          ? 'Camera permission denied. Allow it in Settings or use math.'
          : 'Camera error: ${e.description ?? e.code}');
    } catch (_) {
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

  double _area(Face f) => f.boundingBox.width * f.boundingBox.height;

  String _fmt(double? v) => v == null ? '--' : v.toStringAsFixed(2);

  Future<void> _onFrame(CameraImage image) async {
    if (_busy || _finished) return;
    final now = DateTime.now();
    if (now.difference(_lastFrame).inMilliseconds < _frameGapMs) return;
    _busy = true;
    _lastFrame = now;

    try {
      final ctrl = _cam;
      final cam = _camera;
      if (ctrl == null || cam == null) return;
      final input = CameraInput.convert(image, ctrl, cam);
      if (input == null) return;

      final faces = await _detector.processImage(input);
      if (!mounted || _finished) return;

      if (faces.isEmpty) {
        _engine.lost();
        _publish(
          now,
          warning: CameraInput.brightness(image) < _darkLevel
              ? 'Too dark. Turn on a light.'
              : 'Show your face to the camera.',
        );
        return;
      }

      // Sab se bara chehra (jo camera ke sab se qareeb ho).
      final face = faces.reduce((a, b) => _area(a) >= _area(b) ? a : b);
      final meta = input.metadata!;
      final sideways = meta.rotation == InputImageRotation.rotation90deg ||
          meta.rotation == InputImageRotation.rotation270deg;
      final frameW = sideways ? meta.size.height : meta.size.width;
      final ratio = face.boundingBox.width / frameW;

      final debug = kDebugMode
          ? 'L ${_fmt(face.leftEyeOpenProbability)}  '
              'R ${_fmt(face.rightEyeOpenProbability)}  '
              'smile ${_fmt(face.smilingProbability)}  '
              'face ${(ratio * 100).round()}%'
          : '';

      if (ratio < 0.25) {
        _engine.lost();
        _publish(now, warning: 'Move a little closer.', debug: debug);
        return;
      }
      if (ratio > 0.9) {
        _engine.lost();
        _publish(now, warning: 'Move back a little.', debug: debug);
        return;
      }

      final frontal = (face.headEulerAngleY ?? 0).abs() <= 20 &&
          (face.headEulerAngleX ?? 0).abs() <= 25;

      final advanced = _engine.update(
        FaceFrame(
          left: face.leftEyeOpenProbability,
          right: face.rightEyeOpenProbability,
          smile: face.smilingProbability,
          frontal: frontal,
        ),
        now,
      );

      if (advanced) {
        HapticFeedback.mediumImpact();
        _lastProgress = now;
      }
      if (_engine.done) {
        _finish();
        return;
      }

      _publish(
        now,
        warning: frontal ? '' : 'Look straight at the camera.',
        debug: debug,
      );
    } catch (_) {
      // Ek kharab frame poori mission na roke.
    } finally {
      _busy = false;
    }
  }

  /// HUD sirf zaroorat par (ya har 100ms) update hota hai.
  void _publish(DateTime now, {String warning = '', String debug = ''}) {
    if (!mounted) return;
    final stepChanged = _engine.step != _hud.step;
    final warnChanged = warning != _hud.warning;
    if (!stepChanged &&
        !warnChanged &&
        now.difference(_lastHud).inMilliseconds < _hudGapMs) {
      return;
    }
    _lastHud = now;
    setState(() {
      if (stepChanged) _showFallback = false;
      _hud = _Hud(
        step: _engine.step,
        hold: _engine.hold,
        instruction: _engine.instruction,
        warning: warning,
        debug: debug,
      );
    });
  }

  Future<void> _finish() async {
    if (_finished) return;
    _finished = true;
    HapticFeedback.heavyImpact();
    if (mounted) {
      setState(() => _hud = _Hud(
            step: FaceStep.done,
            hold: 1,
            instruction: _engine.instruction,
          ));
    }
    await Future.delayed(const Duration(milliseconds: 800)); // nishan dikhao
    if (mounted) widget.onSolved();
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
    final h = _hud;
    final done = h.step == FaceStep.done;
    final ready = c != null && c.value.isInitialized;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (ready)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 440),
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
                        painter: _OvalPainter(
                          progress: h.hold,
                          color: done ? _green : AppColors.orange,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Center(child: _StepChips(current: h.step)),
                      ),
                      if (done)
                        Container(
                          color: _green.withValues(alpha: 0.35),
                          child: const Center(
                            child: Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: 96),
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
        const SizedBox(height: 12),
        Text(
          _error ?? h.instruction,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _error != null
                ? Colors.red.shade600
                : (done ? _green : AppColors.textPrimary),
          ),
        ),
        if (h.warning.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              h.warning,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.w700),
            ),
          ),
        if (h.debug.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              h.debug,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        if (_showFallback) ...[
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: _switchToMath,
            child: const Text('Camera not working? Solve math instead'),
          ),
        ],
      ],
    );
  }
}

class _StepChips extends StatelessWidget {
  final FaceStep current;
  const _StepChips({required this.current});

  static const _labels = ['Eyes', 'Blink', 'Smile'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _labels.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _chip(i),
          ),
      ],
    );
  }

  Widget _chip(int i) {
    final complete = current.index > i;
    final active = current.index == i;
    final bg = complete
        ? const Color(0xFF16A34A)
        : active
            ? AppColors.orange
            : Colors.black54;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (complete)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.check_rounded, size: 14, color: Colors.white),
            ),
          Text(
            _labels[i],
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Chehre ka oval guide aur uske gird progress ring.
class _OvalPainter extends CustomPainter {
  final double progress;
  final Color color;
  const _OvalPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.46),
      width: size.width * 0.72,
      height: size.height * 0.6,
    );

    final dim = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      Path()..addOval(rect),
    );
    canvas.drawPath(dim, Paint()..color = Colors.black.withValues(alpha: 0.35));

    canvas.drawOval(
      rect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white70,
    );

    if (progress > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round
          ..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OvalPainter old) =>
      old.progress != progress || old.color != color;
}