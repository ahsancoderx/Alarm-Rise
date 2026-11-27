import 'package:alarm/alarm.dart' as plugin;
import 'package:drift/drift.dart' show Value;
import '../../../core/services/alarm_scheduler.dart';
import '../../../core/services/tone_catalog.dart';
import '../../../core/utils/prayer_calc.dart';
import '../../../data/database/app_database.dart';
import '../../alarms/providers/alarms_provider.dart' show alarmFromRow;
import '../data/prayer_cities.dart';
import '../models/prayer.dart';
import '../models/prayer_config.dart';

const _everyDay = '1,2,3,4,5,6,7';

class PrayerService {
  final AppDatabase _db;
  PrayerService(this._db);

  Future<PrayerConfig> _config() async => PrayerConfig(await _db.getSettings());

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
      // Jo cheez user ne khud chuni ho use shehar badalne par na chhedo.
      final s = await _db.getSettings();
      if (s['pray.method.set'] != '1') {
        await _db.setSetting('pray.method', methodForCountry(country).name);
      }
      if (s['pray.madhab.set'] != '1') {
        await _db.setSetting('pray.madhab', madhabForCountry(country).name);
      }
    }
    await refreshAll(force: true);
  }

  Future<void> setMethod(PrayerMethod m) async {
    await _db.setSetting('pray.method', m.name);
    await _db.setSetting('pray.method.set', '1');
    await refreshAll(force: true);
  }

  Future<void> setMadhab(Madhab m) async {
    await _db.setSetting('pray.madhab', m.name);
    await _db.setSetting('pray.madhab.set', '1');
    await refreshAll(force: true);
  }

  Future<void> setAdjust(Prayer p, int minutes) async {
    await _db.setSetting('adj.${p.name}', minutes.clamp(-30, 30).toString());
    await refreshAll(force: true);
  }

  /// Bell dabane par: alarm on/off, waqt (azan se pehle ya apna), mission, tone.
  Future<void> saveAlarm(
    Prayer p, {
    required bool on,
    required bool custom,
    required int offset,
    required int hour,
    required int minute,
    String? category,
    String? tone,
  }) async {
    final cfg = await _config();
    final k = 'alarm.${p.name}';

    await _db.transaction(() async {
      await _db.setSetting('$k.mode', custom ? 'custom' : 'azan');
      await _db.setSetting('$k.offset', '$offset');
      await _db.setSetting('$k.hour', '$hour');
      await _db.setSetting('$k.minute', '$minute');
      if (category != null) await _db.setSetting('$k.cat', category);
      if (tone != null) await _db.setSetting('$k.tone', tone);
      await _db.setSetting('$k.on', on ? '1' : '0');
    });

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

  /// Alarm band hone ke baad: agla waqt lagao. True = ye prayer alarm tha.
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

  Future<void> _syncAlarm(Prayer p, {required bool force}) async {
    final cfg = await _config();
    final a = cfg.alarm(p);
    if (!a.on) return;

    final now = DateTime.now();
    final next = cfg.nextAlarmTime(p, now);
    if (next == null) return; // azan mode mein location set nahi

    // Azan mode: sirf usi hafte ke din par lagao (roz ka waqt thora badalta
    // hai). Apna waqt: fix hai, isliye har din.
    final days = a.custom ? _everyDay : '${next.weekday}';
    final row = a.alarmId == null ? null : await _db.getAlarm(a.alarmId!);

    if (!force) {
      // User ne Alarms list se delete ya band kiya ho to chhedna nahi.
      if (row == null || !row.enabled) return;
      // Kuch badla hi nahi to dobara schedule na karo.
      if (row.hour == next.hour &&
          row.minute == next.minute &&
          row.days == days) {
        return;
      }
      // Alarm abhi baj raha ho to chhedna nahi.
      final ringAt =
          DateTime(now.year, now.month, now.day, row.hour, row.minute);
      if (!now.isBefore(ringAt) &&
          now.difference(ringAt) < const Duration(minutes: 20)) {
        return;
      }
    }

    int id;
    if (row == null) {
      id = await _db.insertAlarmRow(AlarmsTableCompanion.insert(
        hour: next.hour,
        minute: next.minute,
        category: a.category,
        tone: a.tone ?? ToneCatalog.fallbackAsset,
        days: Value(days),
        label: Value(p.title),
      ));
      await _db.setSetting('alarm.${p.name}.id', '$id');
    } else {
      id = row.id;
      // Pehle 'default' naam ki ghalat tone lagi thi to usay asli tone se badlo.
      final tone =
          a.tone ?? (row.tone == 'default' ? ToneCatalog.fallbackAsset : null);
      await _db.updateAlarmTime(id, next.hour, next.minute, days,
          category: a.category, tone: tone);
    }

    final saved = await _db.getAlarm(id);
    if (saved != null) await AlarmScheduler.schedule(alarmFromRow(saved));
  }
}