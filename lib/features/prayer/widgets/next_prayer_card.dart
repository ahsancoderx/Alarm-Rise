import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/prayer_calc.dart';
import '../../home/providers/clock_provider.dart';
import '../models/prayer.dart';
import '../providers/prayer_providers.dart';

String _until(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  if (h > 0) return 'in ${h}h ${m}m';
  if (m > 0) return 'in ${m}m';
  return 'now';
}

class NextPrayerCard extends ConsumerWidget {
  const NextPrayerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cfg = ref.watch(prayerConfigProvider);
    final next = ref.watch(nextPrayerProvider);
    final now = ref.watch(clockProvider).value ?? DateTime.now();

    if (!cfg.hasLocation) {
      return Card(
        child: ListTile(
          onTap: () => context.go('/routine'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          leading: const Icon(Icons.mosque_rounded, color: AppColors.orange),
          title: const Text('Set location for prayer times',
              style: TextStyle(fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
      );
    }
    if (next == null) return const SizedBox.shrink();

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.go('/routine'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(next.prayer.icon, color: AppColors.orange),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NEXT PRAYER',
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('${next.prayer.title}  ${fmtClock(next.time)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              Text(_until(next.time.difference(now)),
                  style: const TextStyle(
                      color: AppColors.orange, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}