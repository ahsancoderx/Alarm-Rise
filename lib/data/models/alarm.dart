import 'alarm_category.dart';
import 'fitness_exercise.dart';

class Alarm {
  final int id;
  final int hour;
  final int minute;
  final Set<int> days; // 1 = Mon ... 7 = Sun, empty = once
  final AlarmCategory category;
  final String tone;
  final bool vibrate;
  final String label;
  final bool enabled;
  final String referencePhoto;
  final String referenceLabels;
  final String exercise; // FitnessExercise.name
  final int reps;

  const Alarm({
    required this.id,
    required this.hour,
    required this.minute,
    this.days = const {},
    this.category = AlarmCategory.simple,
    this.tone = 'Morning Energy',
    this.vibrate = true,
    this.label = '',
    this.enabled = true,
    this.referencePhoto = '',
    this.referenceLabels = '',
    this.exercise = '',
    this.reps = 10,
  });

  Alarm copyWith({bool? enabled}) {
    return Alarm(
      id: id,
      hour: hour,
      minute: minute,
      days: days,
      category: category,
      tone: tone,
      vibrate: vibrate,
      label: label,
      enabled: enabled ?? this.enabled,
      referencePhoto: referencePhoto,
      referenceLabels: referenceLabels,
      exercise: exercise,
      reps: reps,
    );
  }

  FitnessExercise get workout => FitnessExercise.values.firstWhere(
        (e) => e.name == exercise,
        orElse: () => FitnessExercise.squats,
      );

  /// List aur cards mein dikhane ke liye ("Squats ×10" ya category ka naam).
  String get missionText => category == AlarmCategory.fitness
      ? '${workout.title} ×$reps'
      : category.title;

  String get timeText {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    return '$h:${minute.toString().padLeft(2, '0')}';
  }

  String get period => hour < 12 ? 'AM' : 'PM';

  String get repeatText {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (days.isEmpty) return 'Once';
    if (days.length == 7) return 'Every day';
    if (days.length == 5 && !days.contains(6) && !days.contains(7)) {
      return 'Mon - Fri';
    }
    final sorted = days.toList()..sort();
    return sorted.map((d) => names[d - 1]).join(', ');
  }
}