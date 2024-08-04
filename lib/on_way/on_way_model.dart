import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'on_way_widget.dart' show OnWayWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OnWayModel extends FlutterFlowModel<OnWayWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  int timerMilliseconds = 0;
  String timerValue = StopWatchTimer.getDisplayTime(0, milliSecond: false);
  FlutterFlowTimerController timerController =
  FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countUp));
  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
