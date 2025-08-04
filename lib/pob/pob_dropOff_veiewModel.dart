import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
// import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class DropOffViewModel extends GetxController {
  final mapTheme = ''.obs;
  Rx<bool> isRecenterPressed = false.obs;
  RxSet<Polyline> polylines = <Polyline>{}.obs;
  Rx<BitmapDescriptor> sourceicon = BitmapDescriptor.defaultMarker.obs;
  Rx<BitmapDescriptor> destinationicon = BitmapDescriptor.defaultMarker.obs;
  Rx<BitmapDescriptor> currenticon = BitmapDescriptor.defaultMarker.obs;
  Rx<CameraPosition> kGoogleplay =
      const CameraPosition(target: LatLng(0, 0), zoom: 15).obs;
  RxBool isOnline = false.obs;
  final longitude = 0.0.obs;
  final latitude = 0.0.obs;
  final isMapInitialized = false.obs;
  final userListResponse = [].obs;
  final instructions = [].obs;
  final mapController = ValueNotifier<GoogleMapController?>(null);
  final isridestart = false.obs;
  final convertedLat = 0.0.obs;
  final convertedLng = 0.0.obs;
  // final index = 0.obs;
  final resturantaddress = '1024, Hemioton Street, Union Market, USA'.obs;
  final customeraddress = 'customer address will here'.obs;
  final distance = ''.obs;
  final time = ''.obs;
  RxList<LatLng> decodedPoints = <LatLng>[].obs;
  final isdirectiontap = true.obs;
  final isdeliveryaccepted = false.obs;
  final ispicked = false.obs;
  void launchDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    await launch(url);
  }

  @override
  void onClose() {
    mapController.value?.dispose();
    super.onClose();
  }

  setMapController(GoogleMapController controller) {
    mapController.value = controller;
  }

  void _launchDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    await launch(url);
  }

  Future<Position?> getusercurrentlocation() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  Future<LatLng?> getLatLngFromCurrentLocation() async {
    Position? position = await getusercurrentlocation();

    if (position != null) {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      return LatLng(latitude.value, longitude.value);
    } else {
      return null;
    }
  }

  RxInt currentStepIndex = 0.obs; // Start at the first step
  RxString currentInstruction = ''.obs; // Current instruction to display

  double calculateDistance(LatLng userLocation, LatLng stepLocation) {
    return Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      stepLocation.latitude,
      stepLocation.longitude,
    );
  }

  Future<void> mapApicall() async {
    const apiKey = 'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA';
    var origin = '${latitude.value},${longitude.value}';
    var destination = '${convertedLat.value},${convertedLng.value}';

    instructions.clear();
    final response = await http.post(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey'));
    print('the order ${origin} and destination ${destination}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // log('Google Map detail: $data');
      log('Google Map call 1 $data');
      if (data.containsKey('routes') && data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        if (route.containsKey('legs') && route['legs'].isNotEmpty) {
          final leg = route['legs'][0];
          log('Google Map call 2');
          if (leg.containsKey('distance')) {
            distance.value = leg['distance']['text'];
            time.value = leg['duration']['text'];
            log('Google Map call 3');
// instructions.addAll(iterable)
            if (leg.containsKey('steps') && leg['steps'].isNotEmpty) {
              log('Google Map call 4 instructions');
              instructions.value = leg['steps'].map((step) {
                return {
                  'instruction': step['html_instructions'],
                  'direction': step['maneuver'] ?? 'straight',
                  'end_location': step['end_location'],
                };
              }).toList();
            }

            log("the first turn is from ${leg['steps'][0]['html_instructions']}");
            final points = route['overview_polyline']['points'];

            decodedPoints.value = PolylinePoints()
                .decodePolyline(points)
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();
            log('Google Map call 5 polylines');

            polylines.add(
              Polyline(
                polylineId: const PolylineId('route'),
                color: Colors.blue,
                width: 5,
                points: decodedPoints,
              ),
            );
          }
        }
      }
    }
  }

  String stripHtmlTags(String html) {
    final regExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return html.replaceAll(regExp, '').trim();
  }

  Future<Uint8List> getbytesfromimages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void setcustommarkeritem() async {
    sourceicon.value = await _resizeAndCreateBitmapDescriptor(
      "assets/images/car.png",
      width: 70, // Set desired width
      height: 70, // Set desired height
    );

    destinationicon.value = await _resizeAndCreateBitmapDescriptor(
      "assets/images/flag.png",
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
    final Uint8List resizedBytes =
        Uint8List.fromList(img.encodePng(resizedImage));

    // Convert to BitmapDescriptor
    final ui.Codec codec = await ui.instantiateImageCodec(
      resizedBytes,
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? byteData = await frameInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }
  // void setcustommarkeritem() {
  //   BitmapDescriptor.fromAssetImage(
  //     ImageConfiguration.empty,
  //     "assets/images/car.png",
  //   ).then((value) {
  //     sourceicon.value = value;
  //   });
  //   BitmapDescriptor.fromAssetImage(
  //           ImageConfiguration.empty, "assets/images/userg.png")
  //       .then((value) {
  //     destinationicon.value = value;
  //   });
  // }

  void monitorNavigation() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) async {
      final userLocation = LatLng(position.latitude, position.longitude);

      // Calculate bearing (direction) from last position to current position

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      //   final bearing = Geolocator.bearingBetween(
      //   latitude.value,
      //   longitude.value,
      //   position.latitude,
      //   position.longitude,
      // );
      // Center map on user's current location
      mapController.value?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: userLocation,
            zoom: 18.0,
            // bearing: bearing, // Align map in the direction of travel
            // tilt: 60.0, // Provide a tilted 3D view
          ),
        ),
      );

      // Check if user has deviated from the current path
      if (currentStepIndex.value >= instructions.length) {
        // User has reached the destination
        currentInstruction.value = 'You have arrived at your destination.';
        return;
      }

      final stepLocation = LatLng(
        instructions[currentStepIndex.value]['end_location']['lat'],
        instructions[currentStepIndex.value]['end_location']['lng'],
      );

      final distance = calculateDistance(userLocation, stepLocation);

      // If the user is off route, recalculate the path
      if (distance > 10) {
        // Adjust threshold for deviation as needed
        await recalculateRoute(userLocation);
        return;
      }

      // Move to the next instruction if close enough to the current step
      if (distance < 10) {
        currentStepIndex.value++;
        if (currentStepIndex.value < instructions.length) {
          currentInstruction.value =
              instructions[currentStepIndex.value]['instruction'];
          final FlutterTts flutterTts = FlutterTts();
          await flutterTts.speak(stripHtmlTags(currentInstruction.value));
        }
      }
    });
  }

  Future<void> recalculateRoute(LatLng userLocation) async {
    const apiKey = 'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA';
    var origin = '${userLocation.latitude},${userLocation.longitude}';
    var destination =
        '${convertedLat.value},${convertedLng.value}'; // Replace with actual destination coordinates

    final response = await http.post(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('routes') && data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        final points = route['overview_polyline']['points'];

        // Decode and update polyline points
        decodedPoints.value = PolylinePoints()
            .decodePolyline(points)
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: decodedPoints,
          ),
        );

        // Update instructions for the new route
        if (route.containsKey('legs') && route['legs'].isNotEmpty) {
          final leg = route['legs'][0];
          if (leg.containsKey('steps') && leg['steps'].isNotEmpty) {
            instructions.value = leg['steps'].map((step) {
              return {
                'instruction': step['html_instructions'],
                'direction': step['maneuver'] ?? 'straight',
                'end_location': step['end_location'],
              };
            }).toList();

            // Reset current step index
            currentStepIndex.value = 0;
          }
        }
      }
    }
  }
}
