import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _Greeting(),
            SizedBox(height: 20),
            _NextAlarmCard(),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department_rounded,
                    value: '5',
                    label: 'Day streak',
                    color: AppColors.orange,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.bolt_rounded,
                    value: '1,240',
                    label: 'Total XP',
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              "Today's quests",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12),
            _QuestTile(title: 'Wake up on time', xp: 50, done: true),
            _QuestTile(title: 'Complete morning mission', xp: 100, done: false),
            _QuestTile(title: '10 minute workout', xp: 80, done: false),
            _QuestTile(title: 'Read Quran', xp: 60, done: false),
          ],
        ),
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          'Ready to rise?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _NextAlarmCard extends StatelessWidget {
  const _NextAlarmCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NEXT ALARM',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '7:00',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                SizedBox(width: 6),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'AM',
                    style: TextStyle(
                      color: AppColors.orange,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Mon - Fri  •  Math Quest  •  in 8h 30m',
              style: TextStyle(color: AppColors.textSecondary),
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
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
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

  const _QuestTile({
    required this.title,
    required this.xp,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
        trailing: Text(
          '+$xp XP',
          style: const TextStyle(
            color: AppColors.gold,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}