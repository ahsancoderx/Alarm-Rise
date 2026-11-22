import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/rewards_logic.dart';
import '../../../data/database/app_database.dart';
import '../../../data/database/database_provider.dart';

class HabitView {
  final HabitRow habit;
  final Set<String> days;
  const HabitView(this.habit, this.days);

  bool doneOn(String day) => days.contains(day);
  int streak(String today) => streakFrom(days, today);
}

final habitRowsProvider = StreamProvider<List<HabitRow>>(
  (ref) => ref.watch(databaseProvider).watchHabits(),
);

final habitLogsProvider = StreamProvider<List<HabitLogRow>>(
  (ref) => ref.watch(databaseProvider).watchHabitLogs(),
);

final habitViewsProvider = Provider<List<HabitView>>((ref) {
  final habits = ref.watch(habitRowsProvider).value ?? const <HabitRow>[];
  final logs = ref.watch(habitLogsProvider).value ?? const <HabitLogRow>[];
  final byHabit = <int, Set<String>>{};
  for (final l in logs) {
    byHabit.putIfAbsent(l.habitId, () => <String>{}).add(l.day);
  }
  return [for (final h in habits) HabitView(h, byHabit[h.id] ?? const {})];
});