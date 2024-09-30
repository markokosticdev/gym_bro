import 'package:flutter/material.dart';
import 'package:gym_bro/controllers/form_field_controller.dart';
import 'package:gym_bro/screens/widgets/workout_set_create_update_card/workout_set_create_update_card_widget.dart';
import 'package:gym_bro/utils/model_util.dart';

class WorkoutSetCreateUpdateCardModel
    extends BaseModel<WorkoutSetCreateUpdateCardWidget> {
  bool editMode = false;

  final formKey = GlobalKey<FormState>();

  String? exerciseValue;
  FormFieldController<String>? exerciseValueController;

  FocusNode? weightFocusNode;
  TextEditingController? weightTextController;
  String? Function(BuildContext, String?)? weightTextControllerValidator;

  FocusNode? repsFocusNode;
  TextEditingController? repsTextController;
  String? Function(BuildContext, String?)? repsTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    weightFocusNode?.dispose();
    weightTextController?.dispose();

    repsFocusNode?.dispose();
    repsTextController?.dispose();
  }
}
