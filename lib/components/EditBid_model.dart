import 'package:new_minicab_driver/components/EditBid_widget.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class EditBidModel extends FlutterFlowModel<EditBidWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for biding widget.
  FocusNode? bidingFocusNode;
  TextEditingController? bidingController;
  String? Function(BuildContext, String?)? bidingControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    bidingFocusNode?.dispose();
    bidingController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
