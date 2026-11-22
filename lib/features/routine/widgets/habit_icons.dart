import 'package:flutter/material.dart';

const habitIcons = <String, IconData>{
  'water': Icons.water_drop_rounded,
  'quran': Icons.menu_book_rounded,
  'run': Icons.directions_run_rounded,
  'sleep': Icons.bedtime_rounded,
  'book': Icons.auto_stories_rounded,
  'heart': Icons.favorite_rounded,
  'food': Icons.restaurant_rounded,
  'pray': Icons.mosque_rounded,
  'check': Icons.check_circle_rounded,
};

IconData habitIcon(String key) => habitIcons[key] ?? Icons.check_circle_rounded;