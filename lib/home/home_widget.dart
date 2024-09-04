import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:mini_cab/Acount%20Statements/acount_statements_widget.dart';
import 'package:mini_cab/home/home_screen_alert.dart';
import 'package:mini_cab/home/home_view_controller.dart';
import 'package:mini_cab/home/polyLinesAndMarker.dart';
import 'package:mini_cab/review/review_screen.dart';
import 'package:mini_cab/time_slot/time_slot_view.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:root_checker_plus/root_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import '../Model/jobDetails.dart';
import '../components/notes_widget.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_model.dart';
export 'home_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Model/myProfile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomeWidget extends StatefulWidget {
  bool? isFromOnway;
  HomeWidget({
    this.isFromOnway,
    Key? key,
  }) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with WidgetsBindingObserver {
  late HomeModel _model;
  LatLng? selectedLocation;
  GoogleMapController? mapController;

  bool isLoading = true;
  String? phone;
  String? email;
  bool? switchValue1;
  String? driverStatus;
  String locationMessage = "";
  Timer? locationTimer;
  Timer? userSession;
  bool status = true;
  final ScrollController _scrollController = ScrollController();
  String? pickup;

  String? dueBalance = '0';
  bool rootedCheck = false;
  bool jailbreak = false;
  bool devMode = false;
  bool _isVisible = false;
  final animationsMap = <String, AnimationInfo>{};
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool jobStatus = false;
  bool periodicStatus = false;
  // bool isPeriodicVisible = false;
  // Timer? _timer;
  // Timer? _timerVisible;
  // bool visiblecontainer = false;
  pushercallbg() async {
    myController.timer?.cancel();
    try {
      var pusher = PusherClient(
        '28691ac9c0c5ac41b64a',
        PusherOptions(
          host: 'https://minicaboffice.com/api/driver/upcoming-jobs.php',
          cluster: 'ap2',
          encrypted: false,
        ),
      );
      pusher.connect();

      var channel = pusher.subscribe('jobs-channel');

      // Listen for new events
      channel.bind('job-dispatched', (event) {
        startToon();
        listFromPusher.clear();
        Map<String, dynamic> jsonMap = json.decode(event!.data!);
        print("json data pusehrt${jsonMap['details'][0]['job_id']}");
        listFromPusher.add(Job(
            jobId: jsonMap['details'][0]['job_id'].toString() ?? "",
            bookId: jsonMap['details'][0]['book_id'].toString() ?? '',
            cId: jsonMap['details'][0]['00000003'].toString() ?? "",
            dId: jsonMap['details'][0]['00000000002'].toString() ?? '',
            jobNote: jsonMap['details'][0]['job_note'].toString() ?? '',
            journeyFare: jsonMap['details'][0]['journey_fare'].toString() ?? '',
            bookingFee: jsonMap['details'][0]['booking_fee'].toString() ?? "",
            carParking: jsonMap['details'][0]['car_parking'].toString() ?? '',
            waiting: jsonMap['details'][0]['waiting'].toString() ?? '',
            tolls: jsonMap['details'][0]['tolls'].toString() ?? '',
            extra: jsonMap['details'][0]['extra'].toString() ?? '',
            jobStatus: jsonMap['details'][0]['job_status'].toString() ?? '',
            dateJobAdd: jsonMap['details'][0]['date_job_add'].toString() ?? '',
            cName: jsonMap['details'][0]['c_name'].toString() ?? '',
            cEmail: jsonMap['details'][0]['c_email'].toString() ?? '',
            cPhone: jsonMap['details'][0]['c_phone'].toString() ?? '',
            cAddress: jsonMap['details'][0]['c_address'].toString() ?? '',
            dName: jsonMap['details'][0]['d_name'].toString() ?? '',
            dEmail: jsonMap['details'][0]['d_email'].toString() ?? '',
            dPhone: jsonMap['details'][0]['d_phone'].toString() ?? '',
            bTypeId: jsonMap['details'][0]['b_type_id'].toString() ?? '',
            pickup: jsonMap['details'][0]['pickup'].toString() ?? '',
            destination: jsonMap['details'][0]['destination'].toString() ?? '',
            address: jsonMap['details'][0]['address'].toString() ?? '',
            postalCode: jsonMap['details'][0]['postal_code'].toString() ?? '',
            passenger: jsonMap['details'][0]['passenger'].toString() ?? '',
            pickDate: jsonMap['details'][0]['pick_date'].toString() ?? '',
            pickTime: jsonMap['details'][0]['pick_time'].toString() ?? '',
            journeyType: jsonMap['details'][0]['journey_type'].toString() ?? '',
            vId: jsonMap['details'][0]['v_id'].toString() ?? '',
            luggage: jsonMap['details'][0]['luggage'].toString() ?? '',
            childSeat: jsonMap['details'][0]['child_seat'].toString() ?? '',
            flightNumber:
                jsonMap['details'][0]['flight_number'].toString() ?? '',
            delayTime: jsonMap['details'][0]['delay_time'].toString() ?? '',
            note: jsonMap['details'][0]['note'].toString() ?? '',
            journeyDistance:
                jsonMap['details'][0]['journey_distance'].toString() ?? '',
            bookingStatus:
                jsonMap['details'][0]['booking_status'].toString() ?? '',
            bidStatus: jsonMap['details'][0]['bid_status'].toString() ?? '',
            bidNote: jsonMap['details'][0]['bid_note'].toString() ?? '',
            bookAddDate: jsonMap['details'][0]['bid_status'].toString() ?? ''));

        showAlert();
// listFromPusher=jsonMap
        // jobDetailsFuture();
        // });
      });
      channel.bind('job-withdrawn', (event) {
        Map<String, dynamic> jsonMap = json.decode(event!.data!);
        checkJobStatus();
        print('the order socket from backaground:${jsonMap['data']}');

        // });
      });
    } catch (e) {
      print('the exception is $e');
    }
  }

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
        userSession?.cancel();
        context.pushNamed('Login');
        if (!mounted) return setState(() {});
      } else {
        // Handle the job details as normal
      }
    } else {
      // Handle the error
    }
  }

  final JobController myController = Get.put(JobController());
  @override
  void initState() {
    super.initState();
    myController.visiblecontainer.value = false;
    print('InitState called ......... ');
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    setState(() {
      // myController.visiblecontainer.value = true;
    });

    // userSession = Timer.periodic(Duration(seconds: 4), (s) {
    //   print('user session checking starts');
    //   checkUserSession();
    // });
    pushercallbg();
    myController.jobDetails().then((s) {
      print(
          'the getCoordinatesFromAddress ${myController.listFromPusher.isNotEmpty} ');
      if (myController.listFromPusher.isNotEmpty) {
        // getCoordinatesFromAddress(myController.listFromPusher[0].pickup);
      }
    });
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isAndroid) {
      androidRootChecker();
      developerMode();
    }
    if (Platform.isIOS) {
      iosJailbreak();
    }

    // _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
    //   if (!periodicStatus) {
    //     jobDetailsFuture().then((_) {
    //       print('true');
    //       periodicStatus = true;
    //       myController.jobDetails().then((_) {
    //       print('visible');
    //       _isVisible = true;
    //       myController.isPeriodicVisible.value = true;
    //       _timerVisible!.cancel();
    //     });
    //       _timer!.cancel();
    //     }).catchError((error) {
    //       // jobDetailsFuture();
    //       print(error);
    //     });
    //   }
    // });
    // _timerVisible = Timer.periodic(const Duration(seconds: 8), (timer) {
    //   if (myController.isPeriodicVisible.value) {
    //     myController.jobDetails().then((_) {
    //       print('visible');
    //       _isVisible = true;
    //       myController.isPeriodicVisible.value = true;
    //       _timerVisible!.cancel();
    //     }).catchError((error) {
    //       print(error);
    //     });
    //   }
    // });

    // jobDetailsFuture();
    callAp();
    fetchJobStatus();

    myProfile();
    _loadSwitchStatus();
    _initMapAndLocation();
    checkVehicleDocuments();
    DueBalance();
    _model = createModel(context, () => HomeModel());
    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        loop: true,
        // reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effects: [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 310.0.ms,
            duration: 600.0.ms,
            begin: const Offset(1, 1),
            end: const Offset(1, 1),
          ),
        ],
      ),
    });
  }

  AccpetingOrderViewModel accpetingOrderViewModel =
      Get.put(AccpetingOrderViewModel());
  Future<void> checkJobStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    String? jobId = prefs.getString('jobId');
    final response = await http.post(
      Uri.parse(
          'https://www.minicaboffice.com/api/driver/check-job-status.php'),
      body: {'d_id': dId.toString(), 'job_id': jobId.toString()},
    );
    print('job is deletedS ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == false) {
        prefs.remove("isRideStart");
        setState(() {});
        print('job is deleted ${data}');
        myController.visiblecontainer.value = false;
        myController.isJobDetailDone.value = false;

        context.pushNamed('Home');
      } else {
        // Handle the job details as normal
      }
    } else {
      // Handle the error
    }
  }

  showAlert() {
    // startToon();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return HomeScreenAlert(
            st: listFromPusher,
          );
        });
  }

  List<Job> listFromPusher = [];

  Future startToon() async {
    FlutterRingtonePlayer().playRingtone();

    // FlutterRingtonePlayer..play(
    //   // fromAsset: "assets\audios\ring.mp3",
    //   android: AndroidSounds.alarm,
    //   ios: IosSounds.alarm,
    //   looping: true,
    //   volume: 1.0,
    // );

    try {
      int totalDuration = 20000;
      int vibrationDuration = 3000;
      int pauseDuration = 3000;
      int numIterations = totalDuration ~/ (vibrationDuration + pauseDuration);
      for (int i = 0; i < numIterations; i++) {
        await Vibration.vibrate(duration: vibrationDuration);

        await Future.delayed(Duration(milliseconds: pauseDuration));
      }
    } catch (e) {
      print("Failed to vibrate: $e");
    }

    Timer(const Duration(seconds: 20), () {
      // FlutterRingtonePlayer.stop();
      FlutterRingtonePlayer().stop();
      Vibration.cancel();
    });
  }

  callAp() async {
    await jobDetailsFuture().then((_) {
      print('true');
      periodicStatus = true;

      // _timer!.cancel();
    });
  }
  // vissiblecontainer()async{
  //   SharedPreferences prefs= await SharedPreferences.getInstance();
  //
  //   visiblecontainer=prefs.getBool('visiblecontainer')??false;
  //
  // }

  @override
  void dispose() {
    mapController?.dispose();
    mapController = null;
    super.dispose();
  }

  void _initMapAndLocation() {
    if (mapController != null) {
      _getLocation();
    } else {
      // Delay until the map is ready
      Future.delayed(Duration(milliseconds: 100), _initMapAndLocation);
    }
  }

  Future getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        myController.convertedLat.value = locations.first.latitude;
        myController.convertedLng.value = locations.first.longitude;
        print(
            'convert Latitude: ${myController.convertedLat.value}, convert longitude: ${myController.convertedLng.value}');
        accpetingOrderViewModel.getLatLngFromCurrentLocation().then((value) {
          accpetingOrderViewModel.getdistanceandtime(
              locations.first.latitude, locations.first.longitude);
          accpetingOrderViewModel.kGoogleplay.value = CameraPosition(
              target: LatLng(accpetingOrderViewModel.latitude.value,
                  accpetingOrderViewModel.longitude.value),
              zoom: 12.4746);
          accpetingOrderViewModel.setcustommarkeritem();
        });
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(myController.visiblecontainer.value);
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    if (myController.listFromPusher.isNotEmpty) {
      getCoordinatesFromAddress(myController.listFromPusher[0].pickup);
    }
    DateTime? lastBackPressed;
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (lastBackPressed == null ||
              DateTime.now().difference(lastBackPressed!) >
                  const Duration(seconds: 2)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Press again to exit')),
            );
            lastBackPressed = DateTime.now();
            await saveSwitchStatus(0);
            await sendOnlineStatus();
            stopLocationDataPeriodicUpdates();
            return false;
          } else {
            SystemNavigator.pop();
            return true;
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          drawer: Container(
            width: MediaQuery.sizeOf(context).width * 0.8,
            height: MediaQuery.sizeOf(context).height * 1.0,
            child: Drawer(
              elevation: 40.0,
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? FlutterFlowTheme.of(context).primaryBackground
                        : FlutterFlowTheme.of(context).primaryBackground,
                    boxShadow: [
                      const BoxShadow(
                        blurRadius: 4.0,
                        color: Color(0x33000000),
                        offset: Offset(0.0, 2.0),
                      )
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
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 8.0),
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
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<Driver>>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.blueAccent),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            final driverData = snapshot.data;
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0.0, 15.0, 0.0, 8.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      context.pushNamed(
                                                          'Myprofile');
                                                    },
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  10.0,
                                                                  0.0,
                                                                  10.0,
                                                                  0.0),
                                                          child: Container(
                                                              width: 70.0,
                                                              height: 70.0,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child:
                                                                  Image.network(
                                                                'https://minicaboffice.com/img/drivers/${driverData![0].dPic}',
                                                                width: 100.0,
                                                                height: 100.0,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Image
                                                                      .asset(
                                                                    'assets/images/user.png',
                                                                    width:
                                                                        100.0,
                                                                    height:
                                                                        100.0,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  );
                                                                },
                                                              )),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  4.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
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
                                                                '${driverData[0].dName ?? ""}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Plus Jakarta Sans',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                      fontSize:
                                                                          14.0,
                                                                    ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0.0,
                                                                        10.0,
                                                                        0.0,
                                                                        0.0),
                                                                child: Text(
                                                                  '${driverData[0].dPhone ?? ""}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodySmall
                                                                      .override(
                                                                        fontFamily:
                                                                            'Plus Jakarta Sans',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
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
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 10.0, 10.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'Light & Dark Mode',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                ),
                              ),
                              Switch.adaptive(
                                value: _model.switchValue2 ??= false,
                                onChanged: (newValue) async {
                                  setState(
                                      () => _model.switchValue2 = newValue!);
                                  if (newValue!) {
                                    setDarkModeSetting(context, ThemeMode.dark);
                                  } else {
                                    setDarkModeSetting(
                                        context, ThemeMode.light);
                                  }
                                },
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                activeTrackColor:
                                    FlutterFlowTheme.of(context).accent1,
                                inactiveTrackColor:
                                    FlutterFlowTheme.of(context).alternate,
                                inactiveThumbColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 5.0, 5.0, 5.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('Earnings');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: InkWell(
                                  onTap: () async {
                                    context.pushNamed('Earnings');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: FaIcon(
                                          FontAwesomeIcons.poundSign,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 20.0,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            'Earning  £${dueBalance ?? '00.00'}',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
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
                        ),
                        const Divider(
                          thickness: 1.0,
                          color: Color(0xFFE0E3E7),
                        ),
                        InkWell(
                          onTap: () async {
                            context.pushNamed('Dashboard');
                          },
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                5.0, 5.0, 5.0, 5.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed('Dashboard');
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                curve: Curves.easeInOut,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Icon(
                                          Icons.dashboard_sharp,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 20.0,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed('Dashboard');
                                            },
                                            child: Text(
                                              'Dashboard',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        'Plus Jakarta Sans',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 24.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 5.0, 5.0, 5.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('BidHistoryFilter');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 0.0, 0.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.capsules,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Bid',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 5.0, 5.0, 5.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('jobshistory');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.checklist_sharp,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Job History',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 5.0, 5.0, 5.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('Upcomming');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.directions_car,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Upcoming Jobs',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1.0,
                          color: Color(0xFFE0E3E7),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 5.0, 5.0, 5.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('AllDocoments');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.edit_document,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Edit Documents',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 5.0, 5.0, 5.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TimeSlotView()));
                              // context.pushNamed('TimeSlots');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.share_arrival_time,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Time Slots',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1.0,
                          color: Color(0xFFE0E3E7),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 5.0, 5.0, 5.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('Myprofile');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.account_circle_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'My Account',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 5.0, 5.0, 5.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('invoiecs');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.picture_as_pdf_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'PDF',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 5.0, 5.0, 5.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  (MaterialPageRoute(
                                      builder: (context) =>
                                          AcountStatementsWidget())));
                              // context.pushNamed('AcountStatements');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.payments,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Account Statement',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 5.0, 5.0, 5.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              // context.pushNamed('Reviews');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ReviewScreen()));
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.feedback_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Reviews',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('chat');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 8, 0, 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 0, 0),
                                      child: Icon(
                                        Icons.chat_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12, 0, 0, 0),
                                        child: Text(
                                          'Massages',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              final url = 'tel:+447552834179';
                              await launch(url);
                              // const phoneNumber =
                              //     '+447552834179'; // Change this to your desired phone number
                              // final url = 'tel:$phoneNumber';
                              // if (await canLaunch(url)) {
                              //   await launch(url);
                              // } else {
                              //   print('could not launch $url');
                              //   // throw 'Could not launch $url';
                              // }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 8, 0, 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 0, 0),
                                      child: Icon(
                                        Icons.call_outlined,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12, 0, 0, 0),
                                        child: Text(
                                          'Support',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1.0,
                          color: Color(0xFFE0E3E7),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              5.0, 5.0, 5.0, 80.0),
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
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.login_rounded,
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        size: 20.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          'Log out',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_outlined,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Stack(
                      children: [
                        Obx(() => buildMap())
                        // isLoading
                        //     ? Center(
                        //         child: CircularProgressIndicator(
                        //           valueColor: AlwaysStoppedAnimation<Color>(
                        //             FlutterFlowTheme.of(context).primary,
                        //           ),
                        //         ),
                        //       )
                        //     :
                        // currentLocation != null
                        //     ?
                        //     : Center(
                        //         child: CircularProgressIndicator(
                        //           valueColor: AlwaysStoppedAnimation<Color>(
                        //             FlutterFlowTheme.of(context).primary,
                        //           ),
                        //         ),
                        //       ),
                        ,
                        Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Obx(
                              () => Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              FlutterFlowTheme.of(context)
                                                  .primary,
                                              FlutterFlowTheme.of(context)
                                                  .secondary
                                            ],
                                            stops: [0, 1],
                                            begin: const AlignmentDirectional(
                                                1, -0.98),
                                            end: const AlignmentDirectional(
                                                -1, 0.98),
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(0),
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${myController.initialLabelIndex.value != 1 ? 'Offline' : 'Online'}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 18,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 10, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  scaffoldKey.currentState!
                                                      .openDrawer();
                                                },
                                                child: Material(
                                                  color: Colors.transparent,
                                                  elevation: 4,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: Container(
                                                    width: 45,
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .secondaryBackground,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      border: Border.all(
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .secondaryBackground,
                                                      ),
                                                    ),
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0, 0),
                                                    child: FaIcon(
                                                      FontAwesomeIcons.listUl,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                              child: AnimatedGradientBorder(
                                                  borderSize: 4,
                                                  glowSize: 0,
                                                  gradientColors: [
                                                    Colors.transparent,
                                                    Colors.transparent,
                                                    Colors.transparent,
                                                    if (myController
                                                            .initialLabelIndex
                                                            .value ==
                                                        1)
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary
                                                    else
                                                      Colors.transparent,
                                                  ],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(999)),
                                                  child: SizedBox(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    999)),
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondaryContainer,
                                                      ),
                                                      child: ToggleSwitch(
                                                        minWidth:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.30,
                                                        minHeight: 50,
                                                        initialLabelIndex:
                                                            myController
                                                                .initialLabelIndex
                                                                .value,
                                                        cornerRadius: 30.0,
                                                        activeFgColor:
                                                            Colors.white,
                                                        inactiveBgColor:
                                                            Colors.grey,
                                                        inactiveFgColor:
                                                            Colors.white,
                                                        totalSwitches: 2,
                                                        labels: [
                                                          'Offline',
                                                          'Online'
                                                        ],
                                                        icons: [
                                                          FontAwesomeIcons
                                                              .powerOff,
                                                          FontAwesomeIcons
                                                              .dotCircle,
                                                        ],
                                                        activeBgColors: [
                                                          [
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                          ],
                                                          [
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ]
                                                        ],
                                                        onToggle:
                                                            (index) async {
                                                          setState(() {});

                                                          final service =
                                                              FlutterBackgroundService();
                                                          fetchJobStatus();
                                                          if (rootedCheck &&
                                                              jailbreak &&
                                                              devMode) {
                                                            showToast(
                                                                "Device is rooted");
                                                            showToast(
                                                                "Device is jailbreak");
                                                          } else {
                                                            if (status) {
                                                              await saveSwitchStatus(
                                                                  index!);
                                                              myController
                                                                  .initialLabelIndex
                                                                  .value = index;
                                                              if (!jobStatus) {
                                                                if (index ==
                                                                    1) {
                                                                  startRingtoneAndVibrateLoop();
                                                                  sendOnlineStatus();
                                                                  sendLocationDataPeriodically();
                                                                  service
                                                                      .startService();
                                                                  await Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              5));
                                                                } else if (index ==
                                                                    0) {
                                                                  startRingtoneAndVibrateLoop();
                                                                  sendOnlineStatus();
                                                                  stopLocationDataPeriodicUpdates();
                                                                  service.invoke(
                                                                      "stopService");
                                                                  await Future.delayed(
                                                                      const Duration(
                                                                          seconds:
                                                                              5));
                                                                } else {}
                                                              } else {
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg:
                                                                      "You Can't Go Offline.  You Go offline to Contact Support.",
                                                                );
                                                              }
                                                              if (mounted) {
                                                                setState(() {
                                                                  // Update your state here
                                                                });
                                                              }
                                                            } else {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Upload Vehicle Documents Required'),
                                                                    content:
                                                                        const Text(
                                                                            'You are not Online. Uploading vehicle documents is required before switching to the Online state.'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'Cancel'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'Upload'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          context
                                                                              .pushNamed('AllDocoments');
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                              print(
                                                                  'Switched else to: $index');
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 20, 20),
                                    child: Align(
                                      alignment:
                                          const AlignmentDirectional(1, 1),
                                      child: InkWell(
                                        onTap: _animateToCurrentLocation,
                                        child: Icon(
                                          Icons.my_location,
                                          color: Theme.of(context).primaryColor,
                                          size: 27,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: TextButton(
                                  //       onPressed: () {
                                  //         myController.visiblecontainer.value =
                                  //             false;
                                  //         print(
                                  //             myController.visiblecontainer.value);
                                  //       },
                                  //       child: Text('st')),
                                  // )
                                ],
                              ),
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 300.0, right: 20, left: 20),
                            child: Obx(
                              () => myController.isJobDetailDone.value
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      height: 80,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 30,
                                              child:
                                                  const CircularProgressIndicator(
                                                color: Colors.green,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            const Text(
                                              'Please wait...',
                                              style: TextStyle(
                                                  fontFamily: 'Satoshi',
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                            )),
                      ],
                    ),
                  ),
                ),
                Obx(() => Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          myController.visiblecontainer.value == true
                              ? Container(
                                  // height: 580,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SingleChildScrollView(
                                        child: Container(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '£${myController.listFromPusher[0].journeyFare}',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .displaySmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize: 32,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                          ),
                                                          Text(
                                                            '(Estimated maximum value)',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Montserrat',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                        ].divide(const SizedBox(
                                                            height: 4)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons.business,
                                                        color:
                                                            Color(0xFF5B68F5),
                                                        size: 45,
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Opacity(
                                                            opacity: 0.5,
                                                            child: SizedBox(
                                                              height: 50,
                                                              child:
                                                                  VerticalDivider(
                                                                thickness: 2,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    10,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  'Time',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          15,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    'Date',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                    80,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Text(
                                                                  '${myController.listFromPusher[0]!.pickTime}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Roboto',
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          0,
                                                                          15,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    '${myController.listFromPusher[0]!.pickDate}',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .override(
                                                                          fontFamily:
                                                                              'Roboto',
                                                                          fontSize:
                                                                              16,
                                                                        ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ].divide(const SizedBox(
                                                        width: 16)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xFF5B68F5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50),
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                border:
                                                                    Border.all(
                                                                  color: const Color(
                                                                      0xFF5B68F5),
                                                                  width: 2,
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  'A',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Open Sans',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryBackground,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 25,
                                                            ),
                                                            child: Stack(
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      Container(
                                                                    width: 4,
                                                                    height: 40,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Color(
                                                                          0xFFE5E7EB),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    top: 10,
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    width: 30,
                                                                    height: 30,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0.0),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: 30,
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFF5B68F5),
                                                              shape: BoxShape
                                                                  .circle,
                                                              border:
                                                                  Border.all(
                                                                color: const Color(
                                                                    0xFF5B68F5),
                                                                width: 2,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'B',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Open Sans',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          width:
                                                              20), // Added SizedBox for spacing
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10,
                                                                        // top: 10,
                                                                        bottom:
                                                                            20),
                                                                    child: Text(
                                                                      '${myController.listFromPusher![0].pickup}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                15,
                                                                          ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          3,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          10),
                                                              child: Row(
                                                                children: [
                                                                  const FaIcon(
                                                                    FontAwesomeIcons
                                                                        .bong,
                                                                    color: Color(
                                                                        0xFF5B68F5),
                                                                    size: 18,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            8),
                                                                    child: Text(
                                                                      '${(double.parse(myController.listFromPusher[0]!.journeyDistance) * 0.621371).toStringAsFixed(2)} Miles ${myController.listFromPusher[0]!.journeyType}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Open Sans',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Flexible(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10,
                                                                        bottom:
                                                                            10),
                                                                    child: Text(
                                                                      '${myController.listFromPusher![0].destination}',
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                15,
                                                                          ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          3,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    FFButtonWidget(
                                                      onPressed: () async {
                                                        SharedPreferences sp =
                                                            await SharedPreferences
                                                                .getInstance();

                                                        // print(
                                                        //     'st ${initialLabelIndex == 1}');
                                                        if (myController
                                                                .initialLabelIndex
                                                                .value ==
                                                            1) {
                                                          await sp.setBool(
                                                              'show', false);
                                                          await sp.setInt(
                                                              'isRideStart', 1);
                                                          await showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            enableDrag: false,
                                                            context: context,
                                                            builder: (context) {
                                                              return Padding(
                                                                padding: MediaQuery
                                                                    .viewInsetsOf(
                                                                        context),
                                                                child:
                                                                    NotesWidget(
                                                                  dId:
                                                                      '${myController.listFromPusher[0].dId}',
                                                                  jobId:
                                                                      '${myController.listFromPusher[0].jobId}',
                                                                  pickTime:
                                                                      '${myController.listFromPusher[0].pickTime}',
                                                                  pickDate:
                                                                      '${myController.listFromPusher[0].pickDate}',
                                                                  passenger:
                                                                      '${myController.listFromPusher[0].passenger}',
                                                                  pickup:
                                                                      '${myController.listFromPusher[0].pickup}',
                                                                  dropoff:
                                                                      '${myController.listFromPusher[0].destination}',
                                                                  luggage:
                                                                      '${myController.listFromPusher[0].luggage}',
                                                                  cName:
                                                                      '${myController.listFromPusher[0].cName}',
                                                                  cnumber:
                                                                      '${myController.listFromPusher[0].cPhone}',
                                                                  cemail:
                                                                      '${myController.listFromPusher[0].cEmail}',
                                                                  note:
                                                                      '${myController.listFromPusher[0].note}',
                                                                  fare:
                                                                      '${myController.listFromPusher[0].journeyFare}',
                                                                  distance:
                                                                      '${myController.listFromPusher[0].journeyDistance}',
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              safeSetState(
                                                                  () {}));
                                                        } else {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                "Please be online before starting the ride.",
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0,
                                                          );
                                                        }
                                                      },
                                                      text: 'Start Now',
                                                      icon: const Icon(
                                                        Icons.east,
                                                        size: 15,
                                                      ),
                                                      options: FFButtonOptions(
                                                        height: 40,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                24, 0, 24, 0),
                                                        iconPadding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                0, 0, 0, 0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        textStyle:
                                                            FlutterFlowTheme
                                                                    .of(context)
                                                                .titleSmall
                                                                .override(
                                                                    fontFamily:
                                                                        'Open Sans',
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
                                                        elevation: 3,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ].divide(
                                                  const SizedBox(height: 4)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // TextButton(
                                      //     onPressed: () {
                                      //       myController.isJobDetailDone.value =
                                      //           false;
                                      //     },
                                      //     child: Text('data'))
                                    ],
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    )),
                // TextButton(
                //     onPressed: () {
                //       if (myController.listFromPusher.isNotEmpty) {
                //         getCoordinatesFromAddress(
                //             myController.listFromPusher[0].pickup);
                //       }
                //     },
                //     child: Text('data'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMap() {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(
          myController.currentLocation?.latitude ?? 0.0,
          myController.currentLocation?.longitude ?? 0.0,
        ),
        zoom: 12.0,
      ),
      markers: {
        Marker(
            markerId: const MarkerId('Source'),
            position: LatLng(accpetingOrderViewModel.latitude.value,
                accpetingOrderViewModel.longitude.value),
            icon: accpetingOrderViewModel.sourceicon.value),
        Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(myController.convertedLat.value,
                myController.convertedLng.value),
            icon: accpetingOrderViewModel.destinationicon.value),
      },
      polylines: accpetingOrderViewModel.polylines.value,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      compassEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      scrollGesturesEnabled: true,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
    );
  }

  // Future _getPolyline(double destinationLat, double desLng) async {
  //   print('tapped');
  //   var origin =
  //       '${myController.currentLocation?.latitude},${myController.currentLocation?.longitude}'; // Replace with your source coordinates
  //   var destination =
  //       // '31.414050,73.0613070'; // Replace with your destination coordinates // Replace with your destination coordinates
  //       '${myController.currentLocation?.latitude},${desLng}';
  //   // var destination =
  //   // // '31.414050,73.0613070'; // Replace with your destination coordinates // Replace with your destination coordinates
  //   // '${31.3637197},${73.0553336}';
  //   try {
  //     final response = await http.post(Uri.parse(// can be get and post request
  //         // 'https://maps.googleapis.com/maps/api/directions/json?origin=31.4064054,73.0413076&destination=31.6404050,73.2413070&key=AIzaSyBBSmpcyEaIojvZznYVNpCU0Htvdabe__Y'));
  //         'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey'));
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       if (data.containsKey('routes') && data['routes'].isNotEmpty) {
  //         final route = data['routes'][0];
  //         if (route.containsKey('legs') && route['legs'].isNotEmpty) {
  //           final leg = route['legs'][0];

  //           if (leg.containsKey('distance')) {
  //             // distance.value = leg['distance']['text'];
  //             // time.value = leg['duration']['text'];

  //             final points = route['overview_polyline']['points'];
  //             print('the point of poly line $points');
  //             // Decode polyline points and add them to the map
  //             //         final json = jsonDecode(response.body);
  //             // final String encodedPolyline =
  //             //     json['routes'][0]['overview_polyline']['points'];
  //             // final List<LatLng> points = decodePolyline(encodedPolyline);
  //             decodedPoints = PolylinePoints()
  //                 .decodePolyline(points)
  //                 .map((point) => LatLng(point.latitude, point.longitude))
  //                 .toList();

  //             if (mounted) {
  //               setState(() {
  //                 myController.polylines.add(
  //                   Polyline(
  //                     polylineId: PolylineId('poly'),
  //                     visible: true,
  //                     points: decodedPoints,
  //                     width: 4,
  //                     color: Colors.blue,
  //                   ),
  //                 );
  //               });
  //             }
  //           }
  //         }
  //       }
  //     } else {
  //       print('the point of poly line ');
  //     }
  //   } catch (e) {
  //     print('the point of poly line $e');
  //   }
  // }

  // Future getCoordinatesFromAddress(String address) async {
  //   try {
  //     List<Location> locations = await locationFromAddress(address);
  //     if (locations.isNotEmpty) {
  //       myController.convertedLat.value = locations.first.latitude;
  //       myController.convertedLng.value = locations.first.longitude;
  //       print(
  //           'convert Latitude: ${myController.convertedLat.value}, convert longitude: ${myController.convertedLng.value}');
  //       _getPolyline(locations.first.latitude, locations.first.longitude);
  //     }
  //   } catch (e) {
  //     print('Error occurred: $e');
  //   }
  // }

  // final apiKey = 'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA';

  // List<LatLng> decodedPoints = <LatLng>[];

  // List<LatLng> decodePolyline(String encoded) {
  //   List<LatLng> polyline = [];
  //   int index = 0, len = encoded.length;
  //   int lat = 0, lng = 0;

  //   while (index < len) {
  //     int b, shift = 0, result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1F) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
  //     lat += dlat;

  //     shift = 0;
  //     result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1F) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
  //     lng += dlng;

  //     polyline.add(LatLng(lat / 1E5, lng / 1E5));
  //   }

  //   return polyline;
  // }
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     jobDetailsFuture();
  //     myController.jobDetails();
  //   }
  // }

  LatLng _destination = LatLng(34.0522, -118.2437);
  void fetchJobStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? d_id = prefs.getString('d_id');

    if (d_id != null) {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://www.minicaboffice.com/api/driver/accepted-jobs-today.php'));
      request.fields.addAll({'d_id': d_id});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        var responseData = jsonDecode(responseString);

        jobStatus = responseData['status'];
        print('Status: $status');
        if (status) {
          print('Job List Fetch Successfully');
        } else {
          print('Failed to fetch job list');
        }
      } else {
        print('Error accpet: ${response.reasonPhrase}');
      }
    } else {
      print('d_id not found in preferences');
    }
  }

  // Future<void> fetchDriverStatus() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String? dId = prefs.getString('d_id');
  //
  //   final Uri uri =
  //       Uri.parse('https://www.minicaboffice.com/api/driver/fetch-status.php');
  //   final http.MultipartRequest request = http.MultipartRequest('POST', uri);
  //   request.fields['d_id'] = dId ?? '';
  //   final http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     final String responseBody = await response.stream.bytesToString();
  //     final Map<String, dynamic> jsonResponse = json.decode(responseBody);
  //
  //     if (jsonResponse['status'] == true) {
  //       setState(() async {
  //         driverStatus = jsonResponse['data'][0]['status'];
  //         print(driverStatus);
  //       });
  //       print(
  //           'Driver status: $driverStatus'); // This will print: Driver status: Offline
  //     } else {
  //       print('Failed to fetch status');
  //     }
  //   } else {
  //     print('Request failed with status: ${response.statusCode}');
  //     print(response.reasonPhrase);
  //   }
  // }
  // final JobController myController = Get.put(JobController());
  // Future<Job> myController.jobDetails() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? dId = prefs.getString('d_id');
  //   print(dId);
  //   final response = await http.post(
  //     Uri.parse(
  //         'https://www.minicaboffice.com/api/driver/accepted-jobs-today.php'),
  //     body: {
  //       'd_id': dId.toString(),
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final parsedResponse = json.decode(response.body);
  //     var data = parsedResponse['book_id'].toString();
  //     prefs.setString('bookingid', data);
  //     print('bookingid   $data');

  //     if (parsedResponse['status'] == true) {
  //       isPeriodicVisible = true;
  //       if (parsedResponse['data'] is List &&
  //           parsedResponse['data'].isNotEmpty) {
  //         return Job.fromJson(parsedResponse['data'].first);
  //       } else {
  //         isPeriodicVisible = false;
  //         throw Exception('No jobs found');
  //       }
  //     } else {
  //       isPeriodicVisible = false;

  //       throw Exception('No jobs found');
  //     }
  //   } else {
  //     throw Exception('Failed to load jobs');
  //   }
  // }

  void _animateToCurrentLocation() {
    if (Position != null) {
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(myController.currentLocation!.latitude,
              myController.currentLocation!.longitude),
          zoom: 12.0,
        ),
      ));
    }
  }

  Future<void> androidRootChecker() async {
    try {
      rootedCheck = (await RootCheckerPlus.isRootChecker())!;
    } on PlatformException {
      rootedCheck = false;
    }
    if (!mounted) return;
    setState(() {
      rootedCheck = rootedCheck;
    });
  }

  Future<void> developerMode() async {
    try {
      devMode = (await RootCheckerPlus.isDeveloperMode())!;
    } on PlatformException {
      devMode = false;
    }
    if (!mounted) return;
    setState(() {
      devMode = devMode;
    });
  }

  Future<void> iosJailbreak() async {
    try {
      jailbreak = (await RootCheckerPlus.isJailbreak())!;
    } on PlatformException {
      jailbreak = false;
    }
    if (!mounted) return;
    setState(() {
      jailbreak = jailbreak;
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future jobDetailsFuture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');

    try {
      final response = await http.post(
        Uri.parse('https://minicaboffice.com/api/driver/upcoming-jobs.php'),
        body: {
          'd_id': dId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);

        print("json data api call${jsonMap['data']}");
        bool status = jsonMap['status'];

        if (status == true) {
          periodicStatus = true;

          listFromPusher.clear();

          print("json data api call${jsonMap['data']}");
          listFromPusher.add(Job(
              jobId: jsonMap['data'][0]['job_id'].toString() ?? "",
              bookId: jsonMap['data'][0]['book_id'].toString() ?? '',
              cId: jsonMap['data'][0]['00000003'].toString() ?? "",
              dId: jsonMap['data'][0]['00000000002'].toString() ?? '',
              jobNote: jsonMap['data'][0]['job_note'].toString() ?? '',
              journeyFare: jsonMap['data'][0]['journey_fare'].toString() ?? '',
              bookingFee: jsonMap['data'][0]['booking_fee'].toString() ?? "",
              carParking: jsonMap['data'][0]['car_parking'].toString() ?? '',
              waiting: jsonMap['data'][0]['waiting'].toString() ?? '',
              tolls: jsonMap['data'][0]['tolls'].toString() ?? '',
              extra: jsonMap['data'][0]['extra'].toString() ?? '',
              jobStatus: jsonMap['data'][0]['job_status'].toString() ?? '',
              dateJobAdd: jsonMap['data'][0]['date_job_add'].toString() ?? '',
              cName: jsonMap['data'][0]['c_name'].toString() ?? '',
              cEmail: jsonMap['data'][0]['c_email'].toString() ?? '',
              cPhone: jsonMap['data'][0]['c_phone'].toString() ?? '',
              cAddress: jsonMap['data'][0]['c_address'].toString() ?? '',
              dName: jsonMap['data'][0]['d_name'].toString() ?? '',
              dEmail: jsonMap['data'][0]['d_email'].toString() ?? '',
              dPhone: jsonMap['data'][0]['d_phone'].toString() ?? '',
              bTypeId: jsonMap['data'][0]['b_type_id'].toString() ?? '',
              pickup: jsonMap['data'][0]['pickup'].toString() ?? '',
              destination: jsonMap['data'][0]['destination'].toString() ?? '',
              address: jsonMap['data'][0]['address'].toString() ?? '',
              postalCode: jsonMap['data'][0]['postal_code'].toString() ?? '',
              passenger: jsonMap['data'][0]['passenger'].toString() ?? '',
              pickDate: jsonMap['data'][0]['pick_date'].toString() ?? '',
              pickTime: jsonMap['data'][0]['pick_time'].toString() ?? '',
              journeyType: jsonMap['data'][0]['journey_type'].toString() ?? '',
              vId: jsonMap['data'][0]['v_id'].toString() ?? '',
              luggage: jsonMap['data'][0]['luggage'].toString() ?? '',
              childSeat: jsonMap['data'][0]['child_seat'].toString() ?? '',
              flightNumber:
                  jsonMap['data'][0]['flight_number'].toString() ?? '',
              delayTime: jsonMap['data'][0]['delay_time'].toString() ?? '',
              note: jsonMap['data'][0]['note'].toString() ?? '',
              journeyDistance:
                  jsonMap['data'][0]['journey_distance'].toString() ?? '',
              bookingStatus:
                  jsonMap['data'][0]['booking_status'].toString() ?? '',
              bidStatus: jsonMap['data'][0]['bid_status'].toString() ?? '',
              bidNote: jsonMap['data'][0]['bid_note'].toString() ?? '',
              bookAddDate: jsonMap['data'][0]['bid_status'].toString() ?? ''));

          showAlert();
        } else {
          periodicStatus = false;
        }

        // // Process and return jobs if available
        // if (parsedResponse['data'] is List &&
        //     parsedResponse['data'].isNotEmpty) {
        //   List<Job> jobs = [];
        //   for (var jobJson in parsedResponse['data']) {
        //     jobs.add(Job.fromJson(jobJson));
        //   }
        //   return jobs;
        // } else {
        //   throw Exception('No jobs found');
        // }
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      // Handle exceptions here
      print('Error in jobDetailsFuture: $e');
      // Re-throw the exception to propagate it further if needed
    }
  }

  void startRingtoneAndVibrateLoop() {
    FlutterRingtonePlayer().playRingtone();
    // FlutterRingtonePlayer.play(
    //   android: AndroidSounds.notification,
    //   ios: IosSounds.glass,
    //   looping: true,
    //   volume: 1.0,
    // );
    Vibration.vibrate(duration: 1000);

    Timer(const Duration(seconds: 1), () {
      FlutterRingtonePlayer().stop();
      Vibration.cancel();
    });
  }

  Future<void> DueBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = await prefs.getString('d_id');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://www.minicaboffice.com/api/driver/total-due-balance.php'),
    );
    request.fields.addAll({
      'd_id': dId.toString(),
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      print(jsonResponse);
      String totalCommission = jsonResponse['data']?['total_commission'] ?? '';

      print(totalCommission);
      setState(() {
        dueBalance = totalCommission;
        print('Total commission: $dueBalance');
      });

      print('Total commission: $totalCommission');
    } else {
      print('Failed to fetch data: ${response.reasonPhrase}');
    }
  }

  Future<void> checkVehicleDocuments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://www.minicaboffice.com/api/driver/check-vehicle-documents.php'));
    request.fields.addAll({'d_id': dId.toString(), 'status': 'online'});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData =
          jsonDecode(await response.stream.bytesToString());
      if (responseData['status'] == true) {
        status = true;
        print('Success: ${responseData['message']}');
        print('Success: ${responseData['status']}');
      } else {
        print('Error: ${responseData['message']}');
        print('Success: ${responseData['status']}');
        status = false;
      }
    } else {
      print('Error: ${response.reasonPhrase}');
      status = false;
    }
  }

  Future<void> saveIsLoginInPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
    print('Saved isLogin: ${prefs.getBool('isLogin')}');
  }

  _loadSwitchStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedIndex = prefs.getInt('switchValue') ?? 0;
    setState(() {
      myController.initialLabelIndex.value = savedIndex;
    });
    print(myController.initialLabelIndex.value);
  }

  saveSwitchStatus(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('switchValue', index);
  }

  Future<void> sendOnlineStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      int index = prefs.getInt('switchValue') ?? 0; // Retrieve switch value

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://minicaboffice.com/api/driver/online-status.php'),
      );
      request.fields.addAll({
        'd_id': dId.toString(),
        'status': index == 1 ? 'Online' : 'Offline',
      });
      print(request.fields);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error in online: $e');
    }
  }

  Future<void> sendLocationData(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String driverId = prefs.getString('d_id') ?? '';
    if (latitude != null && longitude != null) {
      var request = http.MultipartRequest('POST',
          Uri.parse('https://minicaboffice.com/api/driver/real-location.php'));
      request.fields.addAll({
        'd_id': driverId.toString(),
        'latitude': latitude.toString(),
        'longitude': longitude.toString()
      });

      request.fields.forEach((key, value) {
        print('$key: $value');
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
        print('issue in locaiton api');
      }
    } else {
      print("Some fields are empty or invalid.");
    }
  }

  void sendLocationDataPeriodically() {
    locationTimer =
        Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        double latitude = position.latitude;
        double longitude = position.longitude;

        await sendLocationData(latitude, longitude);
        print('Latitude: $latitude, Longitude: $longitude');
      } catch (e) {
        print('Errors in latlng: $e');
      }
    });
  }

  void stopLocationDataPeriodicUpdates() {
    locationTimer!.cancel();
    locationTimer = null;
  }

  Future<void> _getLocation() async {
    try {
      myController.currentLocation = await Geolocator.getCurrentPosition();

      if (myController.currentLocation != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(
              myController.currentLocation!.latitude,
              myController.currentLocation!.longitude,
            ),
          ),
        );
        print(
            " the lat ${myController.currentLocation!.latitude} and long ${myController.currentLocation!.longitude}");
      }
      print(
          " the lats ${myController.currentLocation!.latitude} and longs ${myController.currentLocation!.longitude}");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error getting location: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<List<Driver>> myProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');

    final uri =
        Uri.parse('https://minicaboffice.com/api/driver/view-profile.php');
    final response = await http.post(uri, body: {'d_id': dId.toString()});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'] ?? [];
      print('profile api treeeeeeeeeeeeeee');
      if (data is List) {
        List<Driver> profileData =
            data.map((item) => Driver.fromJson(item)).cast<Driver>().toList();
        return profileData;
      } else {
        print('Invalid data format received.');
        return [];
      }
    } else {
      print('Error profile: ${response.reasonPhrase}');
      return [];
    }
  }
}
