import 'package:flutter/material.dart';

enum AlarmCategory {
  simple('Simple Alarm', 'Just wake up', Icons.alarm_rounded, Color(0xFFFF7A1A)),
  math('Math Quest', 'Solve to stop', Icons.calculate_rounded, Color(0xFF3B82F6)),
  sky('Sky Photo', 'Capture the sky', Icons.wb_sunny_rounded, Color(0xFF0EA5E9)),
  room('Room Photo', 'Get out of bed', Icons.meeting_room_rounded, Color(0xFF8B5CF6)),
  fitness('Fitness / Gym', 'Move to stop', Icons.fitness_center_rounded, Color(0xFFEF4444)),
  face('Eyes & Smile', 'Open eyes, then smile', Icons.sentiment_very_satisfied_rounded, Color(0xFF14B8A6));

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const AlarmCategory(this.title, this.subtitle, this.icon, this.color);
}

/// Purana, ab istemal nahi hota (tones ToneCatalog se aati hain).
const alarmTones = [
  'Morning Energy',
  'Sunrise Bell',
  'Bird Song',
  'Digital Beep',
  'Calm Piano',
  'Loud Siren',
];