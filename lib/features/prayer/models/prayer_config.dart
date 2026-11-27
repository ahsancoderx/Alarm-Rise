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
  final bool custom; // true = user ka apna waqt, false = azan se pehle
  final int offset; // azan se kitne minute pehle
  final int customHour;
  final int customMinute;
  final String category;
  final int? alarmId;
  final String? tone;
  const PrayerAlarmConfig({
    required this.on,
    required this.custom,
    required this.offset,
    required this.customHour,
    required this.customMinute,
    required this.category,
    required this.alarmId,
    required this.tone,
  });
}

/// Database ke settings se bana hua config.
class PrayerConfig {
  final Map<String, String> raw;
  const PrayerConfig(this.raw);

  static const _defaultHour = <Prayer, int>{
    Prayer.fajr: 5,
    Prayer.dhuhr: 13,
    Prayer.asr: 16,
    Prayer.maghrib: 18,
    Prayer.isha: 20,
  };

  double? get _lat => double.tryParse(raw['loc.lat'] ?? '');
  double? get _lng => double.tryParse(raw['loc.lng'] ?? '');

  bool get hasLocation => _lat != null && _lng != null;
  Coords? get coords => hasLocation ? Coords(_lat!, _lng!) : null;
  String get locationName => raw['loc.name'] ?? 'My location';

  PrayerMethod get method => PrayerMethod.values.firstWhere(
        (m) => m.name == raw['pray.method'],
        orElse: () => PrayerMethod.mwl,
      );

  Madhab get madhab {
    final m = raw['pray.madhab'];
    if (m != null) {
      return Madhab.values.firstWhere(
        (e) => e.name == m,
        orElse: () => Madhab.shafii,
      );
    }
    // Purani setting (pehle sirf Hanafi on/off tha)
    return raw['pray.hanafi'] == '1' ? Madhab.hanafi : Madhab.shafii;
  }

  bool get hanafi => madhab == Madhab.hanafi;

  int adjust(Prayer p) => int.tryParse(raw['adj.${p.name}'] ?? '') ?? 0;

  PrayerAlarmConfig alarm(Prayer p) {
    final k = 'alarm.${p.name}';
    return PrayerAlarmConfig(
      on: raw['$k.on'] == '1',
      custom: raw['$k.mode'] == 'custom',
      offset: int.tryParse(raw['$k.offset'] ?? '') ??
          (p == Prayer.fajr ? 20 : 0),
      customHour:
          int.tryParse(raw['$k.hour'] ?? '') ?? (_defaultHour[p] ?? 7),
      customMinute: int.tryParse(raw['$k.minute'] ?? '') ?? 0,
      category: raw['$k.cat'] ?? AlarmCategory.simple.name,
      alarmId: int.tryParse(raw['$k.id'] ?? ''),
      tone: raw['$k.tone'],
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

  /// Agla alarm kab bajega. Preview ke liye offset/custom/hour/minute
  /// bahar se bhi diye ja sakte hain, warna saved setting istemal hoti hai.
  DateTime? nextAlarmTime(
    Prayer p,
    DateTime now, {
    int? offset,
    bool? custom,
    int? hour,
    int? minute,
  }) {
    final a = alarm(p);
    final soon = now.add(const Duration(seconds: 30));

    if (custom ?? a.custom) {
      final h = hour ?? a.customHour;
      final m = minute ?? a.customMinute;
      var t = DateTime(now.year, now.month, now.day, h, m);
      if (!t.isAfter(soon)) {
        t = DateTime(now.year, now.month, now.day + 1, h, m);
      }
      return t;
    }

    final off = offset ?? a.offset;
    for (var i = 0; i < 3; i++) {
      final day = timesOn(DateTime(now.year, now.month, now.day + i));
      if (day == null) return null;
      final t = day[p].subtract(Duration(minutes: off));
      if (t.isAfter(soon)) return t;
    }
    return null;
  }
}