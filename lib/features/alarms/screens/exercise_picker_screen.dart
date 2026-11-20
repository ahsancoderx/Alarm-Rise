import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/alarm_category.dart';
import '../../../data/models/fitness_exercise.dart';
import 'alarm_edit_screen.dart';

class ExercisePickerScreen extends StatelessWidget {
  const ExercisePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose exercise')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: FitnessExercise.values.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final e = FitnessExercise.values[i];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => AlarmEditScreen(
                    category: AlarmCategory.fitness,
                    exercise: e,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: e.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(e.icon, color: e.color, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title,
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(e.subtitle,
                              style: const TextStyle(
                                  color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          Text(e.accuracy,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: e.accuracyColor)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}