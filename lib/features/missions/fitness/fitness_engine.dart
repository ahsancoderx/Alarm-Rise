import 'dart:math' as math;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../../data/models/fitness_exercise.dart';

typedef Landmarks = Map<PoseLandmarkType, PoseLandmark>;

const double kMinLikelihood = 0.5;

class _P {
  final double x;
  final double y;
  const _P(this.x, this.y);
}

/// Ek frame ka naap. raw == null matlab jism theek se nazar nahi aaya.
class PoseFrame {
  final double? raw;
  final String hint;
  const PoseFrame(this.raw, this.hint);
}

PoseLandmark? _ok(Landmarks lm, PoseLandmarkType t) {
  final l = lm[t];
  return (l != null && l.likelihood >= kMinLikelihood) ? l : null;
}

/// Left/right mein se jo nazar aaye unka beech ka point.
_P? _mid(Landmarks lm, PoseLandmarkType a, PoseLandmarkType b) {
  final p = _ok(lm, a);
  final q = _ok(lm, b);
  if (p == null && q == null) return null;
  if (p == null) return _P(q!.x, q.y);
  if (q == null) return _P(p.x, p.y);
  return _P((p.x + q.x) / 2, (p.y + q.y) / 2);
}

class PoseAnalyzer {
  static PoseFrame read(FitnessExercise ex, Landmarks lm) {
    switch (ex) {
      case FitnessExercise.squats:
        return _readSquat(lm);
      case FitnessExercise.jumpingJacks:
        return _readJack(lm);
      case FitnessExercise.pushUps:
        return _readPushUp(lm);
    }
  }

  /// Squat: kamar se takhne tak ki vertical doori (neeche jane par ghatti hai).
  static PoseFrame _readSquat(Landmarks lm) {
    final hip = _mid(lm, PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
    final ankle =
        _mid(lm, PoseLandmarkType.leftAnkle, PoseLandmarkType.rightAnkle);
    if (hip == null || ankle == null) {
      return const PoseFrame(
          null, 'Step back until your hips and feet are visible.');
    }
    final h = ankle.y - hip.y;
    if (h <= 0) {
      return const PoseFrame(null, 'Stand upright, facing the phone.');
    }
    return PoseFrame(h, 'OK');
  }

  /// Jumping jack: kalai kandhe se kitni oonchi, dhar ki lambai ke muqable.
  static PoseFrame _readJack(Landmarks lm) {
    final sh = _mid(
        lm, PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
    final hip = _mid(lm, PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
    if (sh == null || hip == null) {
      return const PoseFrame(
          null, 'Step back so your arms and body are visible.');
    }
    final dx = sh.x - hip.x;
    final dy = sh.y - hip.y;
    final torso = math.sqrt(dx * dx + dy * dy);
    if (torso < 20) {
      return const PoseFrame(null, 'Move closer or step back a little.');
    }

    final values = <double>[];
    const sides = [
      [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftWrist],
      [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightWrist],
    ];
    for (final side in sides) {
      final s = _ok(lm, side[0]);
      final w = _ok(lm, side[1]);
      if (s != null && w != null) values.add((s.y - w.y) / torso);
    }
    if (values.isEmpty) {
      return const PoseFrame(null, 'Show your arms to the camera.');
    }
    return PoseFrame(values.reduce((a, b) => a + b) / values.length, 'OK');
  }

  /// Push-up: kandhe se kalai tak vertical doori (neeche jane par ghatti hai).
  static PoseFrame _readPushUp(Landmarks lm) {
    double? best;
    var bestScore = 0.0;
    const sides = [
      [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftWrist],
      [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightWrist],
    ];
    for (final side in sides) {
      final s = lm[side[0]];
      final w = lm[side[1]];
      if (s == null || w == null) continue;
      final score = math.min(s.likelihood, w.likelihood);
      if (score >= kMinLikelihood && score > bestScore) {
        bestScore = score;
        best = w.y - s.y;
      }
    }
    if (best == null) {
      return const PoseFrame(null,
          'Place the phone to your side so your shoulder and hand are visible.');
    }
    return PoseFrame(best, 'OK');
  }
}

/// Calibration, smoothing aur rep counting.
class RepEngine {
  static const calibrationFrames = 20;

  final FitnessExercise ex;
  RepEngine(this.ex);

  final List<double> _samples = [];
  double _baseline = 1;
  bool calibrated = false;
  bool _armed = false;
  bool _active = false;
  double? _smoothed;
  DateTime? _lastRep;

  int count = 0;
  double progress = 0;

  bool get _isJack => ex == FitnessExercise.jumpingJacks;

  double get calibrationProgress =>
      calibrated ? 1 : _samples.length / calibrationFrames;

  String get phaseLabel => !calibrated
      ? 'calibrating'
      : !_armed
          ? 'waiting'
          : _active
              ? 'active'
              : 'rest';

  String get hint {
    if (!calibrated) {
      return '${ex.startPose}... ${(calibrationProgress * 100).round()}%';
    }
    if (!_armed) return 'Get ready: ${ex.startPose}';
    return _active ? 'Good! Now return to the start' : 'Keep going!';
  }

  /// Jism frame se gayab hua.
  void lost() {
    _smoothed = null;
    if (!calibrated) _samples.clear();
  }

  void _calibrate(double raw) {
    _samples.add(raw);
    if (_samples.length > calibrationFrames) _samples.removeAt(0);
    if (_samples.length < calibrationFrames) return;

    final sorted = [..._samples]..sort();
    final median = sorted[sorted.length ~/ 2];
    final range = sorted.last - sorted.first;

    final bool stable = _isJack
        ? range <= 0.25 && median <= ex.restAt + 0.2 // bazu neeche, hilte nahi
        : median > 0 && range <= median * 0.10; // 10% se kam hilna

    if (!stable) return;
    _baseline = median;
    calibrated = true;
    _samples.clear();
  }

  /// Nayi rep poori hui to true.
  bool update(double raw, DateTime now) {
    if (!calibrated) {
      _calibrate(raw);
      return false;
    }

    final p = _isJack ? raw : 1 - raw / _baseline;
    final s = _smoothed = _smoothed == null ? p : _smoothed! * 0.3 + p * 0.7;
    progress = s;

    final atRest = s <= ex.restAt;
    final atActive = s >= ex.activeAt;

    if (!_armed) {
      if (atRest) _armed = true;
      return false;
    }
    if (!_active) {
      if (atActive) {
        _active = true;
      } else if (atRest && !_isJack) {
        // Aaram ke waqt baseline dheere dheere update (thora aage peeche hone par)
        _baseline = _baseline * 0.97 + raw * 0.03;
      }
      return false;
    }
    if (!atRest) return false;

    _active = false;
    final last = _lastRep;
    if (last != null && now.difference(last).inMilliseconds < ex.minRepMs) {
      return false; // bohat tez: rep nahi gini
    }
    _lastRep = now;
    count++;
    return true;
  }
}