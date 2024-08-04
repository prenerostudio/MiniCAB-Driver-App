import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'changepassword_widget.dart' show ChangepasswordWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

  void initState(BuildContext context) {}

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
