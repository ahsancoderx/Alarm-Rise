import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/alarm_scheduler.dart';
import '../../../data/database/app_database.dart';
import '../../../data/database/database_provider.dart';
import '../../../data/models/alarm.dart';
import '../../../data/models/alarm_category.dart';

Alarm alarmFromRow(AlarmRow r) {
  return Alarm(
    id: r.id,
    hour: r.hour,
    minute: r.minute,
    days: r.days.isEmpty ? {} : r.days.split(',').map(int.parse).toSet(),
    category: AlarmCategory.values.firstWhere(
      (c) => c.name == r.category,
      orElse: () => AlarmCategory.simple,
    ),
    tone: r.tone,
    vibrate: r.vibrate,
    label: r.label,
    enabled: r.enabled,
  );
}

class AlarmsNotifier extends Notifier<List<Alarm>> {
  AppDatabase get _db => ref.read(databaseProvider);

  @override
  List<Alarm> build() {
    final sub = ref.watch(databaseProvider).watchAlarms().listen((rows) {
      final list = rows.map(alarmFromRow).toList();
      state = list;
      _sync(list);
    });
    ref.onDispose(sub.cancel);
    return [];
  }

  Future<void> _sync(List<Alarm> list) async {
    try {
      await AlarmScheduler.syncAll(list);
    } catch (e) {
      debugPrint('Alarm sync failed: $e');
    }
  }

  /// 0 = new alarm, database khud id dega.
  int nextId() => 0;

  Future<void> save(Alarm a) {
    final days = (a.days.toList()..sort()).join(',');
    return _db.upsertAlarm(AlarmsTableCompanion(
      id: a.id == 0 ? const Value.absent() : Value(a.id),
      hour: Value(a.hour),
      minute: Value(a.minute),
      days: Value(days),
      category: Value(a.category.name),
      tone: Value(a.tone),
      vibrate: Value(a.vibrate),
      label: Value(a.label),
      enabled: Value(a.enabled),
    ));
  }

  Future<void> toggle(int id) {
    final current = state.firstWhere((a) => a.id == id);
    return _db.setEnabled(id, !current.enabled);
  }

  Future<void> remove(int id) => _db.deleteAlarm(id);
}

final alarmsProvider =
    NotifierProvider<AlarmsNotifier, List<Alarm>>(AlarmsNotifier.new);