import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/alarm.dart';

class AlarmsNotifier extends Notifier<List<Alarm>> {
  @override
  List<Alarm> build() => [];

  int nextId() => state.isEmpty
      ? 1
      : state.map((a) => a.id).reduce((a, b) => a > b ? a : b) + 1;

  void save(Alarm alarm) {
    final list = [...state];
    final i = list.indexWhere((a) => a.id == alarm.id);
    if (i == -1) {
      list.add(alarm);
    } else {
      list[i] = alarm;
    }
    list.sort((a, b) =>
        (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
    state = list;
  }

  void toggle(int id) {
    state = [
      for (final a in state)
        if (a.id == id) a.copyWith(enabled: !a.enabled) else a
    ];
  }

  void remove(int id) {
    state = state.where((a) => a.id != id).toList();
  }
}

final alarmsProvider =
    NotifierProvider<AlarmsNotifier, List<Alarm>>(AlarmsNotifier.new);