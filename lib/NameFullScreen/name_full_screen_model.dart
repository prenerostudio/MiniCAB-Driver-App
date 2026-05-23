import '/flutter_flow/flutter_flow_util.dart';
import 'name_full_screen_widget.dart' show NameFullScreenWidget;
import 'package:flutter/material.dart';

class NameFullScreenModel extends FlutterFlowModel<NameFullScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
