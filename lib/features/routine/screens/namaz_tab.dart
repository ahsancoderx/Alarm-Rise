import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/prayer_calc.dart';
import '../../../core/utils/rewards_logic.dart';
import '../../alarms/providers/alarms_provider.dart';
import '../../home/providers/clock_provider.dart';
import '../../prayer/models/prayer.dart';
import '../../prayer/providers/prayer_providers.dart';
import '../../rewards/providers/rewards_providers.dart';
import 'namaz_sheets.dart';

class NamazTab extends ConsumerWidget {
  const NamazTab({super.key});

  Future<void> _toggle(BuildContext context, WidgetRef ref, Prayer p,
      DateTime time, DateTime now, bool isDone, String today) async {
    final m = ScaffoldMessenger.of(context);
    if (!isDone && now.isBefore(time)) {
      m.clearSnackBars();
      m.showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),
          content: Text('${p.title} time has not started yet')));
      return;
    }
    await ref.read(rewardsServiceProvider).togglePrayer(p, today, !isDone);
    if (!context.mounted) return;
    m.clearSnackBars();
    m.showSnackBar(SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(!isDone ? '+${p.xp} XP' : 'Unchecked')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(settingsProvider).hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    final cfg = ref.watch(prayerConfigProvider);

    if (!cfg.hasLocation) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.mosque_rounded,
                  size: 72, color: Color(0xFF16A34A)),
              const SizedBox(height: 16),
              const Text('Prayer times & alarms',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text(
                'Set your location to see prayer times and set Fajr or any prayer alarm. Works offline.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => showLocationSheet(context),
                icon: const Icon(Icons.location_on_rounded),
                label: const Text('Set my location'),
              ),
            ],
          ),
        ),
      );
    }

    final today = ref.watch(todayKeyProvider);
    final day = ref.watch(todayTimesProvider);
    final done = ref.watch(todayPrayerDoneProvider);
    final next = ref.watch(nextPrayerProvider);
    final alarms = ref.watch(alarmsProvider);
    final now = ref.watch(clockProvider).value ?? DateTime.now();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        Card(
          child: ListTile(
            onTap: () => showLocationSheet(context),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            leading:
                const Icon(Icons.location_on_rounded, color: AppColors.orange),
            title: Text(cfg.locationName,
                style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text('${cfg.method.label}  •  ${cfg.madhab.label}',
                style: const TextStyle(fontSize: 12)),
            trailing: IconButton(
              icon: const Icon(Icons.tune_rounded),
              onPressed: () => showSettingsSheet(context),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text('${done.length} of 5 prayers today',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: done.length / 5,
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
          color: AppColors.orange,
          backgroundColor: AppColors.border,
        ),
        const SizedBox(height: 16),
        if (day == null)
          const Text('Prayer times are not available for this location.',
              style: TextStyle(color: AppColors.textSecondary))
        else ...[
          for (final p in Prayer.values)
            Builder(builder: (_) {
              final time = day[p];
              final isDone = done.contains(p.name);
              final isNext = next?.prayer == p && dayKey(next!.time) == today;
              final ac = cfg.alarm(p);
              final alarmOn = ac.on &&
                  alarms.any((x) => x.id == ac.alarmId && x.enabled);

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                  leading: GestureDetector(
                    onTap: () =>
                        _toggle(context, ref, p, time, now, isDone, today),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone ? AppColors.orange : Colors.transparent,
                        border: Border.all(
                            color: isDone
                                ? AppColors.orange
                                : AppColors.textSecondary,
                            width: 2),
                      ),
                      child: isDone
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 20)
                          : null,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(p.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(p.arabic,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 14)),
                      if (isNext) ...[
                        const SizedBox(width: 8),
                        const Text('NEXT',
                            style: TextStyle(
                                color: AppColors.orange,
                                fontSize: 11,
                                fontWeight: FontWeight.w800)),
                      ],
                    ],
                  ),
                 subtitle: alarmOn
                      ? Text(
                          ac.custom
                              ? 'Alarm at ${fmtClock(DateTime(2000, 1, 1, ac.customHour, ac.customMinute))}'
                              : (ac.offset == 0
                                  ? 'Alarm at azan'
                                  : 'Alarm ${ac.offset} min before'),
                          style: const TextStyle(fontSize: 12))
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(fmtClock(time),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: isNext
                                  ? AppColors.orange
                                  : AppColors.textPrimary)),
                      IconButton(
                        icon: Icon(
                            alarmOn
                                ? Icons.alarm_on_rounded
                                : Icons.alarm_add_rounded,
                            color: alarmOn
                                ? AppColors.orange
                                : AppColors.textSecondary),
                        onPressed: () => showAlarmSheet(context, p),
                      ),
                    ],
                  ),
                ),
              );
            }),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Sunrise ${fmtClock(day.sunrise)}  •  Times are calculated on your phone. '
              'Fine tune them in settings to match your mosque.',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}