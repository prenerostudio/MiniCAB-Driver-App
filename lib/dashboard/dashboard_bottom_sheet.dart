import 'package:flutter/material.dart';
import 'dart:isolate';
import 'dart:ui';
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

class DashboardBottomSheet extends StatefulWidget {
  const DashboardBottomSheet({super.key});

  @override
  State<DashboardBottomSheet> createState() => _DashboardBottomSheetState();
}

class _DashboardBottomSheetState extends State<DashboardBottomSheet> {
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
  _loadSwitchStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedIndex = prefs.getInt('switchValue') ?? 0;
    setState(() {
      SwitchStatus = savedIndex;
    });
    print(SwitchStatus);
  }

  bool? isLogin;
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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! > 20) {
          // Close the BottomSheet on a downward swipe
          Navigator.pop(context);
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 1,
        builder: (context, scrollController) {
          DateTime? lastBackPressed;
          return GestureDetector(
            onTap: () => _model.unfocusNode.canRequestFocus
                ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                : FocusScope.of(context).unfocus(),
            child: WillPopScope(
              onWillPop: () async {
                if (lastBackPressed == null ||
                    DateTime.now().difference(lastBackPressed!) >
                        Duration(seconds: 2)) {
                  context.pushNamed('Home');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Press again to exit')),
                  );
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
                      padding: EdgeInsetsDirectional.fromSTEB(
                        0.0,
                        20.0,
                        0.0,
                        0.0,
                      ),
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
                                        padding: const EdgeInsets.only(
                                          left: 0.0,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FutureBuilder<List<Driver>>(
                                              future: myProfile(),
                                              builder:
                                                  (
                                                    BuildContext context,
                                                    AsyncSnapshot<List<Driver>>
                                                    snapshot,
                                                  ) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(
                                                              Colors.blueAccent,
                                                            ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                        'Error: ${snapshot.error}',
                                                      );
                                                    } else {
                                                      final driverData =
                                                          snapshot.data;
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
                                                                  MainAxisSize
                                                                      .max,
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
                                                                    height:
                                                                        70.0,
                                                                    clipBehavior:
                                                                        Clip.antiAlias,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                    child: Image.network(
                                                                      'https://atiqramzan.online/img/drivers/${driverData![0].dPic}',
                                                                      width:
                                                                          100.0,
                                                                      height:
                                                                          100.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorBuilder:
                                                                          (
                                                                            context,
                                                                            error,
                                                                            stackTrace,
                                                                          ) {
                                                                            return Image.asset(
                                                                              'assets/images/user.png',
                                                                              width: 100.0,
                                                                              height: 100.0,
                                                                              fit: BoxFit.cover,
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
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        driverData[0].dName ??
                                                                            "",
                                                                        style: context.appTheme.bodyMedium.override(
                                                                          fontFamily:
                                                                              'Plus Jakarta Sans',
                                                                          color: context
                                                                              .appTheme
                                                                              .primary,
                                                                          fontSize:
                                                                              14.0,
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                          0.0,
                                                                        ),
                                                                        child: Text(
                                                                          driverData[0].dPhone ??
                                                                              "",
                                                                          style: context.appTheme.bodySmall.override(
                                                                            fontFamily:
                                                                                'Plus Jakarta Sans',
                                                                            color:
                                                                                context.appTheme.primary,
                                                                            fontSize:
                                                                                12.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                        style: context.appTheme.bodyMedium
                                            .override(
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
                                          setDarkModeSetting(
                                            context,
                                            ThemeMode.dark,
                                          );
                                        } else {
                                          setDarkModeSetting(
                                            context,
                                            ThemeMode.light,
                                          );
                                        }
                                      },
                                      activeColor: context.appTheme.primary,
                                      activeTrackColor:
                                          context.appTheme.accent1,
                                      inactiveTrackColor:
                                          context.appTheme.alternate,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12.0,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                              child: Text(
                                                'Earning  £${dueBalance ?? '00.00'}',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12.0,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                              child: Text(
                                                'Home',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12.0,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                              child: Text(
                                                'Bid',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12.0,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                              child: Text(
                                                'Job History',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12.0,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                              child: Text(
                                                'UpComming Jobs',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12.0,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                              child: Text(
                                                'Edit Documents',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12.0,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                              child: Text(
                                                'Time Slots',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12.0,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                              child: Text(
                                                'My Account',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12.0,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                              child: Text(
                                                'Account Statement',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12.0,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                              child: Text(
                                                'Reviews',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              child: Text(
                                                'Massages',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              child: Text(
                                                'Support',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    12.0,
                                                    0.0,
                                                    0.0,
                                                    0.0,
                                                  ),
                                              child: Text(
                                                'Log out',
                                                style: context
                                                    .appTheme
                                                    .bodyMedium
                                                    .override(
                                                      fontFamily:
                                                          'Plus Jakarta Sans',
                                                      color: context
                                                          .appTheme
                                                          .primary,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                body: SafeArea(
                  top: true,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 4,
                              width: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(38),
                                color: Colors.grey.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            30.0,
                            5.0,
                            50.0,
                            5.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0,
                                  10.0,
                                  10.0,
                                  10.0,
                                ),
                                child: FlutterFlowIconButton(
                                  borderColor:
                                      context.appTheme.secondaryBackground,
                                  borderWidth: 1.0,
                                  buttonSize: 40.0,
                                  fillColor:
                                      context.appTheme.secondaryBackground,
                                  icon: Icon(
                                    Icons.menu,
                                    color: context.appTheme.primaryText,
                                    size: 30,
                                  ),
                                  onPressed: () async {
                                    scaffoldKey.currentState!.openDrawer();
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  print('Showing overlay...');

                                  print('Overlay shown');
                                },
                                child: Text(
                                  'Dashboard',
                                  style: context.appTheme.bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            0.0,
                            5.0,
                            0.0,
                            5.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ToggleSwitch(
                                minWidth: MediaQuery.sizeOf(context).width,
                                minHeight: 50,
                                initialLabelIndex: 0,
                                cornerRadius: 30.0,
                                activeFgColor: Colors.white,
                                inactiveBgColor: Colors.grey,
                                inactiveFgColor: Colors.white,
                                totalSwitches: 2,
                                labels: ['Back To Online', 'Break time'],
                                icons: [
                                  FontAwesomeIcons.dotCircle,
                                  FontAwesomeIcons.powerOff,
                                ],
                                activeBgColors: [
                                  [context.appTheme.primary],
                                  [Colors.yellow],
                                ],
                                onToggle: (index) async {
                                  if (SwitchStatus == 1) {
                                    if (index == 1) {
                                      startBreak();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BreakTimeWidget(),
                                        ),
                                      );
                                      // context.pushNamed('BreakTime');
                                    } else {
                                      print('the break press');
                                      // SharedPreferences prefs =
                                      //     await SharedPreferences.getInstance();
                                      // String? dId = prefs.getString('d_id');
                                      // var request = http.MultipartRequest(
                                      //     'POST',
                                      //     Uri.parse(
                                      //         ApiService.driverEndBreak));
                                      // request.fields.addAll({
                                      //   'bt_id': '${breakId}',
                                      //   'd_id': dId.toString()
                                      // });
                                      // print(request.fields);
                                      // http.StreamedResponse response =
                                      //     await request.send();
                                      // if (response.statusCode == 200) {
                                      //   print(await response.stream.bytesToString());
                                      //   Fluttertoast.showToast(
                                      //     msg: "Switched to Online",
                                      //   );
                                      // } else {
                                      //   print(response.reasonPhrase);
                                      // }
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg:
                                          "You're not online. You can't go to break.",
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            16.0,
                            12.0,
                            16.0,
                            12.0,
                          ),
                          child: GridView(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 1.0,
                                ),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed('Home');
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  decoration: BoxDecoration(
                                    color: context.appTheme.primary,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0,
                                      0.0,
                                      12.0,
                                      0.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.home,
                                          color: context.appTheme.info,
                                          size:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.1,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0.0,
                                                0.0,
                                                0.0,
                                                0.0,
                                              ),
                                          child: Text(
                                            'Home',
                                            textAlign: TextAlign.center,
                                            style: context.appTheme.displaySmall
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color: context.appTheme.info,
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.05,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onVerticalDragUpdate: (details) {
                                          if (details.primaryDelta! > 20) {
                                            // Close the BottomSheet on a downward swipe
                                            Navigator.pop(context);
                                          }
                                        },
                                        // onVerticalDragDown: (details) {
                                        //   Navigator.pop(context);
                                        //   debugPrint('downSwipped');
                                        // },
                                        onTap: () =>
                                            _model.unfocusNode.canRequestFocus
                                            ? FocusScope.of(
                                                context,
                                              ).requestFocus(_model.unfocusNode)
                                            : FocusScope.of(context).unfocus(),
                                        child: Padding(
                                          padding: MediaQuery.viewInsetsOf(
                                            context,
                                          ),
                                          child: UpcommingjobWidget(dId: ''),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));

                                  // context.pushNamed('Upcomming');
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  decoration: BoxDecoration(
                                    color: context.appTheme.alternate,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0,
                                      0.0,
                                      12.0,
                                      0.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.directions_car_outlined,
                                          color: context.appTheme.primaryText,
                                          size:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.1,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0.0,
                                                0.0,
                                                0.0,
                                                0.0,
                                              ),
                                          child: Text(
                                            'Upcoming Jobs',
                                            textAlign: TextAlign.center,
                                            style: context.appTheme.displaySmall
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color: context
                                                      .appTheme
                                                      .primaryText,
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.05,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onVerticalDragUpdate: (details) {
                                          if (details.primaryDelta! > 2) {
                                            // Close the BottomSheet on a downward swipe
                                            Navigator.pop(context);
                                          }
                                        },
                                        // onVerticalDragDown: (details) {
                                        //   Navigator.pop(context);
                                        //   debugPrint('downSwipped');
                                        // },
                                        onTap: () =>
                                            _model.unfocusNode.canRequestFocus
                                            ? FocusScope.of(
                                                context,
                                              ).requestFocus(_model.unfocusNode)
                                            : FocusScope.of(context).unfocus(),
                                        child: Padding(
                                          padding: MediaQuery.viewInsetsOf(
                                            context,
                                          ),
                                          child: JobHistorySheet(
                                            // did: '',
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));

                                  // context.pushNamed('jobshistory');
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  decoration: BoxDecoration(
                                    color: context.appTheme.alternate,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0,
                                      0.0,
                                      12.0,
                                      0.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.checklist_rtl,
                                          color: context.appTheme.primaryText,
                                          size:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.1,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0.0,
                                                0.0,
                                                0.0,
                                                0.0,
                                              ),
                                          child: Text(
                                            'Job History',
                                            textAlign: TextAlign.center,
                                            style: context.appTheme.displaySmall
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.05,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ).animateOnPageLoad(
                                animationsMap['containerOnPageLoadAnimation2']!,
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onVerticalDragUpdate: (details) {
                                          if (details.primaryDelta! > 20) {
                                            // Close the BottomSheet on a downward swipe
                                            Navigator.pop(context);
                                          }
                                        },
                                        // onVerticalDragDown: (details) {
                                        //   Navigator.pop(context);
                                        //   debugPrint('downSwipped');
                                        // },
                                        onTap: () =>
                                            _model.unfocusNode.canRequestFocus
                                            ? FocusScope.of(
                                                context,
                                              ).requestFocus(_model.unfocusNode)
                                            : FocusScope.of(context).unfocus(),
                                        child: Padding(
                                          padding: MediaQuery.viewInsetsOf(
                                            context,
                                          ),
                                          child: BidsBottomSheet(),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));

                                  // context.pushNamed('Bids');
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  decoration: BoxDecoration(
                                    color: context.appTheme.alternate,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0,
                                      0.0,
                                      12.0,
                                      0.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.clipboardList,
                                          color: context.appTheme.primaryText,
                                          size:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.1,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0.0,
                                                0.0,
                                                0.0,
                                                0.0,
                                              ),
                                          child: Text(
                                            'Bids ',
                                            textAlign: TextAlign.center,
                                            style: context.appTheme.displaySmall
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.05,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ).animateOnPageLoad(
                                animationsMap['containerOnPageLoadAnimation4']!,
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onVerticalDragUpdate: (details) {
                                          if (details.primaryDelta! > 20) {
                                            // Close the BottomSheet on a downward swipe
                                            Navigator.pop(context);
                                          }
                                        },
                                        // onVerticalDragDown: (details) {
                                        //   Navigator.pop(context);
                                        //   debugPrint('downSwipped');
                                        // },
                                        onTap: () =>
                                            _model.unfocusNode.canRequestFocus
                                            ? FocusScope.of(
                                                context,
                                              ).requestFocus(_model.unfocusNode)
                                            : FocusScope.of(context).unfocus(),
                                        child: Padding(
                                          padding: MediaQuery.viewInsetsOf(
                                            context,
                                          ),
                                          child: ZoneBottomsheet(),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));

                                  // context.pushNamed('Zones');
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  decoration: BoxDecoration(
                                    color: context.appTheme.alternate,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0,
                                      0.0,
                                      12.0,
                                      0.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: context.appTheme.primaryText,
                                          size:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.1,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0.0,
                                                0.0,
                                                0.0,
                                                0.0,
                                              ),
                                          child: Text(
                                            'Zones',
                                            textAlign: TextAlign.center,
                                            style: context.appTheme.displaySmall
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.05,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ).animateOnPageLoad(
                                animationsMap['containerOnPageLoadAnimation5']!,
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        onVerticalDragUpdate: (details) {
                                          if (details.primaryDelta! > 20) {
                                            // Close the BottomSheet on a downward swipe
                                            Navigator.pop(context);
                                          }
                                        },
                                        // onVerticalDragDown: (details) {
                                        //   Navigator.pop(context);
                                        //   debugPrint('downSwipped');
                                        // },
                                        onTap: () =>
                                            _model.unfocusNode.canRequestFocus
                                            ? FocusScope.of(
                                                context,
                                              ).requestFocus(_model.unfocusNode)
                                            : FocusScope.of(context).unfocus(),
                                        child: Padding(
                                          padding: MediaQuery.viewInsetsOf(
                                            context,
                                          ),
                                          child: AccountsBottomsheet(),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => NavBarPage(
                                  //               initialPage: "AccountStatement",
                                  //             )));
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  decoration: BoxDecoration(
                                    color: context.appTheme.alternate,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0,
                                      0.0,
                                      12.0,
                                      0.0,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.payments,
                                          color: context.appTheme.primaryText,
                                          size:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.1,
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0.0,
                                                0.0,
                                                0.0,
                                                0.0,
                                              ),
                                          child: Text(
                                            'Payment',
                                            textAlign: TextAlign.center,
                                            style: context.appTheme.displaySmall
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width *
                                                      0.05,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ).animateOnPageLoad(
                                animationsMap['containerOnPageLoadAnimation6']!,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
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

      List<Driver> profileData = data
          .map((item) => Driver.fromJson(item))
          .cast<Driver>()
          .toList();
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
        'status': switchValue1 == false
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

      List<Driver> profileData = data
          .map((item) => Driver.fromJson(item))
          .cast<Driver>()
          .toList();
      return profileData;
    } else {
      print('Error: ${response.reasonPhrase}');
      return []; // Return an empty list in case of an error.
    }
  }
}
