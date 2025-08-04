import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoogleMapController? mapController;
  Location location = Location();
  LatLng _currentPosition = LatLng(52.50931, 13.42936); // Start Location
  LatLng _destination = LatLng(52.50274, 13.43872); // Destination
  Set<Polyline> _polylines = {};
  List<LatLng> _routePoints = [];
  BitmapDescriptor? carIcon;
  Marker? carMarker;
  int currentIndex = 0;
  Timer? movementTimer;
  FlutterTts flutterTts = FlutterTts();

  final String tomtomApiKey = "YOUR_TOMTOM_API_KEY";

  @override
  void initState() {
    super.initState();
    getRoute();
    loadCarIcon();
  }

  // Load car marker icon
  void loadCarIcon() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/car_icon.png',
    );
    setState(() {});
  }

  // Fetch route from TomTom API with traffic data
  Future<void> getRoute() async {
    final String url =
        "https://api.tomtom.com/routing/1/calculateRoute/${_currentPosition.latitude},${_currentPosition.longitude}:${_destination.latitude},${_destination.longitude}/json?key=$tomtomApiKey&traffic=true";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<LatLng> polylinePoints = [];

      var routes = data['routes'][0]['legs'][0]['points'];
      for (var point in routes) {
        polylinePoints.add(LatLng(point['latitude'], point['longitude']));
      }

      setState(() {
        _routePoints = polylinePoints;
        _polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            points: _routePoints,
            color: Colors.blue,
            width: 5,
          ),
        );
      });

      startTurnByTurnNavigation();
      startCarMovement();
    } else {
      print("Failed to fetch route");
    }
  }

  // Move car along the route
  void startCarMovement() {
    if (_routePoints.isEmpty) return;

    movementTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (currentIndex < _routePoints.length) {
        setState(() {
          _currentPosition = _routePoints[currentIndex];
          _polylines = {
            Polyline(
              polylineId: PolylineId("route"),
              points: _routePoints.sublist(currentIndex),
              color: Colors.blue,
              width: 5,
            ),
          };
          carMarker = Marker(
            markerId: MarkerId("car"),
            position: _currentPosition,
            icon: carIcon ?? BitmapDescriptor.defaultMarker,
            rotation: 0,
          );
        });
        currentIndex++;
      } else {
        timer.cancel();
        speak("You have arrived at your destination.");
      }
    });
  }

  // Enable voice turn-by-turn navigation
  void startTurnByTurnNavigation() {
    if (_routePoints.isEmpty) return;

    Timer.periodic(Duration(seconds: 10), (timer) {
      if (currentIndex < _routePoints.length) {
        speak("Continue straight.");
      } else {
        timer.cancel();
      }
    });
  }

  // Text-to-speech for navigation instructions
  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          mapType:
              MapType.satellite, // Keep this as 'normal' (not satellite etc.)
          tiltGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: _currentPosition,
            zoom: 14,
          ),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          markers: {
            if (carMarker != null) carMarker!,
            Marker(
              markerId: MarkerId("destination"),
              position: _destination,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          },
          polylines: _polylines,
        ),
      ),
    );
  }
}
