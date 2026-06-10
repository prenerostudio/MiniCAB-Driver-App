import 'dart:convert';
import 'dart:developer';

import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:new_minicab_driver/home/home_view_controller.dart';
import 'package:new_minicab_driver/mapbox/mapbox_route_map.dart';
import 'package:new_minicab_driver/pob/pob_dropOff_veiewModel.dart';

import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/clientnotes_widget.dart';
import '../components/waydetails_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pob_model.dart';
export 'pob_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'package:new_minicab_driver/Data/api_service.dart';

class PobWidget extends StatefulWidget {
  const PobWidget({
    super.key,
    // required this.did,
    // required this.jobid,
    // required this.pickup,
    // required this.dropoff,
    // required this.cName,
    // required this.fare,
    // required this.distance,
    // required this.note,
    // required this.pickTime,
    // required this.pickDate,
    // required this.passenger,
    // required this.luggage,
    // required this.cnumber,
    // required this.cemail,
  });

  // final String? did;
  // final String? jobid;
  // final String? pickup;
  // final String? dropoff;
  // final String? cName;
  // final String? fare;
  // final String? distance;
  // final String? note;
  // final String? pickTime;
  // final String? pickDate;
  // final String? passenger;
  // final String? luggage;
  // final String? cnumber;
  // final String? cemail;

  @override
  _PobWidgetState createState() => _PobWidgetState();
}

class _PobWidgetState extends State<PobWidget> {
  late PobModel _model;

  String distanceText = '';
  String durationText = '';

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Timer? _locationTimer;

  bool isLoading = false;
  double dropffLat = 0;
  double dropffLng = 0;
  // double currentLatitude = 0;
  // double currentLongitude = 0;
  String distance = '';

  LatLng? originlatlng;
  List<LatLng> polylineCoordinate = [];
  Uint8List? _driverMarkerImage;
  Uint8List? _destinationMarkerImage;
  @override
  void initState() {
    super.initState();
    pushercallbg();
    loadata().then((s) {});
    sendOnRideRequest();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _model = createModel(context, () => PobModel());
  }

  double pickupLat = 0.0;
  double pickupLng = 0.0;
  final JobController myController = Get.put(JobController());

  String? did;
  String? jobid;
  String? pickup;
  String dropoff = '--';
  String? cName;
  String? fare;

  String? note;
  String? pickTime;
  String? pickDate;
  String? passenger;
  String? luggage;
  String? cnumber;
  String? cemail;
  Future loadata() async {
    // myController.jobDetails();
    SharedPreferences sp = await SharedPreferences.getInstance();
    // isWaiting = sp.getBool('isWaitingTrue') ?? false;
    setState(() {});

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
      } else {
        // Handle the null case, e.g., show an error message, redirect, etc.
      }
    });
    await getCoordinatesFromAddress(dropoff);
  }

  @override
  void dispose() {
    _model.dispose();
    _locationTimer?.cancel();
    _positionStreamSubscription?.cancel();
    super.dispose();
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
      onTap:
          () =>
              _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: context.appTheme.primaryBackground,
          // appBar: AppBar(
          //   backgroundColor: context.appTheme.primaryBackground,
          //   automaticallyImplyLeading: false,
          //   title: Text(
          //     'At DropOff',
          //     style: context.appTheme.headlineMedium.override(
          //           fontFamily: 'Outfit',
          //           color: context.appTheme.primary,
          //           fontSize: 22,
          //         ),
          //   ),
          //   actions: [],
          //   centerTitle: true,
          //   elevation: 2,
          // ),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.96,
                    decoration: BoxDecoration(
                      color: context.appTheme.secondaryBackground,
                    ),
                    child: Stack(
                      children: [
                        buildMap(),

                        // _buildTopNavigationBox(), // Display the navigation box
                        Positioned(
                          bottom: 0,
                          child: Row(
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.30,
                                decoration: BoxDecoration(
                                  color: context.appTheme.primaryBackground,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 15),
                                        Text(
                                          'Remaining Distance:',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          distanceKm,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        // Container(
                                        //   height: 20,
                                        //   width: 1,
                                        //   color: Colors.black,
                                        // ),
                                        // Column(
                                        //   children: [
                                        //     Text(
                                        //       'Arrival Time',
                                        //       style: TextStyle(
                                        //           fontSize: 15,
                                        //           fontWeight: FontWeight.bold),
                                        //     ),
                                        //     Text(
                                        //       '$arrivalTime',
                                        //       style: TextStyle(
                                        //         fontSize: 13,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // )
                                      ],
                                    ),
                                    // // Text('Distance: $estDistance'),
                                    // // Text('Duration: $duration'),
                                    // // Text('Arrival Time: $arrivalTime'),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),
                                    // Text(
                                    //   overflow: TextOverflow.ellipsis,
                                    //   maxLines: 2,
                                    //   'Address: $pickup $pickup $pickup',
                                    //   style: TextStyle(
                                    //       fontSize: 11,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    Wrap(
                                      children: [
                                        Row(
                                          mainAxisSize:
                                              MainAxisSize
                                                  .min, // Set this to MainAxisSize.min
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    10.0,
                                                    10.0,
                                                    0.0,
                                                    10.0,
                                                  ),
                                              child: Icon(
                                                Icons.pin_drop_outlined,
                                                color: context.appTheme.primary,
                                                size: 25,
                                              ),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      10.0,
                                                      10.0,
                                                      0.0,
                                                      20.0,
                                                    ),
                                                child: Text(
                                                  dropoff,
                                                  style: context
                                                      .appTheme
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        color:
                                                            context
                                                                .appTheme
                                                                .secondaryText,
                                                        fontSize: 20.0,
                                                        letterSpacing: 1.5,
                                                      ),
                                                  overflow:
                                                      TextOverflow
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
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        10,
                                        10,
                                        10,
                                        0,
                                      ),
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
                                                  context
                                                      .appTheme
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
                                                          context,
                                                        ),
                                                    child: WaydetailsWidget(
                                                      time: '$pickTime',
                                                      date: '$pickDate',
                                                      passanger: '$passenger',
                                                      cName: '$cName',
                                                      cnumber: '$cnumber',
                                                      luggage: '$luggage',
                                                      pickup: '$pickup',
                                                      dropoff: dropoff,
                                                      cNote: '$note',
                                                      cemail: '$cemail',
                                                    ),
                                                  );
                                                },
                                              ).then(
                                                (value) => safeSetState(() {}),
                                              );
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
                                                          context,
                                                        ),
                                                    child: ClientnotesWidget(
                                                      name: '$cName',
                                                      notes: '$note',
                                                    ),
                                                  );
                                                },
                                              ).then(
                                                (value) => safeSetState(() {}),
                                              );
                                            },
                                            text: 'VIEW NOTE',
                                            icon: FaIcon(
                                              FontAwesomeIcons.infoCircle,
                                              size: 21,
                                            ),
                                            options: FFButtonOptions(
                                              width:
                                                  MediaQuery.sizeOf(
                                                    context,
                                                  ).width *
                                                  0.4,
                                              height: 45,
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    24,
                                                    0,
                                                    24,
                                                    0,
                                                  ),
                                              iconPadding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              color: context.appTheme.primary,
                                              textStyle: context
                                                  .appTheme
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
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        15,
                                        20,
                                        15,
                                        0,
                                      ),
                                      child: SwipeButton(
                                        thumbPadding: EdgeInsets.all(3),
                                        thumb: Icon(
                                          Icons.chevron_right,
                                          color: context.appTheme.primary,
                                        ),
                                        elevationThumb: 2,
                                        elevationTrack: 2,
                                        activeThumbColor:
                                            context.appTheme.primaryBackground,
                                        activeTrackColor:
                                            context.appTheme.primary,
                                        borderRadius: BorderRadius.circular(8),
                                        child: Text(
                                          'AT DROP OFF'.toUpperCase(),
                                          style: TextStyle(
                                            color:
                                                context
                                                    .appTheme
                                                    .primaryBackground,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onSwipe: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text('AT DROP OFF'),
                                              backgroundColor:
                                                  context.appTheme.primary,
                                            ),
                                          );
                                        },
                                        onSwipeEnd: () async {
                                          SharedPreferences sp =
                                              await SharedPreferences.getInstance();
                                          stopRideTracking();
                                          await sp.setString(
                                            'jobAtDropOffTime',
                                            formattedTime,
                                          );
                                          sp.setInt('isRideStart', 3);
                                          context.pushNamed(
                                            'PaymentEntery',
                                            queryParameters:
                                                {
                                                  'jobid': serializeParam(
                                                    '$jobid',
                                                    ParamType.String,
                                                  ),
                                                  'did': serializeParam(
                                                    '$did',
                                                    ParamType.String,
                                                  ),
                                                  'fare': serializeParam(
                                                    '$fare',
                                                    ParamType.String,
                                                  ),
                                                }.withoutNulls,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                                        padding: MediaQuery.viewInsetsOf(
                                          context,
                                        ),
                                        child: ClientnotesWidget(
                                          name: '$cName',
                                          notes: '$note',
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: context.appTheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.info_outline,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 8),

                              // Container(
                              //   height: 40,
                              //   width: 40,
                              //   decoration: BoxDecoration(
                              //       color: context.appTheme.primary,
                              //       shape: BoxShape.circle),
                              //   child: Center(
                              //     child: Transform.rotate(
                              //       angle: _cameraRotation *
                              //           (3.14159265359 /
                              //               180), // Convert heading to radians
                              //       child: Icon(
                              //         Icons.navigation,
                              //         size: 30,
                              //         color: Colors.red,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(height: 8),
                              // Container(
                              //   height: 40,
                              //   width: 40,
                              //   decoration: BoxDecoration(
                              //       color: Colors.black, shape: BoxShape.circle),
                              // )
                            ],
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
      ),
    );
  }

  String distanceKm = '';

  Future<void> _refreshMapboxRoute() async {
    final origin = originlatlng;
    final destinationLat = dropOffViewModel.convertedLat.value;
    final destinationLng = dropOffViewModel.convertedLng.value;
    if (origin == null || destinationLat == 0.0 || destinationLng == 0.0) {
      return;
    }

    final destinationPoint = LatLng(destinationLat, destinationLng);
    final route = await fetchMapboxRoute(
      origin: origin,
      destination: destinationPoint,
    );
    polylineCoordinate = route?.points ?? [origin, destinationPoint];
    distanceKm = route?.distanceText ?? distanceKm;
    setState(() {});
  }

  Future<void> saveRouteToStorage(List<LatLng> route) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> routeData =
        route.map((point) => '${point.latitude},${point.longitude}').toList();
    print("the saved route is $routeData");
    await prefs.setStringList('user_route', routeData);
  }

  void stopRideTracking() {
    _positionStreamSubscription?.cancel();
    setState(() {});
    // Save route to SharedPreferences (or pass directly to the next screen)
    saveRouteToStorage(userRoute);
  }

  List<LatLng> userRoute = [];
  StreamSubscription<Position>? _positionStreamSubscription;
  Future getLiveLocationAndlistner() async {
    await _positionStreamSubscription?.cancel();
    userRoute.clear(); // Clear old routes if any
    _positionStreamSubscription = Geolocator.getPositionStream().listen((
      position,
    ) async {
      setState(() {});

      originlatlng = LatLng(position.latitude, position.longitude);
      LatLng currentPosition = LatLng(position.latitude, position.longitude);
      userRoute.add(currentPosition);
      // print("the user route is ${userRoute}");
      await setCustomMarkerForCurrent();
      await _refreshMapboxRoute();

      // Check proximity to destination
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        dropOffViewModel.convertedLat.value, // Destination latitude
        dropOffViewModel.convertedLng.value, // Destination longitude
      );
      log('the distance in meter is $distanceInMeters');
      if (distanceInMeters <= 200) {
        // isReached = true;
        // if (isReached) {
        //   _showArrivalAlert(); // Show alert if within 200 meters
        // }
      }
    });
  }

  Future<void> setCustomMarkerForCurrent() async {
    _driverMarkerImage ??= await loadResizedAssetBytes(
      "assets/images/car2.png",
      width: 120, // Set desired width
      height: 120, // Set desired height
    );

    _destinationMarkerImage ??= await loadResizedAssetBytes(
      "assets/images/userg.png",
      width: 70,
      height: 70,
    );
  }

  Widget buildMap() {
    return MapboxRouteMap(
      center:
          originlatlng ??
          LatLng(
            dropOffViewModel.latitude.value != 0.0
                ? dropOffViewModel.latitude.value
                : 51.5074,
            dropOffViewModel.longitude.value != 0.0
                ? dropOffViewModel.longitude.value
                : -0.1278,
          ),
      route: polylineCoordinate,
      initialZoom: 15,
      fitRoute: polylineCoordinate.length > 1,
      followCenter: polylineCoordinate.length <= 1,
      routeColor: Colors.blue,
      markers: [
        if (originlatlng != null)
          MapboxRouteMarker(
            id: 'origin',
            point: originlatlng!,
            image: _driverMarkerImage,
            color: context.appTheme.primary,
            iconSize: 0.58,
          ),
        if (dropOffViewModel.convertedLat.value != 0.0 &&
            dropOffViewModel.convertedLng.value != 0.0)
          MapboxRouteMarker(
            id: 'destination',
            point: LatLng(
              dropOffViewModel.convertedLat.value,
              dropOffViewModel.convertedLng.value,
            ),
            image: _destinationMarkerImage,
            color: const Color(0xFF1F7A5B),
          ),
      ],
    );
  }

  DropOffViewModel dropOffViewModel = Get.put(DropOffViewModel());

  Future getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {});
        dropOffViewModel.convertedLat.value = locations.first.latitude;
        dropOffViewModel.convertedLng.value = locations.first.longitude;
        final currentLatLng =
            await dropOffViewModel.getLatLngFromCurrentLocation();
        if (currentLatLng != null) {
          originlatlng = currentLatLng;
          await setCustomMarkerForCurrent();
          await _refreshMapboxRoute();
        }
        await dropOffViewModel.mapApicall().then((s) {
          Future.delayed(Duration(seconds: 2)).then((s) {
            setState(() {});
          });
        });
        await getLiveLocationAndlistner();
      }
    } catch (e) {}
  }

  String stripHtmlTags(String html) {
    final regExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return html.replaceAll(regExp, '').trim();
  }

  String formattedTime = "";
  // List<dynamic> _instructions = [];
  String estDistance = 'Calculating...';
  String duration = 'Calculating...';
  String arrivalTime = 'Calculating...';
  Future<void> sendOnRideRequest() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverOnRide),
      );
      request.fields.addAll({'d_id': dId.toString()});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
      } else {}
    } catch (error) {}
  }

  Future<void> pushercallbg() async {
    var pusher = PusherClient(
      'ef80ba163503f394d9c3',
      const PusherOptions(
        host: ApiService.driverCheckJobStatus,
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

    var dispatchChannel = pusher.subscribe('dispatch-booking');
    dispatchChannel.bind('booking-withdraw', (event) {
      jobStatus();
    });
  }

  Future<void> jobStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    String? jobId = prefs.getString('jobId');
    try {
      final response = await http.post(
        Uri.parse(ApiService.driverCheckJobStatus),
        body: {'d_id': dId.toString(), 'job_id': jobId.toString()},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == false) {
          prefs.remove("isRideStart");
          setState(() {});
          myController.visiblecontainer.value = false;
          myController.clearNavigationRoute();
          context.pushNamed('Home');
        } else {
          // Handle the job details as normal
        }
      } else {
        // Handle the error
      }
    } catch (e) {}
  }

  String distance1 = '';
  String? originAddresses;
  String? destinationAddresses;
}
