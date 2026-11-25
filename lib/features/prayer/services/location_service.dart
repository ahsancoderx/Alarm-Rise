import 'package:geolocator/geolocator.dart';
import '../../../core/utils/prayer_calc.dart';

/// GPS se location (internet nahi chahiye). Na mile to null.
Future<Coords?> getDeviceLocation() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      return null;
    }
    try {
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 20),
        ),
      );
      return Coords(p.latitude, p.longitude);
    } catch (_) {
      final p = await Geolocator.getLastKnownPosition();
      return p == null ? null : Coords(p.latitude, p.longitude);
    }
  } catch (_) {
    return null;
  }
}