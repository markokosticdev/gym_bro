import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_bro/schema/structs/workout_struct.dart';
import 'package:gym_bro/utils/general_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  static void reset() {
    _instance = AppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _workouts = prefs
              .getStringList('app_workouts')
              ?.map((x) {
                try {
                  return WorkoutStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _workouts;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<WorkoutStruct> _workouts = [];
  List<WorkoutStruct> get workouts => _workouts;
  set workouts(List<WorkoutStruct> value) {
    _workouts = value;
    prefs.setStringList(
        'app_workouts', value.map((x) => x.serialize()).toList());
  }

  void addToWorkouts(WorkoutStruct value) {
    workouts.add(value);
    prefs.setStringList(
        'app_workouts', _workouts.map((x) => x.serialize()).toList());
  }

  void removeFromWorkouts(WorkoutStruct value) {
    workouts.remove(value);
    prefs.setStringList(
        'app_workouts', _workouts.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromWorkouts(int index) {
    workouts.removeAt(index);
    prefs.setStringList(
        'app_workouts', _workouts.map((x) => x.serialize()).toList());
  }

  void updateWorkoutsAtIndex(
    int index,
    WorkoutStruct Function(WorkoutStruct) updateFn,
  ) {
    workouts[index] = updateFn(_workouts[index]);
    prefs.setStringList(
        'app_workouts', _workouts.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInWorkouts(int index, WorkoutStruct value) {
    workouts.insert(index, value);
    prefs.setStringList(
        'app_workouts', _workouts.map((x) => x.serialize()).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
