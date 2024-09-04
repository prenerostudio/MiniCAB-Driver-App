import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:mini_cab/Data/links.dart';
import 'package:mini_cab/components/customer_details_widget.dart';
import 'package:mini_cab/home/home_view_controller.dart';
import 'package:mini_cab/home/timer_class.dart';
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

  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late CameraPosition _kGoogle;
  late Timer _locationTimer;
  // final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  Position? _currentPosition;
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
        _currentPosition = position;
        // currentLatitude = position.latitude;
        // currentLongitude = position.longitude;
        print("the current lat long: ${_currentPosition!.latitude}");
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getlocation();
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
      print('the timer is ');
      jobStatus();
    });
    // if (_timer == null || !_timer!.isActive) {

    // }
  }

  Future loadata() async {
    // myController.jobDetails();
    SharedPreferences sp = await SharedPreferences.getInstance();
    isWaiting = sp.getBool('isWaitingTrue') ?? false;
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
        print("after job details $value");
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
        print("No job details found.");
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

  @override
  void dispose() {
    Apitimer?.cancel();
    _model.dispose();

    super.dispose();
  }

  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';
  void checkDriverProximity(double currentLatitude, double currentLongitude,
      double pickupLatitude, double pickupLongitude,
      {double precision = 0.00030}) {
    print(currentLatitude);
    print(pickupLatitude);
    if (isWaiting &&
        ((currentLatitude - pickupLatitude).abs() < precision) &&
        ((currentLongitude - pickupLongitude).abs() < precision)) {
      isRideStarted = true;
      isWaiting = false;
      _model.timerController.onStartTimer();
      print('Ride started');
    } else {
      isRideStarted = true;
      isWaiting = false;
      _model.timerController.onStartTimer();
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
      print('the order socket from backaground:${jsonMap['data']}');

      // });
    });
  }

  late GoogleMapController _mapController;
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
        print('the response is $data');
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
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            title: Text(
              'ON WAY',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 22,
                  ),
            ),
            actions: [
              // TextButton(
              //     onPressed: () {
              //       jobStatus();
              //       // loadata();
              //     },
              //     child: Text('Check job status'))
            ],
            centerTitle: true,
            elevation: 2,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.80,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.60,
                        child: isLoading
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
                                      style: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .primary),
                                    ),
                                  ],
                                ),
                              )
                            : buildMap(),
                      ),
                      Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
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
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 24,
                                    ),
                                    FlutterFlowTimer(
                                      initialTime: _model.timerMilliseconds,
                                      getDisplayTime: (value) =>
                                          StopWatchTimer.getDisplayTime(value,
                                              milliSecond: false),
                                      controller: _model.timerController,
                                      onEnded: () {},
                                      onChanged:
                                          (value, displayTime, shouldUpdate) {
                                        _model.timerMilliseconds = value;
                                        _model.timerValue = displayTime;
                                        if (shouldUpdate) setState(() {});
                                        print(_model.timerValue);
                                      },
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Open Sans',
                                            color: FlutterFlowTheme.of(context)
                                                .info,
                                            fontSize: 18,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              FlutterFlowIconButton(
                                borderColor: FlutterFlowTheme.of(context).info,
                                borderRadius: 20,
                                borderWidth: 1,
                                buttonSize: 40,
                                fillColor: FlutterFlowTheme.of(context).info,
                                icon: Icon(
                                  Icons.menu,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
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
                      Align(
                        alignment: AlignmentDirectional(0.00, 1.35),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 1.0,
                            height: MediaQuery.sizeOf(context).height * 0.4,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Wrap(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize
                                          .min, // Set this to MainAxisSize.min
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 10.0, 0.0, 0.0),
                                          child: Icon(
                                            Icons.pin_drop_outlined,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            size: 25,
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 10.0, 0.0, 20.0),
                                            child: Text(
                                              pickup ?? '--',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Readex Pro',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    fontSize: 20.0,
                                                    letterSpacing: 1.5,
                                                  ),
                                              overflow: TextOverflow
                                                  .ellipsis, // Handle text overflow with ellipsis
                                              maxLines:
                                                  3, // Limit to a maximum of 2 lines
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10, 0, 5, 0),
                                      child: Icon(
                                        Icons.access_time_filled_rounded,
                                        color: Color(0xFF5B68F5),
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      pickTime ?? '--',
                                      style: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .override(
                                            fontFamily: 'Open Sans',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 20,
                                          ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10, 0, 5, 0),
                                      child: FaIcon(
                                        FontAwesomeIcons.calendar,
                                        size: 21,
                                        color: Color(0xFF5B68F5),
                                      ),
                                    ),
                                    Text(
                                      pickDate ?? '--',
                                      style: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .override(
                                            fontFamily: 'Open Sans',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 20,
                                          ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 5, 0),
                                        child: Icon(
                                          Icons.luggage_outlined,
                                          color: Color(0xFF5B68F5),
                                          size: 20,
                                        ),
                                      ),
                                      Text(
                                        luggage ?? '0',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: 'Open Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
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
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20, 0, 5, 0),
                                        child: FaIcon(
                                          FontAwesomeIcons.userFriends,
                                          color: Color(0xFF5B68F5),
                                          size: 18,
                                        ),
                                      ),
                                      Text(
                                        passenger ?? '--',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: 'Open Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 20,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10, 60),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FlutterFlowIconButton(
                                        borderColor: Color(0xFF5B68F5),
                                        borderWidth: 1,
                                        buttonSize: 48,
                                        fillColor: Color(0xFF5B68F5),
                                        icon: FaIcon(
                                          FontAwesomeIcons.ellipsisH,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
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
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child: WaydetailsWidget(
                                                  time: '${pickTime}',
                                                  date: '${pickDate}',
                                                  passanger: '${passenger}',
                                                  cName: '${cName}',
                                                  cnumber: '${cnumber}',
                                                  cemail: '${cemail}',
                                                  luggage: '${luggage}',
                                                  pickup: '${pickup}',
                                                  dropoff: '${dropoff}',
                                                  cNote: '${note}',
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                      ),
                                      FFButtonWidget(
                                        onPressed: () async {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            enableDrag: false,
                                            context: context,
                                            builder: (context) {
                                              return Padding(
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child: ClientnotesWidget(
                                                  name: '${cName}',
                                                  notes: '${note}',
                                                ),
                                              );
                                            },
                                          ).then(
                                              (value) => safeSetState(() {}));
                                        },
                                        text: 'VIEW NOTE',
                                        icon: FaIcon(
                                          FontAwesomeIcons.infoCircle,
                                          size: 21,
                                        ),
                                        options: FFButtonOptions(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                                  0.4,
                                          height: 45,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24, 0, 24, 0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 0, 0, 0),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .override(
                                                    fontFamily: 'Open Sans',
                                                    color: Colors.white,
                                                  ),
                                          elevation: 3,
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: SwipeButton(
                    thumbPadding: EdgeInsets.all(3),
                    thumb: Icon(
                      Icons.chevron_right,
                      color: FlutterFlowTheme.of(context).primary,
                    ),
                    elevationThumb: 2,
                    elevationTrack: 2,
                    activeThumbColor:
                        FlutterFlowTheme.of(context).primaryBackground,
                    activeTrackColor: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(8),
                    child: Text(
                      isRideStarted
                          ? 'POB'
                          : (isWaiting ? 'Arrival Now' : 'Way to Pickup')
                              .toUpperCase(),
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onSwipe: () {
                      setState(() {});
                      print('ststs');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isRideStarted
                              ? 'POB'
                              : (isWaiting ? 'Arrival Now' : 'Way to Pickup')),
                          backgroundColor: FlutterFlowTheme.of(context).primary,
                        ),
                      );
                    },
                    onSwipeEnd: () async {
                      SharedPreferences sp =
                          await SharedPreferences.getInstance();
                      setState(() {});
                      if (isRideStarted) {
                        var request = http.MultipartRequest(
                            'POST',
                            Uri.parse(
                                'https://www.minicaboffice.com/api/driver/calculate-waiting-time.php'));
                        request.fields.addAll({
                          'd_id': '${did}',
                          'job_id': '${jobid}',
                          'waiting_time': _model.timerValue.toString()
                        });

                        try {
                          http.StreamedResponse response = await request.send();

                          if (response.statusCode == 200) {
                            print(await response.stream.bytesToString());
                          } else {
                            print('Error: ${response.reasonPhrase}');
                          }
                        } catch (e) {
                          print('Exception occurred: $e');
                        }
                        _model.timerController.onStopTimer();
                        await sp.setString(
                            'timerValue', _model.timerValue.toString());
                        await sp.setInt('isRideStart', 2);
                        context.pushNamed(
                          'Pob',
                          queryParameters: {
                            'did': serializeParam(
                              '${did}',
                              ParamType.String,
                            ),
                            'jobid': serializeParam(
                              '${jobid}',
                              ParamType.String,
                            ),
                            'pickup': serializeParam(
                              '${pickup}',
                              ParamType.String,
                            ),
                            'dropoff': serializeParam(
                              '${dropoff}',
                              ParamType.String,
                            ),
                            'cName': serializeParam(
                              '${cName}',
                              ParamType.String,
                            ),
                            'fare': serializeParam(
                              '${fare}',
                              ParamType.String,
                            ),
                            'distance': serializeParam(
                              '${distance}',
                              ParamType.String,
                            ),
                            'note': serializeParam(
                              '${note}',
                              ParamType.String,
                            ),
                            'pickTime': serializeParam(
                              '${pickTime}',
                              ParamType.String,
                            ),
                            'pickDate': serializeParam(
                              '${pickDate}',
                              ParamType.String,
                            ),
                            'passenger': serializeParam(
                              '${passenger}',
                              ParamType.String,
                            ),
                            'luggage': serializeParam(
                              '${luggage}',
                              ParamType.String,
                            ),
                            'cnumber': serializeParam(
                              '${cnumber}',
                              ParamType.String,
                            ),
                            'cemail': serializeParam(
                              '${cemail}',
                              ParamType.String,
                            ),
                          }.withoutNulls,
                        );
                        isRideStarted = false;
                        isWaiting = false;
                      } else if (isWaiting) {
                        checkDriverProximity(currentLatitude, currentLongitude,
                            pickupLat, pickupLng);
                      } else {
                        sp.setBool('isWaitingTrue', true);
                        waitingPassanger();
                        print('swipped called');
                        isWaiting = true;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Choose Map Option'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Image.asset(
                                          'assets/images/google.png'), // Replace 'your_image.png' with your image asset path
                                    ),
                                    title: Text('Open in Google Maps'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      MapUtils.navigateTo(pickupLat, pickupLng);
                                    },
                                  ),
                                  ListTile(
                                    leading: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Image.asset(
                                          'assets/images/app_launcher_icon.png'), // Replace 'your_image.png' with your image asset path
                                    ),
                                    title: Text('Using App'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMap() {
    return _currentPosition == null
        ? Center(child: CircularProgressIndicator())
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              zoom: 14,
            ),
            markers: {
              Marker(
                  markerId: const MarkerId('Source'),
                  position: LatLng(
                      _currentPosition!.latitude, _currentPosition!.longitude),
                  icon: sourceicon),
              Marker(
                  markerId: const MarkerId('destination'),
                  position: LatLng(convertedLat, convertedLng),
                  icon: destinationicon),
            },
            myLocationEnabled: true,
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

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    // await _getCurrentLocation();

    // if (_currentPosition == null || pickupLat == null || pickupLng == null) {
    //   print('Current position or pickup location is null');
    //   return;
    // }

    // // Add origin and destination markers
    // markers.add(
    //   Marker(
    //     markerId: MarkerId('origin'),
    //     position:
    //         LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
    //     infoWindow: InfoWindow(title: 'Your Location'),
    //   ),
    // );

    // markers.add(
    //   Marker(
    //     markerId: MarkerId('destination'),
    //     position: LatLng(pickupLat!, pickupLng!),
    //     infoWindow: InfoWindow(title: 'Pickup Location'),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    //   ),
    // );

    // // Fetch directions
    // await _fetchDirections();
  }

  // Future<void> _fetchDirections() async {
  //   final directionsService = DirectionsService();
  //   final request = DirectionsRequest(
  //     origin: '${_currentPosition?.latitude},${_currentPosition?.longitude}',
  //     destination: '${pickupLat},${pickupLng}',
  //   );
  //   print('Request: $request');

  //   directionsService.route(request,
  //       (DirectionsResult? response, DirectionsStatus? status) {
  //     if (status == DirectionsStatus.ok && response != null) {
  //       final encodedPolyline = response.routes![0]?.overviewPolyline?.points;

  //       if (encodedPolyline != null) {
  //         List<LatLng> decodedPoints = decodePolyline(encodedPolyline)!;
  //         print('Decoded points count: ${decodedPoints.length}');

  //         setState(() {
  //           polylines.add(
  //             Polyline(
  //               polylineId: PolylineId('route'),
  //               color: Colors.blue,
  //               width: 5,
  //               points: decodedPoints,
  //             ),
  //           );

  //           // Optionally, adjust the camera to fit the polyline
  //           _adjustCamera(decodedPoints);
  //         });
  //       }
  //     } else {
  //       print('Failed to fetch directions: $status');
  //     }
  //   });
  // }

  // void _adjustCamera(List<LatLng> points) {
  //   if (points.isEmpty) return;

  //   LatLngBounds bounds;
  //   double x0, x1, y0, y1;
  //   x0 = x1 = points[0].latitude;
  //   y0 = y1 = points[0].longitude;

  //   for (LatLng point in points) {
  //     if (point.latitude > x1) x1 = point.latitude;
  //     if (point.latitude < x0) x0 = point.latitude;
  //     if (point.longitude > y1) y1 = point.longitude;
  //     if (point.longitude < y0) y0 = point.longitude;
  //   }

  //   bounds = LatLngBounds(
  //     southwest: LatLng(x0, y0),
  //     northeast: LatLng(x1, y1),
  //   );

  //   _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  // }

  // List<LatLng> decodePolyline(String encoded) {
  //   List<LatLng> points = [];
  //   int index = 0;
  //   int lat = 0, lng = 0;

  //   while (index < encoded.length) {
  //     int b, shift = 0, result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1F) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
  //     lat += dlat;

  //     shift = 0;
  //     result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1F) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
  //     lng += dlng;

  //     double latitude = lat / 1E5;
  //     double longitude = lng / 1E5;
  //     points.add(LatLng(latitude, longitude));
  //   }
  //   return points;
  // }

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
  //   await getLocationFromAddress();

  //   List<LatLng> latLen = [
  //     LatLng(currentLatitude, currentLongitude),
  //     LatLng(pickupLat, pickupLng),
  //   ];

  //   for (int i = 0; i < latLen.length; i++) {
  //     markers.add(
  //       Marker(
  //         markerId: MarkerId(i.toString()),
  //         position: latLen[i],
  //         infoWindow: InfoWindow(
  //           title: i == 0 ? 'Your Location' : 'Pickup Location',
  //         ),
  //         icon: BitmapDescriptor.defaultMarker,
  //       ),
  //     );
  //   }

  //   _polylines.add(
  //     Polyline(
  //       polylineId: PolylineId('1'),
  //       points: latLen,
  //       color: FlutterFlowTheme.of(context as BuildContext).primary,
  //       // Colors.deepOrange,
  //     ),
  //   );

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  Future _getPolyline(double destinationLat, double desLng) async {
    print('tapped');
    const apiKey =
        'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA'; // Replace with your Google Maps API key
    var origin =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}'; // Replace with your source coordinates
    var destination =
        // '31.414050,73.0613070'; // Replace with your destination coordinates // Replace with your destination coordinates
        '${destinationLat},${desLng}'; // Replace with your destination coordinates // Replace with your destination coordinates
    print("the polylines start");
    final response = await http.post(Uri.parse(// can be get and post request
        // 'https://maps.googleapis.com/maps/api/directions/json?origin=31.4064054,73.0413076&destination=31.6404050,73.2413070&key=AIzaSyBBSmpcyEaIojvZznYVNpCU0Htvdabe__Y'));
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);
      // print(data);
      if (data.containsKey('routes') && data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        if (route.containsKey('legs') && route['legs'].isNotEmpty) {
          final leg = route['legs'][0];
          setState(() {});
          if (leg.containsKey('distance')) {
            distance = leg['distance']['text'];
            // time.value = leg['duration']['text'];

            final points = route['overview_polyline']['points'];

            // Decode polyline points and add them to the map
            decodedPoints = PolylinePoints()
                .decodePolyline(points)
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();
            // polylines.value.clear();
            print("the polylines point is $points");
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
        print(
            'convert Latitude: ${convertedLat}, convert longitude: ${convertedLng}');
        setcustommarkeritem();

        _getPolyline(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  double convertedLat = 0;
  double convertedLng = 0;

  Future<void> wayToPickup() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');

      if (dId == null) {
        print('d_id not found in shared preferences.');
      }
      var request = http.MultipartRequest('POST',
          Uri.parse('https://minicaboffice.com/api/driver/way-to-pickup.php'));
      request.fields.addAll({
        'd_id': dId.toString(),
      });

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

  Future<void> waitingPassanger() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');

      if (dId == null) {
        print('d_id not found in shared preferences.');
      }
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/passenger-waiting.php'));
      request.fields.addAll({
        'd_id': dId.toString(),
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error: $error');
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
