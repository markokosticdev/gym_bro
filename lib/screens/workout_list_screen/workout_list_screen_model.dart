import 'package:flutter/material.dart';
import 'package:gym_bro/screens/widgets/workout_card/workout_card_model.dart';
import 'package:gym_bro/screens/workout_list_screen/workout_list_screen_widget.dart';
import 'package:gym_bro/schema/structs/workout_struct.dart';
import 'package:gym_bro/utils/model_util.dart';

class WorkoutListScreenModel extends BaseModel<WorkoutListScreenWidget> {
  late AppDynamicModels<WorkoutCardModel> workoutCardModels;

  @override
  void initState(BuildContext context) {
    workoutCardModels = AppDynamicModels(() => WorkoutCardModel());
  }

  @override
  void dispose() {
    workoutCardModels.dispose();
  }

  List<WorkoutStruct> deleteWorkout(
      List<WorkoutStruct> workouts,
      String id,
      ) {
    return workouts.where((item) => item.id != id).toList();
  }
}
