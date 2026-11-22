import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/rewards_logic.dart';
import '../providers/rewards_providers.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final events = ref.watch(xpEventsProvider).value ?? const [];
    final unlocked = achievements.where((a) => a.check(stats)).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _LevelCard(stats: stats),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('Achievements',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('$unlocked / ${achievements.length}',
                  style: const TextStyle(
                      color: AppColors.gold, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 142,
            ),
            itemBuilder: (_, i) {
              final a = achievements[i];
              return _AchievementTile(a: a, unlocked: a.check(stats));
            },
          ),
          const SizedBox(height: 24),
          const Text('Recent activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          if (events.isEmpty)
            const Text(
              'Nothing yet. Complete an alarm mission or check in a habit to earn XP.',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            for (final e in events.take(12)) _ActivityTile(e: e),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final RewardStats stats;
  const _LevelCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.orange,
                  ),
                  child: Text('${stats.level}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Level ${stats.level}',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w800)),
                      Text('${fmtNum(stats.totalXp)} XP',
                          style: const TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: stats.levelProgress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.orange,
                        backgroundColor: AppColors.border,
                      ),
                      const SizedBox(height: 4),
                      Text(
                          '${fmtNum(stats.xpToNext)} XP to level ${stats.level + 1}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _Mini(Icons.local_fire_department_rounded, AppColors.orange,
                    '${stats.streak}', 'Streak'),
                _Mini(Icons.military_tech_rounded, AppColors.orange,
                    '${stats.bestStreak}', 'Best'),
                _Mini(Icons.monetization_on_rounded, AppColors.gold,
                    fmtNum(stats.coins), 'Coins'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  const _Mini(this.icon, this.color, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement a;
  final bool unlocked;
  const _AchievementTile({required this.a, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unlocked ? 1 : 0.55,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: unlocked
                      ? AppColors.gold.withValues(alpha: 0.18)
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(unlocked ? a.icon : Icons.lock_rounded,
                    color: unlocked ? AppColors.gold : AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(a.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 2),
              Text(a.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final dynamic e; // XpEventRow
  const _ActivityTile({required this.e});

  @override
  Widget build(BuildContext context) {
    final icon = switch (e.kind as String) {
      'alarm' => Icons.alarm_rounded,
      'workout' => Icons.fitness_center_rounded,
      _ => Icons.check_circle_rounded,
    };
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.orange),
        title: Text(e.title as String,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(e.day as String),
        trailing: Text('+${e.xp} XP',
            style: const TextStyle(
                color: AppColors.gold, fontWeight: FontWeight.w700)),
      ),
    );
  }
}