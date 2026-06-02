import '/flutter_flow/flutter_flow_util.dart';
import 'changepassword_widget.dart' show ChangepasswordWidget;
import 'package:flutter/material.dart';

class ChangepasswordModel extends FlutterFlowModel<ChangepasswordWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for jobtitle widget.
  FocusNode? jobtitleFocusNode1;
  TextEditingController? jobtitleController1;
  String? Function(BuildContext, String?)? jobtitleController1Validator;
  // State field(s) for jobtitle widget.
  FocusNode? jobtitleFocusNode2;
  TextEditingController? jobtitleController2;
  String? Function(BuildContext, String?)? jobtitleController2Validator;
  // State field(s) for jobtitle widget.
  FocusNode? jobtitleFocusNode3;
  TextEditingController? jobtitleController3;
  String? Function(BuildContext, String?)? jobtitleController3Validator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    jobtitleFocusNode1?.dispose();
    jobtitleController1?.dispose();

    jobtitleFocusNode2?.dispose();
    jobtitleController2?.dispose();

    jobtitleFocusNode3?.dispose();
    jobtitleController3?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
