import 'package:flutter/material.dart';

enum FitnessExercise {
  squats(
    title: 'Squats',
    subtitle: 'Bend your knees, then stand tall',
    icon: Icons.accessibility_new_rounded,
    color: Color(0xFFEF4444),
    accuracy: 'Best accuracy',
    accuracyColor: Color(0xFF16A34A),
    tip: 'Put the phone 2 m away, to your SIDE, so your whole body is visible side-on.',
    startPose: 'stand up straight',
    defaultReps: 10,
    restIsHigh: true,
    restAngle: 160, // seedha khara: knee angle isse zyada
    activeAngle: 110, // neeche: knee angle isse kam
    minRepMs: 1200,
  ),
  jumpingJacks(
    title: 'Jumping Jacks',
    subtitle: 'Arms up and legs apart, then back',
    icon: Icons.directions_run_rounded,
    color: Color(0xFFDB2777),
    accuracy: 'Good accuracy',
    accuracyColor: Color(0xFF2563EB),
    tip: 'Put the phone 2 m away, FACING you, so arms and body are visible.',
    startPose: 'arms down by your sides',
    defaultReps: 15,
    restIsHigh: false,
    restAngle: 45, // bazu neeche: angle isse kam
    activeAngle: 130, // bazu upar: angle isse zyada
    minRepMs: 600,
  ),
  pushUps(
    title: 'Push-ups',
    subtitle: 'Lower your chest, then push up',
    icon: Icons.fitness_center_rounded,
    color: Color(0xFFE5A100),
    accuracy: 'Needs setup',
    accuracyColor: Color(0xFFEA580C),
    tip: 'Put the phone on the floor, 1.5 to 2 m away, to your SIDE so your whole arm and body show.',
    startPose: 'arms straight, in plank position',
    defaultReps: 8,
    restIsHigh: true,
    restAngle: 150,
    activeAngle: 100,
    minRepMs: 900,
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

  /// true: aaram ki haalat mein angle bara (squat, pushup).
  /// false: aaram ki haalat mein angle chhota (jumping jack).
  final bool restIsHigh;
  final double restAngle;
  final double activeAngle;
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
    required this.restIsHigh,
    required this.restAngle,
    required this.activeAngle,
    required this.minRepMs,
  });
}