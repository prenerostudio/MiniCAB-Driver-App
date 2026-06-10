import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_minicab_driver/mapbox/mapbox_route_map.dart';

class DummyViewMap extends StatefulWidget {
  const DummyViewMap({super.key});

  @override
  State<DummyViewMap> createState() => _DummyViewMapState();
}

class _DummyViewMapState extends State<DummyViewMap> {
  LatLng? _currentPosition;
  final LatLng startPoint = const LatLng(31.5204, 74.3587);
  final LatLng endPoint = const LatLng(31.4504, 73.1350);
  List<LatLng> polylineCoordinates = [];
  String distanceText = '';
  String durationText = '';
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    super.initState();
    unawaited(_loadCurrentLocation());
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  Future<void> _loadCurrentLocation() async {
    final position = await _determinePosition();
    _currentPosition = LatLng(position.latitude, position.longitude);
    await getDirections();
    _startLiveTracking();
  }

  Future<Position> _determinePosition() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  Future<void> getDirections() async {
    final origin = _currentPosition ?? startPoint;
    final route = await fetchMapboxRoute(origin: origin, destination: endPoint);
    if (!mounted) {
      return;
    }
    setState(() {
      polylineCoordinates = route?.points ?? [origin, endPoint];
      distanceText = route?.distanceText ?? '';
      durationText = route?.durationText ?? '';
    });
  }

  void _startLiveTracking() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentPosition ?? startPoint;
    return Scaffold(
      body: Stack(
        children: [
          MapboxRouteMap(
            center: current,
            route: polylineCoordinates,
            fitRoute: polylineCoordinates.length > 1,
            followCenter: polylineCoordinates.length <= 1,
            markers: [
              MapboxRouteMarker(
                id: 'start',
                point: current,
                color: Colors.blue,
              ),
              MapboxRouteMarker(id: 'end', point: endPoint, color: Colors.red),
            ],
          ),
          Positioned(
            top: 40,
            left: 12,
            right: 12,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text('Distance: $distanceText | Time: $durationText'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
