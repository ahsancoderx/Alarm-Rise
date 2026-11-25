import 'dart:math' as math;
import 'package:drift/drift.dart' show Value;
import '../../../core/utils/rewards_logic.dart';
import '../../../data/database/app_database.dart';
import '../../../data/models/alarm.dart';
import '../../../data/models/alarm_category.dart';
import '../../../data/models/fitness_exercise.dart';
import '../../prayer/models/prayer.dart';

class AwardResult {
  final int xp;
  final int coins;
  final int streak;
  final int level;
  final bool leveledUp;
  const AwardResult({
    required this.xp,
    required this.coins,
    required this.streak,
    required this.level,
    required this.leveledUp,
  });
}

int alarmBaseXp(Alarm a) {
  switch (a.category) {
    case AlarmCategory.simple:
      return 20;
    case AlarmCategory.math:
      return 40;
    case AlarmCategory.sky:
    case AlarmCategory.room:
    case AlarmCategory.face:
      return 50;
    case AlarmCategory.fitness:
      return 40 + a.reps * 3;
  }
}

class RewardsService {
  static const maxWorkoutsPerDay = 3;
  final AppDatabase _db;
  RewardsService(this._db);

  /// Alarm mission poora hone par.
  Future<AwardResult> awardAlarm(Alarm a) async {
    final now = DateTime.now();
    final day = dayKey(now);
    final before = await _db.allXpEvents();
    final statsBefore = computeStats(before, day);
    final refKey = 'alarm:${a.id}:$day';

    var xp = 0;
    var coins = 0;
    if (!before.any((e) => e.refKey == refKey)) {
      xp = alarmBaseXp(a) + math.min(statsBefore.streak, 7) * 5;
      coins = xp ~/ 10;
      await _db.insertXp(XpEventsTableCompanion.insert(
        kind: 'alarm',
        title: a.category.title,
        xp: xp,
        day: day,
        refKey: refKey,
        coins: Value(coins),
        hour: Value(now.hour),
      ));
    }
    return _result(day, statsBefore, xp, coins);
  }

  /// Routine mein quick workout poora hone par.
  Future<AwardResult> awardWorkout(FitnessExercise ex, int reps) async {
    final now = DateTime.now();
    final day = dayKey(now);
    final before = await _db.allXpEvents();
    final statsBefore = computeStats(before, day);
    final doneToday =
        before.where((e) => e.kind == 'workout' && e.day == day).length;

    var xp = 0;
    var coins = 0;
    if (doneToday < maxWorkoutsPerDay) {
      xp = reps * 4;
      coins = xp ~/ 10;
      await _db.insertXp(XpEventsTableCompanion.insert(
        kind: 'workout',
        title: '${ex.title} ×$reps',
        xp: xp,
        day: day,
        refKey: 'workout:$day:${doneToday + 1}',
        coins: Value(coins),
        hour: Value(now.hour),
      ));
    }
    return _result(day, statsBefore, xp, coins);
  }

  Future<AwardResult> _result(
      String day, RewardStats before, int xp, int coins) async {
    final after = computeStats(await _db.allXpEvents(), day);
    return AwardResult(
      xp: xp,
      coins: coins,
      streak: after.streak,
      level: after.level,
      leveledUp: after.level > before.level,
    );
  }

  // ---------- Habits ----------

  Future<void> toggleHabit(HabitRow h, String day, bool done) {
    final ref = 'habit:${h.id}:$day';
    return _db.transaction(() async {
      await _db.setHabitLog(h.id, day, done);
      if (done) {
        await _db.insertXp(XpEventsTableCompanion.insert(
          kind: 'habit',
          title: h.name,
          xp: h.xp,
          day: day,
          refKey: ref,
          coins: Value(h.xp ~/ 10),
          hour: Value(DateTime.now().hour),
        ));
      } else {
        await _db.deleteXpByRef(ref);
      }
    });
  }
    // ---------- Namaz ----------

  /// Namaz tick/untick. Har namaz ka XP, aur paanchon par +20 bonus.
  Future<void> togglePrayer(Prayer p, String day, bool done) {
    final ref = 'prayer:$day:${p.name}';
    final bonusRef = 'prayer-bonus:$day';
    return _db.transaction(() async {
      await _db.setPrayerLog(day, p.name, done);
      if (done) {
        await _db.insertXp(XpEventsTableCompanion.insert(
          kind: 'prayer',
          title: p.title,
          xp: p.xp,
          day: day,
          refKey: ref,
          coins: Value(p.xp ~/ 10),
          hour: Value(DateTime.now().hour),
        ));
      } else {
        await _db.deleteXpByRef(ref);
      }

      final logs = await _db.prayerLogsForDay(day);
      if (logs.length >= 5) {
        await _db.insertXp(XpEventsTableCompanion.insert(
          kind: 'prayer',
          title: 'All 5 prayers',
          xp: 20,
          day: day,
          refKey: bonusRef,
          coins: const Value(2),
          hour: Value(DateTime.now().hour),
        ));
      } else {
        await _db.deleteXpByRef(bonusRef);
      }
    });
  }

  Future<void> addHabit(String name, String icon, int xp) =>
      _db.addHabit(name, icon, xp);

  Future<void> deleteHabit(int id) => _db.deleteHabit(id);
}