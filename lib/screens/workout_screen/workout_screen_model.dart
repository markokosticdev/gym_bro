import 'package:flutter/material.dart';
import 'package:gym_bro/screens/widgets/workout_card/workout_card_model.dart';
import 'package:gym_bro/screens/widgets/workout_set_card/workout_set_card_model.dart';
import 'package:gym_bro/screens/widgets/workout_set_create_update_card/workout_set_create_update_card_model.dart';
import 'package:gym_bro/screens/workout_screen/workout_screen_widget.dart';
import 'package:gym_bro/schema/structs/workout_set_struct.dart';
import 'package:gym_bro/schema/structs/workout_struct.dart';
import 'package:gym_bro/utils/model_util.dart';

class WorkoutScreenModel extends BaseModel<WorkoutScreenWidget> {
  WorkoutStruct? workout;
  void updateWorkoutStruct(Function(WorkoutStruct) updateFn) {
    updateFn(workout ??= WorkoutStruct());
  }

  WorkoutSetStruct? workoutSet;
  void updateWorkoutSetStruct(Function(WorkoutSetStruct) updateFn) {
    updateFn(workoutSet ??= WorkoutSetStruct());
  }

  late WorkoutCardModel workoutCardModel;

  late AppDynamicModels<WorkoutSetCardModel> workoutSetCardModels;

  late WorkoutSetCreateUpdateCardModel workoutSetCreateUpdateCardModel;

  @override
  void initState(BuildContext context) {
    workoutCardModel = createModel(context, () => WorkoutCardModel());
    workoutSetCardModels =
        AppDynamicModels(() => WorkoutSetCardModel());
    workoutSetCreateUpdateCardModel =
        createModel(context, () => WorkoutSetCreateUpdateCardModel());
  }

  @override
  void dispose() {
    workoutCardModel.dispose();
    workoutSetCardModels.dispose();
    workoutSetCreateUpdateCardModel.dispose();
  }

  WorkoutStruct? getWorkoutById(
      List<WorkoutStruct> workouts,
      String id,
      ) {
    return workouts.firstWhere((item) => item.hasId() && item.id == id);
  }

  List<WorkoutSetStruct> addWorkoutSet(
      List<WorkoutSetStruct> workoutSets,
      WorkoutSetStruct newWorkoutSet,
      ) {
    workoutSets.add(newWorkoutSet);
    return workoutSets;
  }

  List<WorkoutSetStruct> deleteWorkoutSet(
      List<WorkoutSetStruct> workoutSets,
      String id,
      ) {
    return workoutSets.where((item) => item.id != id).toList();
  }

  List<WorkoutStruct> addWorkout(
      List<WorkoutStruct> workouts,
      WorkoutStruct newWorkout,
      ) {
    workouts.add(newWorkout);
    return workouts;
  }

  List<WorkoutStruct> updateWorkout(
      List<WorkoutStruct> workouts,
      WorkoutStruct updatedWorkout,
      ) {
    final index = workouts.indexWhere((item) => item.id == updatedWorkout.id);
    if (index != -1) {
      workouts[index] = updatedWorkout;
    }
    return workouts;
  }

  List<WorkoutSetStruct> updateWorkoutSet(
      List<WorkoutSetStruct> workoutSets,
      WorkoutSetStruct updatedWorkoutSet,
      ) {
    final index =
    workoutSets.indexWhere((item) => item.id == updatedWorkoutSet.id);
    if (index != -1) {
      workoutSets[index] = updatedWorkoutSet;
    }
    return workoutSets;
  }

  List<WorkoutSetStruct> reorderWorkoutSets(
      int oldIndex,
      int newIndex,
      List<WorkoutSetStruct> workoutSets,
      ) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = workoutSets.removeAt(oldIndex);
    workoutSets.insert(newIndex, item);
    return workoutSets;
  }
}
