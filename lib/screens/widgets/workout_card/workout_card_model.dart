import 'package:flutter/material.dart';
import 'package:gym_bro/screens/widgets/workout_card/workout_card_widget.dart';
import 'package:gym_bro/schema/enums/exercise_enum.dart';
import 'package:gym_bro/schema/structs/workout_set_struct.dart';
import 'package:gym_bro/schema/structs/workout_struct.dart';
import 'package:gym_bro/utils/model_util.dart';

class WorkoutCardModel extends BaseModel<WorkoutCardWidget> {
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  String getWorkoutTitle(WorkoutStruct workout) {
    Set<Exercise> exercises = workout.sets
        .where((item) => item.hasExercise())
        .map((item) => item.exercise!)
        .toSet();

    if (exercises.isEmpty) {
      return "No exercises";
    }

    return exercises.map((exercise) => exercise.serialize()).join(' | ');
  }

  double getWorkoutAvgWeight(List<WorkoutSetStruct>? sets) {
    if (sets == null || sets.isEmpty) return 0;

    int totalWeight =
    sets.map((item) => item.weight ?? 0).reduce((a, b) => a + b);

    return totalWeight / sets.length;
  }

  double getWorkoutAvgReps(List<WorkoutSetStruct>? sets) {
    if (sets == null || sets.isEmpty) return 0;

    int totalReps =
    sets.map((item) => item.repetitions ?? 0).reduce((a, b) => a + b);

    return totalReps / sets.length;
  }
}
