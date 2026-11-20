import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('AlarmRow')
class AlarmsTable extends Table {
  @override
  String get tableName => 'alarms';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  TextColumn get days => text().withDefault(const Constant(''))(); // "1,2,3"
  TextColumn get category => text()();
  TextColumn get tone => text()();
  BoolColumn get vibrate => boolean().withDefault(const Constant(true))();
  TextColumn get label => text().withDefault(const Constant(''))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  TextColumn get referencePhoto => text().withDefault(const Constant(''))();
  TextColumn get referenceLabels => text().withDefault(const Constant(''))();
  TextColumn get exercise => text().withDefault(const Constant(''))();
  IntColumn get reps => integer().withDefault(const Constant(10))();
}

@DriftDatabase(tables: [AlarmsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'risequest'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await customStatement(
              "ALTER TABLE alarms ADD COLUMN reference_photo TEXT NOT NULL DEFAULT ''",
            );
            await customStatement(
              "ALTER TABLE alarms ADD COLUMN reference_labels TEXT NOT NULL DEFAULT ''",
            );
          }
          if (from < 3) {
            await customStatement(
              "ALTER TABLE alarms ADD COLUMN exercise TEXT NOT NULL DEFAULT ''",
            );
            await customStatement(
              "ALTER TABLE alarms ADD COLUMN reps INTEGER NOT NULL DEFAULT 10",
            );
          }
        },
      );

  Stream<List<AlarmRow>> watchAlarms() {
    final query = select(alarmsTable)
      ..orderBy([
        (t) => OrderingTerm.asc(t.hour),
        (t) => OrderingTerm.asc(t.minute),
      ]);
    return query.watch();
  }

  Future<AlarmRow?> getAlarm(int id) =>
      (select(alarmsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertAlarm(AlarmsTableCompanion alarm) =>
      into(alarmsTable).insertOnConflictUpdate(alarm);

  Future<void> setEnabled(int id, bool value) =>
      (update(alarmsTable)..where((t) => t.id.equals(id)))
          .write(AlarmsTableCompanion(enabled: Value(value)));

  Future<void> deleteAlarm(int id) =>
      (delete(alarmsTable)..where((t) => t.id.equals(id))).go();
}