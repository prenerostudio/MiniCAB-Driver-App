// // import 'dart:convert';
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:geolocator/geolocator.dart';
// // // import 'package:polyline_points/polyline_points.dart';
// // import 'package:http/http.dart' as http;

// // class MapNavigationPage extends StatefulWidget {
// //   const MapNavigationPage({super.key});

// //   @override
// //   _MapNavigationPageState createState() => _MapNavigationPageState();
// // }

// // class _MapNavigationPageState extends State<MapNavigationPage> {
// //   final String googleApiKey = "AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA";
// //   final LatLng _destination =
// //       const LatLng(24.8607, 67.0011); // Destination Coordinates
// //   late GoogleMapController _mapController;

// //   Position? _currentPosition;
// //   List<Map<String, String>> _navigationSteps = [];
// //   int _currentStepIndex = 0;
// //   Set<Polyline> _polylines = {};
// //   List<LatLng> _polylineCoordinates = [];
// //   late StreamSubscription<Position> _positionStream;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _determinePosition();
// //   }

// //   @override
// //   void dispose() {
// //     _positionStream.cancel();
// //     super.dispose();
// //   }

// //   Future<void> _determinePosition() async {
// //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
// //     if (!serviceEnabled) return;

// //     LocationPermission permission = await Geolocator.requestPermission();
// //     if (permission == LocationPermission.denied) return;

// //     _currentPosition = await Geolocator.getCurrentPosition();
// //     _fetchRouteAndDetails();
// //     _startLocationTracking();
// //   }

// //   // List<String> _navigationSteps =
// //   //     []; // Store navigation instructions dynamically

// //   Future<void> _fetchRouteAndDetails() async {
// //     // final String url =
// //     //     "https://maps.googleapis.com/maps/api/directions/json?origin=${_initialPosition.latitude},${_initialPosition.longitude}&destination=${_destinationPosition.latitude},${_destinationPosition.longitude}&key=$googleApiKey";

// //     // final response = await http.get(Uri.parse(url));
// //     // if (response.statusCode == 200) {
// //     //   final data = json.decode(response.body);

// //     //   // Extract distance and duration
// //     //   String distance = data['routes'][0]['legs'][0]['distance']['text'];
// //     //   String duration = data['routes'][0]['legs'][0]['duration']['text'];

// //     //   // Extract step-by-step navigation instructions
// //     //   List steps = data['routes'][0]['legs'][0]['steps'];
// //     //   _navigationSteps = steps
// //     //       .map<String>((step) => step['html_instructions']
// //     //           .replaceAll(RegExp(r'<[^>]*>'), '')) // Remove HTML tags
// //     //       .toList();

// //     //   // Extract polyline points
// //     final url =
// //         "https://maps.googleapis.com/maps/api/directions/json?origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${_destination.latitude},${_destination.longitude}&key=$googleApiKey";

// //     final response = await http.get(Uri.parse(url));
// //     if (response.statusCode == 200) {
// //       final data = json.decode(response.body);
// //       //   // Extract distance and duration
// //       String distance = data['routes'][0]['legs'][0]['distance']['text'];
// //       String duration = data['routes'][0]['legs'][0]['duration']['text'];
// //       // Extract steps
// //       List steps = data['routes'][0]['legs'][0]['steps'];
// //       _navigationSteps = steps.map<Map<String, String>>((step) {
// //         return {
// //           "instruction":
// //               step['html_instructions'].replaceAll(RegExp(r'<[^>]*>'), ''),
// //           "maneuver": step['maneuver'] ?? "straight",
// //           "lat": step['end_location']['lat'].toString(),
// //           "lng": step['end_location']['lng'].toString(),
// //         };
// //       }).toList();
// //       List<PointLatLng> polylinePoints = PolylinePoints()
// //           .decodePolyline(data['routes'][0]['overview_polyline']['points']);
// //       _addPolyline(polylinePoints);

// //       setState(() {
// //         _travelDistance = distance;
// //         _travelTime = duration;
// //       });
// //     } else {
// //       print("Error fetching directions");
// //     }
// //   }

// //   String _travelDistance = '';
// //   String _travelTime = '';
// //   // Add polyline to the map
// //   void _addPolyline(List<PointLatLng> polylinePoints) {
// //     _polylines.add(Polyline(
// //       polylineId: const PolylineId("route"),
// //       color: Colors.blue,
// //       width: 5,
// //       points: polylinePoints
// //           .map((point) => LatLng(point.latitude, point.longitude))
// //           .toList(),
// //     ));
// //   }

// //   // Future<void> _fetchRouteAndDetails() async {
// //   //   final url =
// //   //       "https://maps.googleapis.com/maps/api/directions/json?origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${_destination.latitude},${_destination.longitude}&key=$googleApiKey";

// //   //   final response = await http.get(Uri.parse(url));
// //   //   if (response.statusCode == 200) {
// //   //     final data = json.decode(response.body);

// //   //     // Extract steps
// //   //     List steps = data['routes'][0]['legs'][0]['steps'];
// //   //     _navigationSteps = steps.map<Map<String, String>>((step) {
// //   //       return {
// //   //         "instruction":
// //   //             step['html_instructions'].replaceAll(RegExp(r'<[^>]*>'), ''),
// //   //         "maneuver": step['maneuver'] ?? "straight",
// //   //         "lat": step['end_location']['lat'].toString(),
// //   //         "lng": step['end_location']['lng'].toString(),
// //   //       };
// //   //     }).toList();

// //   //     // Extract polyline
// //   //     // _polylineCoordinates = PolylinePoints().decodePolyline(
// //   //     //     data['routes'][0]['overview_polyline']['points']);
// //   //     // Extract polyline points
// //   //     List<PointLatLng> polylinePoints = PolylinePoints()
// //   //         .decodePolyline(data['routes'][0]['overview_polyline']['points']);
// //   //     // _addPolyline(polylinePoints);

// //   //     // setState(() {
// //   //     //   _travelDistance = distance;
// //   //     //   _travelTime = duration;
// //   //     // });
// //   //     _addPolyline();

// //   //     setState(() {});
// //   //   }
// //   // }

// //   // void _addPolyline() {
// //   //   _polylines.add(Polyline(
// //   //     polylineId: const PolylineId("route"),
// //   //     points: _polylineCoordinates,
// //   //     color: Colors.blue,
// //   //     width: 5,
// //   //   ));
// //   //   setState(() {});
// //   // }

// //   void _startLocationTracking() {
// //     _positionStream =
// //         Geolocator.getPositionStream().listen((Position position) {
// //       _currentPosition = position;
// //       _updateCurrentStep();
// //       _mapController.animateCamera(CameraUpdate.newLatLng(
// //           LatLng(position.latitude, position.longitude)));
// //     });
// //   }

// //   void _updateCurrentStep() {
// //     if (_navigationSteps.isNotEmpty &&
// //         _currentStepIndex < _navigationSteps.length) {
// //       double distance = Geolocator.distanceBetween(
// //         _currentPosition!.latitude,
// //         _currentPosition!.longitude,
// //         double.parse(_navigationSteps[_currentStepIndex]["lat"]!),
// //         double.parse(_navigationSteps[_currentStepIndex]["lng"]!),
// //       );

// //       if (distance < 30) {
// //         setState(() {
// //           _currentStepIndex++;
// //         });
// //       }
// //     }
// //   }

// //   Icon _getManeuverIcon(String maneuver) {
// //     switch (maneuver) {
// //       case "turn-left":
// //         return const Icon(Icons.arrow_left, color: Colors.white, size: 40);
// //       case "turn-right":
// //         return const Icon(Icons.arrow_right, color: Colors.white, size: 40);
// //       case "uturn-left":
// //       case "uturn-right":
// //         return const Icon(Icons.u_turn_left, color: Colors.white, size: 40);
// //       default:
// //         return const Icon(Icons.arrow_upward, color: Colors.white, size: 40);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           GoogleMap(
// //             initialCameraPosition: const CameraPosition(
// //               target: LatLng(24.8607, 67.0011), // Default location
// //               zoom: 14,
// //             ),
// //             polylines: _polylines,
// //             myLocationEnabled: true,
// //             myLocationButtonEnabled: true,
// //             zoomGesturesEnabled: true,
// //             tiltGesturesEnabled: true,
// //             rotateGesturesEnabled: true,
// //             scrollGesturesEnabled: true,
// //             onMapCreated: (controller) => _mapController = controller,
// //           ),
// //           Positioned(
// //             top: 30,
// //             left: 20,
// //             right: 20,
// //             child: Container(
// //               padding: const EdgeInsets.all(12),
// //               decoration: BoxDecoration(
// //                 color: Colors.green[700],
// //                 borderRadius: BorderRadius.circular(10),
// //               ),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   _navigationSteps.isNotEmpty
// //                       ? _getManeuverIcon(
// //                           _navigationSteps[_currentStepIndex]["maneuver"]!)
// //                       : const SizedBox.shrink(),
// //                   const SizedBox(width: 10),
// //                   Expanded(
// //                     child: Text(
// //                       _navigationSteps.isNotEmpty
// //                           ? _navigationSteps[_currentStepIndex]["instruction"]!
// //                           : "Fetching directions...",
// //                       style: const TextStyle(color: Colors.white, fontSize: 18),
// //                       textAlign: TextAlign.center,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:http/http.dart' as http;

// // class NavigationMap extends StatefulWidget {
// //   @override
// //   _NavigationMapState createState() => _NavigationMapState();
// // }

// // class _NavigationMapState extends State<NavigationMap> {
// //   GoogleMapController? mapController;

// //   // Replace with your Google Maps API Key
// //   final String googleApiKey = "AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA";

// //   // Initial position (your starting position)
// //   final LatLng _startLocation = LatLng(37.7749, -122.4194); // San Francisco
// //   final LatLng _destinationLocation = LatLng(37.7849, -122.4094); // Destination

// //   Set<Polyline> _polylines = {};
// //   List<String> _instructions = [];
// //   int _currentStepIndex = 0;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _getDirections(); // Fetch and display route on map
// //   }

// //   Future<void> _getDirections() async {
// //     final String url =
// //         "https://maps.googleapis.com/maps/api/directions/json?origin=${_startLocation.latitude},${_startLocation.longitude}&destination=${_destinationLocation.latitude},${_destinationLocation.longitude}&key=$googleApiKey";

// //     final response = await http.get(Uri.parse(url));
// //     final data = jsonDecode(response.body);

// //     if (data['status'] == 'OK') {
// //       // Extract route points
// //       final routePoints = PolylinePoints()
// //           .decodePolyline(data['routes'][0]['overview_polyline']['points']);

// //       // Extract step-by-step instructions
// //       final steps = data['routes'][0]['legs'][0]['steps'] as List<dynamic>;

// //       List<String> instructions = steps.map<String>((step) {
// //         final stepMap = step as Map<String, dynamic>;
// //         return (stepMap['html_instructions'] as String)
// //             .replaceAll(RegExp(r'<[^>]*>'), ''); // Remove HTML tags
// //       }).toList();

// //       setState(() {
// //         _instructions = instructions;
// //         _polylines.add(Polyline(
// //           polylineId: PolylineId("route"),
// //           points:
// //               routePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
// //           color: Colors.blue,
// //           width: 5,
// //         ));
// //       });

// //       _trackLocation(); // Start tracking user location for dynamic navigation
// //     } else {
// //       print("Error fetching directions: ${data['status']}");
// //     }
// //   }

// //   Future<void> _trackLocation() async {
// //     Position position = await Geolocator.getCurrentPosition();

// //     // Listen for position changes
// //     Geolocator.getPositionStream().listen((Position newPosition) {
// //       double distance = Geolocator.distanceBetween(
// //           newPosition.latitude,
// //           newPosition.longitude,
// //           _destinationLocation.latitude,
// //           _destinationLocation.longitude);

// //       if (distance < 50) {
// //         setState(() {
// //           _currentStepIndex = _instructions.length - 1; // Final instruction
// //         });
// //       } else {
// //         setState(() {
// //           // Increment step index dynamically (simplified logic)
// //           _currentStepIndex =
// //               (_currentStepIndex + 1) % _instructions.length; // Circular update
// //         });
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Turn-by-Turn Navigation")),
// //       body: Stack(
// //         children: [
// //           GoogleMap(
// //             initialCameraPosition: CameraPosition(
// //               target: _startLocation,
// //               zoom: 14,
// //             ),
// //             onMapCreated: (controller) => mapController = controller,
// //             polylines: _polylines,
// //             myLocationEnabled: true,
// //           ),
// //           Positioned(
// //             top: 20,
// //             left: 20,
// //             right: 20,
// //             child: Container(
// //               padding: EdgeInsets.all(10),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(8),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.grey.withOpacity(0.5),
// //                     spreadRadius: 2,
// //                     blurRadius: 5,
// //                     offset: Offset(0, 3),
// //                   ),
// //                 ],
// //               ),
// //               child: Text(
// //                 _instructions.isNotEmpty
// //                     ? "Next: ${_instructions[_currentStepIndex]}"
// //                     : "Loading instructions...",
// //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                 textAlign: TextAlign.center,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

// class MapView extends StatefulWidget {
//   const MapView({super.key});

//   @override
//   State<MapView> createState() => _MapViewState();
// }

// class _MapViewState extends State<MapView> {
//   MapBoxNavigationViewController? _controller;
//   String? _instruction;
//   bool _isMultipleStop = false;
//   double? _distanceRemaining, _durationRemaining;
//   bool _routeBuilt = false;
//   bool _isNavigating = false;
//   bool _arrived = false;
//   late MapBoxOptions _navigationOption;

//   Future<void> initialize() async {
//     if (!mounted) return;
//     _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
//     _navigationOption.initialLatitude = 37.7749;
//     _navigationOption.initialLongitude = -122.4194;
//     _navigationOption.mode = MapBoxNavigationMode.driving;
//     MapBoxNavigation.instance.registerRouteEventListener(_onRouteEvent);
//   }

//   @override
//   void initState() {
//     initialize();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 1,
//             child: Container(
//               color: Colors.grey[100],
//               child: MapBoxNavigationView(
//                 options: _navigationOption,
//                 onRouteEvent: _onRouteEvent,
//                 onCreated: (MapBoxNavigationViewController controller) async {
//                   _controller = controller;
//                   controller.initialize();
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _onRouteEvent(e) async {
//     _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
//     _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

//     switch (e.eventType) {
//       case MapBoxEvent.progress_change:
//         var progressEvent = e.data as RouteProgressEvent;
//         _arrived = progressEvent.arrived!;
//         if (progressEvent.currentStepInstruction != null) {
//           _instruction = progressEvent.currentStepInstruction;
//         }
//         break;
//       case MapBoxEvent.route_building:
//       case MapBoxEvent.route_built:
//         _routeBuilt = true;
//         break;
//       case MapBoxEvent.route_build_failed:
//         _routeBuilt = false;
//         break;
//       case MapBoxEvent.navigation_running:
//         _isNavigating = true;
//         break;
//       case MapBoxEvent.on_arrival:
//         _arrived = true;
//         if (!_isMultipleStop) {
//           await Future.delayed(const Duration(seconds: 3));
//           await _controller?.finishNavigation();
//         } else {}
//         break;
//       case MapBoxEvent.navigation_finished:
//       case MapBoxEvent.navigation_cancelled:
//         _routeBuilt = false;
//         _isNavigating = false;
//         break;
//       default:
//         break;
//     }
//     //refresh UI
//     setState(() {});
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class TurnByTurnNavigationScreen extends StatefulWidget {
  @override
  _TurnByTurnNavigationScreenState createState() =>
      _TurnByTurnNavigationScreenState();
}

class _TurnByTurnNavigationScreenState
    extends State<TurnByTurnNavigationScreen> {
  late GoogleMapController _controller;
  LatLng _currentPosition =
      LatLng(37.7749, -122.4194); // Default to San Francisco
  LatLng _destination = LatLng(37.8044, 73.2711); // Default to Oakland
  final Set<Polyline> _polylines = {};
  List<Map<String, dynamic>> _navigationSteps = [];
  late FlutterTts _tts;

  @override
  void initState() {
    super.initState();
    super.initState();
    _tts = FlutterTts();
    // _getCurrentLocation(); // Fetch the user's current location first
    // _tts = FlutterTts();
    // _trackLocation();
    // _getDirections();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _updateCameraWithZoom(
          _currentPosition); // Move the camera to the current location
      _getDirections(); // Fetch directions after getting the current location
      _trackLocation(); // Start tracking the user's movement
    } catch (e) {
      print('Error fetching current location: $e');
    }
  }

  Future<void> _getDirections() async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentPosition.latitude},${_currentPosition.longitude}&destination=${_destination.latitude},${_destination.longitude}&mode=driving&key=AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    print('the response is ${response.body}');
    if (data['status'] == 'OK') {
      final steps = data['routes'][0]['legs'][0]['steps'];
      _navigationSteps = steps.map<Map<String, dynamic>>((step) {
        return {
          'instruction': step['html_instructions'],
          'distance': step['distance']['text'],
          'duration': step['duration']['text'],
          'polyline': step['polyline']['points'],
        };
      }).toList();

      // Draw the route on the map
      final polylinePoints = PolylinePoints();
      final points = polylinePoints
          .decodePolyline(data['routes'][0]['overview_polyline']['points']);
      final polylineCoordinates = points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ));
      });
    } else {
      print('Error fetching directions: ${data['status']}');
    }
  }

  IconData _getArrowIcon(String instruction) {
    if (instruction.toLowerCase().contains('left')) {
      return Icons.turn_left; // Left turn
    } else if (instruction.toLowerCase().contains('right')) {
      return Icons.turn_right; // Right turn
    } else if (instruction.toLowerCase().contains('head')) {
      return Icons.straight; // Straight ahead
    } else if (instruction.toLowerCase().contains('u-turn')) {
      return Icons.u_turn_left; // U-turn
    } else {
      return Icons.navigation; // Default navigation icon
    }
  }

  Widget _buildTopNavigationBox() {
    if (_navigationSteps.isEmpty) return SizedBox.shrink();

    final currentStep = _navigationSteps.first;

    // Extracting the direction and text
    String instruction = currentStep['instruction'];
    String distance = currentStep['distance'];
    IconData arrowIcon =
        _getArrowIcon(instruction); // Get the appropriate arrow icon

    return Positioned(
      top: 200,
      left: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[800],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 5),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(arrowIcon, color: Colors.white, size: 32), // Arrow icon
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    instruction.replaceAll(RegExp(r'<[^>]*>'), ''),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'In $distance',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _trackLocation() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _heading = position.heading; // Get the heading from the location
        print('the heading position ${position.heading}');
      });
      _updateCameraPosition(_currentPosition);
      _updateCameraWithZoom(_currentPosition); // Auto-follow user
      _checkStepCompletion(position);
    });
  }

  void _updateCameraWithZoom(LatLng position) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 17.5, // Adjust zoom level for navigation
          tilt: 60, // Add tilt for a 3D-like view
          bearing: 90, // Lock the view to a 90-degree angle
        ),
      ),
    );
  }

  double _calculateBearing() {
    if (_navigationSteps.isEmpty) return 0;

    final nextStep = _navigationSteps.first;
    final decodedPolyline =
        PolylinePoints().decodePolyline(nextStep['polyline']);

    if (decodedPolyline.length < 2) return 0;

    final start = decodedPolyline.first;
    final end = decodedPolyline.last;

    return Geolocator.bearingBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  void _checkStepCompletion(Position position) {
    if (_navigationSteps.isEmpty) return;

    final currentStep = _navigationSteps[0];
    final stepPolyline = PolylinePoints()
        .decodePolyline(currentStep['polyline'])
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      stepPolyline.last.latitude,
      stepPolyline.last.longitude,
    );

    if (distance < 20) {
      // Step completion threshold
      _speakInstruction(currentStep['instruction']); // Speak the instruction
      setState(() {
        _navigationSteps.removeAt(0);
      });

      if (_navigationSteps.isNotEmpty) {
        final nextStepPolyline = PolylinePoints().decodePolyline(
          _navigationSteps[0]['polyline'],
        );
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                nextStepPolyline.last.latitude,
                nextStepPolyline.last.longitude,
              ),
              zoom: 17.5,
              tilt: 60,
              bearing: 90, // Lock the camera to 90 degrees
            ),
          ),
        );

        // _controller.animateCamera(
        //   CameraUpdate.newLatLngZoom(
        //     LatLng(
        //       nextStepPolyline.last.latitude,
        //       nextStepPolyline.last.longitude,
        //     ),
        //     17.5,
        //   ),
        // );
      }
    }
  }

  Future<void> _speakInstruction(String instruction) async {
    await _tts.speak(instruction.replaceAll(RegExp(r'<[^>]*>'), ''));
  }

  void _updateCameraPosition(LatLng position) {
    _controller.animateCamera(CameraUpdate.newLatLng(position));
  }

  Widget _buildNavigationSteps() {
    return ListView.builder(
      itemCount: _navigationSteps.length,
      itemBuilder: (context, index) {
        final step = _navigationSteps[index];
        return ListTile(
          title: HtmlWidget(
            step['instruction'], // Displays parsed HTML instructions
          ),
          subtitle: Text('${step['distance']} (${step['duration']})'),
        );
      },
    );
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _heading = position.bearing; // Capture the camera's rotation
      _cameraRotation = position.bearing; // Capture the camera's rotation
    });
  }

  double _cameraRotation = 0.0; // Track camera's rotation angle

  double _heading = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Turn-by-Turn Navigation'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition, // Default location, update later
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller; // Initialize the controller here
              _getCurrentLocation(); // Call to fetch current location AFTER map is ready
            },
            onCameraMove: _onCameraMove,
            polylines: _polylines,
            myLocationEnabled: true,
            fortyFiveDegreeImageryEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
              top: 40,
              right: 20,
              child: Transform.rotate(
                angle: _cameraRotation *
                    (3.14159265359 / 180), // Convert heading to radians
                child: Icon(
                  Icons.navigation,
                  size: 40,
                  color: Colors.red,
                ),
              )),
          _buildTopNavigationBox(), // Display the navigation box
        
        
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.1,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                color: Colors.white,
                child: _buildNavigationSteps(),
              );
            },
          ),
        ],
      ),
    );
  }
}
