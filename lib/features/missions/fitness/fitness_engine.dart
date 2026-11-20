import 'dart:math' as math;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../../data/models/fitness_exercise.dart';

/// b par a-b-c ka angle (degrees). Rotation se farq nahi parta.
double angleAt(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
  final r =
      math.atan2(c.y - b.y, c.x - b.x) - math.atan2(a.y - b.y, a.x - b.x);
  var deg = (r * 180 / math.pi).abs();
  if (deg > 180) deg = 360 - deg;
  return deg;
}

class PoseReading {
  final double? signal; // null = jism theek se nahi dikha
  final String hint;
  const PoseReading(this.signal, this.hint);
}

class PoseAnalyzer {
  static const minLikelihood = 0.5;

  static const _legLeft = [
    PoseLandmarkType.leftHip,
    PoseLandmarkType.leftKnee,
    PoseLandmarkType.leftAnkle,
  ];
  static const _legRight = [
    PoseLandmarkType.rightHip,
    PoseLandmarkType.rightKnee,
    PoseLandmarkType.rightAnkle,
  ];
  static const _armLeft = [
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.leftElbow,
    PoseLandmarkType.leftWrist,
  ];
  static const _armRight = [
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightElbow,
    PoseLandmarkType.rightWrist,
  ];
  static const _raiseLeft = [
    PoseLandmarkType.leftHip,
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.leftWrist,
  ];
  static const _raiseRight = [
    PoseLandmarkType.rightHip,
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightWrist,
  ];

  static PoseReading read(
    FitnessExercise ex,
    Map<PoseLandmarkType, PoseLandmark> lm,
  ) {
    switch (ex) {
      case FitnessExercise.squats:
        return _bestSide(lm, _legLeft, _legRight,
            'Step back until your hips, knees and feet are visible.');
      case FitnessExercise.pushUps:
        return _bestSide(lm, _armLeft, _armRight,
            'Place the phone to your side so your arm and body are visible.');
      case FitnessExercise.jumpingJacks:
        return _bothArms(lm);
    }
  }

  static double _score(
      Map<PoseLandmarkType, PoseLandmark> lm, List<PoseLandmarkType> types) {
    var m = 1.0;
    for (final t in types) {
      final l = lm[t];
      if (l == null) return 0;
      m = math.min(m, l.likelihood);
    }
    return m;
  }

  /// Jis taraf (left/right) ke points zyada saaf hon, usay lo.
  static PoseReading _bestSide(
    Map<PoseLandmarkType, PoseLandmark> lm,
    List<PoseLandmarkType> left,
    List<PoseLandmarkType> right,
    String missing,
  ) {
    final ls = _score(lm, left);
    final rs = _score(lm, right);
    if (math.max(ls, rs) < minLikelihood) return PoseReading(null, missing);
    final t = ls >= rs ? left : right;
    return PoseReading(angleAt(lm[t[0]]!, lm[t[1]]!, lm[t[2]]!), 'OK');
  }

  /// Bazu kitne upar hain (kandhe par angle). Dono taraf ka average.
  static PoseReading _bothArms(Map<PoseLandmarkType, PoseLandmark> lm) {
    final angles = <double>[];
    for (final t in [_raiseLeft, _raiseRight]) {
      if (_score(lm, t) >= minLikelihood) {
        angles.add(angleAt(lm[t[0]]!, lm[t[1]]!, lm[t[2]]!));
      }
    }
    if (angles.isEmpty) {
      return const PoseReading(
          null, 'Step back so your arms and body are visible.');
    }
    return PoseReading(angles.reduce((a, b) => a + b) / angles.length, 'OK');
  }
}

/// Angle ki stream se reps ginta hai: aaram, harkat, wapas aaram = 1 rep.
class RepCounter {
  final FitnessExercise exercise;
  RepCounter(this.exercise);

  int count = 0;
  bool _armed = false; // pehle aaram ki haalat dekhni zaroori hai
  bool _active = false;
  double? _smoothed;
  DateTime? _lastRep;

  bool get armed => _armed;

  /// Jism frame se gayab hua: smoothing reset.
  void lost() => _smoothed = null;

  /// Nayi rep poori hui to true.
  bool update(double raw, DateTime now) {
    final s = _smoothed = _smoothed == null ? raw : _smoothed! * 0.5 + raw * 0.5;
    final high = exercise.restIsHigh;
    final atRest =
        high ? s >= exercise.restAngle : s <= exercise.restAngle;
    final atActive =
        high ? s <= exercise.activeAngle : s >= exercise.activeAngle;

    if (!_armed) {
      if (atRest) _armed = true;
      return false;
    }
    if (!_active) {
      if (atActive) _active = true;
      return false;
    }
    if (!atRest) return false;

    _active = false;
    final last = _lastRep;
    if (last != null &&
        now.difference(last).inMilliseconds < exercise.minRepMs) {
      return false; // bohat tez: rep nahi gini
    }
    _lastRep = now;
    count++;
    return true;
  }
}