import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:mini_cab/Data/links.dart';
import 'package:mini_cab/components/customer_details_widget.dart';
import 'package:mini_cab/home/home_view_controller.dart';
import 'package:mini_cab/home/timer_class.dart';
import 'package:mini_cab/on_way/dummy_goglemap.dart';
import 'package:mini_cab/on_way/job_details_sheet.dart';
import 'package:mini_cab/pob/pob_widget.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/clientnotes_widget.dart';
import '../components/dropoff_widget.dart';
import '../components/waydetails_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_timer.dart';
import '../home/home_widget.dart';
import '../main.dart';
import 'dart:ui' as ui;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'on_way_model.dart';
export 'on_way_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'dart:convert';
import 'package:google_directions_api/google_directions_api.dart';

class OnWayWidget extends StatefulWidget {
  OnWayWidget({
    Key? key,
    // this.did,
    // this.jobid = '',
    // this.pickup = '',
    // this.dropoff = '',
    // this.cName = '',
    // this.fare = '',
    // this.distance = '',
    // this.note = '',
    // this.pickTime = '',
    // this.pickDate = '',
    // this.passenger = '',
    // this.luggage = '',
    // this.cnumber = '',
    // this.cemail = '',
  }) : super(key: key);

  @override
  _OnWayWidgetState createState() => _OnWayWidgetState();
}

class _OnWayWidgetState extends State<OnWayWidget> {
  late OnWayModel _model;
  double pickupLat = 0.0;
  double pickupLng = 0.0;
  double currentLatitude = 0;
  double currentLongitude = 0;

  String? did;
  String? jobid;
  String? pickup;
  String? dropoff;
  String? cName;
  String? fare;
  String? distance;
  String? note;
  String? pickTime;
  String? pickDate;
  String? passenger;
  String? luggage;
  String? cnumber;
  String? cemail;
  late PolylinePoints polylinePoints;
  // Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  // Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  Set<Marker> markers = {};
  List<LatLng> _polylineCoordinates = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late GoogleMapController _controller;
  late CameraPosition _kGoogle;
  late Timer _locationTimer;
  // final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  // Position? _currentPosition;
  LatLng _currentPosition = LatLng(37.7749, -122.4194);
  bool isLoading = false;
  bool isWaiting = false;
  bool isRideStarted = false;
  Timer? Apitimer;
  Timer? _timer;
  int _start = 0;

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String jobId = '';
  // statuscheck(String jobid) async {
  //   final response = await http.post(Uri.parse(
  //       'https://www.minicaboffice.com/api/driver/check-job-status.php'));
  //   print('statusresponse  ${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body.toString());
  //     print('joooooobiddddd ${widget.jobid}');
  //     if (data['status'] == false) {
  //       Fluttertoast.showToast(
  //         msg: data['message'],
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //       );
  //       Navigator.push(
  //           context as BuildContext,
  //           MaterialPageRoute(
  //               builder: (context) => NavBarPage(
  //                 page: HomeWidget(),
  //               )));
  //     }
  //     Apitimer?.cancel();
  //
  //
  //
  //   }
  // }

  final JobController myController = Get.put(JobController());
  TimerClass timerclass = TimerClass();
  getlocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        // _currentPosition = position;
        // currentLatitude = position.latitude;
        // currentLongitude = position.longitude;
      });
    } catch (e) {}
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadSavedTimer();
    getlocation();
    // _trackLocationChanges();

    // Load the saved timer state
    loadata().then((s) {});
    startJobStatusTimer();
    pushercallbg();
    recive_jobidid;
    wayToPickup();
    jobStatus();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _setupMarkersAndPolylines();
    _model = createModel(context as BuildContext, () => OnWayModel());
  }

  void startJobStatusTimer() {
    // Ensure the timer is only started once

    myController.timer = Timer.periodic(Duration(seconds: 3), (timer) {
      jobStatus();
    });
    // if (_timer == null || !_timer!.isActive) {

    // }
  }

  double latitudeforGooglmap = 0;
  double lngforGooglmap = 0;
  Future<void> getLatLngFromAddress(String address) async {
    try {
      // Geocode the address to get a list of locations
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        // The first location in the list will be the best match
        latitudeforGooglmap = locations[0].latitude;
        lngforGooglmap = locations[0].longitude;
        setState(() {});
      } else {}
    } catch (e) {}
  }

  Timer? locationTrackingTimer;
  Future startTrackingforpickUp(double pickLat, double pickLng) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    locationTrackingTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        pickLat,
        pickLng,
      );

      if (distance < 4000) {
        // You can set the threshold to any value (e.g., 50 meters)
        // User has reached the destination
        print("Ride complete!");
        //  await     _showOverlay();
        await showNotification(
            'Customer Location', 'You have reached on customer location.');
        locationTrackingTimer!.cancel(); // Stop the tracking
      } else {
        print("no reached the location");
      }
    });
  }

  Future startTrackingfordropOf(double pickLat, double pickLng) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    locationTrackingTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        pickLat,
        pickLng,
      );

      if (distance < 4000) {
        // You can set the threshold to any value (e.g., 50 meters)
        // User has reached the destination
        print("Ride complete!");
        //  await     _showOverlay();
        await showNotification(
            'Ride Complete', 'You have reached on destination');

        locationTrackingTimer!.cancel(); // Stop the tracking

        print('if condtion isridestarted is $isRideStarted');

        await sp.remove('isWaitingTrue');
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://www.minicaboffice.com/api/driver/calculate-waiting-time.php'));
        request.fields.addAll({
          'd_id': '${did}',
          'job_id': '${jobid}',
          'waiting_time': _timerDisplayValue
          // 'waiting_time': _model.timerValue.toString()
        });

        try {
          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {
          } else {}
        } catch (e) {}
        _stopTimer();
        _model.timerController.onStopTimer();
        await sp.setString('timerValue', _formatTime(_elapsedSeconds));
        await sp.setInt('isRideStart', 2);
        Timer(Duration(seconds: 2), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PobWidget()));
        });

        isRideStarted = false;
        isWaiting = false;
      } else {
        print("no reached the location");
      }
    });
  }

  showNotification(String title, String subtitle) async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      subtitle,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future loadata() async {
    // myController.jobDetails();
    SharedPreferences sp = await SharedPreferences.getInstance();
    isWaiting = sp.getBool('isWaitingTrue') ?? false;
    isRideStarted = sp.getBool('arrivalDone') ?? false;
    print('user done arrival swipe');
    setState(() {});
    // widget.did = sp.getString('did');
    // widget.jobid = sp.getString('jobId');
    // widget.pickup = sp.getString('pickup');
    // widget.dropoff = sp.getString('destination');
    // widget.cName = sp.getString('cName');
    // widget.fare = sp.getString('journeyFare');
    // widget.distance = sp.getString('journeyDistance');
    // widget.note = sp.getString('note');
    // widget.pickTime = sp.getString('pickTime');
    // widget.pickDate = sp.getString('pickDate');
    // widget.passenger = sp.getString('passenger');
    // widget.luggage = sp.getString('laggage');
    // widget.cnumber = sp.getString('cPhone');
    // widget.cemail = sp.getString('cEmail');
    await myController.acceptedJobDetails().then((value) {
      if (value != null) {
        did = value.dId;
        jobid = value.jobId;
        pickup = value.pickup;
        dropoff = value.destination;
        cName = value.cName;
        fare = value.journeyFare;
        distance = value.journeyDistance;
        note = value.note;
        pickTime = value.pickTime;
        pickDate = value.pickDate;
        passenger = value.passenger;
        luggage = value.luggage;
        cnumber = value.cPhone;
        cemail = value.cEmail;
        getCoordinatesFromAddress(pickup!);
      } else {
        // Handle the null case, e.g., show an error message, redirect, etc.
      }
    });
  }

  recive_jobidid() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance() as SharedPreferences;

    jobId = jobid.toString();
    // Apitimer = Timer.periodic(Duration(seconds: 3), (timer) {
    //   statuscheck(jobId);
    //
    // });
    setState(() {});
  }

  String job = '';

  // @override
  // void dispose() {
  //   Apitimer?.cancel();
  //   _model.dispose();

  //   super.dispose();
  // }

  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';
  void checkDriverProximity(double currentLatitude, double currentLongitude,
      double pickupLatitude, double pickupLongitude,
      {double precision = 0.00030}) {
    if (isWaiting &&
        ((currentLatitude - pickupLatitude).abs() < precision) &&
        ((currentLongitude - pickupLongitude).abs() < precision)) {
      isRideStarted = true;
      isWaiting = false;
      _model.timerController.onStartTimer();
      _startTimer();
    } else {
      isRideStarted = true;
      isWaiting = false;
      _model.timerController.onStartTimer();
      _startTimer();
      Fluttertoast.showToast(
        msg: "You are not near the customer location",
      );
    }
  }

  pushercallbg() async {
    var pusher = PusherClient(
      '28691ac9c0c5ac41b64a',
      PusherOptions(
        host: 'https://www.minicaboffice.com/api/driver/check-job-status.php',
        cluster: 'ap2',
        encrypted: false,
      ),
    );
    pusher.connect();

    var channel = pusher.subscribe('jobs-channel');

    // Listen for new events
    channel.bind('job-withdrawn', (event) {
      Map<String, dynamic> jsonMap = json.decode(event!.data!);
      jobStatus();

      // });
    });
  }

  // late GoogleMapController _mapController;
  Future<void> jobStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    String? jobId = prefs.getString('jobId');
    final response = await http.post(
      Uri.parse(
          'https://www.minicaboffice.com/api/driver/check-job-status.php'),
      body: {'d_id': dId.toString(), 'job_id': jobId.toString()},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == false) {
        prefs.remove("isRideStart");
        setState(() {});
        myController.visiblecontainer.value = false;

        context.pushNamed('Home');
      } else {
        // Handle the job details as normal
      }
    } else {
      // Handle the error
    }
  }

  int? _timerMilliseconds;
  FlutterFlowTimerController _timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countUp));
  String _timerDisplayValue = "00:00:00";

  Future<void> _loadSavedTimer() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // await _clearSavedTimerState();
    setState(() {
      _elapsedSeconds = sp.getInt('savedTimerMilliseconds') ?? 0;
      _timerMilliseconds = sp.getInt('savedTimerMilliseconds') ?? 0;
      _timerDisplayValue = StopWatchTimer.getDisplayTime(_timerMilliseconds!,
          milliSecond: false);
      print('the saved time $_timerDisplayValue');
      print('the saved miliSecondtime $_timerMilliseconds');
    });
    if (_elapsedSeconds > 0) {
      _startTimer();
      _timerController.onStartTimer();
    }
  }

  Future<void> _saveTimerState(int milliseconds) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt('savedTimerMilliseconds', milliseconds);
  }

  Future<void> _clearSavedTimerState() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove('savedTimerMilliseconds');
  }

  Timer? _timercounter;
  int _elapsedSeconds = 0;

  String _formatTime(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final secs = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  void _startTimer() {
    if (_timercounter != null) {
      _timercounter!.cancel();
    }
    _timercounter = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
        _saveTimerState(_elapsedSeconds);
      });
    });
  }

  void _stopTimer() async {
    await _clearSavedTimerState();
    _timercounter?.cancel();
    _timercounter = null;
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

    // loadata();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          // appBar: AppBar(
          //   backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          //   automaticallyImplyLeading: false,
          //   title: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => TurnByTurnNavigationScreen()));
          //     },
          //     child: Text(
          //       'ON WAYs',
          //       style: FlutterFlowTheme.of(context).headlineMedium.override(
          //             fontFamily: 'Outfit',
          //             color: FlutterFlowTheme.of(context).primary,
          //             fontSize: 22,
          //           ),
          //     ),
          //   ),
          //   actions: [
          //     // TextButton(
          //     //     onPressed: () {
          //     //       jobStatus();
          //     //       // loadata();
          //     //     },
          //     //     child: Text('Check job status'))
          //   ],
          //   centerTitle: true,
          //   elevation: 2,
          // ),

          body: SafeArea(
            top: true,
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  // width: double.infinity,
                  // height: MediaQuery.sizeOf(context).height * 0.80,
                  // decoration: BoxDecoration(
                  //   color: FlutterFlowTheme.of(context).secondaryBackground,
                  // ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.98,
                        child: buildMap(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.timer_sharp,
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        size: 24,
                                      ),
                                      Text(
                                        _formatTime(_elapsedSeconds),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // FlutterFlowTimer(
                                      //   initialTime: _timerMilliseconds!,
                                      //   getDisplayTime: (value) =>
                                      //       StopWatchTimer.getDisplayTime(value,
                                      //           milliSecond: false),
                                      //   controller: _timerController,
                                      //   onEnded: () async {
                                      //     await _clearSavedTimerState();
                                      //   },
                                      //   onChanged: (value, displayTime,
                                      //       shouldUpdate) async {
                                      //     _timerMilliseconds = value;
                                      //     _timerDisplayValue = displayTime;
                                      //     _model.timerMilliseconds = value;
                                      //     _model.timerValue = displayTime;
                                      //     await _saveTimerState(value);

                                      //     if (shouldUpdate) setState(() {});
                                      //   },
                                      //   textAlign: TextAlign.center,
                                      //   style: FlutterFlowTheme.of(context)
                                      //       .bodyMedium
                                      //       .override(
                                      //         fontFamily: 'Open Sans',
                                      //         color: FlutterFlowTheme.of(context)
                                      //             .info,
                                      //         fontSize: 18,
                                      //         letterSpacing: 0,
                                      //         fontWeight: FontWeight.w600,
                                      //       ),
                                      // ),
                                    ],
                                  ),
                                ),
                                FlutterFlowIconButton(
                                  borderColor:
                                      FlutterFlowTheme.of(context).info,
                                  borderRadius: 20,
                                  borderWidth: 1,
                                  buttonSize: 40,
                                  fillColor: FlutterFlowTheme.of(context).info,
                                  icon: Icon(
                                    Icons.menu,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24,
                                  ),
                                  onPressed: () async {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      enableDrag: false,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: CustomerDetailsWidget(
                                            cname: '${cName}',
                                            cNumber: '${cnumber}',
                                            cemail: '${cemail}',
                                          ),
                                        );
                                      },
                                    ).then((value) => safeSetState(() {}));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Positioned(
                      // top: 40,
                      // right: 20,
                      // child: Transform.rotate(
                      //   angle: _cameraRotation *
                      //       (3.14159265359 / 180), // Convert heading to radians
                      //   child: Icon(
                      //     Icons.navigation,
                      //     size: 40,
                      //     color: Colors.red,
                      //   ),
                      // )),

                      _buildTopNavigationBox(), // Display the navigation box
                      // Spacer(),
                      // Positioned(
                      //   bottom: 8,
                      //   child: Container(
                      //     height: MediaQuery.sizeOf(context).height * 0.28,
                      //     width: MediaQuery.sizeOf(context).width * 0.99,
                      //     // alignment: Alignment.bottomCenter,
                      //     decoration: BoxDecoration(color: Colors.white),
                      //     // width: double.infinity,
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Column(
                      //         children: [
                      //           Row(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceAround,
                      //             children: [
                      //               Column(
                      //                 children: [
                      //                   Text(
                      //                     'Distance',
                      //                     style: TextStyle(
                      //                         fontSize: 17,
                      //                         fontWeight: FontWeight.bold),
                      //                   ),
                      //                   Text('$estDistance'),
                      //                 ],
                      //               ),
                      //               Container(
                      //                 height: 20,
                      //                 width: 1,
                      //                 color: Colors.black,
                      //               ),
                      //               Column(
                      //                 children: [
                      //                   Text(
                      //                     'Duration',
                      //                     style: TextStyle(
                      //                         fontSize: 17,
                      //                         fontWeight: FontWeight.bold),
                      //                   ),
                      //                   Text('$duration'),
                      //                 ],
                      //               ),
                      //               Container(
                      //                 height: 20,
                      //                 width: 1,
                      //                 color: Colors.black,
                      //               ),
                      //               Column(
                      //                 children: [
                      //                   Text(
                      //                     'Arrival Time',
                      //                     style: TextStyle(
                      //                         fontSize: 17,
                      //                         fontWeight: FontWeight.bold),
                      //                   ),
                      //                   Text('$arrivalTime'),
                      //                 ],
                      //               )
                      //             ],
                      //           ),
                      //           // Text('Distance: $estDistance'),
                      //           // Text('Duration: $duration'),
                      //           // Text('Arrival Time: $arrivalTime'),
                      //           SizedBox(
                      //             height: 20,
                      //           ),
                      //           Text(
                      //             overflow: TextOverflow.ellipsis,
                      //             maxLines: 2,
                      //             'Address: $pickup $pickup $pickup',
                      //             style: TextStyle(
                      //                 fontSize: 17,
                      //                 fontWeight: FontWeight.bold),
                      //           ),
                      //           SizedBox(
                      //             height: 10,
                      //           ),
                      //           SwipeButton(
                      //             thumbPadding: EdgeInsets.all(3),
                      //             thumb: Icon(
                      //               Icons.chevron_right,
                      //               color: FlutterFlowTheme.of(context).primary,
                      //             ),
                      //             elevationThumb: 2,
                      //             elevationTrack: 2,
                      //             activeThumbColor: FlutterFlowTheme.of(context)
                      //                 .primaryBackground,
                      //             activeTrackColor:
                      //                 FlutterFlowTheme.of(context).primary,
                      //             borderRadius: BorderRadius.circular(8),
                      //             child: Text(
                      //               isRideStarted
                      //                   ? 'POB'
                      //                   : (isWaiting
                      //                           ? 'Arrival Now'
                      //                           : 'Way to Pickup')
                      //                       .toUpperCase(),
                      //               style: TextStyle(
                      //                 color: FlutterFlowTheme.of(context)
                      //                     .primaryBackground,
                      //                 fontSize: 18,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //             onSwipe: () {
                      //               setState(() {});
                      //               ScaffoldMessenger.of(context).showSnackBar(
                      //                 SnackBar(
                      //                   content: Text(isRideStarted
                      //                       ? 'POB'
                      //                       : (isWaiting
                      //                           ? 'Arrival Now'
                      //                           : 'Way to Pickup')),
                      //                   backgroundColor:
                      //                       FlutterFlowTheme.of(context)
                      //                           .primary,
                      //                 ),
                      //               );
                      //             },
                      //             onSwipeEnd: () async {
                      //               SharedPreferences sp =
                      //                   await SharedPreferences.getInstance();
                      //               setState(() {});
                      //               if (isRideStarted) {
                      //                 showDialog(
                      //                   context: context,
                      //                   builder: (BuildContext context) {
                      //                     return AlertDialog(
                      //                       title: Text('Choose Map Option'),
                      //                       content: Column(
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         children: [
                      //                           ListTile(
                      //                             leading: SizedBox(
                      //                               width: 25,
                      //                               height: 25,
                      //                               child: Image.asset(
                      //                                   'assets/images/google.png'), // Replace 'your_image.png' with your image asset path
                      //                             ),
                      //                             title: Text(
                      //                                 'Open in Google Maps'),
                      //                             onTap: () async {
                      //                               // await sp.remove('isWaitingTrue');
                      //                               // await sp.remove('isWaitingTrue');
                      //                               await getLatLngFromAddress(
                      //                                   dropoff!);
                      //                               Navigator.pop(context);
                      //                               startRideTrackingthird(
                      //                                   latitudeforGooglmap
                      //                                       .toString(),
                      //                                   lngforGooglmap
                      //                                       .toString());
                      //                               await startTrackingfordropOf(
                      //                                   latitudeforGooglmap,
                      //                                   lngforGooglmap);
                      //                               await MapUtils.navigateTo(
                      //                                   latitudeforGooglmap,
                      //                                   lngforGooglmap);

                      //                               // start from here
                      //                             },
                      //                           ),
                      //                           ListTile(
                      //                             leading: SizedBox(
                      //                               width: 25,
                      //                               height: 25,
                      //                               child: Image.asset(
                      //                                   'assets/images/app_launcher_icon.png'), // Replace 'your_image.png' with your image asset path
                      //                             ),
                      //                             title: Text('Using App'),
                      //                             onTap: () async {
                      //                               // Navigator.pop(context);
                      //                               print(
                      //                                   'if condtion isridestarted is $isRideStarted');

                      //                               await sp.remove(
                      //                                   'isWaitingTrue');
                      //                               var request =
                      //                                   http.MultipartRequest(
                      //                                       'POST',
                      //                                       Uri.parse(
                      //                                           'https://www.minicaboffice.com/api/driver/calculate-waiting-time.php'));
                      //                               request.fields.addAll({
                      //                                 'd_id': '${did}',
                      //                                 'job_id': '${jobid}',
                      //                                 'waiting_time':
                      //                                     _timerDisplayValue
                      //                                 //     _model.timerValue.toString()
                      //                               });

                      //                               try {
                      //                                 http.StreamedResponse
                      //                                     response =
                      //                                     await request.send();

                      //                                 if (response.statusCode ==
                      //                                     200) {
                      //                                 } else {}
                      //                               } catch (e) {}
                      //                               _stopTimer();
                      //                               _model.timerController
                      //                                   .onStopTimer();
                      //                               await sp.setString(
                      //                                   'timerValue',
                      //                                   _formatTime(
                      //                                       _elapsedSeconds));

                      //                               await sp.setInt(
                      //                                   'isRideStart', 2);
                      //                               // Timer(Duration(seconds: 2), () {
                      //                               Navigator.push(
                      //                                   context,
                      //                                   MaterialPageRoute(
                      //                                       builder: (context) =>
                      //                                           PobWidget()));
                      //                               // });

                      //                               isRideStarted = false;
                      //                               isWaiting = false;
                      //                             },
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     );
                      //                   },
                      //                 );
                      //               } else if (isWaiting) {
                      //                 await sp.setBool('arrivalDone', true);
                      //                 print('arrival swiped');
                      //                 print(
                      //                     'else if condtion isridestarted is $isRideStarted and iswaiting is $isWaiting');
                      //                 checkDriverProximity(
                      //                     currentLatitude,
                      //                     currentLongitude,
                      //                     pickupLat,
                      //                     pickupLng);
                      //               } else {
                      //                 print(
                      //                     'only else and alert showing   condtion isridestarted is $isRideStarted and iswaiting is $isWaiting');
                      //                 await sp.setBool('isWaitingTrue', true);
                      //                 waitingPassanger();
                      //                 isWaiting = true;

                      //                 showDialog(
                      //                   context: context,
                      //                   builder: (BuildContext context) {
                      //                     return AlertDialog(
                      //                       title: Text('Choose Map Option'),
                      //                       content: Column(
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         children: [
                      //                           ListTile(
                      //                             leading: SizedBox(
                      //                               width: 25,
                      //                               height: 25,
                      //                               child: Image.asset(
                      //                                   'assets/images/google.png'), // Replace 'your_image.png' with your image asset path
                      //                             ),
                      //                             title: Text(
                      //                                 'Open in Google Maps'),
                      //                             onTap: () async {
                      //                               await getLatLngFromAddress(
                      //                                   pickup!);
                      //                               startRideTracking(
                      //                                   latitudeforGooglmap
                      //                                       .toString(),
                      //                                   lngforGooglmap
                      //                                       .toString());
                      //                               await startTrackingforpickUp(
                      //                                   latitudeforGooglmap,
                      //                                   lngforGooglmap);

                      //                               Navigator.pop(context);
                      //                               await MapUtils.navigateTo(
                      //                                   latitudeforGooglmap,
                      //                                   lngforGooglmap);

                      //                               // start from here
                      //                             },
                      //                           ),
                      //                           ListTile(
                      //                             leading: SizedBox(
                      //                               width: 25,
                      //                               height: 25,
                      //                               child: Image.asset(
                      //                                   'assets/images/app_launcher_icon.png'), // Replace 'your_image.png' with your image asset path
                      //                             ),
                      //                             title: Text('Using App'),
                      //                             onTap: () {
                      //                               Navigator.pop(context);
                      //                             },
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     );
                      //                   },
                      //                 );
                      //               }
                      //             },
                      //           ),
                      //           SizedBox(
                      //             height: 20,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.38,
                          width: MediaQuery.sizeOf(context).width * 0.99,
                          child: CustomScrollView(
                            shrinkWrap: true,
                            slivers: [
                              SliverAppBar(
                                onStretchTrigger: () async {
                                  print('its triggers');
                                  // return
                                },
                                backgroundColor: Colors.transparent,
                                expandedHeight:
                                    MediaQuery.sizeOf(context).height *
                                        0.48, // Custom height
                                floating: false, stretch: true,
                                titleTextStyle: TextStyle(fontSize: 15),
                                pinned: true, automaticallyImplyLeading: false,
                                flexibleSpace: FlexibleSpaceBar(
                                  // expandedTitleScale: 2.5,
                                  title: Container(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.28,
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.99,
                                    // alignment: Alignment.bottomCenter,
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    // width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      'Distance',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '$estDistance',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 20,
                                                  width: 1,
                                                  color: Colors.black,
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      'Duration',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '$duration',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 20,
                                                  width: 1,
                                                  color: Colors.black,
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      'Arrival Time',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '$arrivalTime',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            // Text('Distance: $estDistance'),
                                            // Text('Duration: $duration'),
                                            // Text('Arrival Time: $arrivalTime'),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              'Address: $pickup $pickup $pickup',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 35,
                                              child: SwipeButton(
                                                thumbPadding: EdgeInsets.all(3),
                                                thumb: Icon(
                                                  size: 16,
                                                  Icons.chevron_right,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                ),
                                                elevationThumb: 2,
                                                elevationTrack: 2,
                                                activeThumbColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryBackground,
                                                activeTrackColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Text(
                                                  isRideStarted
                                                      ? 'POB'
                                                      : (isWaiting
                                                              ? 'Arrival Now'
                                                              : 'Way to Pickup')
                                                          .toUpperCase(),
                                                  style: TextStyle(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                onSwipe: () {
                                                  // setState(() {});
                                                  // if (estDistance == '0.3 km') {
                                                  //   ScaffoldMessenger.of(
                                                  //           context)
                                                  //       .showSnackBar(
                                                  //     SnackBar(
                                                  //       content: Text(isRideStarted
                                                  //           ? 'POB'
                                                  //           : (isWaiting
                                                  //               ? 'Arrival Now'
                                                  //               : 'Way to Pickup')),
                                                  //       backgroundColor:
                                                  //           FlutterFlowTheme.of(
                                                  //                   context)
                                                  //               .primary,
                                                  //     ),
                                                  //   );
                                                  // } else {}
                                                },
                                                onSwipeEnd: () async {
                                                  SharedPreferences sp =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  setState(() {});
                                                  print(
                                                      'isRidestart value is ${isRideStarted}');
                                                  print(
                                                      'iswaiting value is ${isWaiting}');
                                                  if (isRideStarted) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Choose Map Option'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              ListTile(
                                                                leading:
                                                                    SizedBox(
                                                                  width: 25,
                                                                  height: 25,
                                                                  child: Image
                                                                      .asset(
                                                                          'assets/images/google.png'), // Replace 'your_image.png' with your image asset path
                                                                ),
                                                                title: Text(
                                                                    'Open in Google Maps'),
                                                                onTap:
                                                                    () async {
                                                                  // await sp.remove('isWaitingTrue');
                                                                  // await sp.remove('isWaitingTrue');
                                                                  await getLatLngFromAddress(
                                                                      dropoff!);
                                                                  Navigator.pop(
                                                                      context);
                                                                  startRideTrackingthird(
                                                                      latitudeforGooglmap
                                                                          .toString(),
                                                                      lngforGooglmap
                                                                          .toString());
                                                                  await startTrackingfordropOf(
                                                                      latitudeforGooglmap,
                                                                      lngforGooglmap);
                                                                  await MapUtils
                                                                      .navigateTo(
                                                                          latitudeforGooglmap,
                                                                          lngforGooglmap);

                                                                  // start from here
                                                                },
                                                              ),
                                                              ListTile(
                                                                leading:
                                                                    SizedBox(
                                                                  width: 25,
                                                                  height: 25,
                                                                  child: Image
                                                                      .asset(
                                                                          'assets/images/app_launcher_icon.png'), // Replace 'your_image.png' with your image asset path
                                                                ),
                                                                title: Text(
                                                                    'Using App'),
                                                                onTap:
                                                                    () async {
                                                                  // Navigator.pop(context);
                                                                  print(
                                                                      'if condtion isridestarted is $isRideStarted');

                                                                  await sp.remove(
                                                                      'isWaitingTrue');
                                                                  var request =
                                                                      http.MultipartRequest(
                                                                          'POST',
                                                                          Uri.parse(
                                                                              'https://www.minicaboffice.com/api/driver/calculate-waiting-time.php'));
                                                                  request.fields
                                                                      .addAll({
                                                                    'd_id':
                                                                        '${did}',
                                                                    'job_id':
                                                                        '${jobid}',
                                                                    'waiting_time':
                                                                        _timerDisplayValue
                                                                    //     _model.timerValue.toString()
                                                                  });

                                                                  try {
                                                                    http.StreamedResponse
                                                                        response =
                                                                        await request
                                                                            .send();

                                                                    if (response
                                                                            .statusCode ==
                                                                        200) {
                                                                    } else {}
                                                                  } catch (e) {}
                                                                  _stopTimer();
                                                                  _model
                                                                      .timerController
                                                                      .onStopTimer();
                                                                  await sp.setString(
                                                                      'timerValue',
                                                                      _formatTime(
                                                                          _elapsedSeconds));

                                                                  await sp.setInt(
                                                                      'isRideStart',
                                                                      2);
                                                                  // Timer(Duration(seconds: 2), () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              PobWidget()));
                                                                  // });

                                                                  isRideStarted =
                                                                      false;
                                                                  isWaiting =
                                                                      false;
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else if (isWaiting &&
                                                      distanceInMiles <= 0.19) {
                                                    await sp.setBool(
                                                        'arrivalDone', true);
                                                    print(
                                                        'arrival swiped ${distanceInMiles}');
                                                    print(
                                                        'else if condtion isridestarted is $isRideStarted and iswaiting is $isWaiting');
                                                    checkDriverProximity(
                                                        currentLatitude,
                                                        currentLongitude,
                                                        pickupLat,
                                                        pickupLng);
                                                  } else if (isWaiting ==
                                                          false &&
                                                      distanceInMiles != 0.20) {
                                                    _controller.animateCamera(
                                                      CameraUpdate
                                                          .newCameraPosition(
                                                        CameraPosition(
                                                            target:
                                                                _currentPosition,
                                                            zoom:
                                                                18.5, // Adjust zoom level for navigation
                                                            tilt:
                                                                60, // Add tilt for a 3D-like view
                                                            bearing:
                                                                _calculateBearing()), // Zoom and tilt
                                                      ),
                                                    );
                                                    print(
                                                        'only else and alert showing   condtion isridestarted is $isRideStarted and iswaiting is $isWaiting');
                                                    await sp.setBool(
                                                        'isWaitingTrue', true);
                                                    waitingPassanger();
                                                    isWaiting = true;

                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Choose Map Option'),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              ListTile(
                                                                leading:
                                                                    SizedBox(
                                                                  width: 25,
                                                                  height: 25,
                                                                  child: Image
                                                                      .asset(
                                                                          'assets/images/google.png'), // Replace 'your_image.png' with your image asset path
                                                                ),
                                                                title: Text(
                                                                    'Open in Google Maps'),
                                                                onTap:
                                                                    () async {
                                                                  await getLatLngFromAddress(
                                                                      pickup!);
                                                                  startRideTracking(
                                                                      latitudeforGooglmap
                                                                          .toString(),
                                                                      lngforGooglmap
                                                                          .toString());
                                                                  await startTrackingforpickUp(
                                                                      latitudeforGooglmap,
                                                                      lngforGooglmap);

                                                                  Navigator.pop(
                                                                      context);
                                                                  await MapUtils
                                                                      .navigateTo(
                                                                          latitudeforGooglmap,
                                                                          lngforGooglmap);

                                                                  // start from here
                                                                },
                                                              ),
                                                              ListTile(
                                                                leading:
                                                                    SizedBox(
                                                                  width: 25,
                                                                  height: 25,
                                                                  child: Image
                                                                      .asset(
                                                                          'assets/images/app_launcher_icon.png'), // Replace 'your_image.png' with your image asset path
                                                                ),
                                                                title: Text(
                                                                    'Using App'),
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'You have not arrived yet'),
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                      ),
                                                    );
                                                    print('not arrived yet');
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // background: Image.network(
                                  //   'https://via.placeholder.com/400',
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.28,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Wrap(
                                          //   children: [
                                          //     Row(
                                          //       mainAxisSize: MainAxisSize
                                          //           .min, // Set this to MainAxisSize.min
                                          //       children: [
                                          //         Padding(
                                          //           padding:
                                          //               EdgeInsetsDirectional
                                          //                   .fromSTEB(10.0,
                                          //                       10.0, 0.0, 0.0),
                                          //           child: Icon(
                                          //             Icons.pin_drop_outlined,
                                          //             color:
                                          //                 FlutterFlowTheme.of(
                                          //                         context)
                                          //                     .primary,
                                          //             size: 25,
                                          //           ),
                                          //         ),
                                          //         Flexible(
                                          //           child: Padding(
                                          //             padding:
                                          //                 EdgeInsetsDirectional
                                          //                     .fromSTEB(
                                          //                         10.0,
                                          //                         10.0,
                                          //                         0.0,
                                          //                         20.0),
                                          //             child: Text(
                                          //               pickup ?? '--',
                                          //               style:
                                          //                   FlutterFlowTheme.of(
                                          //                           context)
                                          //                       .labelMedium
                                          //                       .override(
                                          //                         fontFamily:
                                          //                             'Readex Pro',
                                          //                         color: FlutterFlowTheme.of(
                                          //                                 context)
                                          //                             .secondaryText,
                                          //                         fontSize:
                                          //                             20.0,
                                          //                         letterSpacing:
                                          //                             1.5,
                                          //                       ),
                                          //               overflow: TextOverflow
                                          //                   .ellipsis, // Handle text overflow with ellipsis
                                          //               maxLines:
                                          //                   3, // Limit to a maximum of 2 lines
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ],
                                          // ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 0, 5, 0),
                                                child: Icon(
                                                  Icons
                                                      .access_time_filled_rounded,
                                                  color: Color(0xFF5B68F5),
                                                  size: 20,
                                                ),
                                              ),
                                              Text(
                                                pickTime ?? '--',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleLarge
                                                    .override(
                                                      fontFamily: 'Open Sans',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 20,
                                                    ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 0, 5, 0),
                                                child: FaIcon(
                                                  FontAwesomeIcons.calendar,
                                                  size: 21,
                                                  color: Color(0xFF5B68F5),
                                                ),
                                              ),
                                              Text(
                                                pickDate ?? '--',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleLarge
                                                    .override(
                                                      fontFamily: 'Open Sans',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 20,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 8, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(10, 0, 5, 0),
                                                  child: Icon(
                                                    Icons.luggage_outlined,
                                                    color: Color(0xFF5B68F5),
                                                    size: 20,
                                                  ),
                                                ),
                                                Text(
                                                  luggage ?? '0',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 20,
                                                      ),
                                                ),
                                                SizedBox(
                                                  height: 25,
                                                  child: VerticalDivider(
                                                    width: 40,
                                                    thickness: 3,
                                                    color: Color(0xFF5B68F5),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(20, 0, 5, 0),
                                                  child: FaIcon(
                                                    FontAwesomeIcons
                                                        .userFriends,
                                                    color: Color(0xFF5B68F5),
                                                    size: 18,
                                                  ),
                                                ),
                                                Text(
                                                  passenger ?? '--',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 20,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10, 10, 10, 60),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                FlutterFlowIconButton(
                                                  borderColor:
                                                      Color(0xFF5B68F5),
                                                  borderWidth: 1,
                                                  buttonSize: 48,
                                                  fillColor: Color(0xFF5B68F5),
                                                  icon: FaIcon(
                                                    FontAwesomeIcons.ellipsisH,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    size: 24,
                                                  ),
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              WaydetailsWidget(
                                                            time: '${pickTime}',
                                                            date: '${pickDate}',
                                                            passanger:
                                                                '${passenger}',
                                                            cName: '${cName}',
                                                            cnumber:
                                                                '${cnumber}',
                                                            cemail: '${cemail}',
                                                            luggage:
                                                                '${luggage}',
                                                            pickup: '${pickup}',
                                                            dropoff:
                                                                '${dropoff}',
                                                            cNote: '${note}',
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                ),
                                                FFButtonWidget(
                                                  onPressed: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              ClientnotesWidget(
                                                            name: '${cName}',
                                                            notes: '${note}',
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  text: 'VIEW NOTE',
                                                  icon: FaIcon(
                                                    FontAwesomeIcons.infoCircle,
                                                    size: 21,
                                                  ),
                                                  options: FFButtonOptions(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.4,
                                                    height: 45,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                24, 0, 24, 0),
                                                    iconPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 0, 0, 0),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    textStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: Colors.white,
                                                        ),
                                                    elevation: 3,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  childCount: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: MediaQuery.sizeOf(context).height * 0.40,
                        right: 10,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: ClientnotesWidget(
                                        name: '${cName}',
                                        notes: '${note}',
                                      ),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 8,
                            ),

                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Transform.rotate(
                                  angle: _cameraRotation *
                                      (3.14159265359 /
                                          180), // Convert heading to radians
                                  child: Icon(
                                    Icons.navigation,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            // Container(
                            //   height: 40,
                            //   width: 40,
                            //   decoration: BoxDecoration(
                            //       color: Colors.black, shape: BoxShape.circle),
                            // )
                          ],
                        ),
                      )
                      // Align(
                      //   alignment: AlignmentDirectional(0.00, 1.35),
                      //   child: Padding(
                      //     padding: EdgeInsetsDirectional.fromSTEB(
                      //         0.0, 0.0, 0.0, 0.0),
                      //     child: Container(
                      //       width: MediaQuery.sizeOf(context).width * 1.0,
                      //       height: MediaQuery.sizeOf(context).height * 0.4,
                      //       decoration: BoxDecoration(
                      //         color: FlutterFlowTheme.of(context)
                      //             .secondaryBackground,
                      //       ),
                      //       child: Column(
                      //         mainAxisSize: MainAxisSize.max,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Wrap(
                      //             children: [
                      //               Row(
                      //                 mainAxisSize: MainAxisSize
                      //                     .min, // Set this to MainAxisSize.min
                      //                 children: [
                      //                   Padding(
                      //                     padding:
                      //                         EdgeInsetsDirectional.fromSTEB(
                      //                             10.0, 10.0, 0.0, 0.0),
                      //                     child: Icon(
                      //                       Icons.pin_drop_outlined,
                      //                       color: FlutterFlowTheme.of(context)
                      //                           .primary,
                      //                       size: 25,
                      //                     ),
                      //                   ),
                      //                   Flexible(
                      //                     child: Padding(
                      //                       padding:
                      //                           EdgeInsetsDirectional.fromSTEB(
                      //                               10.0, 10.0, 0.0, 20.0),
                      //                       child: Text(
                      //                         pickup ?? '--',
                      //                         style: FlutterFlowTheme.of(
                      //                                 context)
                      //                             .labelMedium
                      //                             .override(
                      //                               fontFamily: 'Readex Pro',
                      //                               color: FlutterFlowTheme.of(
                      //                                       context)
                      //                                   .secondaryText,
                      //                               fontSize: 20.0,
                      //                               letterSpacing: 1.5,
                      //                             ),
                      //                         overflow: TextOverflow
                      //                             .ellipsis, // Handle text overflow with ellipsis
                      //                         maxLines:
                      //                             3, // Limit to a maximum of 2 lines
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ],
                      //           ),
                      //           Row(
                      //             mainAxisSize: MainAxisSize.max,
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Padding(
                      //                 padding: EdgeInsetsDirectional.fromSTEB(
                      //                     10, 0, 5, 0),
                      //                 child: Icon(
                      //                   Icons.access_time_filled_rounded,
                      //                   color: Color(0xFF5B68F5),
                      //                   size: 20,
                      //                 ),
                      //               ),
                      //               Text(
                      //                 pickTime ?? '--',
                      //                 style: FlutterFlowTheme.of(context)
                      //                     .titleLarge
                      //                     .override(
                      //                       fontFamily: 'Open Sans',
                      //                       color: FlutterFlowTheme.of(context)
                      //                           .primaryText,
                      //                       fontSize: 20,
                      //                     ),
                      //               ),
                      //               Padding(
                      //                 padding: EdgeInsetsDirectional.fromSTEB(
                      //                     10, 0, 5, 0),
                      //                 child: FaIcon(
                      //                   FontAwesomeIcons.calendar,
                      //                   size: 21,
                      //                   color: Color(0xFF5B68F5),
                      //                 ),
                      //               ),
                      //               Text(
                      //                 pickDate ?? '--',
                      //                 style: FlutterFlowTheme.of(context)
                      //                     .titleLarge
                      //                     .override(
                      //                       fontFamily: 'Open Sans',
                      //                       color: FlutterFlowTheme.of(context)
                      //                           .primaryText,
                      //                       fontSize: 20,
                      //                     ),
                      //               ),
                      //             ],
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsetsDirectional.fromSTEB(
                      //                 0, 8, 0, 0),
                      //             child: Row(
                      //               mainAxisSize: MainAxisSize.max,
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Padding(
                      //                   padding: EdgeInsetsDirectional.fromSTEB(
                      //                       10, 0, 5, 0),
                      //                   child: Icon(
                      //                     Icons.luggage_outlined,
                      //                     color: Color(0xFF5B68F5),
                      //                     size: 20,
                      //                   ),
                      //                 ),
                      //                 Text(
                      //                   luggage ?? '0',
                      //                   style: FlutterFlowTheme.of(context)
                      //                       .titleLarge
                      //                       .override(
                      //                         fontFamily: 'Open Sans',
                      //                         color:
                      //                             FlutterFlowTheme.of(context)
                      //                                 .primaryText,
                      //                         fontSize: 20,
                      //                       ),
                      //                 ),
                      //                 SizedBox(
                      //                   height: 25,
                      //                   child: VerticalDivider(
                      //                     width: 40,
                      //                     thickness: 3,
                      //                     color: Color(0xFF5B68F5),
                      //                   ),
                      //                 ),
                      //                 Padding(
                      //                   padding: EdgeInsetsDirectional.fromSTEB(
                      //                       20, 0, 5, 0),
                      //                   child: FaIcon(
                      //                     FontAwesomeIcons.userFriends,
                      //                     color: Color(0xFF5B68F5),
                      //                     size: 18,
                      //                   ),
                      //                 ),
                      //                 Text(
                      //                   passenger ?? '--',
                      //                   style: FlutterFlowTheme.of(context)
                      //                       .titleLarge
                      //                       .override(
                      //                         fontFamily: 'Open Sans',
                      //                         color:
                      //                             FlutterFlowTheme.of(context)
                      //                                 .primaryText,
                      //                         fontSize: 20,
                      //                       ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           Padding(
                      //             padding: EdgeInsetsDirectional.fromSTEB(
                      //                 10, 10, 10, 60),
                      //             child: Row(
                      //               mainAxisSize: MainAxisSize.max,
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 FlutterFlowIconButton(
                      //                   borderColor: Color(0xFF5B68F5),
                      //                   borderWidth: 1,
                      //                   buttonSize: 48,
                      //                   fillColor: Color(0xFF5B68F5),
                      //                   icon: FaIcon(
                      //                     FontAwesomeIcons.ellipsisH,
                      //                     color: FlutterFlowTheme.of(context)
                      //                         .secondaryBackground,
                      //                     size: 24,
                      //                   ),
                      //                   onPressed: () async {
                      //                     await showModalBottomSheet(
                      //                       isScrollControlled: true,
                      //                       backgroundColor: Colors.transparent,
                      //                       enableDrag: false,
                      //                       context: context,
                      //                       builder: (context) {
                      //                         return Padding(
                      //                           padding:
                      //                               MediaQuery.viewInsetsOf(
                      //                                   context),
                      //                           child: WaydetailsWidget(
                      //                             time: '${pickTime}',
                      //                             date: '${pickDate}',
                      //                             passanger: '${passenger}',
                      //                             cName: '${cName}',
                      //                             cnumber: '${cnumber}',
                      //                             cemail: '${cemail}',
                      //                             luggage: '${luggage}',
                      //                             pickup: '${pickup}',
                      //                             dropoff: '${dropoff}',
                      //                             cNote: '${note}',
                      //                           ),
                      //                         );
                      //                       },
                      //                     ).then(
                      //                         (value) => safeSetState(() {}));
                      //                   },
                      //                 ),
                      //                 FFButtonWidget(
                      //                   onPressed: () async {
                      //                     await showModalBottomSheet(
                      //                       isScrollControlled: true,
                      //                       backgroundColor: Colors.transparent,
                      //                       enableDrag: false,
                      //                       context: context,
                      //                       builder: (context) {
                      //                         return Padding(
                      //                           padding:
                      //                               MediaQuery.viewInsetsOf(
                      //                                   context),
                      //                           child: ClientnotesWidget(
                      //                             name: '${cName}',
                      //                             notes: '${note}',
                      //                           ),
                      //                         );
                      //                       },
                      //                     ).then(
                      //                         (value) => safeSetState(() {}));
                      //                   },
                      //                   text: 'VIEW NOTE',
                      //                   icon: FaIcon(
                      //                     FontAwesomeIcons.infoCircle,
                      //                     size: 21,
                      //                   ),
                      //                   options: FFButtonOptions(
                      //                     width:
                      //                         MediaQuery.sizeOf(context).width *
                      //                             0.4,
                      //                     height: 45,
                      //                     padding:
                      //                         EdgeInsetsDirectional.fromSTEB(
                      //                             24, 0, 24, 0),
                      //                     iconPadding:
                      //                         EdgeInsetsDirectional.fromSTEB(
                      //                             0, 0, 0, 0),
                      //                     color: FlutterFlowTheme.of(context)
                      //                         .primary,
                      //                     textStyle:
                      //                         FlutterFlowTheme.of(context)
                      //                             .titleSmall
                      //                             .override(
                      //                               fontFamily: 'Open Sans',
                      //                               color: Colors.white,
                      //                             ),
                      //                     elevation: 3,
                      //                     borderSide: BorderSide(
                      //                       color: Colors.transparent,
                      //                       width: 1,
                      //                     ),
                      //                     borderRadius:
                      //                         BorderRadius.circular(6),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String estDistance = 'Calculating...';
  String duration = 'Calculating...';
  String arrivalTime = 'Calculating...';
  IconData _getArrowIcon(String instruction) {
    if (instruction.toLowerCase().contains('left')) {
      return Icons.turn_left; // Left turn
    } else if (instruction.toLowerCase().contains('right')) {
      return Icons.turn_right; // Right turn
    } else if (instruction.toLowerCase().contains('head')) {
      return Icons.straight; // Straight ahead
    } else if (instruction.toLowerCase().contains('u-turn')) {
      return Icons.u_turn_left; // U-turn
    } else {
      return Icons.navigation; // Default navigation icon
    }
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
// Capture the camera's rotation
      _cameraRotation = position.bearing; // Capture the camera's rotation
    });
  }

  double _cameraRotation = 0.0; // Track camera's rotation angle
  Widget _buildTopNavigationBox() {
    if (_navigationSteps.isEmpty) return SizedBox.shrink();

    final currentStep = _navigationSteps.first;

    // Extracting the direction and text
    String instruction = currentStep['instruction'];
    String distance = currentStep['distance'];
    IconData arrowIcon =
        _getArrowIcon(instruction); // Get the appropriate arrow icon

    return Positioned(
      // top: 8,
      // left: 5,
      // right: 8,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary,
          // borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 5),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(arrowIcon, color: Colors.white, size: 32), // Arrow icon
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    instruction.replaceAll(RegExp(r'<[^>]*>'), ''),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'In $distance',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startRideTracking(
      String customerLocation1, String customerLocation2) async {
    setState(() {});
    final service = FlutterBackgroundService();
    // This will send the 'updateTimer' event to the background service
    service.invoke('StartRide2', {
      'startRideSecondEvent1': customerLocation1,
      'startRideSecondEvent2': customerLocation2,
    });
  }

  void startRideTrackingthird(
      String customerLocation1, String customerLocation2) async {
    setState(() {});
    final service = FlutterBackgroundService();
    // This will send the 'updateTimer' event to the background service
    service.invoke('StartRide3', {
      'startRideThirdEvent1': customerLocation1,
      'startRideThirdEvent2': customerLocation2,
      'timecount': _timerDisplayValue,
    });
  }

  Widget buildMap() {
    return _currentPosition == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary),
                ),
                SizedBox(height: 10),
                Text(
                  'Finding Route...',
                  style: TextStyle(color: FlutterFlowTheme.of(context).primary),
                ),
              ],
            ),
          )
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              // target: LatLng(
              //   latitude,
              //   longitude,
              // ),
              target: _currentPosition,
              zoom: 14,
            ),
            markers: {
              Marker(
                  markerId: const MarkerId('Source'),
                  position: LatLng(latitude, longitude),
                  icon: sourceicon),
              Marker(
                  markerId: const MarkerId('destination'),
                  position: LatLng(convertedLat, convertedLng),
                  icon: destinationicon),
            },
            onCameraMove: _onCameraMove,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            // markers: markers,
            polylines: polylines,
          );
  }

  void _updateCameraWithZoom(LatLng position) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: position,
            zoom: 17.5, // Adjust zoom level for navigation
            tilt: 60, // Add tilt for a 3D-like view
            bearing: _calculateBearing()), // Zoom and tilt
      ),
    );
  }

  List<Map<String, dynamic>> _navigationSteps = [];
  double _calculateBearing() {
    if (_navigationSteps.isEmpty) return 0;

    final nextStep = _navigationSteps.first;
    final decodedPolyline =
        PolylinePoints().decodePolyline(nextStep['polyline']);

    if (decodedPolyline.length < 2) return 0;

    final start = decodedPolyline.first;
    final end = decodedPolyline.last;

    return Geolocator.bearingBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  // LatLng current2ndPosition = LatLng(37.7749, -122.4194);
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        latitude = position.latitude;
        longitude = position.longitude;
      });

      _updateCameraWithZoom(
          _currentPosition); // Move the camera to the current location
      debugPrint('the converted Latlng are ${convertedLat} ${convertedLng}');
      // _getPolyline(convertedLat, convertedLng);
      // (); // Fetch directions after getting the current location
      _trackLocation(); // Start tracking the user's movement
    } catch (e) {
      print('Error fetching current location: $e');
    }
  }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     setState(() {
  //       _currentPosition = position;
  //       currentLatitude = position.latitude;
  //       currentLongitude = position.longitude;
  //       current2ndPosition = LatLng(position.latitude, position.longitude);
  //       _updateCameraWithZoom(current2ndPosition);
  //     });
  //   } catch (e) {}
  // }

  StreamSubscription<Position>? positionStream;
  void _trackLocation() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
// Get the heading from the location
        print('the heading position ${position.heading}');
      });
      updatePolyline();
      _updateCameraPosition(_currentPosition);
      _updateCameraWithZoom(_currentPosition); // Auto-follow user
      _checkStepCompletion(position);
    });
  }

  void _checkStepCompletion(Position position) {
    if (_navigationSteps.isEmpty) return;

    final currentStep = _navigationSteps[0];
    final stepPolyline = PolylinePoints()
        .decodePolyline(currentStep['polyline'])
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      stepPolyline.last.latitude,
      stepPolyline.last.longitude,
    );

    if (distance < 20) {
      // Step completion threshold
      // _speakInstruction(currentStep['instruction']); // Speak the instruction
      setState(() {
        _navigationSteps.removeAt(0);
      });

      if (_navigationSteps.isNotEmpty) {
        final nextStepPolyline = PolylinePoints().decodePolyline(
          _navigationSteps[0]['polyline'],
        );

        _controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(
              nextStepPolyline.last.latitude,
              nextStepPolyline.last.longitude,
            ),
            17.5,
          ),
        );
      }
    }
  }

  void _updateCameraPosition(LatLng position) {
    _controller.animateCamera(CameraUpdate.newLatLng(position));
  }

//   void _trackLocationChanges() {
//     positionStream = Geolocator.getPositionStream(
//       locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
//     ).listen((Position position) {
//       setState(() {});
// //       _currentPosition!.latitude=
// //       // Update current location variables
//       latitude = position.latitude;
//       longitude = position.longitude;
// // // currentLocation.latitude = position.latitude;
// //       longitude.value = position.longitude;
//       // Update polyline with new user location
//       updatePolyline();
//     });
//   }

  double longitude = 0.0;
  double latitude = 0.0;
  Future<void> updatePolyline() async {
    try {
      // Get destination coordinates
      final destinationLat = convertedLat;
      final destinationLng = convertedLng;
      setState(() {});
      // Recalculate distance and polyline with the new current location
      await _getPolyline(destinationLat, destinationLng);

      // Optionally, move the camera to the new current location
      _controller.animateCamera(
        CameraUpdate.newLatLng(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude)),
      );
    } catch (e) {}
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {});
    _controller = controller;
    _getCurrentLocation();
  }

  Future<void> _setupMarkersAndPolylines() async {
    setState(() {
      isLoading = true;
    });

    await _getCurrentLocation();

    if (currentLatitude != null && currentLongitude != null) {
      _kGoogle = CameraPosition(
        target: LatLng(currentLatitude, currentLongitude),
        zoom: 14,
      );
    }
  }

  double distanceInMiles = 0;
  Future _getPolyline(double destinationLat, double desLng) async {
    const apiKey =
        'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA'; // Replace with your Google Maps API key
    var origin =
        '${latitude},${longitude}'; // Replace with your source coordinates
    var destination =
        // '31.414050,73.0613070'; // Replace with your destination coordinates // Replace with your destination coordinates
        '${destinationLat},${desLng}'; // Replace with your destination coordinates // Replace with your destination coordinates
    debugPrint('origin ${origin}');
    debugPrint('enter valida address ${destination}');
    final response = await http.post(Uri.parse(// can be get and post request
        // 'https://maps.googleapis.com/maps/api/directions/json?origin=31.4064054,73.0413076&destination=31.6404050,73.2413070&key=AIzaSyBBSmpcyEaIojvZznYVNpCU0Htvdabe__Y'));
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey'));
    print('the json responseis ${response.body}');

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);
      // print(data);
      final steps = data['routes'][0]['legs'][0]['steps'];
      double distanceInKm =
          double.tryParse(distance!.replaceAll(' km', '')) ?? 0.0;
      distanceInMiles = distanceInKm * 0.621371;
      _navigationSteps = steps.map<Map<String, dynamic>>((step) {
        return {
          'instruction': step['html_instructions'],
          'distance': "${distanceInMiles.toStringAsFixed(2)} miles",
          'duration': step['duration']['text'],
          'polyline': step['polyline']['points'],
        };
      }).toList();
      if (data.containsKey('routes') && data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        if (route.containsKey('legs') && route['legs'].isNotEmpty) {
          final leg = route['legs'][0];
          setState(() {});
          if (leg.containsKey('distance')) {
            distance = leg['distance']['text'];
            double distanceInKm =
                double.tryParse(distance!.replaceAll(' km', '')) ?? 0.0;
            distanceInMiles = distanceInKm * 0.621371;
            // time.value = leg['duration']['text'];
            estDistance = "${distanceInMiles.toStringAsFixed(2)} miles";
            duration = leg['duration']['text'];
            arrivalTime = leg['arrival_time'] != null
                ? leg['arrival_time']['text']
                : 'Unavailable';

            final points = route['overview_polyline']['points'];

            // Decode polyline points and add them to the map
            decodedPoints = PolylinePoints()
                .decodePolyline(points)
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();
            polylines.clear();
            polylines.add(Polyline(
              // patterns: [PatternItem.dash(20), PatternItem.gap(10)],
              // patterns: points,
              polylineId: const PolylineId('route'),
              color: Colors.blue,
              width: 5,
              points: decodedPoints,
            ));
          }
        }
      }
    }
  }

  Future<Uint8List> getbytesfromimages(
      String path, int width, int height) async {
    setState(() {});
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void setcustommarkeritem() async {
    setState(() {});
    final Uint8List sourceImage =
        await getbytesfromimages('assets/images/car.png', 80, 80);
    final Uint8List destinationImage =
        await getbytesfromimages('assets/images/userg.png', 80, 80);

    sourceicon = BitmapDescriptor.fromBytes(sourceImage);
    destinationicon = BitmapDescriptor.fromBytes(destinationImage);
  }

  final apiKey = 'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA';

  List<LatLng> decodedPoints = <LatLng>[];
  BitmapDescriptor sourceicon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationicon = BitmapDescriptor.defaultMarker;
  Future getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {});
        convertedLat = locations.first.latitude;
        convertedLng = locations.first.longitude;
        setcustommarkeritem();
        debugPrint('enter valida address ${locations.first.latitude}');
        _getPolyline(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {}
  }

  double convertedLat = 0;
  double convertedLng = 0;

  Future<void> wayToPickup() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');

      if (dId == null) {}
      var request = http.MultipartRequest('POST',
          Uri.parse('https://minicaboffice.com/api/driver/way-to-pickup.php'));
      request.fields.addAll({
        'd_id': dId.toString(),
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {}
  }

  Future<void> waitingPassanger() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');

      if (dId == null) {}
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/passenger-waiting.php'));
      request.fields.addAll({
        'd_id': dId.toString(),
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
      } else {}
    } catch (error) {
      // Handle the error as needed
    }
  }

// class JobDetailsScreen extends StatefulWidget {
//   final String jobId;

//   JobDetailsScreen({required this.jobId});

//   @override
//   _JobDetailsScreenState createState() => _JobDetailsScreenState();
// }

// class _JobDetailsScreenState extends State<JobDetailsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     fetchJobDetails();
//   }

//   Future<void> fetchJobDetails() async {
//     final response = await http.post(
//       Uri.parse(
//           'https://www.minicaboffice.com/api/driver/check-job-status.php'),
//       body: {'job_id':  jobId},
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == false && data['notification'] != null) {
//         _showInAppNotification(data['notification']);
//       } else {
//         // Handle the job details as normal
//       }
//     } else {
//       // Handle the error
//     }
//   }

//   void _showInAppNotification(Map<String, dynamic> notification) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(notification['title']),
//         content: Text(notification['message']),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Job Details'),
//       ),
//       body: Center(
//         child: Text('Loading job details...'),
//       ),
//     );
//   }
// }
}
