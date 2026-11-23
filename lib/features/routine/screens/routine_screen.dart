import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'fitness_tab.dart';
import 'habits_tab.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Routine'),
          bottom: const TabBar(
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.orange,
            tabs: [
              Tab(text: 'Habits'),
              Tab(text: 'Fitness'),
              Tab(text: 'Quran'),
            ],
          ),
        ),
        body: const TabBarView(
  children: [HabitsTab(), FitnessTab(), Center(child: Text('Quran'))],
),
      ),
    );
  }
}