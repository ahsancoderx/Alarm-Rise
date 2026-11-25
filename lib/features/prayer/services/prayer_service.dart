import 'package:alarm/alarm.dart' as plugin;
import 'package:drift/drift.dart' show Value;

import '../../../core/services/alarm_scheduler.dart';
import '../../../data/database/app_database.dart';
import '../../../data/models/alarm.dart';
import '../../../data/models/alarm_category.dart';
import '../data/prayer_cities.dart';
import '../models/prayer.dart';
import '../models/prayer_config.dart';
import '../../../core/utils/prayer_calc.dart';

/// Prayer alarm ki default tone.
const kPrayerDefaultTone = 'default';

class PrayerService {
  final AppDatabase _db;

  PrayerService(this._db);

  Future<PrayerConfig> _config() async =>
      PrayerConfig(await _db.getSettings());

  // AlarmRow ko Alarm model mein convert karta hai.
  Alarm _asAlarm(AlarmRow row) => Alarm(
        id: row.id,
        hour: row.hour,
        minute: row.minute,
        days: row.days
            .split(',')
            .where((e) => e.isNotEmpty)
            .map(int.parse)
            .toSet(),
        category: AlarmCategory.values.firstWhere(
          (e) => e.name == row.category,
          orElse: () => AlarmCategory.simple,
        ),
        tone: row.tone,
        vibrate: row.vibrate,
        label: row.label,
        enabled: row.enabled,
        referencePhoto: row.referencePhoto,
        referenceLabels: row.referenceLabels,
        exercise: row.exercise,
        reps: row.reps,
      );

  Future<void> setLocation({
    required String name,
    required double lat,
    required double lng,
    String? country,
  }) async {
    await _db.setSetting('loc.name', name);
    await _db.setSetting('loc.lat', lat.toString());
    await _db.setSetting('loc.lng', lng.toString());

    if (country != null) {
      await _db.setSetting(
          'pray.method', methodForCountry(country).name);
      await _db.setSetting(
          'pray.hanafi', hanafiForCountry(country) ? '1' : '0');
    }

    await refreshAll(force: true);
  }

  Future<void> setMethod(PrayerMethod m) async {
    await _db.setSetting('pray.method', m.name);
    await refreshAll(force: true);
  }

  Future<void> setHanafi(bool v) async {
    await _db.setSetting('pray.hanafi', v ? '1' : '0');
    await refreshAll(force: true);
  }

  Future<void> setAdjust(Prayer p, int minutes) async {
    await _db.setSetting(
        'adj.${p.name}', minutes.clamp(-30, 30).toString());
    await refreshAll(force: true);
  }

  /// Bell dabane par: alarm on/off, offset, (Fajr ke liye) mission.
  Future<void> saveAlarm(
    Prayer p, {
    required bool on,
    required int offset,
    String? category,
  }) async {
    final cfg = await _config();
    final k = 'alarm.${p.name}';

    await _db.setSetting('$k.offset', '$offset');

    if (category != null) {
      await _db.setSetting('$k.cat', category);
    }

    await _db.setSetting('$k.on', on ? '1' : '0');

    if (!on) {
      final id = cfg.alarm(p).alarmId;

      if (id != null) {
        await _db.setEnabled(id, false);

        try {
          await plugin.Alarm.stop(id);
        } catch (_) {}
      }

      return;
    }

    await _syncAlarm(p, force: true);
  }

  /// Sab on prayer alarms ka agla waqt dobara lagata hai.
  Future<void> refreshAll({bool force = false}) async {
    for (final p in Prayer.values) {
      await _syncAlarm(p, force: force);
    }
  }

  /// Alarm band hone ke baad: kal ka waqt lagao.
  /// True = ye prayer alarm tha.
  Future<bool> refreshAlarm(int alarmId) async {
    final cfg = await _config();

    for (final p in Prayer.values) {
      final a = cfg.alarm(p);

      if (a.on && a.alarmId == alarmId) {
        await _syncAlarm(p, force: true);
        return true;
      }
    }

    return false;
  }

  Future<void> _syncAlarm(
    Prayer p, {
    required bool force,
  }) async {
    final cfg = await _config();
    final a = cfg.alarm(p);

    if (!a.on) return;

    final now = DateTime.now();
    final next = cfg.nextAlarmTime(p, now);

    if (next == null) return; // location set nahi

    final row =
        a.alarmId == null ? null : await _db.getAlarm(a.alarmId!);

    if (!force) {
      // User ne list se delete ya band kiya ho,
      // ya alarm abhi baj raha ho to chhedna nahi.
      if (row == null || !row.enabled) return;

      final ringAt =
          DateTime(now.year, now.month, now.day, row.hour, row.minute);

      if (!now.isBefore(ringAt) &&
          now.difference(ringAt) < const Duration(minutes: 20)) {
        return;
      }
    }

    // Sirf usi hafte ke din par lagao.
    // 1 = Monday ... 7 = Sunday.
    final days = '${next.weekday}';

    int id;

    if (row == null) {
      id = await _db.insertAlarmRow(
        AlarmsTableCompanion.insert(
          hour: next.hour,
          minute: next.minute,
          category: a.category,
          tone: kPrayerDefaultTone,
          days: Value(days),
          label: Value(p.title),
        ),
      );

      await _db.setSetting('alarm.${p.name}.id', '$id');
    } else {
      id = row.id;

      await _db.updateAlarmTime(
        id,
        next.hour,
        next.minute,
        days,
        category: a.category,
      );
    }

    final saved = await _db.getAlarm(id);

    if (saved != null) {
      await AlarmScheduler.schedule(_asAlarm(saved));
    }
  }
}