import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:mini_cab/main.dart';

import '../Model/jobDetails.dart';
import '../home/home_widget.dart';
import '/components/upcommingjob_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'upcomming_model.dart';
export 'upcomming_model.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latlong;
import '../Model/myProfile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpcommingWidget extends StatefulWidget {
  const UpcommingWidget({Key? key}) : super(key: key);

  @override
  _UpcommingWidgetState createState() => _UpcommingWidgetState();
}

class _UpcommingWidgetState extends State<UpcommingWidget> {
  late UpcommingModel _model;
  late GoogleMapController mapController;
  // LocationData? currentLocation;
  Position? currentLocation;
  bool isLoading = false;
  late Timer _timer;
  List<LatLng> _polylineCoordinates = [];
  List<Marker> markers = [];
  late double currentLatitude;
  late double currentLongitude;
  late double pickupLat;
  late double pickupLng;
  late CameraPosition _kGoogle;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _getLocation();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () => _model.unfocusNode.canRequestFocus
                ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                : FocusScope.of(context).unfocus(),
            child: Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: UpcommingjobWidget(
                dId: '',
              ),
            ),
          );
        },
      ).then((value) => safeSetState(() {}));
    });
    jobDetailsFuture();
    DirectionsService.init('AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA');
    _setupMarkersAndPolylines();
    _model = createModel(context, () => UpcommingModel());
  }

  @override
  void dispose() {
    _model.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _getLocation() async {
    try {
      currentLocation = await Geolocator.getCurrentPosition();

      if (currentLocation != null) {
        mapController.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(
              currentLocation!.latitude,
              currentLocation!.longitude,
            ),
          ),
        );
      }

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

  String? pickup;

  Future<List<Job>> jobDetailsFuture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    print(dId);
    final response = await http.post(
      Uri.parse('https://minicaboffice.com/api/driver/upcoming-jobs.php'),
      body: {
        'd_id': dId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      print(parsedResponse);

      if (parsedResponse['data'] is List) {
        if (parsedResponse.containsKey('data')) {
          pickup = parsedResponse['data'][0]['pickup'];
        }
        return (parsedResponse['data'] as List)
            .map((item) => Job.fromJson(item))
            .toList();
      }
    }
    throw Exception('App Check Now');
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
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              borderWidth: 1,
              buttonSize: 60,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: 30,
              ),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavBarPage(
                              page: HomeWidget(),
                            )));
              },
            ),
            title: Text(
              'Upcoming Booking',
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
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          )
                        : currentLocation != null
                            ? buildMap()
                            : Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
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
    );
  }

  Widget buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          _currentPosition?.latitude ?? 0.0,
          _currentPosition?.longitude ?? 0.0,
        ),
        zoom: 12,
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
      mapController = controller;
    });

    final directionsService = DirectionsService();
    final request = DirectionsRequest(
      origin: '${_currentPosition?.latitude} ,${_currentPosition?.longitude}',
      destination: '${pickup}',
    );
    print(request);
    directionsService.route(request,
        (DirectionsResult? response, DirectionsStatus? status) {
      if (status == DirectionsStatus.ok && response != null) {
        setState(() {
          final encodedPolyline = response.routes![0]?.overviewPolyline?.points;
          print('encoded    ${encodedPolyline}');
          if (encodedPolyline != null) {
            _polylineCoordinates = decodePolyline(encodedPolyline)!;
            print('polylineCoordinates ${_polylineCoordinates}');

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
      print('lati ${latitude}');
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
          Uri.parse(
              'https://minicaboffice.com/api/driver/passenger-waiting.php'));
      request.fields.addAll({
        'd_id': dId.toString(),
      });

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
      var request = http.MultipartRequest('POST',
          Uri.parse('https://minicaboffice.com/api/driver/way-to-pickup.php'));
      request.fields.addAll({
        'd_id': dId.toString(),
      });

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

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
        print('locat  ${_currentPosition}');
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
        color: FlutterFlowTheme.of(context).primary,
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
    final address = pickup;
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
