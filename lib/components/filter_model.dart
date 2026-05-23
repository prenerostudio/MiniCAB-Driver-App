import '/flutter_flow/flutter_flow_util.dart';
import 'filter_widget.dart' show FilterWidget;
import 'package:flutter/material.dart';

class FilterModel extends FlutterFlowModel<FilterWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for startDate widget.
  FocusNode? startDateFocusNode1;
  TextEditingController? startDateTextController1;
  String? Function(BuildContext, String?)? startDateTextController1Validator;
  // State field(s) for startDate widget.
  FocusNode? startDateFocusNode2;
  TextEditingController? startDateTextController2;
  String? Function(BuildContext, String?)? startDateTextController2Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    startDateFocusNode1?.dispose();
    startDateTextController1?.dispose();

    startDateFocusNode2?.dispose();
    startDateTextController2?.dispose();
  }
}
