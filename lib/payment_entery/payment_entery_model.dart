import '/flutter_flow/flutter_flow_util.dart';
import 'payment_entery_widget.dart' show PaymentEnteryWidget;
import 'package:flutter/material.dart';

class PaymentEnteryModel extends FlutterFlowModel<PaymentEnteryWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for Journey widget.
  FocusNode? journeyFocusNode;
  TextEditingController? journeyController;
  String? Function(BuildContext, String?)? journeyControllerValidator;
  // State field(s) for ExtraWaiting widget.
  FocusNode? extraWaitingFocusNode;
  TextEditingController? extraWaitingController;
  String? Function(BuildContext, String?)? extraWaitingControllerValidator;
  // State field(s) for Parking widget.
  FocusNode? parkingFocusNode;
  TextEditingController? parkingController;
  String? Function(BuildContext, String?)? parkingControllerValidator;
  // State field(s) for emailAddress widget.
  FocusNode? emailAddressFocusNode;
  TextEditingController? emailAddressController;
  String? Function(BuildContext, String?)? emailAddressControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
    journeyFocusNode?.dispose();
    journeyController?.dispose();

    extraWaitingFocusNode?.dispose();
    extraWaitingController?.dispose();

    parkingFocusNode?.dispose();
    parkingController?.dispose();

    emailAddressFocusNode?.dispose();
    emailAddressController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
