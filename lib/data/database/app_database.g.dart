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
  static const VerificationMeta _referencePhotoMeta = const VerificationMeta(
    'referencePhoto',
  );
  @override
  late final GeneratedColumn<String> referencePhoto = GeneratedColumn<String>(
    'reference_photo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _referenceLabelsMeta = const VerificationMeta(
    'referenceLabels',
  );
  @override
  late final GeneratedColumn<String> referenceLabels = GeneratedColumn<String>(
    'reference_labels',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _exerciseMeta = const VerificationMeta(
    'exercise',
  );
  @override
  late final GeneratedColumn<String> exercise = GeneratedColumn<String>(
    'exercise',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
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
    referencePhoto,
    referenceLabels,
    exercise,
    reps,
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
    if (data.containsKey('reference_photo')) {
      context.handle(
        _referencePhotoMeta,
        referencePhoto.isAcceptableOrUnknown(
          data['reference_photo']!,
          _referencePhotoMeta,
        ),
      );
    }
    if (data.containsKey('reference_labels')) {
      context.handle(
        _referenceLabelsMeta,
        referenceLabels.isAcceptableOrUnknown(
          data['reference_labels']!,
          _referenceLabelsMeta,
        ),
      );
    }
    if (data.containsKey('exercise')) {
      context.handle(
        _exerciseMeta,
        exercise.isAcceptableOrUnknown(data['exercise']!, _exerciseMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
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
      referencePhoto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_photo'],
      )!,
      referenceLabels: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_labels'],
      )!,
      exercise: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
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
  final String referencePhoto;
  final String referenceLabels;
  final String exercise;
  final int reps;
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
    required this.referencePhoto,
    required this.referenceLabels,
    required this.exercise,
    required this.reps,
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
    map['reference_photo'] = Variable<String>(referencePhoto);
    map['reference_labels'] = Variable<String>(referenceLabels);
    map['exercise'] = Variable<String>(exercise);
    map['reps'] = Variable<int>(reps);
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
      referencePhoto: Value(referencePhoto),
      referenceLabels: Value(referenceLabels),
      exercise: Value(exercise),
      reps: Value(reps),
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
      referencePhoto: serializer.fromJson<String>(json['referencePhoto']),
      referenceLabels: serializer.fromJson<String>(json['referenceLabels']),
      exercise: serializer.fromJson<String>(json['exercise']),
      reps: serializer.fromJson<int>(json['reps']),
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
      'referencePhoto': serializer.toJson<String>(referencePhoto),
      'referenceLabels': serializer.toJson<String>(referenceLabels),
      'exercise': serializer.toJson<String>(exercise),
      'reps': serializer.toJson<int>(reps),
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
    String? referencePhoto,
    String? referenceLabels,
    String? exercise,
    int? reps,
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
    referencePhoto: referencePhoto ?? this.referencePhoto,
    referenceLabels: referenceLabels ?? this.referenceLabels,
    exercise: exercise ?? this.exercise,
    reps: reps ?? this.reps,
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
      referencePhoto: data.referencePhoto.present
          ? data.referencePhoto.value
          : this.referencePhoto,
      referenceLabels: data.referenceLabels.present
          ? data.referenceLabels.value
          : this.referenceLabels,
      exercise: data.exercise.present ? data.exercise.value : this.exercise,
      reps: data.reps.present ? data.reps.value : this.reps,
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
          ..write('enabled: $enabled, ')
          ..write('referencePhoto: $referencePhoto, ')
          ..write('referenceLabels: $referenceLabels, ')
          ..write('exercise: $exercise, ')
          ..write('reps: $reps')
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
    referencePhoto,
    referenceLabels,
    exercise,
    reps,
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
          other.enabled == this.enabled &&
          other.referencePhoto == this.referencePhoto &&
          other.referenceLabels == this.referenceLabels &&
          other.exercise == this.exercise &&
          other.reps == this.reps);
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
  final Value<String> referencePhoto;
  final Value<String> referenceLabels;
  final Value<String> exercise;
  final Value<int> reps;
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
    this.referencePhoto = const Value.absent(),
    this.referenceLabels = const Value.absent(),
    this.exercise = const Value.absent(),
    this.reps = const Value.absent(),
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
    this.referencePhoto = const Value.absent(),
    this.referenceLabels = const Value.absent(),
    this.exercise = const Value.absent(),
    this.reps = const Value.absent(),
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
    Expression<String>? referencePhoto,
    Expression<String>? referenceLabels,
    Expression<String>? exercise,
    Expression<int>? reps,
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
      if (referencePhoto != null) 'reference_photo': referencePhoto,
      if (referenceLabels != null) 'reference_labels': referenceLabels,
      if (exercise != null) 'exercise': exercise,
      if (reps != null) 'reps': reps,
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
    Value<String>? referencePhoto,
    Value<String>? referenceLabels,
    Value<String>? exercise,
    Value<int>? reps,
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
      referencePhoto: referencePhoto ?? this.referencePhoto,
      referenceLabels: referenceLabels ?? this.referenceLabels,
      exercise: exercise ?? this.exercise,
      reps: reps ?? this.reps,
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
    if (referencePhoto.present) {
      map['reference_photo'] = Variable<String>(referencePhoto.value);
    }
    if (referenceLabels.present) {
      map['reference_labels'] = Variable<String>(referenceLabels.value);
    }
    if (exercise.present) {
      map['exercise'] = Variable<String>(exercise.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
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
          ..write('enabled: $enabled, ')
          ..write('referencePhoto: $referencePhoto, ')
          ..write('referenceLabels: $referenceLabels, ')
          ..write('exercise: $exercise, ')
          ..write('reps: $reps')
          ..write(')'))
        .toString();
  }
}

class $HabitsTableTable extends HabitsTable
    with TableInfo<$HabitsTableTable, HabitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('check'),
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, xp, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HabitsTableTable createAlias(String alias) {
    return $HabitsTableTable(attachedDatabase, alias);
  }
}

class HabitRow extends DataClass implements Insertable<HabitRow> {
  final int id;
  final String name;
  final String icon;
  final int xp;
  final DateTime createdAt;
  const HabitRow({
    required this.id,
    required this.name,
    required this.icon,
    required this.xp,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['xp'] = Variable<int>(xp);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HabitsTableCompanion toCompanion(bool nullToAbsent) {
    return HabitsTableCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      xp: Value(xp),
      createdAt: Value(createdAt),
    );
  }

  factory HabitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      xp: serializer.fromJson<int>(json['xp']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'xp': serializer.toJson<int>(xp),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HabitRow copyWith({
    int? id,
    String? name,
    String? icon,
    int? xp,
    DateTime? createdAt,
  }) => HabitRow(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    xp: xp ?? this.xp,
    createdAt: createdAt ?? this.createdAt,
  );
  HabitRow copyWithCompanion(HabitsTableCompanion data) {
    return HabitRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      xp: data.xp.present ? data.xp.value : this.xp,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('xp: $xp, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, xp, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.xp == this.xp &&
          other.createdAt == this.createdAt);
}

class HabitsTableCompanion extends UpdateCompanion<HabitRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> xp;
  final Value<DateTime> createdAt;
  const HabitsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.xp = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  HabitsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.icon = const Value.absent(),
    this.xp = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<HabitRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? xp,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (xp != null) 'xp': xp,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  HabitsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? xp,
    Value<DateTime>? createdAt,
  }) {
    return HabitsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      xp: xp ?? this.xp,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('xp: $xp, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $HabitLogsTableTable extends HabitLogsTable
    with TableInfo<$HabitLogsTableTable, HabitLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitLogsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<int> habitId = GeneratedColumn<int>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, habitId, day];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {habitId, day},
  ];
  @override
  HabitLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}habit_id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
    );
  }

  @override
  $HabitLogsTableTable createAlias(String alias) {
    return $HabitLogsTableTable(attachedDatabase, alias);
  }
}

class HabitLogRow extends DataClass implements Insertable<HabitLogRow> {
  final int id;
  final int habitId;
  final String day;
  const HabitLogRow({
    required this.id,
    required this.habitId,
    required this.day,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['habit_id'] = Variable<int>(habitId);
    map['day'] = Variable<String>(day);
    return map;
  }

  HabitLogsTableCompanion toCompanion(bool nullToAbsent) {
    return HabitLogsTableCompanion(
      id: Value(id),
      habitId: Value(habitId),
      day: Value(day),
    );
  }

  factory HabitLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitLogRow(
      id: serializer.fromJson<int>(json['id']),
      habitId: serializer.fromJson<int>(json['habitId']),
      day: serializer.fromJson<String>(json['day']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'habitId': serializer.toJson<int>(habitId),
      'day': serializer.toJson<String>(day),
    };
  }

  HabitLogRow copyWith({int? id, int? habitId, String? day}) => HabitLogRow(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    day: day ?? this.day,
  );
  HabitLogRow copyWithCompanion(HabitLogsTableCompanion data) {
    return HabitLogRow(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      day: data.day.present ? data.day.value : this.day,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitLogRow(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('day: $day')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, day);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitLogRow &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.day == this.day);
}

class HabitLogsTableCompanion extends UpdateCompanion<HabitLogRow> {
  final Value<int> id;
  final Value<int> habitId;
  final Value<String> day;
  const HabitLogsTableCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.day = const Value.absent(),
  });
  HabitLogsTableCompanion.insert({
    this.id = const Value.absent(),
    required int habitId,
    required String day,
  }) : habitId = Value(habitId),
       day = Value(day);
  static Insertable<HabitLogRow> custom({
    Expression<int>? id,
    Expression<int>? habitId,
    Expression<String>? day,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (day != null) 'day': day,
    });
  }

  HabitLogsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? habitId,
    Value<String>? day,
  }) {
    return HabitLogsTableCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      day: day ?? this.day,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<int>(habitId.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('day: $day')
          ..write(')'))
        .toString();
  }
}

class $XpEventsTableTable extends XpEventsTable
    with TableInfo<$XpEventsTableTable, XpEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $XpEventsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coinsMeta = const VerificationMeta('coins');
  @override
  late final GeneratedColumn<int> coins = GeneratedColumn<int>(
    'coins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _refKeyMeta = const VerificationMeta('refKey');
  @override
  late final GeneratedColumn<String> refKey = GeneratedColumn<String>(
    'ref_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    title,
    xp,
    coins,
    day,
    hour,
    refKey,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'xp_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<XpEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    } else if (isInserting) {
      context.missing(_xpMeta);
    }
    if (data.containsKey('coins')) {
      context.handle(
        _coinsMeta,
        coins.isAcceptableOrUnknown(data['coins']!, _coinsMeta),
      );
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    }
    if (data.containsKey('ref_key')) {
      context.handle(
        _refKeyMeta,
        refKey.isAcceptableOrUnknown(data['ref_key']!, _refKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_refKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  XpEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return XpEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      xp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}xp'],
      )!,
      coins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coins'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      refKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $XpEventsTableTable createAlias(String alias) {
    return $XpEventsTableTable(attachedDatabase, alias);
  }
}

class XpEventRow extends DataClass implements Insertable<XpEventRow> {
  final int id;
  final String kind;
  final String title;
  final int xp;
  final int coins;
  final String day;
  final int hour;
  final String refKey;
  final DateTime createdAt;
  const XpEventRow({
    required this.id,
    required this.kind,
    required this.title,
    required this.xp,
    required this.coins,
    required this.day,
    required this.hour,
    required this.refKey,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    map['title'] = Variable<String>(title);
    map['xp'] = Variable<int>(xp);
    map['coins'] = Variable<int>(coins);
    map['day'] = Variable<String>(day);
    map['hour'] = Variable<int>(hour);
    map['ref_key'] = Variable<String>(refKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  XpEventsTableCompanion toCompanion(bool nullToAbsent) {
    return XpEventsTableCompanion(
      id: Value(id),
      kind: Value(kind),
      title: Value(title),
      xp: Value(xp),
      coins: Value(coins),
      day: Value(day),
      hour: Value(hour),
      refKey: Value(refKey),
      createdAt: Value(createdAt),
    );
  }

  factory XpEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return XpEventRow(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String>(json['title']),
      xp: serializer.fromJson<int>(json['xp']),
      coins: serializer.fromJson<int>(json['coins']),
      day: serializer.fromJson<String>(json['day']),
      hour: serializer.fromJson<int>(json['hour']),
      refKey: serializer.fromJson<String>(json['refKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String>(title),
      'xp': serializer.toJson<int>(xp),
      'coins': serializer.toJson<int>(coins),
      'day': serializer.toJson<String>(day),
      'hour': serializer.toJson<int>(hour),
      'refKey': serializer.toJson<String>(refKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  XpEventRow copyWith({
    int? id,
    String? kind,
    String? title,
    int? xp,
    int? coins,
    String? day,
    int? hour,
    String? refKey,
    DateTime? createdAt,
  }) => XpEventRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    xp: xp ?? this.xp,
    coins: coins ?? this.coins,
    day: day ?? this.day,
    hour: hour ?? this.hour,
    refKey: refKey ?? this.refKey,
    createdAt: createdAt ?? this.createdAt,
  );
  XpEventRow copyWithCompanion(XpEventsTableCompanion data) {
    return XpEventRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      xp: data.xp.present ? data.xp.value : this.xp,
      coins: data.coins.present ? data.coins.value : this.coins,
      day: data.day.present ? data.day.value : this.day,
      hour: data.hour.present ? data.hour.value : this.hour,
      refKey: data.refKey.present ? data.refKey.value : this.refKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('XpEventRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('xp: $xp, ')
          ..write('coins: $coins, ')
          ..write('day: $day, ')
          ..write('hour: $hour, ')
          ..write('refKey: $refKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, title, xp, coins, day, hour, refKey, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is XpEventRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.xp == this.xp &&
          other.coins == this.coins &&
          other.day == this.day &&
          other.hour == this.hour &&
          other.refKey == this.refKey &&
          other.createdAt == this.createdAt);
}

class XpEventsTableCompanion extends UpdateCompanion<XpEventRow> {
  final Value<int> id;
  final Value<String> kind;
  final Value<String> title;
  final Value<int> xp;
  final Value<int> coins;
  final Value<String> day;
  final Value<int> hour;
  final Value<String> refKey;
  final Value<DateTime> createdAt;
  const XpEventsTableCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.xp = const Value.absent(),
    this.coins = const Value.absent(),
    this.day = const Value.absent(),
    this.hour = const Value.absent(),
    this.refKey = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  XpEventsTableCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required String title,
    required int xp,
    this.coins = const Value.absent(),
    required String day,
    this.hour = const Value.absent(),
    required String refKey,
    this.createdAt = const Value.absent(),
  }) : kind = Value(kind),
       title = Value(title),
       xp = Value(xp),
       day = Value(day),
       refKey = Value(refKey);
  static Insertable<XpEventRow> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<int>? xp,
    Expression<int>? coins,
    Expression<String>? day,
    Expression<int>? hour,
    Expression<String>? refKey,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (xp != null) 'xp': xp,
      if (coins != null) 'coins': coins,
      if (day != null) 'day': day,
      if (hour != null) 'hour': hour,
      if (refKey != null) 'ref_key': refKey,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  XpEventsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<String>? title,
    Value<int>? xp,
    Value<int>? coins,
    Value<String>? day,
    Value<int>? hour,
    Value<String>? refKey,
    Value<DateTime>? createdAt,
  }) {
    return XpEventsTableCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      day: day ?? this.day,
      hour: hour ?? this.hour,
      refKey: refKey ?? this.refKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (coins.present) {
      map['coins'] = Variable<int>(coins.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (refKey.present) {
      map['ref_key'] = Variable<String>(refKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('XpEventsTableCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('xp: $xp, ')
          ..write('coins: $coins, ')
          ..write('day: $day, ')
          ..write('hour: $hour, ')
          ..write('refKey: $refKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PrayerLogsTableTable extends PrayerLogsTable
    with TableInfo<$PrayerLogsTableTable, PrayerLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrayerLogsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prayerMeta = const VerificationMeta('prayer');
  @override
  late final GeneratedColumn<String> prayer = GeneratedColumn<String>(
    'prayer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, day, prayer];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prayer_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrayerLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('prayer')) {
      context.handle(
        _prayerMeta,
        prayer.isAcceptableOrUnknown(data['prayer']!, _prayerMeta),
      );
    } else if (isInserting) {
      context.missing(_prayerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {day, prayer},
  ];
  @override
  PrayerLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrayerLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      prayer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prayer'],
      )!,
    );
  }

  @override
  $PrayerLogsTableTable createAlias(String alias) {
    return $PrayerLogsTableTable(attachedDatabase, alias);
  }
}

class PrayerLogRow extends DataClass implements Insertable<PrayerLogRow> {
  final int id;
  final String day;
  final String prayer;
  const PrayerLogRow({
    required this.id,
    required this.day,
    required this.prayer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day'] = Variable<String>(day);
    map['prayer'] = Variable<String>(prayer);
    return map;
  }

  PrayerLogsTableCompanion toCompanion(bool nullToAbsent) {
    return PrayerLogsTableCompanion(
      id: Value(id),
      day: Value(day),
      prayer: Value(prayer),
    );
  }

  factory PrayerLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrayerLogRow(
      id: serializer.fromJson<int>(json['id']),
      day: serializer.fromJson<String>(json['day']),
      prayer: serializer.fromJson<String>(json['prayer']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'day': serializer.toJson<String>(day),
      'prayer': serializer.toJson<String>(prayer),
    };
  }

  PrayerLogRow copyWith({int? id, String? day, String? prayer}) => PrayerLogRow(
    id: id ?? this.id,
    day: day ?? this.day,
    prayer: prayer ?? this.prayer,
  );
  PrayerLogRow copyWithCompanion(PrayerLogsTableCompanion data) {
    return PrayerLogRow(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      prayer: data.prayer.present ? data.prayer.value : this.prayer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrayerLogRow(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('prayer: $prayer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, day, prayer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrayerLogRow &&
          other.id == this.id &&
          other.day == this.day &&
          other.prayer == this.prayer);
}

class PrayerLogsTableCompanion extends UpdateCompanion<PrayerLogRow> {
  final Value<int> id;
  final Value<String> day;
  final Value<String> prayer;
  const PrayerLogsTableCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.prayer = const Value.absent(),
  });
  PrayerLogsTableCompanion.insert({
    this.id = const Value.absent(),
    required String day,
    required String prayer,
  }) : day = Value(day),
       prayer = Value(prayer);
  static Insertable<PrayerLogRow> custom({
    Expression<int>? id,
    Expression<String>? day,
    Expression<String>? prayer,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (prayer != null) 'prayer': prayer,
    });
  }

  PrayerLogsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? day,
    Value<String>? prayer,
  }) {
    return PrayerLogsTableCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      prayer: prayer ?? this.prayer,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (prayer.present) {
      map['prayer'] = Variable<String>(prayer.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrayerLogsTableCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('prayer: $prayer')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _settingKeyMeta = const VerificationMeta(
    'settingKey',
  );
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
    'setting_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingValueMeta = const VerificationMeta(
    'settingValue',
  );
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
    'setting_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [settingKey, settingValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('setting_key')) {
      context.handle(
        _settingKeyMeta,
        settingKey.isAcceptableOrUnknown(data['setting_key']!, _settingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('setting_value')) {
      context.handle(
        _settingValueMeta,
        settingValue.isAcceptableOrUnknown(
          data['setting_value']!,
          _settingValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_settingValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {settingKey};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      settingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_key'],
      )!,
      settingValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_value'],
      )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String settingKey;
  final String settingValue;
  const SettingRow({required this.settingKey, required this.settingValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['setting_key'] = Variable<String>(settingKey);
    map['setting_value'] = Variable<String>(settingValue);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      settingKey: Value(settingKey),
      settingValue: Value(settingValue),
    );
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String>(json['settingValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String>(settingValue),
    };
  }

  SettingRow copyWith({String? settingKey, String? settingValue}) => SettingRow(
    settingKey: settingKey ?? this.settingKey,
    settingValue: settingValue ?? this.settingValue,
  );
  SettingRow copyWithCompanion(SettingsTableCompanion data) {
    return SettingRow(
      settingKey: data.settingKey.present
          ? data.settingKey.value
          : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(settingKey, settingValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue);
}

class SettingsTableCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> settingKey;
  final Value<String> settingValue;
  final Value<int> rowid;
  const SettingsTableCompanion({
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    required String settingKey,
    required String settingValue,
    this.rowid = const Value.absent(),
  }) : settingKey = Value(settingKey),
       settingValue = Value(settingValue);
  static Insertable<SettingRow> custom({
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (settingKey != null) 'setting_key': settingKey,
      if (settingValue != null) 'setting_value': settingValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsTableCompanion copyWith({
    Value<String>? settingKey,
    Value<String>? settingValue,
    Value<int>? rowid,
  }) {
    return SettingsTableCompanion(
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['setting_value'] = Variable<String>(settingValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AlarmsTableTable alarmsTable = $AlarmsTableTable(this);
  late final $HabitsTableTable habitsTable = $HabitsTableTable(this);
  late final $HabitLogsTableTable habitLogsTable = $HabitLogsTableTable(this);
  late final $XpEventsTableTable xpEventsTable = $XpEventsTableTable(this);
  late final $PrayerLogsTableTable prayerLogsTable = $PrayerLogsTableTable(
    this,
  );
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    alarmsTable,
    habitsTable,
    habitLogsTable,
    xpEventsTable,
    prayerLogsTable,
    settingsTable,
  ];
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
      Value<String> referencePhoto,
      Value<String> referenceLabels,
      Value<String> exercise,
      Value<int> reps,
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
      Value<String> referencePhoto,
      Value<String> referenceLabels,
      Value<String> exercise,
      Value<int> reps,
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

  ColumnFilters<String> get referencePhoto => $composableBuilder(
    column: $table.referencePhoto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceLabels => $composableBuilder(
    column: $table.referenceLabels,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exercise => $composableBuilder(
    column: $table.exercise,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
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

  ColumnOrderings<String> get referencePhoto => $composableBuilder(
    column: $table.referencePhoto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceLabels => $composableBuilder(
    column: $table.referenceLabels,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exercise => $composableBuilder(
    column: $table.exercise,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
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

  GeneratedColumn<String> get referencePhoto => $composableBuilder(
    column: $table.referencePhoto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenceLabels => $composableBuilder(
    column: $table.referenceLabels,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exercise =>
      $composableBuilder(column: $table.exercise, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);
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
                Value<String> referencePhoto = const Value.absent(),
                Value<String> referenceLabels = const Value.absent(),
                Value<String> exercise = const Value.absent(),
                Value<int> reps = const Value.absent(),
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
                referencePhoto: referencePhoto,
                referenceLabels: referenceLabels,
                exercise: exercise,
                reps: reps,
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
                Value<String> referencePhoto = const Value.absent(),
                Value<String> referenceLabels = const Value.absent(),
                Value<String> exercise = const Value.absent(),
                Value<int> reps = const Value.absent(),
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
                referencePhoto: referencePhoto,
                referenceLabels: referenceLabels,
                exercise: exercise,
                reps: reps,
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
typedef $$HabitsTableTableCreateCompanionBuilder =
    HabitsTableCompanion Function({
      Value<int> id,
      required String name,
      Value<String> icon,
      Value<int> xp,
      Value<DateTime> createdAt,
    });
typedef $$HabitsTableTableUpdateCompanionBuilder =
    HabitsTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> icon,
      Value<int> xp,
      Value<DateTime> createdAt,
    });

class $$HabitsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HabitsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTableTable,
          HabitRow,
          $$HabitsTableTableFilterComposer,
          $$HabitsTableTableOrderingComposer,
          $$HabitsTableTableAnnotationComposer,
          $$HabitsTableTableCreateCompanionBuilder,
          $$HabitsTableTableUpdateCompanionBuilder,
          (
            HabitRow,
            BaseReferences<_$AppDatabase, $HabitsTableTable, HabitRow>,
          ),
          HabitRow,
          PrefetchHooks Function()
        > {
  $$HabitsTableTableTableManager(_$AppDatabase db, $HabitsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HabitsTableCompanion(
                id: id,
                name: name,
                icon: icon,
                xp: xp,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> icon = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => HabitsTableCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                xp: xp,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitsTableTable, HabitRow>(table),
                  BaseReferences<_$AppDatabase, $HabitsTableTable, HabitRow>(
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

typedef $$HabitsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTableTable,
      HabitRow,
      $$HabitsTableTableFilterComposer,
      $$HabitsTableTableOrderingComposer,
      $$HabitsTableTableAnnotationComposer,
      $$HabitsTableTableCreateCompanionBuilder,
      $$HabitsTableTableUpdateCompanionBuilder,
      (HabitRow, BaseReferences<_$AppDatabase, $HabitsTableTable, HabitRow>),
      HabitRow,
      PrefetchHooks Function()
    >;
typedef $$HabitLogsTableTableCreateCompanionBuilder =
    HabitLogsTableCompanion Function({
      Value<int> id,
      required int habitId,
      required String day,
    });
typedef $$HabitLogsTableTableUpdateCompanionBuilder =
    HabitLogsTableCompanion Function({
      Value<int> id,
      Value<int> habitId,
      Value<String> day,
    });

class $$HabitLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HabitLogsTableTable> {
  $$HabitLogsTableTableFilterComposer({
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

  ColumnFilters<int> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitLogsTableTable> {
  $$HabitLogsTableTableOrderingComposer({
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

  ColumnOrderings<int> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitLogsTableTable> {
  $$HabitLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);
}

class $$HabitLogsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitLogsTableTable,
          HabitLogRow,
          $$HabitLogsTableTableFilterComposer,
          $$HabitLogsTableTableOrderingComposer,
          $$HabitLogsTableTableAnnotationComposer,
          $$HabitLogsTableTableCreateCompanionBuilder,
          $$HabitLogsTableTableUpdateCompanionBuilder,
          (
            HabitLogRow,
            BaseReferences<_$AppDatabase, $HabitLogsTableTable, HabitLogRow>,
          ),
          HabitLogRow,
          PrefetchHooks Function()
        > {
  $$HabitLogsTableTableTableManager(
    _$AppDatabase db,
    $HabitLogsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> habitId = const Value.absent(),
            Value<String> day = const Value.absent(),
          }) => HabitLogsTableCompanion(id: id, habitId: habitId, day: day),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int habitId,
                required String day,
              }) => HabitLogsTableCompanion.insert(
                id: id,
                habitId: habitId,
                day: day,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitLogsTableTable, HabitLogRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $HabitLogsTableTable,
                    HabitLogRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitLogsTableTable,
      HabitLogRow,
      $$HabitLogsTableTableFilterComposer,
      $$HabitLogsTableTableOrderingComposer,
      $$HabitLogsTableTableAnnotationComposer,
      $$HabitLogsTableTableCreateCompanionBuilder,
      $$HabitLogsTableTableUpdateCompanionBuilder,
      (
        HabitLogRow,
        BaseReferences<_$AppDatabase, $HabitLogsTableTable, HabitLogRow>,
      ),
      HabitLogRow,
      PrefetchHooks Function()
    >;
typedef $$XpEventsTableTableCreateCompanionBuilder =
    XpEventsTableCompanion Function({
      Value<int> id,
      required String kind,
      required String title,
      required int xp,
      Value<int> coins,
      required String day,
      Value<int> hour,
      required String refKey,
      Value<DateTime> createdAt,
    });
typedef $$XpEventsTableTableUpdateCompanionBuilder =
    XpEventsTableCompanion Function({
      Value<int> id,
      Value<String> kind,
      Value<String> title,
      Value<int> xp,
      Value<int> coins,
      Value<String> day,
      Value<int> hour,
      Value<String> refKey,
      Value<DateTime> createdAt,
    });

class $$XpEventsTableTableFilterComposer
    extends Composer<_$AppDatabase, $XpEventsTableTable> {
  $$XpEventsTableTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coins => $composableBuilder(
    column: $table.coins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refKey => $composableBuilder(
    column: $table.refKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$XpEventsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $XpEventsTableTable> {
  $$XpEventsTableTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coins => $composableBuilder(
    column: $table.coins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refKey => $composableBuilder(
    column: $table.refKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$XpEventsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $XpEventsTableTable> {
  $$XpEventsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get coins =>
      $composableBuilder(column: $table.coins, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<String> get refKey =>
      $composableBuilder(column: $table.refKey, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$XpEventsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $XpEventsTableTable,
          XpEventRow,
          $$XpEventsTableTableFilterComposer,
          $$XpEventsTableTableOrderingComposer,
          $$XpEventsTableTableAnnotationComposer,
          $$XpEventsTableTableCreateCompanionBuilder,
          $$XpEventsTableTableUpdateCompanionBuilder,
          (
            XpEventRow,
            BaseReferences<_$AppDatabase, $XpEventsTableTable, XpEventRow>,
          ),
          XpEventRow,
          PrefetchHooks Function()
        > {
  $$XpEventsTableTableTableManager(_$AppDatabase db, $XpEventsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$XpEventsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$XpEventsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$XpEventsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> coins = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<String> refKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => XpEventsTableCompanion(
                id: id,
                kind: kind,
                title: title,
                xp: xp,
                coins: coins,
                day: day,
                hour: hour,
                refKey: refKey,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                required String title,
                required int xp,
                Value<int> coins = const Value.absent(),
                required String day,
                Value<int> hour = const Value.absent(),
                required String refKey,
                Value<DateTime> createdAt = const Value.absent(),
              }) => XpEventsTableCompanion.insert(
                id: id,
                kind: kind,
                title: title,
                xp: xp,
                coins: coins,
                day: day,
                hour: hour,
                refKey: refKey,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$XpEventsTableTable, XpEventRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $XpEventsTableTable,
                    XpEventRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$XpEventsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $XpEventsTableTable,
      XpEventRow,
      $$XpEventsTableTableFilterComposer,
      $$XpEventsTableTableOrderingComposer,
      $$XpEventsTableTableAnnotationComposer,
      $$XpEventsTableTableCreateCompanionBuilder,
      $$XpEventsTableTableUpdateCompanionBuilder,
      (
        XpEventRow,
        BaseReferences<_$AppDatabase, $XpEventsTableTable, XpEventRow>,
      ),
      XpEventRow,
      PrefetchHooks Function()
    >;
typedef $$PrayerLogsTableTableCreateCompanionBuilder =
    PrayerLogsTableCompanion Function({
      Value<int> id,
      required String day,
      required String prayer,
    });
typedef $$PrayerLogsTableTableUpdateCompanionBuilder =
    PrayerLogsTableCompanion Function({
      Value<int> id,
      Value<String> day,
      Value<String> prayer,
    });

class $$PrayerLogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PrayerLogsTableTable> {
  $$PrayerLogsTableTableFilterComposer({
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

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prayer => $composableBuilder(
    column: $table.prayer,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrayerLogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PrayerLogsTableTable> {
  $$PrayerLogsTableTableOrderingComposer({
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

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prayer => $composableBuilder(
    column: $table.prayer,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrayerLogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrayerLogsTableTable> {
  $$PrayerLogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get prayer =>
      $composableBuilder(column: $table.prayer, builder: (column) => column);
}

class $$PrayerLogsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrayerLogsTableTable,
          PrayerLogRow,
          $$PrayerLogsTableTableFilterComposer,
          $$PrayerLogsTableTableOrderingComposer,
          $$PrayerLogsTableTableAnnotationComposer,
          $$PrayerLogsTableTableCreateCompanionBuilder,
          $$PrayerLogsTableTableUpdateCompanionBuilder,
          (
            PrayerLogRow,
            BaseReferences<_$AppDatabase, $PrayerLogsTableTable, PrayerLogRow>,
          ),
          PrayerLogRow,
          PrefetchHooks Function()
        > {
  $$PrayerLogsTableTableTableManager(
    _$AppDatabase db,
    $PrayerLogsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrayerLogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrayerLogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrayerLogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> day = const Value.absent(),
            Value<String> prayer = const Value.absent(),
          }) => PrayerLogsTableCompanion(id: id, day: day, prayer: prayer),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String day,
                required String prayer,
              }) => PrayerLogsTableCompanion.insert(
                id: id,
                day: day,
                prayer: prayer,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PrayerLogsTableTable, PrayerLogRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PrayerLogsTableTable,
                    PrayerLogRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrayerLogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrayerLogsTableTable,
      PrayerLogRow,
      $$PrayerLogsTableTableFilterComposer,
      $$PrayerLogsTableTableOrderingComposer,
      $$PrayerLogsTableTableAnnotationComposer,
      $$PrayerLogsTableTableCreateCompanionBuilder,
      $$PrayerLogsTableTableUpdateCompanionBuilder,
      (
        PrayerLogRow,
        BaseReferences<_$AppDatabase, $PrayerLogsTableTable, PrayerLogRow>,
      ),
      PrayerLogRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      required String settingKey,
      required String settingValue,
      Value<int> rowid,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<String> settingKey,
      Value<String> settingValue,
      Value<int> rowid,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => column,
  );
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          SettingRow,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $SettingsTableTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> settingKey = const Value.absent(),
                Value<String> settingValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsTableCompanion(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String settingKey,
                required String settingValue,
                Value<int> rowid = const Value.absent(),
              }) => SettingsTableCompanion.insert(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTableTable, SettingRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SettingsTableTable,
                    SettingRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      SettingRow,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (
        SettingRow,
        BaseReferences<_$AppDatabase, $SettingsTableTable, SettingRow>,
      ),
      SettingRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AlarmsTableTableTableManager get alarmsTable =>
      $$AlarmsTableTableTableManager(_db, _db.alarmsTable);
  $$HabitsTableTableTableManager get habitsTable =>
      $$HabitsTableTableTableManager(_db, _db.habitsTable);
  $$HabitLogsTableTableTableManager get habitLogsTable =>
      $$HabitLogsTableTableTableManager(_db, _db.habitLogsTable);
  $$XpEventsTableTableTableManager get xpEventsTable =>
      $$XpEventsTableTableTableManager(_db, _db.xpEventsTable);
  $$PrayerLogsTableTableTableManager get prayerLogsTable =>
      $$PrayerLogsTableTableTableManager(_db, _db.prayerLogsTable);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
}
