import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_cab/Data/links.dart';
import 'package:mini_cab/components/customer_details_widget.dart';
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
  const OnWayWidget({
    Key? key,
    required this.did,
    required this.jobid,
    required this.pickup,
    required this.dropoff,
    required this.cName,
    required this.fare,
    required this.distance,
    required this.note,
    required this.pickTime,
    required this.pickDate,
    required this.passenger,
    required this.luggage,
    required this.cnumber,
    required this.cemail,
  }) : super(key: key);

  final String? did;
  final String jobid;
  final String? pickup;
  final String? dropoff;
  final String? cName;
  final String? fare;
  final String? distance;
  final String? note;
  final String? pickTime;
  final String? pickDate;
  final String? passenger;
  final String? luggage;
  final String? cnumber;
  final String? cemail;

  @override
  _OnWayWidgetState createState() => _OnWayWidgetState();
}

class _OnWayWidgetState extends State<OnWayWidget> {
  late OnWayModel _model;
  late double pickupLat;
  late double pickupLng;
  late double currentLatitude;
  late double currentLongitude;

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  List<Marker> markers = [];
  List<LatLng> _polylineCoordinates = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  late CameraPosition _kGoogle;
  late Timer _locationTimer;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  late Position _currentPosition;
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
String jobId='';
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







  @override
  void initState() {
    super.initState();
    recive_jobidid;
    wayToPickup();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _setupMarkersAndPolylines();
    _model = createModel(context as BuildContext, () => OnWayModel());
  }

  recive_jobidid() async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance() as SharedPreferences;

    jobId=widget.jobid.toString();
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
      Fluttertoast.showToast(
        msg: "You are not near the customer location",
      );
    }
  }

  late GoogleMapController _mapController;
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
            actions: [],
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
                                      onChanged:
                                          (value, displayTime, shouldUpdate) {
                                        _model.timerMilliseconds = value;
                                        _model.timerValue = displayTime;
                                        if (shouldUpdate) setState(() {});
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
                                          cname: '${widget.cName}',
                                          cNumber: '${widget.cnumber}',
                                          cemail: '${widget.cemail}',
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
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(
                                                  10.0, 10.0, 0.0, 0.0),
                                          child: Icon(
                                            Icons.pin_drop_outlined,
                                            color:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            size: 25,
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: EdgeInsetsDirectional
                                                .fromSTEB(
                                                    10.0, 10.0, 0.0, 20.0),
                                            child: Text(
                                              '${widget.pickup}',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily:
                                                        'Readex Pro',
                                                    color:
                                                        FlutterFlowTheme.of(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              10, 0, 5, 0),
                                      child: Icon(
                                        Icons.access_time_filled_rounded,
                                        color: Color(0xFF5B68F5),
                                        size: 20,
                                      ),
                                    ),
                                    Text(
                                      '${widget.pickTime}',
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
                                    Padding(
                                      padding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              10, 0, 5, 0),
                                      child: FaIcon(
                                        FontAwesomeIcons.calendar,
                                        size: 21,
                                        color: Color(0xFF5B68F5),
                                      ),
                                    ),
                                    Text(
                                      '${widget.pickDate}',
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
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 8, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                10, 0, 5, 0),
                                        child: Icon(
                                          Icons.luggage_outlined,
                                          color: Color(0xFF5B68F5),
                                          size: 20,
                                        ),
                                      ),
                                      Text(
                                        '${widget.luggage ?? '0'}',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: 'Open Sans',
                                              color: FlutterFlowTheme.of(
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
                                        padding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                20, 0, 5, 0),
                                        child: FaIcon(
                                          FontAwesomeIcons.userFriends,
                                          color: Color(0xFF5B68F5),
                                          size: 18,
                                        ),
                                      ),
                                      Text(
                                        '${widget.passenger}',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: 'Open Sans',
                                              color: FlutterFlowTheme.of(
                                                      context)
                                                  .primaryText,
                                              fontSize: 20,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 10, 10,60),
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
                                          color:
                                              FlutterFlowTheme.of(context)
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
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child: WaydetailsWidget(
                                                  time:
                                                      '${widget.pickTime}',
                                                  date:
                                                      '${widget.pickDate}',
                                                  passanger:
                                                      '${widget.passenger}',
                                                  cName: '${widget.cName}',
                                                  cnumber:
                                                      '${widget.cnumber}',
                                                  cemail:
                                                      '${widget.cemail}',
                                                  luggage:
                                                      '${widget.luggage}',
                                                  pickup:
                                                      '${widget.pickup}',
                                                  dropoff:
                                                      '${widget.dropoff}',
                                                  cNote: '${widget.note}',
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
                                                padding:
                                                    MediaQuery.viewInsetsOf(
                                                        context),
                                                child: ClientnotesWidget(
                                                  name: '${widget.cName}',
                                                  notes: '${widget.note}',
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
                                          width: MediaQuery.sizeOf(context)
                                                  .width *
                                              0.4,
                                          height: 45,
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(24, 0, 24, 0),
                                          iconPadding: EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 0, 0),
                                          color:
                                              FlutterFlowTheme.of(context)
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
                ),Positioned(bottom: 0,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child:
                      SwipeButton(
                        thumbPadding: EdgeInsets.all(3),
                        thumb: Icon(
                          Icons.chevron_right,
                          color: FlutterFlowTheme.of(context)
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
                        borderRadius: BorderRadius.circular(8),
                        child: Text(
                          isRideStarted
                              ? 'POB'
                              : (isWaiting
                              ? 'Arrival Now'
                              : 'Way to Pickup')
                              .toUpperCase(),
                          style: TextStyle(
                            color: FlutterFlowTheme.of(context)
                                .primaryBackground,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onSwipe: () {setState(() {

                        });
                        print('ststs');
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(isRideStarted
                                ? 'POB'
                                : (isWaiting
                                ? 'Arrival Now'
                                : 'Way to Pickup')),
                            backgroundColor:
                            FlutterFlowTheme.of(context)
                                .primary,
                          ),
                        );
                        },
                        onSwipeEnd: () {
                          setState(() async {
                            if (isRideStarted) {
                              var request = http.MultipartRequest(
                                  'POST',
                                  Uri.parse(
                                      'https://www.minicaboffice.com/api/driver/calculate-waiting-time.php'));
                              request.fields.addAll({
                                'd_id': '${widget.did}',
                                'job_id': '${widget.jobid}',
                                'waiting_time':
                                '${_model.timerValue.toString()}'
                              });

                              try {
                                http.StreamedResponse response =
                                await request.send();

                                if (response.statusCode ==
                                    200) {
                                  print(await response.stream
                                      .bytesToString());
                                } else {
                                  print(
                                      'Error: ${response.reasonPhrase}');
                                }
                              } catch (e) {
                                print('Exception occurred: $e');
                              }
                              _model.timerController
                                  .onStopTimer();
                              context.pushNamed(
                                'Pob',
                                queryParameters: {
                                  'did': serializeParam(
                                    '${widget.did}',
                                    ParamType.String,
                                  ),
                                  'jobid': serializeParam(
                                    '${widget.jobid}',
                                    ParamType.String,
                                  ),
                                  'pickup': serializeParam(
                                    '${widget.pickup}',
                                    ParamType.String,
                                  ),
                                  'dropoff': serializeParam(
                                    '${widget.dropoff}',
                                    ParamType.String,
                                  ),
                                  'cName': serializeParam(
                                    '${widget.cName}',
                                    ParamType.String,
                                  ),
                                  'fare': serializeParam(
                                    '${widget.fare}',
                                    ParamType.String,
                                  ),
                                  'distance': serializeParam(
                                    '${widget.distance}',
                                    ParamType.String,
                                  ),
                                  'note': serializeParam(
                                    '${widget.note}',
                                    ParamType.String,
                                  ),
                                  'pickTime': serializeParam(
                                    '${widget.pickTime}',
                                    ParamType.String,
                                  ),
                                  'pickDate': serializeParam(
                                    '${widget.pickDate}',
                                    ParamType.String,
                                  ),
                                  'passenger': serializeParam(
                                    '${widget.passenger}',
                                    ParamType.String,
                                  ),
                                  'luggage': serializeParam(
                                    '${widget.luggage}',
                                    ParamType.String,
                                  ),
                                  'cnumber': serializeParam(
                                    '${widget.cnumber}',
                                    ParamType.String,
                                  ),
                                  'cemail': serializeParam(
                                    '${widget.cemail}',
                                    ParamType.String,
                                  ),
                                }.withoutNulls,
                              );
                              isRideStarted = false;
                              isWaiting = false;
                            }
                            else if (isWaiting) {
                              checkDriverProximity(
                                  currentLatitude,
                                  currentLongitude,
                                  pickupLat,
                                  pickupLng);
                            }
                            else {
                              waitingPassanger();
                              isWaiting = true;
                              showDialog(
                                context: context,
                                builder:
                                    (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Choose Map Option'),
                                    content: Column(
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: Image.asset(
                                                'assets/images/google.png'), // Replace 'your_image.png' with your image asset path
                                          ),
                                          title: Text(
                                              'Open in Google Maps'),
                                          onTap: () {
                                            Navigator.pop(
                                                context);
                                            MapUtils.navigateTo(
                                                pickupLat,
                                                pickupLng);
                                          },
                                        ),
                                        ListTile(
                                          leading: SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: Image.asset(
                                                'assets/images/app_launcher_icon.png'), // Replace 'your_image.png' with your image asset path
                                          ),

                                          title:
                                          Text('Using App'),
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
                            }
                          });
                        },
                      ),


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
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          _currentPosition?.latitude ?? 0.0,
          _currentPosition?.longitude ?? 0.0,
        ),
        zoom: 14,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      compassEnabled: true,
      rotateGesturesEnabled: true,
      tiltGesturesEnabled: true,
      scrollGesturesEnabled: true,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      onMapCreated: _onMapCreated,
      markers: Set<Marker>.of(markers),
      polylines: Set<Polyline>.of([
        Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          width: 5,
          points: _polylineCoordinates,
        ),
      ]),
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    await _getCurrentLocation();
    setState(() {
      _mapController = controller;
    });

    final directionsService = DirectionsService();
    final request = DirectionsRequest(
      origin: '${_currentPosition?.latitude} ,${_currentPosition?.longitude}',
      destination: '${widget.pickup}',
    );

    directionsService.route(request,
        (DirectionsResult? response, DirectionsStatus? status) {
      if (status == DirectionsStatus.ok && response != null) {
        setState(() {
          final encodedPolyline = response.routes![0]?.overviewPolyline?.points;

          if (encodedPolyline != null) {
            _polylineCoordinates = decodePolyline(encodedPolyline)!;

            markers.add(
              Marker(
                markerId: MarkerId('origin'),
                position: LatLng(
                  response.routes![0]!.legs![0].startLocation!.latitude,
                  response.routes![0]!.legs![0].startLocation!.longitude,
                ),
              ),
            );
            markers.add(
              Marker(
                markerId: MarkerId('destination'),
                position: LatLng(
                  response.routes![0]!.legs![0].endLocation!.latitude,
                  response.routes![0]!.legs![0].endLocation!.longitude,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
            );
          }
        });
      } else {
        print('Failed to fetch directions: $status');
      }
    });
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int lat = 0, lng = 0;

    while (index < encoded.length) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      points.add(LatLng(latitude, longitude));
    }
    return points;
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

    await getLocationFromAddress();

    List<LatLng> latLen = [
      LatLng(currentLatitude, currentLongitude),
      LatLng(pickupLat, pickupLng),
    ];

    for (int i = 0; i < latLen.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: latLen[i],
          infoWindow: InfoWindow(
            title: i == 0 ? 'Your Location' : 'Pickup Location',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }

    _polylines.add(
      Polyline(
        polylineId: PolylineId('1'),
        points: latLen,
        color: FlutterFlowTheme.of(context as BuildContext).primary,
        // Colors.deepOrange,
      ),
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getLocationFromAddress() async {
    final apiKey = 'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA';
    final apiUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
    final address = widget.pickup;
    final response = await http.post(
      Uri.parse('$apiUrl?address=$address&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);

      if (decodedData['status'] == 'OK') {
        final results = decodedData['results'][0];
        final geometry = results['geometry'];
        final location = geometry['location'];
        pickupLat = location['lat'];
        pickupLng = location['lng'];
        print('Latitude pickup: $pickupLat');
        print('Longitude pickup: $pickupLng');
      } else {
        print('Error: ${decodedData['status']}');
      }
    } else {
      print('HTTP Request Error: ${response.statusCode}');
    }
  }
}


class JobDetailsScreen extends StatefulWidget {
  final String jobId;

  JobDetailsScreen({required this.jobId});

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {

  @override
  void initState() {
    super.initState();
    fetchJobDetails();
  }

  Future<void> fetchJobDetails() async {
    final response = await http.post(
      Uri.parse('https://www.minicaboffice.com/api/driver/check-job-status.php'),
      body: {'job_id': widget.jobId},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == false && data['notification'] != null) {
        _showInAppNotification(data['notification']);
      } else {
        // Handle the job details as normal
      }
    } else {
      // Handle the error
    }
  }

  void _showInAppNotification(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification['title']),
        content: Text(notification['message']),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: Center(
        child: Text('Loading job details...'),
      ),
    );
  }
}