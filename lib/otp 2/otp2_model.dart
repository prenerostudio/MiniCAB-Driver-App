import '/flutter_flow/flutter_flow_util.dart';
import 'otp2_widget.dart' show Otp2Widget;
import 'package:flutter/material.dart';

class Otp2Model extends FlutterFlowModel<Otp2Widget> {
  final unfocusNode = FocusNode();
  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    pinCodeController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
