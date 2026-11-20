import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/fitness_exercise.dart';

class WorkoutPicker extends StatelessWidget {
  static const minReps = 3;
  static const maxReps = 30;

  final FitnessExercise exercise;
  final int reps;
  final ValueChanged<FitnessExercise> onExercise;
  final ValueChanged<int> onReps;

  const WorkoutPicker({
    super.key,
    required this.exercise,
    required this.reps,
    required this.onExercise,
    required this.onReps,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final e in FitnessExercise.values)
                  ChoiceChip(
                    label: Text(e.title),
                    selected: e == exercise,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: e == exercise ? Colors.white : AppColors.textPrimary,
                    ),
                    onSelected: (_) => onExercise(e),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(exercise.tip,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Reps to stop alarm',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const Spacer(),
                IconButton.filledTonal(
                  onPressed: reps > minReps ? () => onReps(reps - 1) : null,
                  icon: const Icon(Icons.remove_rounded),
                ),
                SizedBox(
                  width: 44,
                  child: Text('$reps',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800)),
                ),
                IconButton.filledTonal(
                  onPressed: reps < maxReps ? () => onReps(reps + 1) : null,
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}