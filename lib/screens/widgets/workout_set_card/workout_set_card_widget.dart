import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_bro/configs/theme.dart';
import 'package:gym_bro/screens/widgets/workout_set_card/workout_set_card_model.dart';
import 'package:gym_bro/schema/structs/workout_set_struct.dart';
import 'package:gym_bro/utils/general_util.dart';
import 'package:gym_bro/utils/model_util.dart';

class WorkoutSetCardWidget extends StatefulWidget {
  const WorkoutSetCardWidget({
    super.key,
    required this.workoutSet,
    required this.onEdit,
    required this.index,
  });

  final WorkoutSetStruct? workoutSet;
  final Future Function(WorkoutSetStruct workoutSet)? onEdit;
  final int? index;

  @override
  State<WorkoutSetCardWidget> createState() => _WorkoutSetCardWidgetState();
}

class _WorkoutSetCardWidgetState extends State<WorkoutSetCardWidget> {
  late WorkoutSetCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkoutSetCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.0,
      decoration: BoxDecoration(
        color: AppTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${((widget.index!) + 1).toString()} - ${widget.workoutSet?.exercise?.name}',
                    style: AppTheme.of(context).titleSmall.override(
                          fontFamily: 'Inter Tight',
                          letterSpacing: 0.0,
                        ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${widget.workoutSet?.weight.toString()} kg',
                          style: AppTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Inter',
                                color:
                                    AppTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                        ),
                        SizedBox(
                          height: 14.0,
                          child: VerticalDivider(
                            thickness: 1.0,
                            color: AppTheme.of(context).secondaryText,
                          ),
                        ),
                        Text(
                          '${widget.workoutSet?.repetitions.toString()} ${widget.workoutSet?.repetitions == 1 ? 'rep' : 'reps'}',
                          style: AppTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Inter',
                                color:
                                    AppTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              key: ValueKey('editWorkoutSet'),
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                await widget.onEdit?.call(
                  widget.workoutSet!,
                );
              },
              child: Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: AppTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: FaIcon(
                    FontAwesomeIcons.penToSquare,
                    color: AppTheme.of(context).primaryText,
                    size: 16.0,
                  ),
                ),
              ),
            ),
          ].divide(SizedBox(width: 16.0)),
        ),
      ),
    );
  }
}
