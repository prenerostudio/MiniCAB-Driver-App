import 'dart:convert';
import 'dart:developer';

import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:new_minicab_driver/home/home_view_controller.dart';
import 'package:new_minicab_driver/pob/pob_dropOff_veiewModel.dart';

import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/clientnotes_widget.dart';
import '../components/waydetails_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'pob_model.dart';
export 'pob_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'dart:async';
import 'dart:ui' as ui;

class PobWidget extends StatefulWidget {
  const PobWidget({
    Key? key,
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
  }) : super(key: key);

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
  // late GoogleMapController _mapController;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  // Completer<GoogleMapController> _controller = Completer();

  late Timer _locationTimer;

  // final LatLng _currentPosition = LatLng(37.7749, -122.4194);
  // late Position _currentPosition;
  bool isLoading = false;
  double dropffLat = 0;
  double dropffLng = 0;
  // double currentLatitude = 0;
  // double currentLongitude = 0;
  String distance = '';

  // List<Marker> markers = [];
  // List<LatLng> _polylineCoordinates = [];

  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(31.234234, -122.234234),
  );
  Set<Marker> markers = {};
  Set<Polyline> polyline = {};
  LatLng? originlatlng;
  LatLng? destlatlng;
  // LatLngBounds latLngBounds=LatLngBounds(southwest: southwest, northeast: northeast)
  List<LatLng> polylineCoordinate = [];
  PolylinePoints polylinePoints = PolylinePoints();
  @override
  void initState() {
    super.initState();
    pushercallbg();
    loadata().then((s) {});
    sendOnRideRequest();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // dropOffViewModel.getLatLngFromCurrentLocation().then((value) {
    //   dropOffViewModel.kGoogleplay.value = CameraPosition(
    //       target: LatLng(dropOffViewModel.latitude.value,
    //           dropOffViewModel.longitude.value),
    //       zoom: 17);
    // });
    // dropOffViewModel.setcustommarkeritem();

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
    _locationTimer.cancel();
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
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          // appBar: AppBar(
          //   backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          //   automaticallyImplyLeading: false,
          //   title: Text(
          //     'At DropOff',
          //     style: FlutterFlowTheme.of(context).headlineMedium.override(
          //           fontFamily: 'Outfit',
          //           color: FlutterFlowTheme.of(context).primary,
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
                      color: FlutterFlowTheme.of(context).secondaryBackground,
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
                                  color:
                                      FlutterFlowTheme.of(
                                        context,
                                      ).primaryBackground,
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
                                          '$distanceKm',
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
                                                color:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).primary,
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
                                                  '${dropoff}',
                                                  style: FlutterFlowTheme.of(
                                                    context,
                                                  ).labelMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    color:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).secondaryText,
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
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).secondaryBackground,
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
                                                      time: '${pickTime}',
                                                      date: '${pickDate}',
                                                      passanger: '${passenger}',
                                                      cName: '${cName}',
                                                      cnumber: '${cnumber}',
                                                      luggage: '${luggage}',
                                                      pickup: '${pickup}',
                                                      dropoff: '${dropoff}',
                                                      cNote: '${note}',
                                                      cemail: '${cemail}',
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
                                                      name: '${cName}',
                                                      notes: '${note}',
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
                                              color:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                              textStyle: FlutterFlowTheme.of(
                                                context,
                                              ).titleSmall.override(
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
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).primary,
                                        ),
                                        elevationThumb: 2,
                                        elevationTrack: 2,
                                        activeThumbColor:
                                            FlutterFlowTheme.of(
                                              context,
                                            ).primaryBackground,
                                        activeTrackColor:
                                            FlutterFlowTheme.of(
                                              context,
                                            ).primary,
                                        borderRadius: BorderRadius.circular(8),
                                        child: Text(
                                          'AT DROP OFF'.toUpperCase(),
                                          style: TextStyle(
                                            color:
                                                FlutterFlowTheme.of(
                                                  context,
                                                ).primaryBackground,
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
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
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
                                                    '${jobid}',
                                                    ParamType.String,
                                                  ),
                                                  'did': serializeParam(
                                                    '${did}',
                                                    ParamType.String,
                                                  ),
                                                  'fare': serializeParam(
                                                    '${fare}',
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
                              //       color: FlutterFlowTheme.of(context).primary,
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
  String address = '';
  _getpolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: "AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA",
      request: PolylineRequest(
        origin: PointLatLng(originlatlng!.latitude, originlatlng!.longitude),
        destination: PointLatLng(
          dropOffViewModel.convertedLat.value,
          dropOffViewModel.convertedLng.value,
        ),
        mode: TravelMode.driving,
      ),
    );
    polylineCoordinate.clear();

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinate.add(LatLng(point.latitude, point.longitude));
      });
    }
    double distanceinKm = result.totalDistanceValue! / 1600;
    distanceKm = "${distanceinKm.toStringAsFixed(1)} miles";
    address = result.endAddress.toString();
    polyline.add(
      Polyline(
        polylineId: PolylineId('polyline'),
        color: Colors.blue,
        width: 10,
        points: polylineCoordinate,
      ),
    );
    googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(originlatlng!, 16),
    );
    setState(() {});
  }

  Future<void> saveRouteToStorage(List<LatLng> route) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> routeData =
        route.map((point) => '${point.latitude},${point.longitude}').toList();
    print("the saved route is ${routeData}");
    await prefs.setStringList('user_route', routeData);
  }

  void stopRideTracking() {
    _positionStreamSubscription?.cancel();
    setState(() {});
    // Save route to SharedPreferences (or pass directly to the next screen)
    saveRouteToStorage(userRoute);
  }

  Set<Circle> geofenceCircles = {}; // Set for geofence circles
  void addGeofenceCircle() {
    // Add a circle around the destination
    geofenceCircles.add(
      Circle(
        circleId: CircleId('destination_geofence'),
        center: originlatlng!, // Destination LatLng
        radius: 100, // Radius in meters
        strokeWidth: 2, // Border width
        strokeColor: Colors.blue.withOpacity(0.5), // Border color
        fillColor: Colors.blue.withOpacity(0.2), // Fill color
      ),
    );
    setState(() {});
  }

  List<LatLng> userRoute = [];
  StreamSubscription<Position>? _positionStreamSubscription;
  Future getLiveLocationAndlistner() async {
    userRoute.clear(); // Clear old routes if any
    _positionStreamSubscription = Geolocator.getPositionStream().listen((
      position,
    ) {
      setState(() {});

      originlatlng = LatLng(position.latitude, position.longitude);
      LatLng currentPosition = LatLng(position.latitude, position.longitude);
      userRoute.add(currentPosition);
      // print("the user route is ${userRoute}");
      initialCameraPosition = CameraPosition(target: originlatlng!, zoom: 15);
      setCustomMarkerForCurrent();
      // if (destlatlng != null) {
      _getpolylines();
      // }
      addGeofenceCircle();

      // Check proximity to destination
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        dropOffViewModel.convertedLat.value, // Destination latitude
        dropOffViewModel.convertedLng.value, // Destination longitude
      );
      log('the distance in meter is ${distanceInMeters}');
      if (distanceInMeters <= 200) {
        // isReached = true;
        // if (isReached) {
        //   _showArrivalAlert(); // Show alert if within 200 meters
        // }
      }
      markers.removeWhere(
        (element) => element.mapsId.value.compareTo('origin') == 0,
      );
      markers.add(
        Marker(
          markerId: MarkerId('origin'),
          position: originlatlng!,
          icon: sourceicon,
        ),
      );
      markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position:
              LatLng(
                dropOffViewModel.convertedLat.value,
                dropOffViewModel.convertedLng.value,
              )!,
          icon: destination,
        ),
      );
    });
  }

  BitmapDescriptor sourceicon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destination = BitmapDescriptor.defaultMarker;
  void setCustomMarkerForCurrent() async {
    sourceicon = await _resizeAndCreateBitmapDescriptor(
      "assets/images/car2.png",
      width: 120, // Set desired width
      height: 120, // Set desired height
    );

    destination = await _resizeAndCreateBitmapDescriptor(
      "assets/images/userg.png",
      width: 70,
      height: 70,
    );
  }

  Future<BitmapDescriptor> _resizeAndCreateBitmapDescriptor(
    String imagePath, {
    required int width,
    required int height,
  }) async {
    final ByteData data = await rootBundle.load(imagePath);
    final Uint8List bytes = data.buffer.asUint8List();

    // Decode and resize the image
    final img.Image? originalImage = img.decodeImage(bytes);
    if (originalImage == null) throw Exception("Failed to decode image");
    final img.Image resizedImage = img.copyResize(
      originalImage,
      width: width,
      height: height,
    );

    // Convert resized image back to Uint8List
    final Uint8List resizedBytes = Uint8List.fromList(
      img.encodePng(resizedImage),
    );

    // Convert to BitmapDescriptor
    final ui.Codec codec = await ui.instantiateImageCodec(resizedBytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData = await frameInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  late GoogleMapController googleMapController;
  Widget buildMap() {
    return
    //  initialCameraPosition == null
    //     ? Center(
    //         child: CircularProgressIndicator(),
    //       )
    //     :
    GoogleMap(
      // circles: geofenceCircles,
      initialCameraPosition: initialCameraPosition!,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      mapType: MapType.satellite, // Keep this as 'normal' (not satellite etc.)
      tiltGesturesEnabled: true,
      compassEnabled: true,
      rotateGesturesEnabled: true,

      buildingsEnabled: true, // 3D buildings dikhayein
      scrollGesturesEnabled: true,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      // onCameraMove: _onCameraMove,
      onMapCreated: (controller) {
        googleMapController = controller;
        setState(() {});
        // dropOffViewModel.setMapController(controller);
      },
      markers: markers,
      // markers: Set<Marker>.of(markers),
      polylines: polyline,
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
        await dropOffViewModel.mapApicall().then((s) {
          Future.delayed(Duration(seconds: 2)).then((s) {
            setState(() {});
          });
        });
        await getLiveLocationAndlistner();
        // setcustommarkeritem();

        // _getPolyline(locations.first.latitude, locations.first.longitude);
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
  final apiKey = 'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA';

  List<LatLng> decodedPoints = <LatLng>[];
  // BitmapDescriptor sourceicon = BitmapDescriptor.defaultMarker;
  // BitmapDescriptor destinationicon = BitmapDescriptor.defaultMarker;
  Future<void> sendOnRideRequest() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://minicaboffice.com/api/driver/on-ride.php'),
      );
      request.fields.addAll({'d_id': dId.toString()});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
      } else {}
    } catch (error) {}
  }

  pushercallbg() async {
    var pusher = PusherClient(
      '28691ac9c0c5ac41b64a',
      const PusherOptions(
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

  Future<void> jobStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    String? jobId = prefs.getString('jobId');
    try {
      final response = await http.post(
        Uri.parse(
          'https://www.minicaboffice.com/api/driver/check-job-status.php',
        ),
        body: {'d_id': dId.toString(), 'job_id': jobId.toString()},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == false) {
          prefs.remove("isRideStart");
          setState(() {});
          myController.visiblecontainer.value = false;
          myController.polylines.clear();
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
