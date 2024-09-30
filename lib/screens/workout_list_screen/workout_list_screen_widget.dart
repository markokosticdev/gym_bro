import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_bro/configs/state.dart';
import 'package:gym_bro/configs/theme.dart';
import 'package:gym_bro/screens/widgets/empty_list_widget.dart';
import 'package:gym_bro/screens/widgets/workout_card/workout_card_widget.dart';
import 'package:gym_bro/screens/workout_list_screen/workout_list_screen_model.dart';
import 'package:gym_bro/schema/structs/workout_struct.dart';
import 'package:gym_bro/utils/general_util.dart';
import 'package:gym_bro/utils/model_util.dart';
import 'package:gym_bro/utils/serialization_util.dart';
import 'package:provider/provider.dart';

class WorkoutListScreenWidget extends StatefulWidget {
  const WorkoutListScreenWidget({super.key});

  @override
  State<WorkoutListScreenWidget> createState() =>
      _WorkoutListScreenWidgetState();
}

class _WorkoutListScreenWidgetState extends State<WorkoutListScreenWidget> {
  late WorkoutListScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkoutListScreenModel());
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
        floatingActionButton: FloatingActionButton(
          key: ValueKey('createWorkout'),
          onPressed: () async {
            context.pushNamed('WorkoutScreen');
          },
          backgroundColor: AppTheme.of(context).primary,
          elevation: 8.0,
          child: FaIcon(
            FontAwesomeIcons.dumbbell,
            color: AppTheme.of(context).info,
            size: 24.0,
          ),
        ),
        appBar: AppBar(
          backgroundColor: AppTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'All Workouts',
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
            child: Builder(
              builder: (context) {
                final workoutList = AppState().workouts.toList();
                if (workoutList.isEmpty) {
                  return Center(
                    child: EmptyListWidget(
                      title: 'There is no Workouts',
                      subtitle: 'Please create a Workout',
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children:
                        List.generate(workoutList.length, (workoutListIndex) {
                      final workoutListItem = workoutList[workoutListIndex];
                      return InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(
                            'WorkoutScreen',
                            queryParameters: {
                              'id': serializeParam(
                                workoutListItem.id,
                                ParamType.String,
                              ),
                            }.withoutNulls,
                          );
                        },
                        child: wrapWithModel(
                          model: _model.workoutCardModels.getModel(
                            workoutListItem.id,
                            workoutListIndex,
                          ),
                          updateCallback: () => safeSetState(() {}),
                          child: Hero(
                            tag: 'workout',
                            transitionOnUserGestures: true,
                            child: Material(
                              color: Colors.transparent,
                              child: WorkoutCardWidget(
                                key: Key(
                                  'WI_${workoutListItem.id}',
                                ),
                                workout: workoutListItem,
                                hasDelete: true,
                                onDelete: (workout) async {
                                  var confirmDialogResponse =
                                      await showDialog<bool>(
                                            context: context,
                                            builder: (alertDialogContext) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Confirm to delete Workout'),
                                                content: Text(
                                                    'Workout deletion cannot be undone!'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext,
                                                            false),
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            alertDialogContext,
                                                            true),
                                                    child: Text('Confirm'),
                                                  ),
                                                ],
                                              );
                                            },
                                          ) ??
                                          false;
                                  if (confirmDialogResponse) {
                                    AppState().workouts = _model
                                        .deleteWorkout(
                                            AppState().workouts.toList(),
                                            workoutListItem.id)
                                        .toList()
                                        .cast<WorkoutStruct>();
                                    safeSetState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Workout successfully deleted!',
                                          style: TextStyle(
                                            color: AppTheme.of(context)
                                                .primaryText,
                                          ),
                                        ),
                                        duration: Duration(milliseconds: 4000),
                                        backgroundColor:
                                            AppTheme.of(context)
                                                .alternate,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                            .divide(SizedBox(height: 16.0))
                            .addToStart(SizedBox(height: 16.0))
                            .addToEnd(SizedBox(height: 16.0)),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
