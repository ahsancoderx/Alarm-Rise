import 'package:flutter/material.dart';

enum AlarmCategory {
  simple('Simple Alarm', 'Just wake up', Icons.alarm_rounded, Color(0xFFFF7A1A)),
  math('Math Quest', 'Solve to stop', Icons.calculate_rounded, Color(0xFF3B82F6)),
  sky('Sky Photo', 'Capture the sky', Icons.wb_sunny_rounded, Color(0xFF0EA5E9)),
  room('Room Photo', 'Get out of bed', Icons.meeting_room_rounded, Color(0xFF8B5CF6)),
  quran('Quran Read', 'Start with tilawat', Icons.menu_book_rounded, Color(0xFF16A34A)),
  fitness('Fitness / Gym', 'Move to stop', Icons.fitness_center_rounded, Color(0xFFEF4444)),
  qr('QR Scan', 'Scan a hidden code', Icons.qr_code_scanner_rounded, Color(0xFF0F766E)),
  steps('Walk Steps', 'Walk to stop', Icons.directions_walk_rounded, Color(0xFFE5A100)),
  shake('Shake', 'Shake your phone', Icons.vibration_rounded, Color(0xFFDB2777)),
  memory('Memory Match', 'Repeat the pattern', Icons.psychology_rounded, Color(0xFF6366F1));

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const AlarmCategory(this.title, this.subtitle, this.icon, this.color);
}

const alarmTones = [
  'Morning Energy',
  'Sunrise Bell',
  'Bird Song',
  'Digital Beep',
  'Calm Piano',
  'Loud Siren',
];