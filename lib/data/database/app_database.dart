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

@DataClassName('HabitRow')
class HabitsTable extends Table {
  @override
  String get tableName => 'habits';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get icon => text().withDefault(const Constant('check'))();
  IntColumn get xp => integer().withDefault(const Constant(15))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('HabitLogRow')
class HabitLogsTable extends Table {
  @override
  String get tableName => 'habit_logs';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId => integer()();
  TextColumn get day => text()(); // "2026-11-22"

  @override
  List<Set<Column>> get uniqueKeys => [
        {habitId, day},
      ];
}

/// XP aur coins ka hisab. Streak bhi isi se nikalti hai.
@DataClassName('XpEventRow')
class XpEventsTable extends Table {
  @override
  String get tableName => 'xp_events';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()(); // alarm | habit | workout
  TextColumn get title => text()();
  IntColumn get xp => integer()();
  IntColumn get coins => integer().withDefault(const Constant(0))();
  TextColumn get day => text()();
  IntColumn get hour => integer().withDefault(const Constant(0))();
  TextColumn get refKey => text().unique()(); // dobara XP milne se rokta hai
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [AlarmsTable, HabitsTable, HabitLogsTable, XpEventsTable],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'risequest'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedHabits();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(alarmsTable, alarmsTable.referencePhoto);
            await m.addColumn(alarmsTable, alarmsTable.referenceLabels);
          }
          if (from < 3) {
            await m.addColumn(alarmsTable, alarmsTable.exercise);
            await m.addColumn(alarmsTable, alarmsTable.reps);
          }
          if (from < 4) {
            await m.createTable(habitsTable);
            await m.createTable(habitLogsTable);
            await m.createTable(xpEventsTable);
            await _seedHabits();
          }
        },
      );

  Future<void> _seedHabits() async {
    const defaults = [
      ('Drink water', 'water', 10),
      ('Read Quran', 'quran', 20),
      ('Exercise', 'run', 20),
      ('Sleep before 11 PM', 'sleep', 15),
    ];
    for (final d in defaults) {
      await into(habitsTable).insert(HabitsTableCompanion.insert(
        name: d.$1,
        icon: Value(d.$2),
        xp: Value(d.$3),
      ));
    }
  }

  // ---------- Alarms ----------

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

  // ---------- Habits ----------

  Stream<List<HabitRow>> watchHabits() =>
      (select(habitsTable)..orderBy([(t) => OrderingTerm.asc(t.id)])).watch();

  Stream<List<HabitLogRow>> watchHabitLogs() => select(habitLogsTable).watch();

  Future<void> addHabit(String name, String icon, int xp) =>
      into(habitsTable).insert(HabitsTableCompanion.insert(
        name: name,
        icon: Value(icon),
        xp: Value(xp),
      ));

  /// Habit aur uske logs hata deta hai (kamaya hua XP bacha rehta hai).
  Future<void> deleteHabit(int id) => transaction(() async {
        await (delete(habitLogsTable)..where((t) => t.habitId.equals(id))).go();
        await (delete(habitsTable)..where((t) => t.id.equals(id))).go();
      });

  Future<void> setHabitLog(int habitId, String day, bool done) async {
    if (done) {
      await into(habitLogsTable).insert(
        HabitLogsTableCompanion.insert(habitId: habitId, day: day),
        mode: InsertMode.insertOrIgnore,
      );
    } else {
      await (delete(habitLogsTable)
            ..where((t) => t.habitId.equals(habitId) & t.day.equals(day)))
          .go();
    }
  }

  // ---------- XP ----------

  Stream<List<XpEventRow>> watchXpEvents() => (select(xpEventsTable)
        ..orderBy([
          (t) => OrderingTerm.desc(t.createdAt),
          (t) => OrderingTerm.desc(t.id),
        ]))
      .watch();

  Future<List<XpEventRow>> allXpEvents() => select(xpEventsTable).get();

  Future<void> insertXp(XpEventsTableCompanion event) =>
      into(xpEventsTable).insert(event, mode: InsertMode.insertOrIgnore);

  Future<void> deleteXpByRef(String refKey) =>
      (delete(xpEventsTable)..where((t) => t.refKey.equals(refKey))).go();
}