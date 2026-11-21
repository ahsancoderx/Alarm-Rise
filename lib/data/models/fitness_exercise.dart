import 'package:flutter/material.dart';

enum FitnessExercise {
  squats(
    title: 'Squats',
    subtitle: 'Bend your knees, then stand tall',
    icon: Icons.accessibility_new_rounded,
    color: Color(0xFFEF4444),
    accuracy: 'Best accuracy',
    accuracyColor: Color(0xFF16A34A),
    tip: 'Put the phone 2 m away, in front of you or to your side. '
        'Your whole body, head to feet, must be visible.',
    startPose: 'Stand up straight and hold still',
    defaultReps: 10,
    restAt: 0.08, // kamar ki height itni se kam girी = aaram
    activeAt: 0.22, // itni gir gayi = squat neeche
    minRepMs: 1000,
  ),
  jumpingJacks(
    title: 'Jumping Jacks',
    subtitle: 'Arms up and legs apart, then back',
    icon: Icons.directions_run_rounded,
    color: Color(0xFFDB2777),
    accuracy: 'Good accuracy',
    accuracyColor: Color(0xFF2563EB),
    tip: 'Put the phone 2 m away, facing you. Raise your arms to shoulder '
        'height or higher.',
    startPose: 'Stand with your arms down by your sides',
    defaultReps: 15,
    restAt: -0.5, // bazu neeche
    activeAt: 0.15, // bazu kandhe ki height ya us se upar
    minRepMs: 450,
  ),
  pushUps(
    title: 'Push-ups',
    subtitle: 'Lower your chest, then push up',
    icon: Icons.fitness_center_rounded,
    color: Color(0xFFE5A100),
    accuracy: 'Needs setup',
    accuracyColor: Color(0xFFEA580C),
    tip: 'Put the phone on the floor, 1.5 to 2 m away, to your SIDE so your '
        'shoulder and hand are visible.',
    startPose: 'Hold a plank with straight arms and stay still',
    defaultReps: 8,
    restAt: 0.15,
    activeAt: 0.40,
    minRepMs: 800,
  );

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String accuracy;
  final Color accuracyColor;
  final String tip;
  final String startPose;
  final int defaultReps;

  /// Har exercise ka "progress" (aaram = 0 ke aas paas, active = bara).
  /// progress <= restAt: aaram. progress >= activeAt: active.
  final double restAt;
  final double activeAt;
  final int minRepMs;

  const FitnessExercise({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.accuracy,
    required this.accuracyColor,
    required this.tip,
    required this.startPose,
    required this.defaultReps,
    required this.restAt,
    required this.activeAt,
    required this.minRepMs,
  });
}