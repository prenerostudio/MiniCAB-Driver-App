import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'payment_entery_widget.dart' show PaymentEnteryWidget;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

  void initState(BuildContext context) {}

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
