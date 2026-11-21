import 'package:flutter/services.dart';

class AudioControl {
  static const _channel = MethodChannel('risequest/audio');

  /// 0.0 = mute, 1.0 = full. Vibration par asar nahi parta.
  static Future<bool> setAlarmVolume(double volume) async {
    try {
      return await _channel
              .invokeMethod<bool>('setAlarmVolume', {'volume': volume}) ??
          false;
    } catch (_) {
      return false;
    }
  }
}