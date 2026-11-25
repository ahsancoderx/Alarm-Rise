import 'dart:math' as math;

class Coords {
  final double lat;
  final double lng;
  const Coords(this.lat, this.lng);
}

enum PrayerMethod {
  ummAlQura('Umm al-Qura (Saudi Arabia)', 18.5, 0, 90),
  dubai('UAE', 18.2, 18.2, 0),
  kuwait('Kuwait', 18, 17.5, 0),
  qatar('Qatar', 18, 0, 90),
  karachi('Karachi (Pakistan, India)', 18, 18, 0),
  mwl('Muslim World League (UK, Europe)', 18, 17, 0),
  isna('ISNA (USA, Canada)', 15, 15, 0),
  egyptian('Egyptian', 19.5, 17.5, 0);

  final String label;
  final double fajrAngle;
  final double ishaAngle;
  final int ishaMinutes; // 0 ho to angle istemal hota hai
  const PrayerMethod(
      this.label, this.fajrAngle, this.ishaAngle, this.ishaMinutes);
}

class PrayerTimesDay {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  const PrayerTimesDay({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });
}

String fmtClock(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final m = d.minute.toString().padLeft(2, '0');
  return '$h:$m ${d.hour < 12 ? 'AM' : 'PM'}';
}

double distanceKm(Coords a, Coords b) {
  double r(double d) => d * math.pi / 180;
  final dLat = r(b.lat - a.lat);
  final dLng = r(b.lng - a.lng);
  final h = math.pow(math.sin(dLat / 2), 2) +
      math.cos(r(a.lat)) *
          math.cos(r(b.lat)) *
          math.pow(math.sin(dLng / 2), 2);
  return 2 * 6371.0 * math.asin(math.sqrt(h.toDouble()));
}

// ---------- andar ke helpers ----------

double _rad(double d) => d * math.pi / 180;
double _deg(double r) => r * 180 / math.pi;
double _sin(double d) => math.sin(_rad(d));
double _cos(double d) => math.cos(_rad(d));
double _tan(double d) => math.tan(_rad(d));

double _fix(double a, double m) {
  a = a - m * (a / m).floorToDouble();
  return a < 0 ? a + m : a;
}

double _julian(int year, int month, int day) {
  if (month <= 2) {
    year -= 1;
    month += 12;
  }
  final a = (year / 100).floor();
  final b = 2 - a + (a / 4).floor();
  return (365.25 * (year + 4716)).floor() +
      (30.6001 * (month + 1)).floor() +
      day +
      b -
      1524.5;
}

/// (declination, equation of time)
(double, double) _sunPosition(double jd) {
  final d = jd - 2451545.0;
  final g = _fix(357.529 + 0.98560028 * d, 360);
  final q = _fix(280.459 + 0.98564736 * d, 360);
  final l = _fix(q + 1.915 * _sin(g) + 0.020 * _sin(2 * g), 360);
  final e = 23.439 - 0.00000036 * d;
  final ra = _fix(_deg(math.atan2(_cos(e) * _sin(l), _cos(l))), 360) / 15;
  final eqt = q / 15 - ra;
  final decl = _deg(math.asin(_sin(e) * _sin(l)));
  return (decl, eqt);
}

DateTime _toDate(DateTime d, double hours) {
  final secs = (hours * 3600).round();
  final rounded = ((secs + 30) ~/ 60) * 60; // nazdeeki minute
  return DateTime(d.year, d.month, d.day, 0, 0, rounded);
}

/// Ek din ke prayer times. Polar ilaqon mein (sooraj na nikle) null deta hai.
PrayerTimesDay? calcPrayerTimes({
  required DateTime date,
  required Coords coords,
  required PrayerMethod method,
  required bool hanafi,
}) {
  final tz =
      DateTime(date.year, date.month, date.day, 12).timeZoneOffset.inMinutes /
          60.0;
  final jd = _julian(date.year, date.month, date.day) - coords.lng / 360.0;
  final lat = coords.lat;

  double noon(double t) => _fix(12 - _sunPosition(jd + t).$2, 24);

  double angleTime(double angle, double t, {bool ccw = false}) {
    final decl = _sunPosition(jd + t).$1;
    final x = (-_sin(angle) - _sin(decl) * _sin(lat)) /
        (_cos(decl) * _cos(lat));
    if (x < -1 || x > 1) return double.nan;
    final h = _deg(math.acos(x)) / 15;
    return noon(t) + (ccw ? -h : h);
  }

  double asrTime(double factor, double t) {
    final decl = _sunPosition(jd + t).$1;
    final angle = -_deg(math.atan(1 / (factor + _tan((lat - decl).abs()))));
    return angleTime(angle, t);
  }

  const riseSet = 0.833;
  var fajr = angleTime(method.fajrAngle, 5 / 24, ccw: true);
  var sunrise = angleTime(riseSet, 6 / 24, ccw: true);
  var dhuhr = noon(12 / 24);
  var asr = asrTime(hanafi ? 2 : 1, 13 / 24);
  var sunset = angleTime(riseSet, 18 / 24);
  var isha = method.ishaMinutes == 0
      ? angleTime(method.ishaAngle, 18 / 24)
      : double.nan;

  final shift = tz - coords.lng / 15;
  fajr += shift;
  sunrise += shift;
  dhuhr += shift;
  asr += shift;
  sunset += shift;
  isha += shift;

  if (sunrise.isNaN || sunset.isNaN || dhuhr.isNaN || asr.isNaN) return null;

  // High latitude (UK waghera): raat ka hissa angle ke hisab se
  final night = _fix(sunrise - sunset, 24);
  double adjust(double time, double base, double angle, {bool ccw = false}) {
    final portion = angle / 60 * night;
    final diff = ccw ? _fix(base - time, 24) : _fix(time - base, 24);
    if (time.isNaN || diff > portion) {
      return base + (ccw ? -portion : portion);
    }
    return time;
  }

  fajr = adjust(fajr, sunrise, method.fajrAngle, ccw: true);
  if (method.ishaMinutes == 0) {
    isha = adjust(isha, sunset, method.ishaAngle);
  } else {
    isha = sunset + method.ishaMinutes / 60;
  }

  return PrayerTimesDay(
    fajr: _toDate(date, fajr),
    sunrise: _toDate(date, sunrise),
    dhuhr: _toDate(date, dhuhr),
    asr: _toDate(date, asr),
    maghrib: _toDate(date, sunset),
    isha: _toDate(date, isha),
  );
}