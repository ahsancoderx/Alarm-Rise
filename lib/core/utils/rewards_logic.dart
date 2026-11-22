import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../data/database/app_database.dart';

String dayKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

String prevDay(String key) {
  final d = DateTime.parse(key);
  return dayKey(DateTime(d.year, d.month, d.day - 1));
}

String fmtNum(int n) {
  final s = n.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return n < 0 ? '-$b' : b.toString();
}

/// Level n shuru hota hai 100 * (n-1)^2 XP par.
int levelStartXp(int level) => 100 * (level - 1) * (level - 1);
int levelFor(int xp) => math.sqrt(xp / 100).floor() + 1;

/// Aaj tak lagataar din. Aaj abhi poora na hua ho to kal tak ki streak chalti hai.
int streakFrom(Set<String> days, String today) {
  var cursor = days.contains(today) ? today : prevDay(today);
  var n = 0;
  while (days.contains(cursor)) {
    n++;
    cursor = prevDay(cursor);
  }
  return n;
}

int bestStreakOf(Set<String> days) {
  final sorted = days.toList()..sort();
  var best = 0;
  var run = 0;
  String? prev;
  for (final d in sorted) {
    run = (prev != null && prevDay(d) == prev) ? run + 1 : 1;
    best = math.max(best, run);
    prev = d;
  }
  return best;
}

class RewardStats {
  final int totalXp;
  final int coins;
  final int level;
  final int levelStart;
  final int nextLevelXp;
  final int streak;
  final int bestStreak;
  final int alarmsDone;
  final int habitChecks;
  final int workouts;
  final int categories;
  final bool alarmToday;
  final bool earlyBird;

  const RewardStats({
    required this.totalXp,
    required this.coins,
    required this.level,
    required this.levelStart,
    required this.nextLevelXp,
    required this.streak,
    required this.bestStreak,
    required this.alarmsDone,
    required this.habitChecks,
    required this.workouts,
    required this.categories,
    required this.alarmToday,
    required this.earlyBird,
  });

  double get levelProgress =>
      ((totalXp - levelStart) / (nextLevelXp - levelStart)).clamp(0.0, 1.0);

  int get xpToNext => nextLevelXp - totalXp;
}

RewardStats computeStats(List<XpEventRow> events, String today) {
  var xp = 0;
  var coins = 0;
  var alarms = 0;
  var habits = 0;
  var workouts = 0;
  var early = false;
  final days = <String>{};
  final types = <String>{};

  for (final e in events) {
    xp += e.xp;
    coins += e.coins;
    switch (e.kind) {
      case 'alarm':
        alarms++;
        days.add(e.day);
        types.add(e.title);
        if (e.hour < 6) early = true;
      case 'habit':
        habits++;
      case 'workout':
        workouts++;
    }
  }

  final level = levelFor(xp);
  return RewardStats(
    totalXp: xp,
    coins: coins,
    level: level,
    levelStart: levelStartXp(level),
    nextLevelXp: levelStartXp(level + 1),
    streak: streakFrom(days, today),
    bestStreak: bestStreakOf(days),
    alarmsDone: alarms,
    habitChecks: habits,
    workouts: workouts,
    categories: types.length,
    alarmToday: days.contains(today),
    earlyBird: early,
  );
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool Function(RewardStats s) check;
  Achievement(this.id, this.title, this.description, this.icon, this.check);
}

final achievements = <Achievement>[
  Achievement('first', 'First Rise', 'Complete your first alarm mission',
      Icons.wb_twilight_rounded, (s) => s.alarmsDone >= 1),
  Achievement('streak3', '3 Day Streak', 'Wake up 3 days in a row',
      Icons.local_fire_department_rounded, (s) => s.bestStreak >= 3),
  Achievement('streak7', 'Week Warrior', 'Wake up 7 days in a row',
      Icons.whatshot_rounded, (s) => s.bestStreak >= 7),
  Achievement('streak30', 'Unstoppable', 'Wake up 30 days in a row',
      Icons.military_tech_rounded, (s) => s.bestStreak >= 30),
  Achievement('early', 'Early Bird', 'Finish a mission before 6 AM',
      Icons.wb_sunny_rounded, (s) => s.earlyBird),
  Achievement('variety', 'Mission Master', 'Finish 3 different alarm types',
      Icons.workspace_premium_rounded, (s) => s.categories >= 3),
  Achievement('habit10', 'Habit Builder', 'Check in 10 habits',
      Icons.checklist_rounded, (s) => s.habitChecks >= 10),
  Achievement('gym5', 'Gym Rat', 'Complete 5 workouts',
      Icons.fitness_center_rounded, (s) => s.workouts >= 5),
  Achievement('xp1000', 'XP Hunter', 'Earn 1,000 XP', Icons.bolt_rounded,
      (s) => s.totalXp >= 1000),
  Achievement('level5', 'Level 5', 'Reach level 5',
      Icons.emoji_events_rounded, (s) => s.level >= 5),
];