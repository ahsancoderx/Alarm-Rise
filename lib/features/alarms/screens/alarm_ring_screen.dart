import 'package:alarm/alarm.dart' as plugin;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/alarm_scheduler.dart';
import '../../../data/database/database_provider.dart';
import '../../../data/models/alarm.dart';
import '../../../data/models/alarm_category.dart';
import '../../missions/math_mission.dart';
import '../providers/alarms_provider.dart';

class AlarmRingScreen extends ConsumerStatefulWidget {
  final int alarmId;
  const AlarmRingScreen({super.key, required this.alarmId});

  @override
  ConsumerState<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends ConsumerState<AlarmRingScreen> {
  Alarm? _alarm;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final row = await ref.read(databaseProvider).getAlarm(widget.alarmId);
    if (!mounted) return;
    if (row == null) {
      await plugin.Alarm.stop(widget.alarmId);
      appRouter.go('/home');
      return;
    }
    setState(() => _alarm = alarmFromRow(row));
  }

  Future<void> _complete() async {
    final a = _alarm!;
    await plugin.Alarm.stop(a.id);
    if (a.days.isEmpty) {
      // Ek baar wala alarm: band kar do
      await ref.read(databaseProvider).setEnabled(a.id, false);
    } else {
      // Repeat wala alarm: agla din schedule karo
      await AlarmScheduler.schedule(a);
    }
    appRouter.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final a = _alarm;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: a == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Icon(a.category.icon, size: 48, color: a.category.color),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(a.timeText,
                              style: const TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.w800,
                                  height: 1)),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(a.period,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.orange)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        a.label.isNotEmpty ? a.label : a.category.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 28),
                      Expanded(
                        child: SingleChildScrollView(
                          child: a.category == AlarmCategory.math
                              ? MathMission(onSolved: _complete)
                              : _SimpleDismiss(onDismiss: _complete),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _SimpleDismiss extends StatelessWidget {
  final VoidCallback onDismiss;
  const _SimpleDismiss({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        const Text(
          'Good morning! Time to rise.',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 72,
          child: FilledButton(
            onPressed: onDismiss,
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Dismiss',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          ),
        ),
      ],
    );
  }
}