import '/flutter_flow/flutter_flow_util.dart';
import 'upcommingjob_widget.dart' show UpcommingjobWidget;
import 'package:flutter/material.dart';

class UpcommingjobModel extends FlutterFlowModel<UpcommingjobWidget> {
  /// Initialization and disposal methods.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
