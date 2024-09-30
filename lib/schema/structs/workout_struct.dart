import 'package:collection/collection.dart';
import 'package:gym_bro/utils/serialization_util.dart';
import 'package:gym_bro/schema/structs/base_struct.dart';
import 'package:gym_bro/schema/structs/workout_set_struct.dart';
import 'package:gym_bro/utils/general_util.dart';
import 'package:gym_bro/utils/schema_util.dart';

class WorkoutStruct extends BaseStruct {
  WorkoutStruct({
    String? id,
    List<WorkoutSetStruct>? sets,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : _id = id,
        _sets = sets,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  List<WorkoutSetStruct>? _sets;
  List<WorkoutSetStruct> get sets => _sets ?? const [];
  set sets(List<WorkoutSetStruct>? val) => _sets = val;

  void updateSets(Function(List<WorkoutSetStruct>) updateFn) {
    updateFn(_sets ??= []);
  }

  bool hasSets() => _sets != null;

  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  set updatedAt(DateTime? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  static WorkoutStruct fromMap(Map<String, dynamic> data) => WorkoutStruct(
        id: data['id'] as String?,
        sets: getStructList(
          data['sets'],
          WorkoutSetStruct.fromMap,
        ),
        createdAt: data['createdAt'] as DateTime?,
        updatedAt: data['updatedAt'] as DateTime?,
      );

  static WorkoutStruct? maybeFromMap(dynamic data) =>
      data is Map ? WorkoutStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'sets': _sets?.map((e) => e.toMap()).toList(),
        'createdAt': _createdAt,
        'updatedAt': _updatedAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'sets': serializeParam(
          _sets,
          ParamType.DataStruct,
          isList: true,
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

  static WorkoutStruct fromSerializableMap(Map<String, dynamic> data) =>
      WorkoutStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        sets: deserializeStructParam<WorkoutSetStruct>(
          data['sets'],
          ParamType.DataStruct,
          true,
          structBuilder: WorkoutSetStruct.fromSerializableMap,
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
  String toString() => 'WorkoutStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is WorkoutStruct &&
        id == other.id &&
        listEquality.equals(sets, other.sets) &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, sets, createdAt, updatedAt]);
}

WorkoutStruct createWorkoutStruct({
  String? id,
  DateTime? createdAt,
  DateTime? updatedAt,
}) =>
    WorkoutStruct(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
