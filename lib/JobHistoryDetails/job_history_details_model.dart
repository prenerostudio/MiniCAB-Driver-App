import '/flutter_flow/flutter_flow_util.dart';
import 'job_history_details_widget.dart' show JobHistoryDetailsWidget;

import 'package:flutter/material.dart';

class JobHistoryDetailsModel extends FlutterFlowModel<JobHistoryDetailsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
