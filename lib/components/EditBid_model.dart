 
import 'package:new_minicab_driver/components/EditBid_widget.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'edit_bid_widget.dart' show EditBidWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditBidModel extends FlutterFlowModel<EditBidWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for biding widget.
  FocusNode? bidingFocusNode;
  TextEditingController? bidingController;
  String? Function(BuildContext, String?)? bidingControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    bidingFocusNode?.dispose();
    bidingController?.dispose();
  }

/// Action blocks are added here.

/// Additional helper methods are added here.
}
