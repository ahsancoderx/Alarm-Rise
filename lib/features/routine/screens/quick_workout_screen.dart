import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/fitness_exercise.dart';
import '../../missions/fitness/workout_mission.dart';
import '../../rewards/providers/rewards_providers.dart';

class QuickWorkoutScreen extends ConsumerStatefulWidget {
  final FitnessExercise exercise;
  final int reps;
  const QuickWorkoutScreen(
      {super.key, required this.exercise, required this.reps});

  @override
  ConsumerState<QuickWorkoutScreen> createState() =>
      _QuickWorkoutScreenState();
}

class _QuickWorkoutScreenState extends ConsumerState<QuickWorkoutScreen> {
  bool _done = false;

  Future<void> _onSolved() async {
    if (_done) return;
    _done = true;
    final r = await ref
        .read(rewardsServiceProvider)
        .awardWorkout(widget.exercise, widget.reps);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Workout complete!'),
        content: Text(r.xp > 0
            ? '+${r.xp} XP   •   +${r.coins} coins'
            : 'Great job! You reached today\'s workout XP limit.'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.exercise.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: WorkoutMission(
            exercise: widget.exercise,
            reps: widget.reps,
            onSolved: _onSolved,
          ),
        ),
      ),
    );
  }
}