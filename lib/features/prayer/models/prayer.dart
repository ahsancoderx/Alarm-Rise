import 'package:flutter/material.dart';

enum Prayer { fajr, dhuhr, asr, maghrib, isha }

extension PrayerInfo on Prayer {
  String get title => switch (this) {
        Prayer.fajr => 'Fajr',
        Prayer.dhuhr => 'Dhuhr',
        Prayer.asr => 'Asr',
        Prayer.maghrib => 'Maghrib',
        Prayer.isha => 'Isha',
      };

  String get arabic => switch (this) {
        Prayer.fajr => 'الفجر',
        Prayer.dhuhr => 'الظهر',
        Prayer.asr => 'العصر',
        Prayer.maghrib => 'المغرب',
        Prayer.isha => 'العشاء',
      };

  IconData get icon => switch (this) {
        Prayer.fajr => Icons.nights_stay_rounded,
        Prayer.dhuhr => Icons.wb_sunny_rounded,
        Prayer.asr => Icons.wb_cloudy_rounded,
        Prayer.maghrib => Icons.wb_twilight_rounded,
        Prayer.isha => Icons.bedtime_rounded,
      };

  int get xp => this == Prayer.fajr ? 20 : 10;
}

enum Madhab {
  hanafi('Hanafi'),
  shafii("Shafi'i"),
  maliki('Maliki'),
  hanbali('Hanbali');

  final String label;
  const Madhab(this.label);
}