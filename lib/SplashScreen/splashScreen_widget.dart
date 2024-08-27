import 'dart:async';
import 'dart:convert';

import 'package:mini_cab/payment_entery/complete.dart';
import 'package:system_alert_window/system_alert_window.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'splashScreen_model.dart';
export 'splashScreen_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  late SplashScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();

    checkAndRequestPermissions();
    checkLocationPermissionAndNavigate(context);
    _model = createModel(context, () => SplashScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void checkAndRequestPermissions() async {
    bool? isGrantedNullable = await SystemAlertWindow.checkPermissions();
    bool isGranted = isGrantedNullable ?? false; // Default to false if null
    if (!isGranted) {
      bool requested = await SystemAlertWindow.requestPermissions() ?? false;
      if (!requested) {
        // Navigate to app settings
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Permission Required"),
            content: Text(
                "This app requires the 'Draw over other apps' permission to function properly. Please enable it in the app settings."),
            actions: <Widget>[
              TextButton(
                child: Text("Open Settings"),
                onPressed: () {
                  openAppSettings();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLogin = prefs.getBool('isLogin');
    // prefs.setInt('isRideStart', 0);
    setState(() {});
    int? isRideStart = prefs.getInt('isRideStart');

    if (isLogin == true && isRideStart == 0) {
      usersessionTimer = Timer.periodic(Duration(seconds: 4), (s) {
        print('user session checking starts');
        checkUserSession();
      });
      context.pushNamed('Home');
    } else if (isLogin == true && isRideStart == 1) {
      usersessionTimer = Timer.periodic(Duration(seconds: 4), (s) {
        print('user session checking starts');
        checkUserSession();
      });
      context.pushNamed('onWay');
    } else if (isLogin == true && isRideStart == 2) {
      usersessionTimer = Timer.periodic(Duration(seconds: 4), (s) {
        print('user session checking starts');
        checkUserSession();
      });
      context.pushNamed('Pob');
    } else if (isLogin == true && isRideStart == 3) {
      usersessionTimer = Timer.periodic(Duration(seconds: 4), (s) {
        print('user session checking starts');
        checkUserSession();
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CompleteWidget()));
    } else {
      context.pushNamed('Welcome');
    }
  }

  Future<void> checkLocationPermissionAndNavigate(BuildContext context) async {
    final permissionStatus = await Permission.location.request();
    final currentStatus = await Permission.location.status;
    print(currentStatus);
    if (permissionStatus.isDenied) {
      openAppSettings();
    } else {}
  }

  Timer? usersessionTimer;
  Future<void> checkUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('loginToken');
    // String? jobId = prefs.getString('jobId');
    final response = await http.post(
      Uri.parse(
          'https://www.minicaboffice.com/api/driver/check-login-token.php'),
      body: {'token': token.toString()},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == false) {
        prefs.setString('loginToken', '');
        prefs.setBool('isLogin', false);
        setState(() {});
        usersessionTimer?.cancel();
        context.pushNamed('Login');
      } else {
        // Handle the job details as normal
      }
    } else {
      // Handle the error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/app_launcher_icon.png',
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
