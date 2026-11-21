import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseOverlay {
  final Pose pose;
  final Size imageSize;
  final InputImageRotation rotation;
  const PoseOverlay(this.pose, this.imageSize, this.rotation);
}

/// Jism ki lakeerein aur points camera ke upar. Android ke liye.
class PosePainter extends CustomPainter {
  final ValueListenable<PoseOverlay?> overlay;
  final CameraLensDirection lens;

  PosePainter(this.overlay, this.lens) : super(repaint: overlay);

  static const _links = <List<PoseLandmarkType>>[
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder],
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow],
    [PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow],
    [PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist],
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip],
    [PoseLandmarkType.leftHip, PoseLandmarkType.rightHip],
    [PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee],
    [PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle],
    [PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee],
    [PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle],
  ];

  static const _dots = <PoseLandmarkType>[
    PoseLandmarkType.nose,
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.leftElbow,
    PoseLandmarkType.rightElbow,
    PoseLandmarkType.leftWrist,
    PoseLandmarkType.rightWrist,
    PoseLandmarkType.leftHip,
    PoseLandmarkType.rightHip,
    PoseLandmarkType.leftKnee,
    PoseLandmarkType.rightKnee,
    PoseLandmarkType.leftAnkle,
    PoseLandmarkType.rightAnkle,
  ];

  double _x(double x, Size canvas, PoseOverlay o) {
    switch (o.rotation) {
      case InputImageRotation.rotation90deg:
        return x * canvas.width / o.imageSize.height;
      case InputImageRotation.rotation270deg:
        return canvas.width - x * canvas.width / o.imageSize.height;
      case InputImageRotation.rotation0deg:
      case InputImageRotation.rotation180deg:
        return lens == CameraLensDirection.back
            ? x * canvas.width / o.imageSize.width
            : canvas.width - x * canvas.width / o.imageSize.width;
    }
  }

  double _y(double y, Size canvas, PoseOverlay o) {
    switch (o.rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return y * canvas.height / o.imageSize.width;
      case InputImageRotation.rotation0deg:
      case InputImageRotation.rotation180deg:
        return y * canvas.height / o.imageSize.height;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final o = overlay.value;
    if (o == null) return;

    final line = Paint()
      ..color = const Color(0xFF22C55E)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final dot = Paint()..color = const Color(0xFFFF7A1A);

    Offset? point(PoseLandmarkType t) {
      final l = o.pose.landmarks[t];
      if (l == null || l.likelihood < 0.5) return null;
      return Offset(_x(l.x, size, o), _y(l.y, size, o));
    }

    for (final link in _links) {
      final a = point(link[0]);
      final b = point(link[1]);
      if (a != null && b != null) canvas.drawLine(a, b, line);
    }
    for (final t in _dots) {
      final p = point(t);
      if (p != null) canvas.drawCircle(p, 5, dot);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter old) => old.lens != lens;
}