import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'add_vehicle_widget.dart' show AddVehicleWidget;
import 'package:flutter/material.dart';

class AddVehicleModel extends FlutterFlowModel<AddVehicleWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for DropDown widget.

  FormFieldController<String>? dropDownValueController;
  // State field(s) for Vdescription widget.
  FocusNode? vdescriptionFocusNode;
  TextEditingController? vdescriptionController;
  String? Function(BuildContext, String?)? vdescriptionControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    vdescriptionFocusNode?.dispose();
    vdescriptionController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
