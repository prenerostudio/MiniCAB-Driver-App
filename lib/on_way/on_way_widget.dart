import 'dart:developer';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image/image.dart' as img;
import 'package:get/get.dart';
import 'package:new_minicab_driver/Data/links.dart';
import 'package:new_minicab_driver/components/customer_details_widget.dart';
import 'package:new_minicab_driver/home/home_view_controller.dart';
import 'package:new_minicab_driver/home/timer_class.dart';
import 'package:new_minicab_driver/on_way/onway_view_model.dart';
import 'package:new_minicab_driver/pob/pob_widget.dart';

import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import '../components/clientnotes_widget.dart';
import '../components/waydetails_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_timer.dart';
import 'dart:ui' as ui;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'on_way_model.dart';
export 'on_way_model.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'dart:convert';

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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

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
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
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

  final JobController myController = Get.put(JobController());
  TimerClass timerclass = TimerClass();

  getlocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;
      // accpetingOrderViewModel.isMapInitialized.value = true;
      setState(() {
        // accpetingOrderViewModel. = position;
        // currentLatitude = position.latitude;
        // currentLongitude = position.longitude;
      });
    } catch (e) {}
    setState(() {});
  }

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

  AccpetingOrderViewModel accpetingOrderViewModel = Get.put(
    AccpetingOrderViewModel(),
  );
  @override
  void initState() {
    super.initState();
    _loadSavedTimer();
    getlocation();

    // Load the saved timer state
    loadata().then((s) {});
    startJobStatusTimer();
    pushercallbg();
    recive_jobidid;
    wayToPickup();

    // accpetingOrderViewModel.getusercurrentlocation();
    // // _getCurrentLocation();
    // accpetingOrderViewModel.getLatLngFromCurrentLocation().then((value) {
    //   // accpetingOrderViewModel.mapApicall();
    //   accpetingOrderViewModel.kGoogleplay.value = CameraPosition(
    //       target: LatLng(accpetingOrderViewModel.latitude.value,
    //           accpetingOrderViewModel.longitude.value),
    //       zoom: 17);
    // });
    // accpetingOrderViewModel.setcustommarkeritem();
    jobStatus();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _model = createModel(context as BuildContext, () => OnWayModel());
  }

  String distanceKm = '';
  late GoogleMapController googleMapController;
  StreamSubscription<Position>? _positionStreamSubscription;
  //  String distance = '';
  String address = '';
  _getpolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: "AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA",
      request: PolylineRequest(
        origin: PointLatLng(originlatlng!.latitude, originlatlng!.longitude),
        destination: PointLatLng(
          accpetingOrderViewModel.convertedLat.value,
          accpetingOrderViewModel.convertedLng.value,
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

  void getLiveLocationAndlistner() async {
    _positionStreamSubscription = Geolocator.getPositionStream().listen((
      position,
    ) {
      setState(() {});
      print("the position is ${position}");
      originlatlng = LatLng(position.latitude, position.longitude);
      initialCameraPosition = CameraPosition(target: originlatlng!, zoom: 15);
      setCustomMarkerForCurrent();
      // if (destlatlng != null) {
      _getpolylines();

      // }
      // addGeofenceCircle();

      // Check proximity to destination
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        accpetingOrderViewModel.convertedLat.value, // Destination latitude
        accpetingOrderViewModel.convertedLng.value, // Destination longitude
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
                accpetingOrderViewModel.convertedLat.value,
                accpetingOrderViewModel.convertedLng.value,
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
      width: 130, // Set desired width
      height: 130, // Set desired height
    );

    destination = await _resizeAndCreateBitmapDescriptor(
      "assets/images/userg.png",
      width: 70,
      height: 70,
    );
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

  void startJobStatusTimer() {
    // Ensure the timer is only started once

    myController.timer = Timer.periodic(const Duration(seconds: 3), (timer) {
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
    locationTrackingTimer = Timer.periodic(const Duration(seconds: 5), (
      timer,
    ) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

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
          'Customer Location',
          'You have reached on customer location.',
        );
        locationTrackingTimer!.cancel(); // Stop the tracking
      } else {
        print("no reached the location");
      }
    });
  }

  Future startTrackingfordropOf(double pickLat, double pickLng) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    locationTrackingTimer = Timer.periodic(const Duration(seconds: 5), (
      timer,
    ) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

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
          'Ride Complete',
          'You have reached on destination',
        );

        locationTrackingTimer!.cancel(); // Stop the tracking

        print('if condtion isridestarted is $isRideStarted');

        await sp.remove('isWaitingTrue');
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(
            'https://www.minicaboffice.com/api/driver/calculate-waiting-time.php',
          ),
        );
        request.fields.addAll({
          'd_id': '$did',
          'job_id': '$jobid',
          'waiting_time': _timerDisplayValue,
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
        Timer(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PobWidget()),
          );
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

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

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

    setState(() {});
  }

  String job = '';
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

  void checkDriverProximity(
    double currentLatitude,
    double currentLongitude,
    double pickupLatitude,
    double pickupLongitude, {
    double precision = 0.00030,
  }) {
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
      Fluttertoast.showToast(msg: "You are not near the customer location");
    }
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

  // late GoogleMapController _mapController;
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

  int? _timerMilliseconds;
  final FlutterFlowTimerController _timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countUp));
  String _timerDisplayValue = "00:00:00";

  Future<void> _loadSavedTimer() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // await _clearSavedTimerState();
    setState(() {
      _elapsedSeconds = sp.getInt('savedTimerMilliseconds') ?? 0;
      _timerMilliseconds = sp.getInt('savedTimerMilliseconds') ?? 0;
      _timerDisplayValue = StopWatchTimer.getDisplayTime(
        _timerMilliseconds!,
        milliSecond: false,
      );
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
    _timercounter = Timer.periodic(const Duration(seconds: 1), (timer) {
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
      onTap:
          () =>
              _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          body: SafeArea(
            top: true,
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.99,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.7,
                        child:
                        //  initialCameraPosition == null
                        //     ? Center(
                        //         child: CircularProgressIndicator(),
                        //       )
                        //     :
                        GoogleMap(
                          mapType:
                              MapType
                                  .satellite, // Keep this as 'normal' (not satellite etc.)
                          tiltGesturesEnabled: true,
                          initialCameraPosition: initialCameraPosition,

                          markers: markers,
                          polylines: polyline,
                          // markers: Set<Marker>.of(homeViewModel.list.value),
                          // circles: geofenceCircles,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          compassEnabled: true,

                          buildingsEnabled: true, // 3D buildings dikhayein
                          rotateGesturesEnabled: true,
                          // tiltGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: true,
                          onTap: (argument) {
                            setState(() {
                              tappedLocation = argument;
                            });
                            // _getRouteFromTappedLocation();
                            debugPrint('the selected lat lng ${argument}');
                          },
                          onMapCreated: (controller) {
                            googleMapController = controller;
                            setState(() {});
                            // controller.setMapStyle(accpetingOrderViewModel.mapTheme.value);
                            // accpetingOrderViewModel
                            //     .setMapController(controller);
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 150.0),
                      //   child: TextButton(
                      //       onPressed: () {
                      //         // myController.showDialog();
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (context) => Dummy3View()));
                      //       },
                      //       child: Text('Navigation')),
                      // ),
                      isRideStarted == false
                          ? Text('')
                          : Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            height: 100,
                            decoration: const BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                10,
                                0,
                                10,
                                0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FlutterFlowIconButton(
                                    borderColor:
                                        FlutterFlowTheme.of(context).info,
                                    borderRadius: 20,
                                    borderWidth: 1,
                                    buttonSize: 40,
                                    fillColor:
                                        FlutterFlowTheme.of(context).info,
                                    icon: Icon(
                                      Icons.menu,
                                      color:
                                          FlutterFlowTheme.of(
                                            context,
                                          ).primaryText,
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
                                            padding: MediaQuery.viewInsetsOf(
                                              context,
                                            ),
                                            child: CustomerDetailsWidget(
                                              cname: '$cName',
                                              cNumber: '$cnumber',
                                              cemail: '$cemail',
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

                      // _buildTopNavigationBox(), // Display the navigation box
                      // Text('data $isRideStarted'),
                      DraggableScrollableSheet(
                        initialChildSize:
                            0.33, // Initial height of the container
                        minChildSize: 0.33, // Minimum height of the container
                        maxChildSize: 0.7, // Maximum height of the container
                        builder: (context, scrollController) {
                          return Container(
                            decoration: BoxDecoration(
                              color:
                                  FlutterFlowTheme.of(
                                    context,
                                  ).primaryBackground,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10.0,
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 10),
                                    Container(
                                      height: 5,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Remaining Distance: ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Text(
                                          '$distanceKm',
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                        // Container(
                                        //   height: 20,
                                        //   width: 1,
                                        //   color: Colors.black,
                                        // ),
                                        // Column(
                                        //   children: [
                                        //     const Text(
                                        //       'Arrival Time',
                                        //       style: TextStyle(
                                        //           fontSize: 13,
                                        //           fontWeight: FontWeight.bold),
                                        //     ),
                                        //     Text(
                                        //       '$arrivalTime',
                                        //       style: const TextStyle(
                                        //         fontSize: 13,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      children: [
                                        Row(
                                          // mainAxisSize: MainAxisSize
                                          //     .min, // Set this to MainAxisSize.min
                                          children: [
                                            Icon(
                                              Icons.pin_drop_outlined,
                                              color:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                              size: 25,
                                            ),
                                            Flexible(
                                              child: Text(
                                                pickup ?? '--',
                                                // style:
                                                overflow:
                                                    TextOverflow
                                                        .ellipsis, // Handle text overflow with ellipsis
                                                maxLines:
                                                    3, // Limit to a maximum of 2 lines
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                10,
                                                0,
                                                5,
                                                0,
                                              ),
                                          child: Icon(
                                            Icons.access_time_filled_rounded,
                                            color: Color(0xFF5B68F5),
                                            size: 20,
                                          ),
                                        ),
                                        Text(
                                          pickTime ?? '--',
                                          style: FlutterFlowTheme.of(
                                            context,
                                          ).titleLarge.override(
                                            fontFamily: 'Open Sans',
                                            color:
                                                FlutterFlowTheme.of(
                                                  context,
                                                ).primaryText,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                10,
                                                0,
                                                5,
                                                0,
                                              ),
                                          child: FaIcon(
                                            FontAwesomeIcons.calendar,
                                            size: 21,
                                            color: Color(0xFF5B68F5),
                                          ),
                                        ),
                                        Text(
                                          pickDate ?? '--',
                                          style: FlutterFlowTheme.of(
                                            context,
                                          ).titleLarge.override(
                                            fontFamily: 'Open Sans',
                                            color:
                                                FlutterFlowTheme.of(
                                                  context,
                                                ).primaryText,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                            0,
                                            8,
                                            0,
                                            0,
                                          ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  10,
                                                  0,
                                                  5,
                                                  0,
                                                ),
                                            child: Icon(
                                              Icons.luggage_outlined,
                                              color: Color(0xFF5B68F5),
                                              size: 20,
                                            ),
                                          ),
                                          Text(
                                            luggage ?? '0',
                                            style: FlutterFlowTheme.of(
                                              context,
                                            ).titleLarge.override(
                                              fontFamily: 'Open Sans',
                                              color:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).primaryText,
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                            child: VerticalDivider(
                                              width: 40,
                                              thickness: 3,
                                              color: Color(0xFF5B68F5),
                                            ),
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  20,
                                                  0,
                                                  5,
                                                  0,
                                                ),
                                            child: FaIcon(
                                              FontAwesomeIcons.userFriends,
                                              color: Color(0xFF5B68F5),
                                              size: 18,
                                            ),
                                          ),
                                          Text(
                                            passenger ?? '--',
                                            style: FlutterFlowTheme.of(
                                              context,
                                            ).titleLarge.override(
                                              fontFamily: 'Open Sans',
                                              color:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).primaryText,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      child: SwipeButton(
                                        thumbPadding: const EdgeInsets.all(3),
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
                                          isRideStarted
                                              ? 'POB'
                                              : (isWaiting
                                                      ? 'Arrival Now'
                                                      : 'Way to Pickup')
                                                  .toUpperCase(),
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
                                          setState(() {});
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                isRideStarted
                                                    ? 'POB'
                                                    : (isWaiting
                                                        ? 'Arrival Now'
                                                        : 'Way to Pickup'),
                                              ),
                                              backgroundColor:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).primary,
                                            ),
                                          );
                                        },
                                        onSwipeEnd: () async {
                                          _getCurrentTime();
                                          SharedPreferences sp =
                                              await SharedPreferences.getInstance();

                                          setState(() {});
                                          if (isRideStarted) {
                                            await sp.setString(
                                              'jobPOBTime',
                                              formattedTime,
                                            );
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Choose Map Option',
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ListTile(
                                                        leading: SizedBox(
                                                          width: 25,
                                                          height: 25,
                                                          child: Image.asset(
                                                            'assets/images/google.png',
                                                          ), // Replace 'your_image.png' with your image asset path
                                                        ),
                                                        title: const Text(
                                                          'Open in Google Maps',
                                                        ),
                                                        onTap: () async {
                                                          // await sp.remove('isWaitingTrue');
                                                          // await sp.remove('isWaitingTrue');
                                                          await getLatLngFromAddress(
                                                            dropoff!,
                                                          );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          startRideTrackingthird(
                                                            latitudeforGooglmap
                                                                .toString(),
                                                            lngforGooglmap
                                                                .toString(),
                                                          );
                                                          await startTrackingfordropOf(
                                                            latitudeforGooglmap,
                                                            lngforGooglmap,
                                                          );
                                                          await MapUtils.navigateTo(
                                                            latitudeforGooglmap,
                                                            lngforGooglmap,
                                                          );

                                                          // start from here
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading: SizedBox(
                                                          width: 25,
                                                          height: 25,
                                                          child: Image.asset(
                                                            'assets/images/app_launcher_icon.png',
                                                          ), // Replace 'your_image.png' with your image asset path
                                                        ),
                                                        title: const Text(
                                                          'Using App',
                                                        ),
                                                        onTap: () async {
                                                          // googleMapController
                                                          //     .animateCamera(
                                                          //         CameraUpdate
                                                          //             .newLatLngZoom(
                                                          //                 originlatlng!,
                                                          //                 17));
                                                          // Navigator.pop(context);
                                                          print(
                                                            'if condtion isridestarted is $isRideStarted',
                                                          );

                                                          await sp.remove(
                                                            'isWaitingTrue',
                                                          );
                                                          var request =
                                                              http.MultipartRequest(
                                                                'POST',
                                                                Uri.parse(
                                                                  'https://www.minicaboffice.com/api/driver/calculate-waiting-time.php',
                                                                ),
                                                              );
                                                          request.fields.addAll({
                                                            'd_id': '$did',
                                                            'job_id': '$jobid',
                                                            'waiting_time':
                                                                _timerDisplayValue,
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
                                                          _model.timerController
                                                              .onStopTimer();
                                                          await sp.setString(
                                                            'timerValue',
                                                            _formatTime(
                                                              _elapsedSeconds,
                                                            ),
                                                          );

                                                          await sp.setInt(
                                                            'isRideStart',
                                                            2,
                                                          );
                                                          // Timer(Duration(seconds: 2), () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      const PobWidget(),
                                                            ),
                                                          );
                                                          // });

                                                          isRideStarted = false;
                                                          isWaiting = false;
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          } else if (isWaiting) {
                                            await sp.setBool(
                                              'arrivalDone',
                                              true,
                                            );
                                            print('arrival swiped');
                                            await sp.setString(
                                              'jobArrivalNowTime',
                                              formattedTime,
                                            );
                                            print(
                                              'else if condtion isridestarted is $isRideStarted and iswaiting is $isWaiting',
                                            );
                                            checkDriverProximity(
                                              currentLatitude,
                                              currentLongitude,
                                              pickupLat,
                                              pickupLng,
                                            );
                                          } else {
                                            print(
                                              'only else and alert showing   condtion isridestarted is $isRideStarted and iswaiting is $isWaiting',
                                            );
                                            await sp.setBool(
                                              'isWaitingTrue',
                                              true,
                                            );
                                            waitingPassanger();
                                            isWaiting = true;
                                            await sp.setString(
                                              'jobWayToPickupTime',
                                              formattedTime,
                                            );
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Choose Map Option',
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ListTile(
                                                        leading: SizedBox(
                                                          width: 25,
                                                          height: 25,
                                                          child: Image.asset(
                                                            'assets/images/google.png',
                                                          ), // Replace 'your_image.png' with your image asset path
                                                        ),
                                                        title: const Text(
                                                          'Open in Google Maps',
                                                        ),
                                                        onTap: () async {
                                                          await getLatLngFromAddress(
                                                            pickup!,
                                                          );
                                                          startRideTracking(
                                                            latitudeforGooglmap
                                                                .toString(),
                                                            lngforGooglmap
                                                                .toString(),
                                                          );
                                                          await startTrackingforpickUp(
                                                            latitudeforGooglmap,
                                                            lngforGooglmap,
                                                          );

                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          await MapUtils.navigateTo(
                                                            latitudeforGooglmap,
                                                            lngforGooglmap,
                                                          );

                                                          // start from here
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading: SizedBox(
                                                          width: 25,
                                                          height: 25,
                                                          child: Image.asset(
                                                            'assets/images/app_launcher_icon.png',
                                                          ), // Replace 'your_image.png' with your image asset path
                                                        ),
                                                        title: const Text(
                                                          'Using App',
                                                        ),
                                                        onTap: () async {
                                                          isWaiting = true;
                                                          setState(() {});
                                                          debugPrint(
                                                            'its printed',
                                                          );

                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //         builder:
                                                          //             (context) =>
                                                          //                 MapboxNavigationExample())
                                                          //                 );
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
                                    const SizedBox(height: 15),
                                    const Row(
                                      children: [
                                        Text(
                                          'Passenger ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          cName ?? '--',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          cnumber ?? '--',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    const Row(
                                      children: [
                                        Text(
                                          'Fare ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          "£ $fare" ?? '--',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                            10,
                                            10,
                                            10,
                                            10,
                                          ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FlutterFlowIconButton(
                                            borderColor: const Color(
                                              0xFF5B68F5,
                                            ),
                                            borderWidth: 1,
                                            buttonSize: 48,
                                            fillColor: const Color(0xFF5B68F5),
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
                                                      time: '$pickTime',
                                                      date: '$pickDate',
                                                      passanger: '$passenger',
                                                      cName: '$cName',
                                                      cnumber: '$cnumber',
                                                      cemail: '$cemail',
                                                      luggage: '$luggage',
                                                      pickup: '$pickup',
                                                      dropoff: '$dropoff',
                                                      cNote: '$note',
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
                                            icon: const FaIcon(
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
                                                  const EdgeInsetsDirectional.fromSTEB(
                                                    24,
                                                    0,
                                                    24,
                                                    0,
                                                  ),
                                              iconPadding:
                                                  const EdgeInsetsDirectional.fromSTEB(
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
                                              borderSide: const BorderSide(
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
                          );
                        },
                      ),
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

  double distanceInMiles = 0;

  List<LatLng> decodedPoints = <LatLng>[];

  Future getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {});
        accpetingOrderViewModel.convertedLat.value = locations.first.latitude;
        accpetingOrderViewModel.convertedLng.value = locations.first.longitude;
        // setcustommarkeritem();
        // await accpetingOrderViewModel.mapApicall().then((s) {
        //   Future.delayed(Duration(seconds: 2)).then((s) {
        //     setState(() {});
        //   });
        // });
        if (isWaiting) {}
        getLiveLocationAndlistner();
        // _getPolyline(locations.first.latitude, locations.first.longitude);
      }
      debugPrint(
        'the address is $isRideStarted ${accpetingOrderViewModel.convertedLat.value} ${accpetingOrderViewModel.convertedLng.value}',
      );

      // _getDirections();
    } catch (e) {}
  }

  void _getCurrentTime() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm a');
    setState(() {
      formattedTime = formatter.format(now);
    });
  }

  LatLng? tappedLocation;

  String stripHtmlTags(String html) {
    final regExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return html.replaceAll(regExp, '').trim();
  }

  String formattedTime = "";
  void startRideTracking(
    String customerLocation1,
    String customerLocation2,
  ) async {
    setState(() {});
    final service = FlutterBackgroundService();
    // This will send the 'updateTimer' event to the background service
    service.invoke('StartRide2', {
      'startRideSecondEvent1': customerLocation1,
      'startRideSecondEvent2': customerLocation2,
    });
  }

  void startRideTrackingthird(
    String customerLocation1,
    String customerLocation2,
  ) async {
    setState(() {});
    final service = FlutterBackgroundService();
    // This will send the 'updateTimer' event to the background service
    service.invoke('StartRide3', {
      'startRideThirdEvent1': customerLocation1,
      'startRideThirdEvent2': customerLocation2,
      'timecount': _timerDisplayValue,
    });
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  StreamSubscription<Position>? positionStream;
  Future<void> wayToPickup() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');

      if (dId == null) {}
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://minicaboffice.com/api/driver/way-to-pickup.php'),
      );
      request.fields.addAll({'d_id': dId.toString()});

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
        Uri.parse('https://minicaboffice.com/api/driver/passenger-waiting.php'),
      );
      request.fields.addAll({'d_id': dId.toString()});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
      } else {}
    } catch (error) {
      // Handle the error as needed
    }
  }
}
