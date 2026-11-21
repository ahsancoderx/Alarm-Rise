import 'package:alarm/alarm.dart' as plugin;
import '../../data/models/alarm.dart';
import 'tone_catalog.dart';

class AlarmScheduler {
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
    final audio = await ToneCatalog.resolve(a.tone);

    await plugin.Alarm.set(
      alarmSettings: plugin.AlarmSettings(
        id: a.id,
        dateTime: when,
        assetAudioPath: audio,
        loopAudio: true,
        vibrate: a.vibrate,
        androidFullScreenIntent: true,
        // App recents se swipe karne par bhi alarm chalta rahe
        androidStopAlarmOnTermination: false,
        // "App band hui" wali warning ab zaroori nahi
        warningNotificationOnKill: false,
        // false: user mute kar sake, aur hamari mute button kaam kare
        volumeSettings: plugin.VolumeSettings.fixed(
          volume: 1.0,
          volumeEnforced: false,
        ),
        notificationSettings: plugin.NotificationSettings(
          title: title,
          body: 'Complete your mission to stop the alarm.',
          // Swipe karne par alarm band nahi hoga, notification wapas aa jayegi
          androidStopAlarmOnDismiss: false,
          // Notification mein Stop button nahi
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