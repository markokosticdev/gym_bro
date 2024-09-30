import 'package:collection/collection.dart';
import 'package:gym_bro/utils/serialization_util.dart';
import 'package:gym_bro/schema/enums/exercise_enum.dart';
import 'package:gym_bro/schema/structs/base_struct.dart';
import 'package:gym_bro/utils/general_util.dart';

class WorkoutSetStruct extends BaseStruct {
  WorkoutSetStruct({
    String? id,
    Exercise? exercise,
    int? weight,
    int? repetitions,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : _id = id,
        _exercise = exercise,
        _weight = weight,
        _repetitions = repetitions,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  Exercise? _exercise;
  Exercise? get exercise => _exercise;
  set exercise(Exercise? val) => _exercise = val;

  bool hasExercise() => _exercise != null;

  int? _weight;
  int get weight => _weight ?? 0;
  set weight(int? val) => _weight = val;

  void incrementWeight(int amount) => weight = weight + amount;

  bool hasWeight() => _weight != null;

  int? _repetitions;
  int get repetitions => _repetitions ?? 0;
  set repetitions(int? val) => _repetitions = val;

  void incrementRepetitions(int amount) => repetitions = repetitions + amount;

  bool hasRepetitions() => _repetitions != null;

  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  set updatedAt(DateTime? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  static WorkoutSetStruct fromMap(Map<String, dynamic> data) =>
      WorkoutSetStruct(
        id: data['id'] as String?,
        exercise: deserializeEnum<Exercise>(data['exercise']),
        weight: castToType<int>(data['weight']),
        repetitions: castToType<int>(data['repetitions']),
        createdAt: data['createdAt'] as DateTime?,
        updatedAt: data['updatedAt'] as DateTime?,
      );

  static WorkoutSetStruct? maybeFromMap(dynamic data) => data is Map
      ? WorkoutSetStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'exercise': _exercise?.serialize(),
        'weight': _weight,
        'repetitions': _repetitions,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'exercise': serializeParam(
          _exercise,
          ParamType.Enum,
        ),
        'weight': serializeParam(
          _weight,
          ParamType.int,
        ),
        'repetitions': serializeParam(
          _repetitions,
          ParamType.int,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'updatedAt': serializeParam(
          _updatedAt,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static WorkoutSetStruct fromSerializableMap(Map<String, dynamic> data) =>
      WorkoutSetStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        exercise: deserializeParam<Exercise>(
          data['exercise'],
          ParamType.Enum,
          false,
        ),
        weight: deserializeParam(
          data['weight'],
          ParamType.int,
          false,
        ),
        repetitions: deserializeParam(
          data['repetitions'],
          ParamType.int,
          false,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.DateTime,
          false,
        ),
        updatedAt: deserializeParam(
          data['updatedAt'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'WorkoutSetStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is WorkoutSetStruct &&
        id == other.id &&
        exercise == other.exercise &&
        weight == other.weight &&
        repetitions == other.repetitions &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, exercise, weight, repetitions, createdAt, updatedAt]);
}

WorkoutSetStruct createWorkoutSetStruct({
  String? id,
  Exercise? exercise,
  int? weight,
  int? repetitions,
  DateTime? createdAt,
  DateTime? updatedAt,
}) =>
    WorkoutSetStruct(
      id: id,
      exercise: exercise,
      weight: weight,
      repetitions: repetitions,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
