import 'package:flutter/material.dart';
import 'package:gym_bro/configs/theme.dart';
import 'package:gym_bro/controllers/form_field_controller.dart';
import 'package:gym_bro/screens/widgets/drop_down_widget.dart';
import 'package:gym_bro/screens/widgets/primary_button_widget.dart';
import 'package:gym_bro/screens/widgets/workout_set_create_update_card/workout_set_create_update_card_model.dart';
import 'package:gym_bro/schema/enums/exercise_enum.dart';
import 'package:gym_bro/schema/structs/workout_set_struct.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:gym_bro/utils/general_util.dart';
import 'package:gym_bro/utils/model_util.dart';

class WorkoutSetCreateUpdateCardWidget extends StatefulWidget {
  const WorkoutSetCreateUpdateCardWidget({
    super.key,
    this.workoutSet,
    required this.onCreate,
    required this.onEdit,
  });

  final WorkoutSetStruct? workoutSet;
  final Future Function(WorkoutSetStruct workoutSet)? onCreate;
  final Future Function(WorkoutSetStruct workoutSet)? onEdit;

  @override
  State<WorkoutSetCreateUpdateCardWidget> createState() =>
      _WorkoutSetCreateUpdateCardWidgetState();
}

class _WorkoutSetCreateUpdateCardWidgetState
    extends State<WorkoutSetCreateUpdateCardWidget> {
  late WorkoutSetCreateUpdateCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkoutSetCreateUpdateCardModel());

    _model.weightTextController ??= TextEditingController(
        text: widget.workoutSet != null
            ? widget.workoutSet?.weight.toString()
            : '25');
    _model.weightFocusNode ??= FocusNode();

    _model.repsTextController ??= TextEditingController(
        text: widget.workoutSet != null
            ? widget.workoutSet?.repetitions.toString()
            : '25');
    _model.repsFocusNode ??= FocusNode();
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
              '${widget.workoutSet != null ? 'Edit' : 'Add'} Workout Set',
              style: AppTheme.of(context).titleSmall.override(
                    fontFamily: 'Inter Tight',
                    letterSpacing: 0.0,
                  ),
            ),
            Form(
              key: _model.formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Exercise',
                            style: AppTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: DropDownWidget<String>(
                            controller: _model.exerciseValueController ??=
                                FormFieldController<String>(
                              _model.exerciseValue ??=
                                  widget.workoutSet != null
                                      ? widget.workoutSet?.exercise?.name
                                      : Exercise.BarbellRow.name,
                            ),
                            options:
                                Exercise.values.map((e) => e.name).toList(),
                            onChanged: (val) =>
                                safeSetState(() => _model.exerciseValue = val),
                            width: 200.0,
                            height: 40.0,
                            textStyle: AppTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                            hintText: 'Select...',
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppTheme.of(context).secondaryText,
                              size: 24.0,
                            ),
                            fillColor: AppTheme.of(context).alternate,
                            elevation: 2.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 10.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            hidesUnderline: true,
                            isOverButton: false,
                            isSearchable: false,
                            isMultiSelect: false,
                          ),
                        ),
                      ].divide(SizedBox(width: 16.0)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Weight',
                            style: AppTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: 200.0,
                            child: TextFormField(
                              controller: _model.weightTextController,
                              focusNode: _model.weightFocusNode,
                              autofocus: false,
                              textInputAction: TextInputAction.done,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelStyle: AppTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                    ),
                                hintText: 'TextField',
                                hintStyle: AppTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppTheme.of(context).error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppTheme.of(context).error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor:
                                    AppTheme.of(context).alternate,
                              ),
                              style: AppTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                              keyboardType: TextInputType.number,
                              cursorColor:
                                  AppTheme.of(context).primaryText,
                              validator: _model.weightTextControllerValidator
                                  .asValidator(context),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'))
                              ],
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 16.0)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Reps',
                            style: AppTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Inter',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            width: 200.0,
                            child: TextFormField(
                              controller: _model.repsTextController,
                              focusNode: _model.repsFocusNode,
                              autofocus: false,
                              textInputAction: TextInputAction.done,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelStyle: AppTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                    ),
                                hintText: 'TextField',
                                hintStyle: AppTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0.0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppTheme.of(context).error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppTheme.of(context).error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor:
                                    AppTheme.of(context).alternate,
                              ),
                              style: AppTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Inter',
                                    letterSpacing: 0.0,
                                  ),
                              keyboardType: TextInputType.number,
                              cursorColor:
                                  AppTheme.of(context).primaryText,
                              validator: _model.repsTextControllerValidator
                                  .asValidator(context),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'))
                              ],
                            ),
                          ),
                        ),
                      ].divide(SizedBox(width: 16.0)),
                    ),
                  ].divide(SizedBox(height: 10.0)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.workoutSet != null)
                    PrimaryButtonWidget(
                      onPressed: () async {
                        await widget.onEdit?.call(
                          WorkoutSetStruct(
                            id: widget.workoutSet?.id,
                            exercise: convertStringToExercise(_model.exerciseValue!),
                            weight: int.tryParse(
                                    _model.weightTextController.text) ??
                                25,
                            repetitions:
                                int.tryParse(_model.repsTextController.text) ??
                                    25,
                          ),
                        );
                      },
                      text: 'Update',
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
                  PrimaryButtonWidget(
                    onPressed: () async {
                      await widget.onCreate?.call(
                        WorkoutSetStruct(
                          id: createId(),
                          exercise: convertStringToExercise(_model.exerciseValue!),
                          weight:
                              int.tryParse(_model.weightTextController.text) ??
                                  25,
                          repetitions:
                              int.tryParse(_model.repsTextController.text) ??
                                  25,
                        ),
                      );
                    },
                    text: 'Add New',
                    options: PrimaryButtonOptions(
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
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
                ].divide(SizedBox(width: 16.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
