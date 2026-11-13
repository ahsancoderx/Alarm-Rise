import 'package:alarm/alarm.dart' as plugin;
import '../../data/models/alarm.dart';

class AlarmScheduler {
  static const tonePath = 'assets/tones/alarm.mp3';

  static Future<void> init() => plugin.Alarm.init();

  /// Agla waqt jab ye alarm bajna chahiye (system time se).
  static DateTime? nextOccurrence(Alarm a, [DateTime? from]) {
    final now = from ?? DateTime.now();
    for (var i = 0; i <= 7; i++) {
      final c = DateTime(now.year, now.month, now.day + i, a.hour, a.minute);
      if (!c.isAfter(now)) continue;
      if (a.days.isEmpty || a.days.contains(c.weekday)) return c;
    }
    return null;
  }

  static Future<void> schedule(Alarm a) async {
    final when = nextOccurrence(a);
    if (when == null) return;

    final title = a.label.isNotEmpty ? a.label : a.category.title;

    await plugin.Alarm.set(
      alarmSettings: plugin.AlarmSettings(
        id: a.id,
        dateTime: when,
        assetAudioPath: tonePath,
        loopAudio: true,
        vibrate: a.vibrate,
        warningNotificationOnKill: true,
        androidFullScreenIntent: true,
        volumeSettings: plugin.VolumeSettings.fixed(
          volume: 1.0,
          volumeEnforced: true,
        ),
        notificationSettings: plugin.NotificationSettings(
          title: title,
          body: 'Time to wake up! Open RiseQuest to stop the alarm.',
        ),
      ),
    );
  }

  /// Database ke mutabiq saare alarms schedule/cancel karta hai.
  static Future<void> syncAll(List<Alarm> alarms) async {
    final active = {for (final a in alarms) if (a.enabled) a.id: a};

    for (final s in await plugin.Alarm.getAlarms()) {
      if (!active.containsKey(s.id) && !await plugin.Alarm.isRinging(s.id)) {
        await plugin.Alarm.stop(s.id);
      }
    }
    for (final a in active.values) {
      if (await plugin.Alarm.isRinging(a.id)) continue;
      await schedule(a);
    }
  }
}