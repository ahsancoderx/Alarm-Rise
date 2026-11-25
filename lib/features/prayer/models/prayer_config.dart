import '../../../core/utils/prayer_calc.dart';
import '../../../data/models/alarm_category.dart';
import 'prayer.dart';

class PrayerDay {
  final DateTime sunrise;
  final Map<Prayer, DateTime> times;
  const PrayerDay(this.sunrise, this.times);
  DateTime operator [](Prayer p) => times[p]!;
}

class PrayerAlarmConfig {
  final bool on;
  final int offset; // namaz se kitne minute pehle
  final String category;
  final int? alarmId;
  const PrayerAlarmConfig({
    required this.on,
    required this.offset,
    required this.category,
    required this.alarmId,
  });
}

/// Database ke settings se bana hua config.
class PrayerConfig {
  final Map<String, String> raw;
  const PrayerConfig(this.raw);

  double? get _lat => double.tryParse(raw['loc.lat'] ?? '');
  double? get _lng => double.tryParse(raw['loc.lng'] ?? '');

  bool get hasLocation => _lat != null && _lng != null;
  Coords? get coords => hasLocation ? Coords(_lat!, _lng!) : null;
  String get locationName => raw['loc.name'] ?? 'My location';

  PrayerMethod get method => PrayerMethod.values.firstWhere(
        (m) => m.name == raw['pray.method'],
        orElse: () => PrayerMethod.mwl,
      );

  bool get hanafi => raw['pray.hanafi'] == '1';

  int adjust(Prayer p) => int.tryParse(raw['adj.${p.name}'] ?? '') ?? 0;

  PrayerAlarmConfig alarm(Prayer p) {
    final k = 'alarm.${p.name}';
    return PrayerAlarmConfig(
      on: raw['$k.on'] == '1',
      offset: int.tryParse(raw['$k.offset'] ?? '') ??
          (p == Prayer.fajr ? 20 : 0),
      category: raw['$k.cat'] ?? AlarmCategory.simple.name,
      alarmId: int.tryParse(raw['$k.id'] ?? ''),
    );
  }

  PrayerDay? timesOn(DateTime date) {
    final c = coords;
    if (c == null) return null;
    final t = calcPrayerTimes(
        date: date, coords: c, method: method, hanafi: hanafi);
    if (t == null) return null;
    DateTime adj(Prayer p, DateTime d) =>
        d.add(Duration(minutes: adjust(p)));
    return PrayerDay(t.sunrise, {
      Prayer.fajr: adj(Prayer.fajr, t.fajr),
      Prayer.dhuhr: adj(Prayer.dhuhr, t.dhuhr),
      Prayer.asr: adj(Prayer.asr, t.asr),
      Prayer.maghrib: adj(Prayer.maghrib, t.maghrib),
      Prayer.isha: adj(Prayer.isha, t.isha),
    });
  }

  /// Agla alarm kab bajega (namaz ka waqt minus offset).
  DateTime? nextAlarmTime(Prayer p, DateTime now, {int? offset}) {
    final off = offset ?? alarm(p).offset;
    for (var i = 0; i < 3; i++) {
      final day = timesOn(DateTime(now.year, now.month, now.day + i));
      if (day == null) return null;
      final t = day[p].subtract(Duration(minutes: off));
      if (t.isAfter(now.add(const Duration(seconds: 30)))) return t;
    }
    return null;
  }
}