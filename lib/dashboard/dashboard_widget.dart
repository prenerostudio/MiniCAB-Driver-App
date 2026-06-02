import 'dart:isolate';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_minicab_driver/Acount%20Statements/accounts_bottomSheet.dart';
import 'package:new_minicab_driver/bids/bids_bottom_sheet.dart';
import 'package:new_minicab_driver/break_time/break_time_view.dart';
import 'package:new_minicab_driver/components/upcommingjob_widget.dart';
import 'package:new_minicab_driver/jobshistory/job_history_sheet.dart';
import 'package:new_minicab_driver/zones/zone_bottomSheet.dart';
// import 'package:system_alert_window/system_alert_window.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dashboard_model.dart';
export 'dashboard_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../Model/myProfile.dart';
import 'package:new_minicab_driver/Data/api_service.dart';
// library flutter_overlay_window;

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget>
    with TickerProviderStateMixin {
  late DashboardModel _model;
  String locationMessage = "";
  Timer? locationTimer;
  bool? switchValue1;
  String? phone;
  String? email;
  String? dueBalance;
  // String? breakId;
  int initialLabelIndex = 0;
  bool isLoading = true;
  bool isButtonDisabled = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'textOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 100.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 600.ms,
          begin: Offset(0.0, 170.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 60.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 90.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 170.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation4': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 170.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation5': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 170.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation6': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 170.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    DueBalance();
    getDriverPreferences();
    saveInPref();
    _loadSwitchStatus();
    _checkPermissions();
    _model = createModel(context, () => DashboardModel());
    _initPlatformState();
  }

  Future<void> _checkPermissions() async {
    // await SystemAlertWindow.requestPermissions;
  }

  int? SwitchStatus;
  Future<void> _loadSwitchStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedIndex = prefs.getInt('switchValue') ?? 0;
    setState(() {
      SwitchStatus = savedIndex;
    });
    print(SwitchStatus);
  }

  bool? isLogin;
  String _platformVersion = 'Unknown';
  final bool _isShowingWindow = false;
  final bool _isUpdatedWindow = false;
  // SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
  static const String _mainAppPort = 'MainApp';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? latestMessageFromOverlay;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    // await SystemAlertWindow.enableLogs(true);
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // platformVersion = await SystemAlertWindow.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    if (platformVersion != null) {
      setState(() {
        _platformVersion = platformVersion!;
      });
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
    DateTime? lastBackPressed;
    return GestureDetector(
      onTap:
          () =>
              _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (lastBackPressed == null ||
              DateTime.now().difference(lastBackPressed!) >
                  Duration(seconds: 2)) {
            context.pushNamed('Home');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Press again to exit')));
            lastBackPressed = DateTime.now();
            return false;
          } else {
            SystemNavigator.pop();
            return true;
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: context.appTheme.primaryBackground,
          drawer: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.8,
            height: MediaQuery.sizeOf(context).height * 1.0,
            child: Drawer(
              elevation: 40.0,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).brightness == Brightness.light
                            ? context.appTheme.primaryBackground
                            : context.appTheme.primaryBackground,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(0.0, 2.0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            0.0,
                            15.0,
                            0.0,
                            8.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<List<Driver>>(
                                        future: myProfile(),
                                        builder: (
                                          BuildContext context,
                                          AsyncSnapshot<List<Driver>> snapshot,
                                        ) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.blueAccent,
                                                  ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              'Error: ${snapshot.error}',
                                            );
                                          } else {
                                            final driverData = snapshot.data;
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0.0,
                                                        15.0,
                                                        0.0,
                                                        8.0,
                                                      ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional.fromSTEB(
                                                              10.0,
                                                              0.0,
                                                              10.0,
                                                              0.0,
                                                            ),
                                                        child: Container(
                                                          width: 70.0,
                                                          height: 70.0,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          decoration:
                                                              BoxDecoration(
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                              ),
                                                          child: Image.network(
                                                            'https://atiqramzan.online/img/drivers/${driverData![0].dPic}',
                                                            width: 100.0,
                                                            height: 100.0,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) {
                                                              return Image.asset(
                                                                'assets/images/user.png',
                                                                width: 100.0,
                                                                height: 100.0,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional.fromSTEB(
                                                              4.0,
                                                              0.0,
                                                              0.0,
                                                              0.0,
                                                            ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              driverData[0]
                                                                      .dName ??
                                                                  "",
                                                              style: context
                                                                  .appTheme
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Plus Jakarta Sans',
                                                                    color:
                                                                        context
                                                                            .appTheme
                                                                            .primary,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                    0.0,
                                                                    10.0,
                                                                    0.0,
                                                                    0.0,
                                                                  ),
                                                              child: Text(
                                                                driverData[0]
                                                                        .dPhone ??
                                                                    "",
                                                                style: context
                                                                    .appTheme
                                                                    .bodySmall
                                                                    .override(
                                                                      fontFamily:
                                                                          'Plus Jakarta Sans',
                                                                      color:
                                                                          context
                                                                              .appTheme
                                                                              .primary,
                                                                      fontSize:
                                                                          12.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            0.0,
                            10.0,
                            10.0,
                            0.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  0.0,
                                  0.0,
                                  0.0,
                                ),
                                child: Text(
                                  'Light & Dark Mode',
                                  style: context.appTheme.bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    color: context.appTheme.primary,
                                  ),
                                ),
                              ),
                              Switch.adaptive(
                                value: _model.switchValue2 ??= false,
                                onChanged: (newValue) async {
                                  setState(
                                    () => _model.switchValue2 = newValue,
                                  );
                                  if (newValue) {
                                    setDarkModeSetting(context, ThemeMode.dark);
                                  } else {
                                    setDarkModeSetting(
                                      context,
                                      ThemeMode.light,
                                    );
                                  }
                                },
                                activeColor: context.appTheme.primary,
                                activeTrackColor: context.appTheme.accent1,
                                inactiveTrackColor: context.appTheme.alternate,
                                inactiveThumbColor:
                                    context.appTheme.secondaryText,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            5.0,
                            5.0,
                            5.0,
                            5.0,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('Earnings');
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  8.0,
                                  0.0,
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0,
                                        0.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.poundSign,
                                        color: context.appTheme.primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0,
                                          0.0,
                                          0.0,
                                          0.0,
                                        ),
                                        child: Text(
                                          'Earning  £${dueBalance ?? '00.00'}',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(thickness: 1.0, color: Color(0xFFE0E3E7)),

                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            5.0,
                            5.0,
                            5.0,
                            5.0,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('Home');
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  8.0,
                                  0.0,
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0,
                                        0.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.home,
                                        color: context.appTheme.primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0,
                                          0.0,
                                          0.0,
                                          0.0,
                                        ),
                                        child: Text(
                                          'Home',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.appTheme.primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            5.0,
                            5.0,
                            5.0,
                            5.0,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('BidHistoryFilter');
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  8.0,
                                  0.0,
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0,
                                        0.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.capsules,
                                        color: context.appTheme.primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0,
                                          0.0,
                                          0.0,
                                          0.0,
                                        ),
                                        child: Text(
                                          'Bid',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.appTheme.primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            5.0,
                            5.0,
                            5.0,
                            5.0,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('jobshistory');
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  8.0,
                                  0.0,
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0,
                                        0.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: Icon(
                                        Icons.checklist_sharp,
                                        color: context.appTheme.primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0,
                                          0.0,
                                          0.0,
                                          0.0,
                                        ),
                                        child: Text(
                                          'Job History',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.appTheme.primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            5.0,
                            5.0,
                            5.0,
                            5.0,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('Upcomming');
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  8.0,
                                  0.0,
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0,
                                        0.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: Icon(
                                        Icons.directions_car,
                                        color: context.appTheme.primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0,
                                          0.0,
                                          0.0,
                                          0.0,
                                        ),
                                        child: Text(
                                          'UpComming Jobs',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.appTheme.primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(thickness: 1.0, color: Color(0xFFE0E3E7)),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            5.0,
                            5.0,
                            5.0,
                            5.0,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('AllDocoments');
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  8.0,
                                  0.0,
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0,
                                        0.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: Icon(
                                        Icons.edit_document,
                                        color: context.appTheme.primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0,
                                          0.0,
                                          0.0,
                                          0.0,
                                        ),
                                        child: Text(
                                          'Edit Documents',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.appTheme.primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            5.0,
                            5.0,
                            5.0,
                            5.0,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('TimeSlots');
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  8.0,
                                  0.0,
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0,
                                        0.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: Icon(
                                        Icons.share_arrival_time,
                                        color: context.appTheme.primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0,
                                          0.0,
                                          0.0,
                                          0.0,
                                        ),
                                        child: Text(
                                          'Time Slots',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.appTheme.primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsetsDirectional.fromSTEB(
                        //       5.0, 5.0, 5.0, 5.0),
                        //   child: InkWell(
                        //     splashColor: Colors.transparent,
                        //     focusColor: Colors.transparent,
                        //     hoverColor: Colors.transparent,
                        //     highlightColor: Colors.transparent,
                        //     onTap: () async {
                        //       await showModalBottomSheet(
                        //         isScrollControlled: true,
                        //         backgroundColor: Colors.transparent,
                        //         enableDrag: false,
                        //         context: context,
                        //         builder: (context) {
                        //           return GestureDetector(
                        //             onTap: () => _model
                        //                     .unfocusNode.canRequestFocus
                        //                 ? FocusScope.of(context)
                        //                     .requestFocus(_model.unfocusNode)
                        //                 : FocusScope.of(context).unfocus(),
                        //             child: Padding(
                        //               padding: MediaQuery.viewInsetsOf(context),
                        //               child: ChangepaymentmethodWidget(),
                        //             ),
                        //           );
                        //         },
                        //       ).then((value) => safeSetState(() {}));
                        //     },
                        //     child: AnimatedContainer(
                        //       duration: Duration(milliseconds: 150),
                        //       curve: Curves.easeInOut,
                        //       width: double.infinity,
                        //       child: Padding(
                        //         padding: EdgeInsetsDirectional.fromSTEB(
                        //             0.0, 8.0, 0.0, 8.0),
                        //         child: Row(
                        //           mainAxisSize: MainAxisSize.max,
                        //           children: [
                        //             Padding(
                        //               padding: EdgeInsetsDirectional.fromSTEB(
                        //                   12.0, 0.0, 0.0, 0.0),
                        //               child: Icon(
                        //                 Icons.payment,
                        //                 color: context.appTheme
                        //                     .primary,
                        //                 size: 20.0,
                        //               ),
                        //             ),
                        //             Expanded(
                        //               child: Padding(
                        //                 padding: EdgeInsetsDirectional.fromSTEB(
                        //                     12.0, 0.0, 0.0, 0.0),
                        //                 child: Text(
                        //                   'Change Payment Method',
                        //                   style: context.appTheme
                        //                       .bodyMedium
                        //                       .override(
                        //                         fontFamily: 'Plus Jakarta Sans',
                        //                         color:
                        //                             context.appTheme
                        //                                 .primary,
                        //                         fontSize: 14.0,
                        //                         fontWeight: FontWeight.w500,
                        //                       ),
                        //                 ),
                        //               ),
                        //             ),
                        //             Icon(
                        //               Icons.chevron_right_outlined,
                        //               color:
                        //                   context.appTheme.primary,
                        //               size: 24.0,
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Divider(thickness: 1.0, color: Color(0xFFE0E3E7)),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            5.0,
                            5.0,
                            5.0,
                            5.0,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('Myprofile');
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  8.0,
                                  0.0,
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0,
                                        0.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: Icon(
                                        Icons.account_circle_outlined,
                                        color: context.appTheme.primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0,
                                          0.0,
                                          0.0,
                                          0.0,
                                        ),
                                        child: Text(
                                          'My Account',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.appTheme.primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            5.0,
                            5.0,
                            5.0,
                            5.0,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('AcountStatements');
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  8.0,
                                  0.0,
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0,
                                        0.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: Icon(
                                        Icons.payments,
                                        color: context.appTheme.primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0,
                                          0.0,
                                          0.0,
                                          0.0,
                                        ),
                                        child: Text(
                                          'Account Statement',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.appTheme.primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            5.0,
                            5.0,
                            5.0,
                            5.0,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('Reviews');
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  8.0,
                                  0.0,
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0,
                                        0.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: Icon(
                                        Icons.feedback_outlined,
                                        color: context.appTheme.primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0,
                                          0.0,
                                          0.0,
                                          0.0,
                                        ),
                                        child: Text(
                                          'Reviews',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.appTheme.primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('chat');
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  8,
                                  0,
                                  8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12,
                                        0,
                                        0,
                                        0,
                                      ),
                                      child: Icon(
                                        Icons.chat_outlined,
                                        color: context.appTheme.primary,
                                        size: 20,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12,
                                          0,
                                          0,
                                          0,
                                        ),
                                        child: Text(
                                          'Massages',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.appTheme.primary,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              const phoneNumber =
                                  '+447552834179'; // Change this to your desired phone number
                              final url = 'tel:$phoneNumber';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  8,
                                  0,
                                  8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12,
                                        0,
                                        0,
                                        0,
                                      ),
                                      child: Icon(
                                        Icons.call_outlined,
                                        color: context.appTheme.primary,
                                        size: 20,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12,
                                          0,
                                          0,
                                          0,
                                        ),
                                        child: Text(
                                          'Support',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.appTheme.primary,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(thickness: 1.0, color: Color(0xFFE0E3E7)),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            5.0,
                            5.0,
                            5.0,
                            80.0,
                          ),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('isLoggedIn');
                              await prefs.clear();
                              await prefs.setBool('isLoggedIn', false);
                              context.pushNamed('Login');
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  8.0,
                                  0.0,
                                  8.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0,
                                        0.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: Icon(
                                        Icons.login_rounded,
                                        color: context.appTheme.primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          12.0,
                                          0.0,
                                          0.0,
                                          0.0,
                                        ),
                                        child: Text(
                                          'Log out',
                                          style: context.appTheme.bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color: context.appTheme.primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color: context.appTheme.primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(top: true, child: _buildDashboardBody(context)),
        ),
      ),
    );
  }

  Widget _buildDashboardBody(BuildContext context) {
    final isOnline = SwitchStatus == 1;

    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(18.0, 10.0, 18.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 18.0),
          _buildHeroCard(context, isOnline),
          const SizedBox(height: 16.0),
          _buildBreakControl(context),
          const SizedBox(height: 24.0),
          Text(
            'Quick actions',
            style: context.appTheme.titleLarge.override(
              fontFamily: 'Outfit',
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14.0),
          _buildActionGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        FlutterFlowIconButton(
          borderColor: context.appTheme.lineColor,
          borderWidth: 1.0,
          buttonSize: 46.0,
          fillColor: context.appTheme.secondaryBackground,
          icon: Icon(
            Icons.menu_rounded,
            color: context.appTheme.primaryText,
            size: 24.0,
          ),
          onPressed: () async {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        const SizedBox(width: 14.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: context.appTheme.headlineMedium.override(
                  fontFamily: 'Outfit',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                'Manage your day from one place',
                style: context.appTheme.bodySmall.override(
                  fontFamily: 'Plus Jakarta Sans',
                  color: context.appTheme.secondaryText,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context, bool isOnline) {
    final statusColor =
        isOnline ? context.appTheme.success : context.appTheme.warning;

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 18.0),
      decoration: BoxDecoration(
        color: context.appTheme.primary,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18.0,
            color: Color(0x22000000),
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Icon(
                  Icons.local_taxi_rounded,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOnline ? 'Ready for jobs' : 'Currently offline',
                      style: context.appTheme.titleMedium.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      isOnline
                          ? 'You are available to receive bookings'
                          : 'Go online to receive bookings',
                      style: context.appTheme.bodySmall.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white.withOpacity(0.72),
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  10.0,
                  6.0,
                  10.0,
                  6.0,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7.0,
                      height: 7.0,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      isOnline ? 'Online' : 'Offline',
                      style: context.appTheme.bodySmall.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Colors.white,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22.0),
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(
              14.0,
              12.0,
              14.0,
              12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_rounded,
                  color: context.appTheme.secondary,
                  size: 22.0,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    'Available earnings',
                    style: context.appTheme.bodySmall.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 12.0,
                    ),
                  ),
                ),
                Text(
                  '£${dueBalance ?? '00.00'}',
                  style: context.appTheme.titleMedium.override(
                    fontFamily: 'Outfit',
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakControl(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: context.appTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: context.appTheme.lineColor),
      ),
      child: ToggleSwitch(
        minWidth: MediaQuery.sizeOf(context).width,
        minHeight: 48.0,
        initialLabelIndex: 0,
        cornerRadius: 12.0,
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.transparent,
        inactiveFgColor: context.appTheme.secondaryText,
        totalSwitches: 2,
        labels: const ['Back Online', 'Break Time'],
        icons: const [FontAwesomeIcons.circleDot, FontAwesomeIcons.powerOff],
        activeBgColors: [
          [context.appTheme.success],
          [context.appTheme.warning],
        ],
        onToggle: (index) async {
          if (SwitchStatus == 1) {
            if (index == 1) {
              startBreak();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BreakTimeWidget()),
              );
            } else {
              print('the break press');
            }
          } else {
            Fluttertoast.showToast(
              msg: "You're not online. You can't go to break.",
            );
          }
        },
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    final actions = <_DashboardAction>[
      _DashboardAction(
        title: 'Home',
        subtitle: 'Live jobs',
        icon: Icons.home_rounded,
        color: context.appTheme.primary,
        onTap: () async => context.pushNamed('Home'),
      ),
      _DashboardAction(
        title: 'Upcoming',
        subtitle: 'Booked trips',
        icon: Icons.directions_car_filled_rounded,
        color: const Color(0xFF249689),
        onTap: () async => _showDashboardSheet(UpcommingjobWidget(dId: '')),
      ),
      _DashboardAction(
        title: 'History',
        subtitle: 'Past jobs',
        icon: Icons.checklist_rtl_rounded,
        color: const Color(0xFF6374E8),
        onTap: () async => _showDashboardSheet(JobHistorySheet()),
      ),
      _DashboardAction(
        title: 'Bids',
        subtitle: 'Offers',
        icon: FontAwesomeIcons.clipboardList,
        color: const Color(0xFFC96F46),
        onTap: () async => _showDashboardSheet(BidsBottomSheet()),
      ),
      _DashboardAction(
        title: 'Zones',
        subtitle: 'Coverage',
        icon: Icons.location_on_rounded,
        color: const Color(0xFF39A7D2),
        onTap: () async => _showDashboardSheet(ZoneBottomsheet()),
      ),
      _DashboardAction(
        title: 'Payment',
        subtitle: 'Statements',
        icon: Icons.payments_rounded,
        color: context.appTheme.secondary,
        onTap: () async => _showDashboardSheet(AccountsBottomsheet()),
      ),
    ];

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: 1.08,
      ),
      primary: false,
      shrinkWrap: true,
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return _buildActionTile(context, actions[index]).animateOnPageLoad(
          animationsMap['containerOnPageLoadAnimation${(index % 6) + 1}']!,
        );
      },
    );
  }

  Widget _buildActionTile(BuildContext context, _DashboardAction action) {
    final foreground =
        action.color == context.appTheme.secondary
            ? context.appTheme.primary
            : Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.0),
        onTap: action.onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: context.appTheme.secondaryBackground,
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(color: context.appTheme.lineColor),
            boxShadow: const [
              BoxShadow(
                blurRadius: 14.0,
                color: Color(0x12000000),
                offset: Offset(0.0, 8.0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              16.0,
              16.0,
              16.0,
              14.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46.0,
                  height: 46.0,
                  decoration: BoxDecoration(
                    color: action.color,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Icon(action.icon, color: foreground, size: 22.0),
                ),
                const Spacer(),
                Text(
                  action.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.appTheme.titleLarge.override(
                    fontFamily: 'Outfit',
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  action.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.appTheme.bodySmall.override(
                    fontFamily: 'Plus Jakarta Sans',
                    color: context.appTheme.secondaryText,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDashboardSheet(Widget child) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            if ((details.primaryDelta ?? 0) > 20) {
              Navigator.pop(context);
            }
          },
          onTap:
              () =>
                  _model.unfocusNode.canRequestFocus
                      ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                      : FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: child,
          ),
        );
      },
    ).then((value) => safeSetState(() {}));
  }

  Future<void> startBreak() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverStartBreak),
      );
      request.fields.addAll({'d_id': dId.toString()});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        Fluttertoast.showToast(msg: "Switched to Break time");
        if (jsonResponse['status']) {
          String data = jsonResponse['data'].toString();
          // breakId = data;
          await prefs.setString('breakId', data);
          print(jsonResponse['message']);
        } else {
          print('Error: ${jsonResponse['message']}');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> getDriverPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('d_email');
    phone = prefs.getString('d_phone');
    var pic = prefs.getString('d_pic');
    print('Driver Email: $email');
    print('Driver pic: $pic');
    print('Driver Phone: $phone');
  }

  void getCurrentLocationOnTime() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> DueBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiService.driverTotalDueBalance),
    );
    request.fields.addAll({'d_id': dId.toString()});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      print(jsonResponse);
      if (jsonResponse['status'] == false) {
      } else {
        String totalCommission = jsonResponse['data']['total_commission'] ?? "";
        print(totalCommission);
        if (mounted) {
          setState(() {
            dueBalance = totalCommission;
            print('Total commission: $dueBalance');
          });
        }

        print('Total commission: $totalCommission');
      }
    } else {
      print('Failed to fetch data: ${response.reasonPhrase}');
    }
  }

  Future<List<Driver>> myProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');

    if (dId == null) {
      print('d_id not found in shared preferences.');
      return [];
    }

    final uri = Uri.parse(ApiService.driverViewProfile);
    final response = await http.post(uri, body: {'d_id': dId.toString()});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'] ?? [];

      List<Driver> profileData =
          data.map((item) => Driver.fromJson(item)).cast<Driver>().toList();
      return profileData;
    } else {
      print('Error: ${response.reasonPhrase}');
      return [];
    }
  }

  Future<void> sendOnlineStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverOnlineStatus),
      );
      request.fields.addAll({
        'd_id': dId.toString(),
        'status':
            switchValue1 == false
                ? 'Offline'
                : 'Online', // Adjusted status based on the switch value
      });
      print(request.fields);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendLocationData(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String driverId = prefs.getString('d_id') ?? '';
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiService.driverRealLocation),
    );
    request.fields.addAll({
      'd_id': driverId.toString(),
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    });

    request.fields.forEach((key, value) {
      print('$key: $value');
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  void sendLocationDataPeriodically() {
    locationTimer = Timer.periodic(Duration(seconds: 10), (Timer timer) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        double latitude = position.latitude;
        double longitude = position.longitude;

        await sendLocationData(latitude, longitude);
        print('Latitude: $latitude, Longitude: $longitude');
      } catch (e) {
        print('Error: $e');
      }
    });
  }

  void stopLocationDataPeriodicUpdates() {
    locationTimer!.cancel();
    locationTimer = null;
  }

  Future<void> saveInPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPhone = prefs.getString('d_phone');
    String? savedPassword = prefs.getString('d_password');
    final url = Uri.parse(ApiService.driverSignin);
    final request = http.MultipartRequest('POST', url);
    request.fields.addAll({
      'd_phone': '$savedPhone',
      'd_password': '$savedPassword',
    });
    try {
      final url = Uri.parse(ApiService.driverSignin);
      final request = http.MultipartRequest('POST', url);
      request.fields.addAll({
        'd_phone': savedPhone ?? '',
        'd_password': savedPassword ?? '',
      });
      print(request.fields);
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        print('Response: $responseBody');
        if (jsonResponse['status'] == true) {
          if (jsonResponse.containsKey('data')) {
            final Map<String, dynamic> userData = jsonResponse[''];
            if (userData.isNotEmpty) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLogin', true);
              userData.forEach((key, value) async {
                await prefs.setString(key, value?.toString() ?? '') ?? '';
                print('Saved $key: ${prefs.getString(key)}');
              });
            } else {
              print('Error: userData is null or empty');
            }
          } else {}
        } else {
          print(response.reasonPhrase);
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error during login: $error');
    }
  }

  Future<List<Driver>> pro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');

    final uri = Uri.parse(ApiService.driverViewProfile);
    final response = await http.post(uri, body: {'d_id': dId.toString()});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse[''];

      List<Driver> profileData =
          data.map((item) => Driver.fromJson(item)).cast<Driver>().toList();
      return profileData;
    } else {
      print('Error: ${response.reasonPhrase}');
      return []; // Return an empty list in case of an error.
    }
  }
}

class _DashboardAction {
  const _DashboardAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Future<void> Function() onTap;
}
