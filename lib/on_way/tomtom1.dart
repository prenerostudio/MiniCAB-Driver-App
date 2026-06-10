import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_minicab_driver/mapbox/mapbox_route_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LatLng _currentPosition = const LatLng(52.50931, 13.42936);
  final LatLng _destination = const LatLng(52.50274, 13.43872);
  List<LatLng> _routePoints = [];
  Timer? _movementTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_loadRoute());
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadRoute() async {
    final route = await fetchMapboxRoute(
      origin: _currentPosition,
      destination: _destination,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _routePoints = route?.points ?? [_currentPosition, _destination];
    });
    _startMovement();
  }

  void _startMovement() {
    if (_routePoints.isEmpty) {
      return;
    }
    _movementTimer?.cancel();
    _currentIndex = 0;
    _movementTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentIndex >= _routePoints.length) {
        timer.cancel();
        return;
      }
      setState(() {
        _currentPosition = _routePoints[_currentIndex++];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MapboxRouteMap(
          center: _currentPosition,
          route: _routePoints,
          fitRoute: _routePoints.length > 1,
          followCenter: _routePoints.length <= 1,
          markers: [
            MapboxRouteMarker(
              id: 'car',
              point: _currentPosition,
              color: Colors.blue,
            ),
            MapboxRouteMarker(
              id: 'destination',
              point: _destination,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
