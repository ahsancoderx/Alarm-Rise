import 'package:alarm/alarm.dart' as plugin;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/alarm_scheduler.dart';
import '../../../core/services/audio_control.dart';
import '../../../core/services/photo_service.dart';
import '../../../data/database/database_provider.dart';
import '../../../data/models/alarm.dart';
import '../../../data/models/alarm_category.dart';
import '../../missions/fitness/workout_mission.dart';
import '../../missions/math_mission.dart';
import '../../missions/photo_mission.dart';
import '../providers/alarms_provider.dart';

class AlarmRingScreen extends ConsumerStatefulWidget {
  final int alarmId;
  const AlarmRingScreen({super.key, required this.alarmId});

  @override
  ConsumerState<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends ConsumerState<AlarmRingScreen> {
  Alarm? _alarm;
  bool _muted = false;

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

  Future<void> _toggleMute() async {
    final next = !_muted;
    final ok = await AudioControl.setAlarmVolume(next ? 0.0 : 1.0);
    if (ok && mounted) setState(() => _muted = next);
  }

  Future<void> _complete() async {
    final a = _alarm!;
    await plugin.Alarm.stop(a.id); // package purani volume khud wapas kar deta hai
    if (a.days.isEmpty) {
      await ref.read(databaseProvider).setEnabled(a.id, false);
    } else {
      await AlarmScheduler.schedule(a);
    }
    appRouter.go('/home');
  }

  Widget _buildMission(Alarm a) {
    switch (a.category) {
      case AlarmCategory.math:
        return MathMission(onSolved: _complete);
      case AlarmCategory.sky:
        return PhotoMission(
          icon: Icons.wb_sunny_rounded,
          instruction:
              'Take a clear photo of the sky. Step outside or go to an open window.',
          verify: PhotoService.verifySky,
          onSolved: _complete,
        );
      case AlarmCategory.room:
        return PhotoMission(
          icon: Icons.meeting_room_rounded,
          instruction: 'Walk to your spot and take a photo of it.',
          referencePath: a.referencePhoto,
          verify: (path) => PhotoService.verifyRoom(a.referenceLabels, path),
          onSolved: _complete,
        );
      case AlarmCategory.fitness:
        return WorkoutMission(
          exercise: a.workout,
          reps: a.reps,
          onSolved: _complete,
        );
      default:
        return _SimpleDismiss(onDismiss: _complete);
    }
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
                        a.label.isNotEmpty ? a.label : a.missionText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, color: AppColors.textSecondary),
                      ),
                      if (a.vibrate)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: TextButton.icon(
                            onPressed: _toggleMute,
                            icon: Icon(_muted
                                ? Icons.volume_up_rounded
                                : Icons.volume_off_rounded),
                            label: Text(_muted
                                ? 'Unmute sound'
                                : 'Mute sound (vibration stays on)'),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(child: _buildMission(a)),
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
        const Text('Good morning! Time to rise.',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
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