import '../Model/jobDetails.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'upcomming_model.dart';
export 'upcomming_model.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:new_minicab_driver/Data/api_service.dart';
import 'dart:ui' as ui;

class UpcommingWidget extends StatefulWidget {
  const UpcommingWidget({super.key});

  @override
  _UpcommingWidgetState createState() => _UpcommingWidgetState();
}

class _UpcommingWidgetState extends State<UpcommingWidget> {
  late UpcommingModel _model;
  GoogleMapController? mapController;
  // LocationData? currentLocation;
  Position? currentLocation;
  bool isLoading = false;
  // late Timer _timer;
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  double pickupLat = 0.0;
  double pickupLng = 0.0;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final scaffoldKey = GlobalKey<ScaffoldState>();
  BitmapDescriptor? _driverMarkerIcon;
  bool _isInitializingUpcomingMap = false;
  bool _isFetchingCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UpcommingModel());
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    // await
    // showModalBottomSheet(
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   enableDrag: false,
    //   context: context,
    //   builder: (context) {
    //     return GestureDetector(
    //       onVerticalDragUpdate: (details) {
    //         if (details.primaryDelta! > 20) {
    //           // Close the BottomSheet on a downward swipe
    //           Navigator.pop(context);
    //         }
    //       },
    //       // onVerticalDragDown: (details) {
    //       //   Navigator.pop(context);
    //       //   debugPrint('downSwipped');
    //       // },
    //       onTap: () => _model.unfocusNode.canRequestFocus
    //           ? FocusScope.of(context).requestFocus(_model.unfocusNode)
    //           : FocusScope.of(context).unfocus(),
    //       child: Padding(
    //         padding: MediaQuery.viewInsetsOf(context),
    //         child: UpcommingjobWidget(
    //           dId: '',
    //         ),
    //       ),
    //     );
    //   },
    // );

    // });
    // DirectionsService.init('AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA');
    unawaited(_initializeUpcomingMap());
  }

  @override
  void dispose() {
    _model.dispose();
    // _timer.cancel();
    super.dispose();
  }

  Future<void> _initializeUpcomingMap() async {
    if (_isInitializingUpcomingMap) {
      return;
    }

    _isInitializingUpcomingMap = true;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      await jobDetailsFuture();
      await _setupMarkersAndPolylines();
    } finally {
      _isInitializingUpcomingMap = false;
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String? pickup;

  Future<List<Job>> jobDetailsFuture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    print(dId);
    final response = await http.post(
      Uri.parse(ApiService.driverUpcomingJobs),
      body: {'d_id': dId.toString()},
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      print(parsedResponse);

      if (parsedResponse['data'] is List) {
        final jobs = parsedResponse['data'] as List;
        if (jobs.isNotEmpty) {
          pickup = jobs[0]['pickup'];
        }
        return jobs.map((item) => Job.fromJson(item)).toList();
      }
    }
    return [];
    // throw Exception('App Check Now');
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
          backgroundColor: Colors.transparent,

          // appBar: AppBar(
          //   backgroundColor: context.appTheme.primaryBackground,
          //   automaticallyImplyLeading: false,
          //   leading: FlutterFlowIconButton(
          //     borderColor: Colors.transparent,
          //     borderRadius: 30,
          //     borderWidth: 1,
          //     buttonSize: 60,
          //     icon: Icon(
          //       Icons.arrow_back_rounded,
          //       color: context.appTheme.primary,
          //       size: 30,
          //     ),
          //     onPressed: () async {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => NavBarPage(
          //                     page: HomeWidget(),
          //                   )));
          //     },
          //   ),
          //   title: Text(
          //     'Upcoming Booking',
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
          body: Stack(
            children: [
              Positioned.fill(child: buildMap()),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.appTheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMap() {
    final center = LatLng(
      currentLocation?.latitude ?? 31.4064054,
      currentLocation?.longitude ?? 73.0413076,
    );

    return GoogleMap(
      mapType: MapType.normal,
      tiltGesturesEnabled: true,
      initialCameraPosition: CameraPosition(target: center, zoom: 15.5),
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      compassEnabled: true,
      rotateGesturesEnabled: true,

      // tiltGesturesEnabled: true,
      buildingsEnabled: true, // 3D buildings dikhayein
      scrollGesturesEnabled: true,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: true,
      onMapCreated: _onMapCreated,
      markers: _markers,
      polylines: _polylines,
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });
    if (currentLocation == null) {
      await _initializeUpcomingMap();
    } else {
      await _moveCameraToCurrentLocation();
    }

    // final directionsService = DirectionsService();
    // final request = DirectionsRequest(
    //   origin: '${_currentPosition?.latitude} ,${_currentPosition?.longitude}',
    //   destination: '${pickup}',
    // );
    // print(request);
    // directionsService.route(request,
    //     (DirectionsResult? response, DirectionsStatus? status) {
    //   if (status == DirectionsStatus.ok && response != null) {
    //     setState(() {
    //       final encodedPolyline = response.routes![0]?.overviewPolyline?.points;
    //       print('encoded    ${encodedPolyline}');
    //       if (encodedPolyline != null) {
    //         _polylineCoordinates = decodePolyline(encodedPolyline)!;
    //         print('polylineCoordinates ${_polylineCoordinates}');

    //         markers.add(
    //           Marker(
    //             markerId: MarkerId('origin'),
    //             position: LatLng(
    //               response.routes![0]!.legs![0].startLocation!.latitude,
    //               response.routes![0]!.legs![0].startLocation!.longitude,
    //             ),
    //           ),
    //         );
    //         markers.add(
    //           Marker(
    //             markerId: MarkerId('destination'),
    //             position: LatLng(
    //               response.routes![0]!.legs![0].endLocation!.latitude,
    //               response.routes![0]!.legs![0].endLocation!.longitude,
    //             ),
    //             icon: BitmapDescriptor.defaultMarkerWithHue(
    //                 BitmapDescriptor.hueGreen),
    //           ),
    //         );
    //       }
    //     });
    //   } else {
    //     print('Failed to fetch directions: $status');
    //   }
    // });
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
      print('lati $latitude');
    }
    return points;
  }

  Future<void> waitingPassanger() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      print(dId);

      if (dId == null) {
        print('d_id not found in shared preferences.');
      }
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverPassengerWaiting),
      );
      request.fields.addAll({'d_id': dId.toString()});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        print('waiting Passenger');
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
      print(dId);

      if (dId == null) {
        print('d_id not found in shared preferences.');
      }
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverWayToPickup),
      );
      request.fields.addAll({'d_id': dId.toString()});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        print('way to pickup');
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
  }

  Future<void> _moveCameraToCurrentLocation() async {
    final location = currentLocation;
    final controller = mapController;
    if (location == null || controller == null) {
      return;
    }

    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(location.latitude, location.longitude),
        15.8,
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    if (_isFetchingCurrentLocation) {
      return;
    }

    _isFetchingCurrentLocation = true;
    try {
      final hasPermission = await _ensureLocationPermission();
      if (!hasPermission) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (mounted) {
        setState(() {
          currentLocation = position;
          currentLatitude = position.latitude;
          currentLongitude = position.longitude;
          print('locat  $position');
        });
      }
      await _moveCameraToCurrentLocation();
    } catch (e) {
      print("Error getting current location: $e");
    } finally {
      _isFetchingCurrentLocation = false;
    }
  }

  Future<void> _setupMarkersAndPolylines() async {
    final routeColor = context.appTheme.primary;

    await _getCurrentLocation();
    await getLocationFromAddress();
    await _loadMarkerIcons();

    final points = <LatLng>[];
    if (currentLatitude != 0.0 && currentLongitude != 0.0) {
      final currentPoint = LatLng(currentLatitude, currentLongitude);
      points.add(currentPoint);
      _markers
        ..removeWhere((marker) => marker.markerId.value == 'current-location')
        ..add(
          Marker(
            markerId: const MarkerId('current-location'),
            position: currentPoint,
            anchor: const Offset(0.5, 1),
            infoWindow: const InfoWindow(title: 'Your Location'),
            icon: _driverMarkerIcon ?? BitmapDescriptor.defaultMarker,
          ),
        );
    }

    if (pickupLat != 0.0 && pickupLng != 0.0) {
      final pickupPoint = LatLng(pickupLat, pickupLng);
      points.add(pickupPoint);
      _markers
        ..removeWhere((marker) => marker.markerId.value == 'pickup-location')
        ..add(
          Marker(
            markerId: const MarkerId('pickup-location'),
            position: pickupPoint,
            infoWindow: const InfoWindow(title: 'Pickup Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
          ),
        );
    }

    _polylines.clear();
    if (points.length > 1) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: routeColor,
          width: 5,
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadMarkerIcons() async {
    _driverMarkerIcon ??= BitmapDescriptor.fromBytes(
      await _buildDriverMarkerBytes(),
    );
  }

  Future<Uint8List> _buildDriverMarkerBytes() async {
    const markerWidth = 96;
    const markerHeight = 116;
    const center = Offset(markerWidth / 2, 44);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final pinPath =
        Path()
          ..moveTo(markerWidth / 2, markerHeight - 7)
          ..cubicTo(40, 98, 14, 76, 14, 44)
          ..cubicTo(14, 22, 30, 7, markerWidth / 2, 7)
          ..cubicTo(66, 7, 82, 22, 82, 44)
          ..cubicTo(82, 76, 56, 98, markerWidth / 2, markerHeight - 7)
          ..close();

    canvas.drawPath(
      pinPath.shift(const Offset(0, 4)),
      Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 7),
    );
    canvas.drawPath(pinPath, Paint()..color = Colors.white);
    canvas.drawPath(
      pinPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = context.appTheme.primary,
    );

    canvas.drawCircle(center, 28, Paint()..color = context.appTheme.primary);

    const carIcon = Icons.local_taxi_rounded;
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(carIcon.codePoint),
        style: TextStyle(
          color: Colors.white,
          fontFamily: carIcon.fontFamily,
          package: carIcon.fontPackage,
          fontSize: 35,
          height: 1,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      Offset(
        center.dx - iconPainter.width / 2,
        center.dy - iconPainter.height / 2,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(markerWidth, markerHeight);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    picture.dispose();
    return byteData!.buffer.asUint8List();
  }

  Future<void> getLocationFromAddress() async {
    final apiKey = 'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA';
    final address = pickup ?? '';
    final response = await http.post(
      ApiService.googleGeocodeUri(address: address, apiKey: apiKey),
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
