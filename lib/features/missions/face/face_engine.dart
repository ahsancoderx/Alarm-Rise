import 'dart:math' as math;

enum FaceStep { eyes, blink, smile, done }

/// Ek frame ka naap (ML Kit ke probabilities, 0 se 1).
class FaceFrame {
  final double? left;
  final double? right;
  final double? smile;
  final bool frontal;
  const FaceFrame({this.left, this.right, this.smile, this.frontal = true});

  /// Dono aankhein khuli: kamzor aankh ka score.
  double? get eyesOpen =>
      (left == null || right == null) ? null : math.min(left!, right!);

  /// Dono aankhein band: mazboot aankh ka score bhi kam ho.
  double? get eyesClosed =>
      (left == null || right == null) ? null : math.max(left!, right!);
}

class FaceEngine {
  // --- Tuning yahan ---
  static const openAt = 0.6; // isse zyada = aankh khuli
  static const closedAt = 0.3; // isse kam = aankh band
  static const smileAt = 0.7; // isse zyada = muskurahat
  static const eyesHold = Duration(milliseconds: 2500);
  static const closedHold = Duration(milliseconds: 400);
  static const smileHold = Duration(milliseconds: 2000);
  static const grace = Duration(milliseconds: 350); // chhoti galti maaf
  // --------------------

  FaceStep step = FaceStep.eyes;
  double hold = 0; // 0 se 1, mojooda step ka progress

  DateTime? _holdStart;
  DateTime? _badSince;
  DateTime? _closedStart;
  bool _sawClosed = false;

  bool get done => step == FaceStep.done;

  String get instruction {
    switch (step) {
      case FaceStep.eyes:
        return 'Open your eyes wide and look at the camera';
      case FaceStep.blink:
        return _sawClosed
            ? 'Now open your eyes'
            : 'Close your eyes for a second';
      case FaceStep.smile:
        return 'Now smile!';
      case FaceStep.done:
        return "You're awake!";
    }
  }

  /// Chehra frame se gayab hua.
  void lost() {
    _holdStart = null;
    _badSince = null;
    if (step != FaceStep.blink) hold = 0;
  }

  void _advance(FaceStep next) {
    step = next;
    hold = 0;
    _holdStart = null;
    _badSince = null;
    _closedStart = null;
    _sawClosed = false;
  }

  /// Step badla to true.
  bool update(FaceFrame f, DateTime now) {
    switch (step) {
      case FaceStep.eyes:
        return _holdStep(
          good: f.frontal && (f.eyesOpen ?? 0) >= openAt,
          need: eyesHold,
          now: now,
          next: FaceStep.blink,
        );
      case FaceStep.blink:
        return _blinkStep(f, now);
      case FaceStep.smile:
        return _holdStep(
          good: f.frontal &&
              (f.smile ?? 0) >= smileAt &&
              (f.eyesOpen ?? 0) >= 0.4, // aankhein khuli rahen
          need: smileHold,
          now: now,
          next: FaceStep.done,
        );
      case FaceStep.done:
        return false;
    }
  }

  bool _holdStep({
    required bool good,
    required Duration need,
    required DateTime now,
    required FaceStep next,
  }) {
    if (good) {
      _badSince = null;
      _holdStart ??= now;
      final ms = now.difference(_holdStart!).inMilliseconds;
      hold = (ms / need.inMilliseconds).clamp(0.0, 1.0);
      if (ms >= need.inMilliseconds) {
        _advance(next);
        return true;
      }
      return false;
    }
    _badSince ??= now;
    if (now.difference(_badSince!) > grace) {
      _holdStart = null;
      _badSince = null;
      hold = 0;
    }
    return false;
  }

  bool _blinkStep(FaceFrame f, DateTime now) {
    final closed = (f.eyesClosed ?? 1) <= closedAt;
    final open = (f.eyesOpen ?? 0) >= openAt;

    if (!_sawClosed) {
      if (closed) {
        _closedStart ??= now;
        final ms = now.difference(_closedStart!).inMilliseconds;
        hold = (ms / closedHold.inMilliseconds).clamp(0.0, 1.0);
        if (ms >= closedHold.inMilliseconds) {
          _sawClosed = true;
          hold = 1;
        }
      } else {
        _closedStart = null;
        hold = 0;
      }
      return false;
    }

    if (open) {
      _advance(FaceStep.smile);
      return true;
    }
    return false;
  }
}