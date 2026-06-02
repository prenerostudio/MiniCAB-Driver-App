import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'on_way_widget.dart' show OnWayWidget;
import 'package:flutter/material.dart';

class OnWayModel extends FlutterFlowModel<OnWayWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  int timerMilliseconds = 0;
  String timerValue = StopWatchTimer.getDisplayTime(0, milliSecond: false);
  FlutterFlowTimerController timerController = FlutterFlowTimerController(
    StopWatchTimer(mode: StopWatchMode.countUp),
  );

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
