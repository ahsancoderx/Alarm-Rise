import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/rewards_logic.dart';
import '../../../data/database/app_database.dart';
import '../../../data/database/database_provider.dart';
import '../../home/providers/clock_provider.dart';
import '../services/rewards_service.dart';

/// Aaj ki tareekh ("2026-11-22"). Sirf aadhi raat ko badalti hai.
final todayKeyProvider = Provider<String>(
  (ref) => dayKey(ref.watch(clockProvider).value ?? DateTime.now()),
);

final xpEventsProvider = StreamProvider<List<XpEventRow>>(
  (ref) => ref.watch(databaseProvider).watchXpEvents(),
);

final statsProvider = Provider<RewardStats>((ref) {
  final events = ref.watch(xpEventsProvider).value ?? const <XpEventRow>[];
  return computeStats(events, ref.watch(todayKeyProvider));
});

final rewardsServiceProvider = Provider<RewardsService>(
  (ref) => RewardsService(ref.watch(databaseProvider)),
);