// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AlarmsTableTable extends AlarmsTable
    with TableInfo<$AlarmsTableTable, AlarmRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlarmsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysMeta = const VerificationMeta('days');
  @override
  late final GeneratedColumn<String> days = GeneratedColumn<String>(
    'days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toneMeta = const VerificationMeta('tone');
  @override
  late final GeneratedColumn<String> tone = GeneratedColumn<String>(
    'tone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vibrateMeta = const VerificationMeta(
    'vibrate',
  );
  @override
  late final GeneratedColumn<bool> vibrate = GeneratedColumn<bool>(
    'vibrate',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("vibrate" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hour,
    minute,
    days,
    category,
    tone,
    vibrate,
    label,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alarms';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlarmRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('days')) {
      context.handle(
        _daysMeta,
        days.isAcceptableOrUnknown(data['days']!, _daysMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('tone')) {
      context.handle(
        _toneMeta,
        tone.isAcceptableOrUnknown(data['tone']!, _toneMeta),
      );
    } else if (isInserting) {
      context.missing(_toneMeta);
    }
    if (data.containsKey('vibrate')) {
      context.handle(
        _vibrateMeta,
        vibrate.isAcceptableOrUnknown(data['vibrate']!, _vibrateMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlarmRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlarmRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
      days: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}days'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      tone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tone'],
      )!,
      vibrate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}vibrate'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $AlarmsTableTable createAlias(String alias) {
    return $AlarmsTableTable(attachedDatabase, alias);
  }
}

class AlarmRow extends DataClass implements Insertable<AlarmRow> {
  final int id;
  final int hour;
  final int minute;
  final String days;
  final String category;
  final String tone;
  final bool vibrate;
  final String label;
  final bool enabled;
  const AlarmRow({
    required this.id,
    required this.hour,
    required this.minute,
    required this.days,
    required this.category,
    required this.tone,
    required this.vibrate,
    required this.label,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['days'] = Variable<String>(days);
    map['category'] = Variable<String>(category);
    map['tone'] = Variable<String>(tone);
    map['vibrate'] = Variable<bool>(vibrate);
    map['label'] = Variable<String>(label);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  AlarmsTableCompanion toCompanion(bool nullToAbsent) {
    return AlarmsTableCompanion(
      id: Value(id),
      hour: Value(hour),
      minute: Value(minute),
      days: Value(days),
      category: Value(category),
      tone: Value(tone),
      vibrate: Value(vibrate),
      label: Value(label),
      enabled: Value(enabled),
    );
  }

  factory AlarmRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlarmRow(
      id: serializer.fromJson<int>(json['id']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      days: serializer.fromJson<String>(json['days']),
      category: serializer.fromJson<String>(json['category']),
      tone: serializer.fromJson<String>(json['tone']),
      vibrate: serializer.fromJson<bool>(json['vibrate']),
      label: serializer.fromJson<String>(json['label']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'days': serializer.toJson<String>(days),
      'category': serializer.toJson<String>(category),
      'tone': serializer.toJson<String>(tone),
      'vibrate': serializer.toJson<bool>(vibrate),
      'label': serializer.toJson<String>(label),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  AlarmRow copyWith({
    int? id,
    int? hour,
    int? minute,
    String? days,
    String? category,
    String? tone,
    bool? vibrate,
    String? label,
    bool? enabled,
  }) => AlarmRow(
    id: id ?? this.id,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    days: days ?? this.days,
    category: category ?? this.category,
    tone: tone ?? this.tone,
    vibrate: vibrate ?? this.vibrate,
    label: label ?? this.label,
    enabled: enabled ?? this.enabled,
  );
  AlarmRow copyWithCompanion(AlarmsTableCompanion data) {
    return AlarmRow(
      id: data.id.present ? data.id.value : this.id,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      days: data.days.present ? data.days.value : this.days,
      category: data.category.present ? data.category.value : this.category,
      tone: data.tone.present ? data.tone.value : this.tone,
      vibrate: data.vibrate.present ? data.vibrate.value : this.vibrate,
      label: data.label.present ? data.label.value : this.label,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlarmRow(')
          ..write('id: $id, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('days: $days, ')
          ..write('category: $category, ')
          ..write('tone: $tone, ')
          ..write('vibrate: $vibrate, ')
          ..write('label: $label, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hour,
    minute,
    days,
    category,
    tone,
    vibrate,
    label,
    enabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlarmRow &&
          other.id == this.id &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.days == this.days &&
          other.category == this.category &&
          other.tone == this.tone &&
          other.vibrate == this.vibrate &&
          other.label == this.label &&
          other.enabled == this.enabled);
}

class AlarmsTableCompanion extends UpdateCompanion<AlarmRow> {
  final Value<int> id;
  final Value<int> hour;
  final Value<int> minute;
  final Value<String> days;
  final Value<String> category;
  final Value<String> tone;
  final Value<bool> vibrate;
  final Value<String> label;
  final Value<bool> enabled;
  const AlarmsTableCompanion({
    this.id = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.days = const Value.absent(),
    this.category = const Value.absent(),
    this.tone = const Value.absent(),
    this.vibrate = const Value.absent(),
    this.label = const Value.absent(),
    this.enabled = const Value.absent(),
  });
  AlarmsTableCompanion.insert({
    this.id = const Value.absent(),
    required int hour,
    required int minute,
    this.days = const Value.absent(),
    required String category,
    required String tone,
    this.vibrate = const Value.absent(),
    this.label = const Value.absent(),
    this.enabled = const Value.absent(),
  }) : hour = Value(hour),
       minute = Value(minute),
       category = Value(category),
       tone = Value(tone);
  static Insertable<AlarmRow> custom({
    Expression<int>? id,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<String>? days,
    Expression<String>? category,
    Expression<String>? tone,
    Expression<bool>? vibrate,
    Expression<String>? label,
    Expression<bool>? enabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (days != null) 'days': days,
      if (category != null) 'category': category,
      if (tone != null) 'tone': tone,
      if (vibrate != null) 'vibrate': vibrate,
      if (label != null) 'label': label,
      if (enabled != null) 'enabled': enabled,
    });
  }

  AlarmsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? hour,
    Value<int>? minute,
    Value<String>? days,
    Value<String>? category,
    Value<String>? tone,
    Value<bool>? vibrate,
    Value<String>? label,
    Value<bool>? enabled,
  }) {
    return AlarmsTableCompanion(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      days: days ?? this.days,
      category: category ?? this.category,
      tone: tone ?? this.tone,
      vibrate: vibrate ?? this.vibrate,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (days.present) {
      map['days'] = Variable<String>(days.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (tone.present) {
      map['tone'] = Variable<String>(tone.value);
    }
    if (vibrate.present) {
      map['vibrate'] = Variable<bool>(vibrate.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlarmsTableCompanion(')
          ..write('id: $id, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('days: $days, ')
          ..write('category: $category, ')
          ..write('tone: $tone, ')
          ..write('vibrate: $vibrate, ')
          ..write('label: $label, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AlarmsTableTable alarmsTable = $AlarmsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [alarmsTable];
}

typedef $$AlarmsTableTableCreateCompanionBuilder =
    AlarmsTableCompanion Function({
      Value<int> id,
      required int hour,
      required int minute,
      Value<String> days,
      required String category,
      required String tone,
      Value<bool> vibrate,
      Value<String> label,
      Value<bool> enabled,
    });
typedef $$AlarmsTableTableUpdateCompanionBuilder =
    AlarmsTableCompanion Function({
      Value<int> id,
      Value<int> hour,
      Value<int> minute,
      Value<String> days,
      Value<String> category,
      Value<String> tone,
      Value<bool> vibrate,
      Value<String> label,
      Value<bool> enabled,
    });

class $$AlarmsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AlarmsTableTable> {
  $$AlarmsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get days => $composableBuilder(
    column: $table.days,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tone => $composableBuilder(
    column: $table.tone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get vibrate => $composableBuilder(
    column: $table.vibrate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlarmsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AlarmsTableTable> {
  $$AlarmsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get days => $composableBuilder(
    column: $table.days,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tone => $composableBuilder(
    column: $table.tone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get vibrate => $composableBuilder(
    column: $table.vibrate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlarmsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlarmsTableTable> {
  $$AlarmsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<String> get days =>
      $composableBuilder(column: $table.days, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get tone =>
      $composableBuilder(column: $table.tone, builder: (column) => column);

  GeneratedColumn<bool> get vibrate =>
      $composableBuilder(column: $table.vibrate, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$AlarmsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlarmsTableTable,
          AlarmRow,
          $$AlarmsTableTableFilterComposer,
          $$AlarmsTableTableOrderingComposer,
          $$AlarmsTableTableAnnotationComposer,
          $$AlarmsTableTableCreateCompanionBuilder,
          $$AlarmsTableTableUpdateCompanionBuilder,
          (
            AlarmRow,
            BaseReferences<_$AppDatabase, $AlarmsTableTable, AlarmRow>,
          ),
          AlarmRow,
          PrefetchHooks Function()
        > {
  $$AlarmsTableTableTableManager(_$AppDatabase db, $AlarmsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlarmsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlarmsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlarmsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
                Value<String> days = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> tone = const Value.absent(),
                Value<bool> vibrate = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => AlarmsTableCompanion(
                id: id,
                hour: hour,
                minute: minute,
                days: days,
                category: category,
                tone: tone,
                vibrate: vibrate,
                label: label,
                enabled: enabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int hour,
                required int minute,
                Value<String> days = const Value.absent(),
                required String category,
                required String tone,
                Value<bool> vibrate = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => AlarmsTableCompanion.insert(
                id: id,
                hour: hour,
                minute: minute,
                days: days,
                category: category,
                tone: tone,
                vibrate: vibrate,
                label: label,
                enabled: enabled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AlarmsTableTable, AlarmRow>(table),
                  BaseReferences<_$AppDatabase, $AlarmsTableTable, AlarmRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlarmsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlarmsTableTable,
      AlarmRow,
      $$AlarmsTableTableFilterComposer,
      $$AlarmsTableTableOrderingComposer,
      $$AlarmsTableTableAnnotationComposer,
      $$AlarmsTableTableCreateCompanionBuilder,
      $$AlarmsTableTableUpdateCompanionBuilder,
      (AlarmRow, BaseReferences<_$AppDatabase, $AlarmsTableTable, AlarmRow>),
      AlarmRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AlarmsTableTableTableManager get alarmsTable =>
      $$AlarmsTableTableTableManager(_db, _db.alarmsTable);
}
