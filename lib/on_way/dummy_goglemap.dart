// Changes applied to your existing DummyViewMap for live turn-by-turn navigation

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class DummyViewMap extends StatefulWidget {
  @override
  _DummyViewMapState createState() => _DummyViewMapState();
}

class _DummyViewMapState extends State<DummyViewMap> {
  GoogleMapController? mapController;
  LatLng? _currentPosition;
  BitmapDescriptor? customIcon;
  bool rideStarted = false;

  final LatLng startPoint = LatLng(31.5204, 74.3587); // Lahore
  final LatLng endPoint = LatLng(31.4504, 73.1350); // Faisalabad
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  String distanceText = '';
  String durationText = '';
  Map<PolylineId, Polyline> allPolylines = {};
  Marker? liveMarker;
  StreamSubscription<Position>? positionStream;
  CameraPosition? _lastCameraPosition;
  PolylineId? selectedPolylineId;
  List routesData = [];
  List<dynamic> turnSteps = [];
  int currentStepIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  Future<void> _loadCurrentLocation() async {
    final position = await _determinePosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // _loadCustomMarker();
    getDirections();
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // void _loadCustomMarker() async {
  //   customIcon = await BitmapDescriptor.fromAssetImage(
  //     const ImageConfiguration(size: Size(48, 48)),
  //     'assets/images/userCurrent.png',
  //   );
  // }

  Future<void> getDirections() async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPoint.latitude},${startPoint.longitude}&destination=${endPoint.latitude},${endPoint.longitude}&alternatives=true&key=AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'] != null && data['routes'].length > 0) {
        routesData = data['routes'];
        allPolylines.clear();

        for (int i = 0; i < routesData.length; i++) {
          final route = routesData[i];
          final leg = route['legs'][0];
          final polylinePoints = PolylinePoints();

          List<PointLatLng> result = polylinePoints.decodePolyline(
            route['overview_polyline']['points'],
          );
          List<LatLng> coordinates =
              result
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();

          final polylineId = PolylineId('route_$i');
          allPolylines[polylineId] = Polyline(
            polylineId: polylineId,
            points: coordinates,
            color: i == 0 ? Colors.blue : Colors.grey,
            width: 14,
            consumeTapEvents: true,
            onTap: () {
              _onPolylineTapped(
                polylineId,
                leg['distance']['text'],
                leg['duration']['text'],
              );
            },
          );

          if (i == 0) {
            selectedPolylineId = polylineId;
            distanceText = leg['distance']['text'];
            durationText = leg['duration']['text'];
            turnSteps = leg['steps'];
          }
        }
        setState(() {});
      }
    }
  }

  void _onPolylineTapped(PolylineId tappedId, String dist, String dur) {
    final leg = routesData[int.parse(tappedId.value.split('_')[1])]['legs'][0];
    setState(() {
      selectedPolylineId = tappedId;
      distanceText = dist;
      durationText = dur;
      turnSteps = leg['steps'];
      currentStepIndex = 0;

      allPolylines.updateAll((id, polyline) {
        return polyline.copyWith(
          colorParam: id == tappedId ? Colors.blue : Colors.grey,
        );
      });
    });
  }

  void _startRideNavigation() {
    rideStarted = true;
    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      LatLng newPosition = LatLng(position.latitude, position.longitude);
      _updateLiveMarker(newPosition, position.heading);
      _checkTurnByTurn(newPosition);
    });
  }

  void _checkTurnByTurn(LatLng current) {
    if (currentStepIndex >= turnSteps.length) return;
    final step = turnSteps[currentStepIndex];
    final stepEnd = LatLng(
      step['end_location']['lat'],
      step['end_location']['lng'],
    );
    final distance = Geolocator.distanceBetween(
      current.latitude,
      current.longitude,
      stepEnd.latitude,
      stepEnd.longitude,
    );

    if (distance < 30) {
      setState(() => currentStepIndex++);
    }
  }

  void _updateLiveMarker(LatLng position, double heading) {
    final markerId = MarkerId('liveMarker');
    final newMarker = Marker(
      markerId: markerId,
      position: position,
      rotation: heading,
      icon: customIcon ?? BitmapDescriptor.defaultMarker,
      anchor: Offset(0.5, 0.5),
      flat: true,
    );

    setState(() => liveMarker = newMarker);

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 18, bearing: heading),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _currentPosition == null
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (controller) => mapController = controller,
                    initialCameraPosition: CameraPosition(
                      target: startPoint,
                      zoom: 11,
                    ),
                    polylines: Set<Polyline>.of(allPolylines.values),
                    markers: {
                      Marker(markerId: MarkerId('start'), position: startPoint),
                      Marker(markerId: MarkerId('end'), position: endPoint),
                      if (liveMarker != null) liveMarker!,
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    compassEnabled: true,
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      color: Colors.white,
                      child: Text(
                        'Distance: $distanceText | Time: $durationText',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (!rideStarted)
                    Positioned(
                      bottom: 30,
                      left: MediaQuery.of(context).size.width / 4,
                      right: MediaQuery.of(context).size.width / 4,
                      child: ElevatedButton(
                        onPressed: _startRideNavigation,
                        child: Text('Start Ride'),
                      ),
                    ),
                ],
              ),
    );
  }
}
