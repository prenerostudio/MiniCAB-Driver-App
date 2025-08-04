import 'package:flutter/material.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:new_minicab_driver/Model/jobDetails.dart';
import 'package:new_minicab_driver/flutter_flow/flutter_flow_theme.dart';
import 'package:new_minicab_driver/home/home_screen_alert.dart';
import 'package:new_minicab_driver/main.dart';

// import 'main.dart'; // Import navigatorKey

class MyController extends ChangeNotifier {
  ValueNotifier<bool> a = ValueNotifier(false);

  void toggleVariable(bool value, List<Job> listFromPusher) {
    a.value = value;
    if (value) {
      showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentContext!,
          // Use the global navigator key
          builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide(color: Colors.transparent)),
                insetPadding: EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  color: Colors.transparent,
                  child: AnimatedGradientBorder(
                    glowSize: 0,
                    gradientColors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      if (myController.initialLabelIndex.value == 1)
                        FlutterFlowTheme.of(context).primary
                      else
                        Colors.transparent,
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: HomeScreenAlert(
                      height: MediaQuery.of(context).size.height * 0.55,
                      st: listFromPusher,
                    ),
                  ),
                ),
              ));
    }
  }
}
