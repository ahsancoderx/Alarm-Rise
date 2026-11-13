import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/alarm_scheduler.dart';
import '../../../data/models/alarm.dart';
import '../../alarms/providers/alarms_provider.dart';
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

    // Sab se qareebi alarm dhundo
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
            Text(date,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            _NextAlarmCard(
              alarm: next,
              remaining: nextTime?.difference(now),
              onAdd: () => context.go('/alarms'),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department_rounded,
                    value: '0',
                    label: 'Day streak',
                    color: AppColors.orange,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.bolt_rounded,
                    value: '0',
                    label: 'Total XP',
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Today's quests",
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            const _QuestTile(title: 'Wake up on time', xp: 50, done: false),
            const _QuestTile(
                title: 'Complete morning mission', xp: 100, done: false),
            const _QuestTile(title: '10 minute workout', xp: 80, done: false),
            const _QuestTile(title: 'Read Quran', xp: 60, done: false),
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
        child: a == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NEXT ALARM',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
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
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NEXT ALARM',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
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
                    '${a.repeatText}  •  ${a.category.title}  •  ${_countdown(remaining!)}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
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

class _QuestTile extends StatelessWidget {
  final String title;
  final int xp;
  final bool done;

  const _QuestTile({required this.title, required this.xp, required this.done});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          color: done ? AppColors.orange : AppColors.textSecondary,
        ),
        title: Text(title,
            style: TextStyle(
              color: done ? AppColors.textSecondary : AppColors.textPrimary,
              decoration: done ? TextDecoration.lineThrough : null,
              fontWeight: FontWeight.w600,
            )),
        trailing: Text('+$xp XP',
            style: const TextStyle(
                color: AppColors.gold, fontWeight: FontWeight.w700)),
      ),
    );
  }
}