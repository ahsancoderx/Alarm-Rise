import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database/app_database.dart';
import '../../../data/database/database_provider.dart';
import '../../home/providers/clock_provider.dart';
import '../../rewards/providers/rewards_providers.dart';
import '../models/prayer.dart';
import '../models/prayer_config.dart';
import '../services/prayer_service.dart';

final settingsProvider = StreamProvider<Map<String, String>>(
  (ref) => ref.watch(databaseProvider).watchSettings(),
);

final prayerConfigProvider = Provider<PrayerConfig>(
  (ref) => PrayerConfig(ref.watch(settingsProvider).value ?? const {}),
);

final prayerServiceProvider = Provider<PrayerService>(
  (ref) => PrayerService(ref.watch(databaseProvider)),
);

/// Sirf aaj ke logs. Din badalne par khud naya stream ban jata hai.
final prayerLogsProvider = StreamProvider<List<PrayerLogRow>>(
  (ref) => ref
      .watch(databaseProvider)
      .watchPrayerLogsForDay(ref.watch(todayKeyProvider)),
);

/// Aaj ki kaun si namazein tick hain.
final todayPrayerDoneProvider = Provider<Set<String>>((ref) {
  final logs = ref.watch(prayerLogsProvider).value ?? const <PrayerLogRow>[];
  return {for (final l in logs) l.prayer};
});

final prayersDoneTodayProvider =
    Provider<int>((ref) => ref.watch(todayPrayerDoneProvider).length);

final todayTimesProvider = Provider<PrayerDay?>((ref) {
  final cfg = ref.watch(prayerConfigProvider);
  final today = DateTime.parse(ref.watch(todayKeyProvider));
  return cfg.timesOn(today);
});

class NextPrayer {
  final Prayer prayer;
  final DateTime time;
  const NextPrayer(this.prayer, this.time);
}

final nextPrayerProvider = Provider<NextPrayer?>((ref) {
  final cfg = ref.watch(prayerConfigProvider);
  final now = ref.watch(clockProvider).value ?? DateTime.now();
  for (var i = 0; i < 2; i++) {
    final day = cfg.timesOn(DateTime(now.year, now.month, now.day + i));
    if (day == null) return null;
    for (final p in Prayer.values) {
      if (day[p].isAfter(now)) return NextPrayer(p, day[p]);
    }
  }
  return null;
});