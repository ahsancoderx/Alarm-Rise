import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/alarm_scheduler.dart';
import '../../../core/utils/rewards_logic.dart';
import '../../../data/models/alarm.dart';
import '../../alarms/providers/alarms_provider.dart';
import '../../rewards/providers/rewards_providers.dart';
import '../../routine/providers/habit_providers.dart';
import '../../routine/widgets/habit_icons.dart';
import '../providers/clock_provider.dart';

const _weekdays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
];
const _months = [
  'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
  'September', 'October', 'November', 'December'
];

String _greeting(int hour) {
  if (hour < 5) return 'Good night';
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  if (hour < 21) return 'Good evening';
  return 'Good night';
}

String _countdown(Duration d) {
  final days = d.inDays;
  final hours = d.inHours % 24;
  final minutes = d.inMinutes % 60;
  if (days > 0) return 'in ${days}d ${hours}h';
  if (hours > 0) return 'in ${hours}h ${minutes}m';
  if (minutes > 0) return 'in ${minutes}m';
  return 'in less than a minute';
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final alarms = ref.watch(alarmsProvider);
    final stats = ref.watch(statsProvider);
    final habits = ref.watch(habitViewsProvider);
    final today = ref.watch(todayKeyProvider);

    // Sab se qareebi alarm
    Alarm? next;
    DateTime? nextTime;
    for (final a in alarms.where((a) => a.enabled)) {
      final t = AlarmScheduler.nextOccurrence(a, now);
      if (t != null && (nextTime == null || t.isBefore(nextTime))) {
        next = a;
        nextTime = t;
      }
    }

    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final clock = '$h:${now.minute.toString().padLeft(2, '0')}';
    final period = now.hour < 12 ? 'AM' : 'PM';
    final date =
        '${_weekdays[now.weekday - 1]}, ${now.day} ${_months[now.month - 1]}';

    final questsTotal = 1 + habits.length;
    final questsDone =
        (stats.alarmToday ? 1 : 0) + habits.where((x) => x.doneOn(today)).length;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(_greeting(now.hour),
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 16)),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(clock,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        height: 1)),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(period,
                      style: const TextStyle(
                          color: AppColors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(date, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            _NextAlarmCard(
              alarm: next,
              remaining: nextTime?.difference(now),
              onAdd: () => context.go('/alarms'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department_rounded,
                    value: '${stats.streak}',
                    label: 'Day streak',
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.bolt_rounded,
                    value: fmtNum(stats.totalXp),
                    label: 'Total XP',
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _LevelBar(stats: stats, onTap: () => context.go('/rewards')),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text("Today's quests",
                    style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('$questsDone / $questsTotal',
                    style: const TextStyle(
                        color: AppColors.orange, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            _QuestTile(
              icon: Icons.alarm_rounded,
              title: 'Complete your alarm mission',
              done: stats.alarmToday,
              trailing: stats.alarmToday ? null : '',
              onTap: () => context.go('/alarms'),
            ),
            for (final v in habits)
              _QuestTile(
                icon: habitIcon(v.habit.icon),
                title: v.habit.name,
                done: v.doneOn(today),
                trailing: '+${v.habit.xp} XP',
                onTap: () => ref
                    .read(rewardsServiceProvider)
                    .toggleHabit(v.habit, today, !v.doneOn(today)),
              ),
            if (habits.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Add habits in the Routine tab to see them here.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NextAlarmCard extends StatelessWidget {
  final Alarm? alarm;
  final Duration? remaining;
  final VoidCallback onAdd;

  const _NextAlarmCard({
    required this.alarm,
    required this.remaining,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final a = alarm;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('NEXT ALARM',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            if (a == null) ...[
              const Text('No alarm set',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create alarm'),
              ),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(a.timeText,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 56,
                          fontWeight: FontWeight.w800,
                          height: 1)),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(a.period,
                        style: const TextStyle(
                            color: AppColors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${a.repeatText}  •  ${a.missionText}  •  ${_countdown(remaining!)}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w800)),
            Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _LevelBar extends StatelessWidget {
  final RewardStats stats;
  final VoidCallback onTap;
  const _LevelBar({required this.stats, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.orange),
                child: Text('${stats.level}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level ${stats.level}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: stats.levelProgress,
                      minHeight: 7,
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.orange,
                      backgroundColor: AppColors.border,
                    ),
                    const SizedBox(height: 4),
                    Text('${fmtNum(stats.xpToNext)} XP to next level',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool done;
  final String? trailing; // null = "Done", '' = chevron
  final VoidCallback onTap;

  const _QuestTile({
    required this.icon,
    required this.title,
    required this.done,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          color: done ? AppColors.orange : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: done ? AppColors.textSecondary : AppColors.textPrimary,
            decoration: done ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: trailing == null
            ? const Text('Done',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700))
            : trailing!.isEmpty
                ? const Icon(Icons.chevron_right_rounded)
                : Text(trailing!,
                    style: TextStyle(
                        color: done ? AppColors.textSecondary : AppColors.gold,
                        fontWeight: FontWeight.w700)),
      ),
    );
  }
}