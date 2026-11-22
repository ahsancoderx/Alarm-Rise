import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/fitness_exercise.dart';
import '../../alarms/widgets/workout_picker.dart';
import '../../rewards/providers/rewards_providers.dart';
import 'quick_workout_screen.dart';

class FitnessTab extends ConsumerStatefulWidget {
  const FitnessTab({super.key});

  @override
  ConsumerState<FitnessTab> createState() => _FitnessTabState();
}

class _FitnessTabState extends ConsumerState<FitnessTab> {
  FitnessExercise _exercise = FitnessExercise.squats;
  int _reps = FitnessExercise.squats.defaultReps;

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(statsProvider);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.fitness_center_rounded,
                    color: AppColors.orange, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${stats.workouts} workouts completed',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 2),
                      const Text(
                        'XP is given for your first 3 workouts each day.',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Quick workout',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        WorkoutPicker(
          exercise: _exercise,
          reps: _reps,
          onExercise: (e) => setState(() {
            _exercise = e;
            _reps = e.defaultReps;
          }),
          onReps: (r) => setState(() => _reps = r),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 56,
          child: FilledButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) =>
                    QuickWorkoutScreen(exercise: _exercise, reps: _reps),
              ),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text('Start ${_exercise.title}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}