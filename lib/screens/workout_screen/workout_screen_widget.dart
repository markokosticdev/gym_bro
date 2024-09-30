import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_bro/configs/state.dart';
import 'package:gym_bro/configs/theme.dart';
import 'package:gym_bro/screens/widgets/empty_list_widget.dart';
import 'package:gym_bro/screens/widgets/icon_button_widget..dart';
import 'package:gym_bro/screens/widgets/primary_button_widget.dart';
import 'package:gym_bro/screens/widgets/workout_card/workout_card_widget.dart';
import 'package:gym_bro/screens/widgets/workout_set_card/workout_set_card_widget.dart';
import 'package:gym_bro/screens/widgets/workout_set_create_update_card/workout_set_create_update_card_widget.dart';
import 'package:gym_bro/screens/workout_screen/workout_screen_model.dart';
import 'package:gym_bro/schema/structs/workout_struct.dart';
import 'package:gym_bro/utils/general_util.dart';
import 'package:gym_bro/utils/model_util.dart';
import 'package:provider/provider.dart';

class WorkoutScreenWidget extends StatefulWidget {
  const WorkoutScreenWidget({
    super.key,
    this.id,
  });

  final String? id;

  @override
  State<WorkoutScreenWidget> createState() => _WorkoutScreenWidgetState();
}

class _WorkoutScreenWidgetState extends State<WorkoutScreenWidget> {
  late WorkoutScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkoutScreenModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget.id != null && widget.id != '') {
        _model.workout = _model.getWorkoutById(
            AppState().workouts.toList(), widget.id!);
        safeSetState(() {});
      } else {
        _model.workout = WorkoutStruct(
          id: createId(),
        );
        safeSetState(() {});
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: AppTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: IconButtonWidget(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            '${widget.id != null && widget.id != '' ? 'Edit' : 'Create'} Workout',
            style: AppTheme.of(context).headlineMedium.override(
                  fontFamily: 'Inter Tight',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (_model.workout != null)
                    wrapWithModel(
                      model: _model.workoutCardModel,
                      updateCallback: () => safeSetState(() {}),
                      child: Hero(
                        tag: 'workout',
                        transitionOnUserGestures: true,
                        child: Material(
                          color: Colors.transparent,
                          child: WorkoutCardWidget(
                            hasDelete: false,
                            workout: _model.workout!,
                            onDelete: (workout) async {},
                          ),
                        ),
                      ),
                    ),
                  if (_model.workout != null)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Workout Sets',
                              style: AppTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Inter Tight',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Builder(
                                builder: (context) {
                                  final setList =
                                      _model.workout?.sets ?? [];
                                  if (setList.isEmpty) {
                                    return Center(
                                      child: EmptyListWidget(
                                        title: 'There is no Sets',
                                        subtitle: 'Please create a Workout Set',
                                      ),
                                    );
                                  }

                                  return ReorderableListView.builder(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: setList.length,
                                    itemBuilder: (context, setListIndex) {
                                      final setListItem = setList[setListIndex];
                                      return Container(
                                        key: ValueKey("RSI_${setListIndex.toString()}"),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0,
                                                  valueOrDefault<double>(
                                                    setListIndex == 0
                                                        ? 0.0
                                                        : 16.0,
                                                    0.0,
                                                  ),
                                                  0.0,
                                                  0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onDoubleTap: () async {
                                              var confirmDialogResponse =
                                                  await showDialog<bool>(
                                                        context: context,
                                                        builder:
                                                            (alertDialogContext) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Confirm to delete Workout Set'),
                                                            content: Text(
                                                                'Workout Set deletion cannot be undone!'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext,
                                                                        false),
                                                                child: Text(
                                                                    'Cancel'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        alertDialogContext,
                                                                        true),
                                                                child: Text(
                                                                    'Confirm'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ) ??
                                                      false;
                                              if (confirmDialogResponse) {
                                                _model.updateWorkoutStruct(
                                                  (e) => e
                                                    ..sets = _model.deleteWorkoutSet(
                                                            _model.workout!.sets,
                                                            setListItem.id)
                                                        .toList(),
                                                );
                                                safeSetState(() {});
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Workout Set successfully deleted!',
                                                      style: TextStyle(
                                                        color:
                                                            AppTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                    backgroundColor:
                                                        AppTheme.of(
                                                                context)
                                                            .alternate,
                                                  ),
                                                );
                                              }
                                            },
                                            child: wrapWithModel(
                                              model: _model.workoutSetCardModels
                                                  .getModel(
                                                setListItem.id,
                                                setListIndex,
                                              ),
                                              updateCallback: () =>
                                                  safeSetState(() {}),
                                              child: WorkoutSetCardWidget(
                                                key: Key(
                                                  'SI_${setListItem.id}',
                                                ),
                                                workoutSet: setListItem,
                                                index: setListIndex,
                                                onEdit: (workoutSet) async {
                                                  _model.workoutSet =
                                                      workoutSet;
                                                  safeSetState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    onReorder: (int reorderableOldIndex,
                                        int reorderableNewIndex) async {
                                      _model.updateWorkoutStruct(
                                        (e) => e
                                          ..sets = _model.reorderWorkoutSets(
                                                  reorderableOldIndex,
                                                  reorderableNewIndex,
                                                  _model.workout!.sets.toList())
                                              .toList(),
                                      );
                                      safeSetState(() {});

                                      safeSetState(() {});
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_model.workout != null)
                    wrapWithModel(
                      model: _model.workoutSetCreateUpdateCardModel,
                      updateCallback: () => safeSetState(() {}),
                      updateOnChange: true,
                      child: WorkoutSetCreateUpdateCardWidget(
                        workoutSet: _model.workoutSet,
                        onCreate: (workoutSet) async {
                          _model.updateWorkoutStruct(
                            (e) => e
                              ..sets = _model.addWorkoutSet(
                                      _model.workout!.sets.toList(), workoutSet)
                                  .toList()
                              ..createdAt = getCurrentTimestamp,
                          );
                          safeSetState(() {});
                        },
                        onEdit: (workoutSet) async {
                          _model.updateWorkoutStruct(
                            (e) => e
                              ..sets = _model
                                  .updateWorkoutSet(
                                      _model.workout!.sets.toList(), workoutSet)
                                  .toList()
                              ..updatedAt = getCurrentTimestamp,
                          );
                          _model.workoutSet = null;
                          safeSetState(() {});
                        },
                      ),
                    ),
                  if (_model.workout != null)
                    PrimaryButtonWidget(
                      key: ValueKey('saveWorkout'),
                      onPressed: () async {
                        if (_model.workout!.sets.length > 0) {
                          if (widget.id != null && widget.id != '') {
                            _model.updateWorkoutStruct(
                              (e) => e..updatedAt = getCurrentTimestamp,
                            );
                            AppState().workouts = _model
                                .updateWorkout(AppState().workouts.toList(),
                                    _model.workout!)
                                .toList()
                                .cast<WorkoutStruct>();
                            AppState().update(() {});
                          } else {
                            _model.updateWorkoutStruct(
                              (e) => e..createdAt = getCurrentTimestamp,
                            );
                            AppState().workouts = _model
                                .addWorkout(AppState().workouts.toList(),
                                    _model.workout!)
                                .toList()
                                .cast<WorkoutStruct>();
                            AppState().update(() {});
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Workout successfully saved!',
                                style: TextStyle(
                                  color:
                                      AppTheme.of(context).primaryText,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  AppTheme.of(context).alternate,
                            ),
                          );

                          context.goNamed('WorkoutListScreen');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Workout need to have sets!',
                                style: TextStyle(
                                  color: AppTheme.of(context).error,
                                ),
                              ),
                              duration: Duration(milliseconds: 4000),
                              backgroundColor:
                                  AppTheme.of(context).alternate,
                            ),
                          );
                        }
                      },
                      text: 'Save',
                      options: PrimaryButtonOptions(
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: AppTheme.of(context).primary,
                        textStyle:
                            AppTheme.of(context).titleSmall.override(
                                  fontFamily: 'Inter Tight',
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                ]
                    .divide(SizedBox(height: 16.0))
                    .addToStart(SizedBox(height: 16.0))
                    .addToEnd(SizedBox(height: 16.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
