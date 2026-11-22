import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class CameraInput {
  static const _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  static InputImage? convert(
    CameraImage image,
    CameraController ctrl,
    CameraDescription cam,
  ) {
    var comp = _orientations[ctrl.value.deviceOrientation];
    if (comp == null) return null;
    comp = cam.lensDirection == CameraLensDirection.front
        ? (cam.sensorOrientation + comp) % 360
        : (cam.sensorOrientation - comp + 360) % 360;

    final rotation = InputImageRotationValue.fromRawValue(comp);
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
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

  /// Frame ki roshni, 0 se 255 (kuch pixels dekh kar, tez).
  static double brightness(CameraImage image) {
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
}