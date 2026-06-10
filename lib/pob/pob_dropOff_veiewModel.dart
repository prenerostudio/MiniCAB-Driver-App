import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_minicab_driver/mapbox/mapbox_route_map.dart';
import 'package:url_launcher/url_launcher.dart';

class DropOffViewModel extends GetxController {
  final mapTheme = ''.obs;
  Rx<bool> isRecenterPressed = false.obs;
  RxBool isOnline = false.obs;
  final longitude = 0.0.obs;
  final latitude = 0.0.obs;
  final isMapInitialized = false.obs;
  final userListResponse = [].obs;
  final instructions = [].obs;
  final isridestart = false.obs;
  final convertedLat = 0.0.obs;
  final convertedLng = 0.0.obs;
  final resturantaddress = '1024, Hemioton Street, Union Market, USA'.obs;
  final customeraddress = 'customer address will here'.obs;
  final distance = ''.obs;
  final time = ''.obs;
  RxList<LatLng> decodedPoints = <LatLng>[].obs;
  final isdirectiontap = true.obs;
  final isdeliveryaccepted = false.obs;
  final ispicked = false.obs;
  RxInt currentStepIndex = 0.obs;
  RxString currentInstruction = ''.obs;

  void launchDialer(String phoneNumber) async {
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
    final position = await getusercurrentlocation();

    if (position != null) {
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      return LatLng(latitude.value, longitude.value);
    }
    return null;
  }

  double calculateDistance(LatLng userLocation, LatLng stepLocation) {
    return Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      stepLocation.latitude,
      stepLocation.longitude,
    );
  }

  Future<void> mapApicall() async {
    final route = await fetchMapboxRoute(
      origin: LatLng(latitude.value, longitude.value),
      destination: LatLng(convertedLat.value, convertedLng.value),
    );
    if (route == null) {
      return;
    }
    _applyRoute(route);
  }

  void _applyRoute(MapboxRouteResult route) {
    decodedPoints.value = route.points;
    distance.value = route.distanceText;
    time.value = route.durationText;
    currentInstruction.value = route.nextInstruction;
    instructions.value =
        route.steps
            .map(
              (step) => {
                'instruction': step.instruction,
                'end_location': step.endLocation,
              },
            )
            .toList();
  }

  String stripHtmlTags(String html) {
    final regExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return html.replaceAll(regExp, '').trim();
  }

  void monitorNavigation() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) async {
      final userLocation = LatLng(position.latitude, position.longitude);

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      if (currentStepIndex.value >= instructions.length) {
        currentInstruction.value = 'You have arrived at your destination.';
        return;
      }

      final stepLocation =
          instructions[currentStepIndex.value]['end_location'] as LatLng?;
      if (stepLocation == null) {
        return;
      }

      final distanceToStep = calculateDistance(userLocation, stepLocation);

      if (distanceToStep > 10) {
        await recalculateRoute(userLocation);
        return;
      }

      if (distanceToStep < 10) {
        currentStepIndex.value++;
        if (currentStepIndex.value < instructions.length) {
          currentInstruction.value =
              instructions[currentStepIndex.value]['instruction'].toString();
          final flutterTts = FlutterTts();
          await flutterTts.speak(stripHtmlTags(currentInstruction.value));
        }
      }
    });
  }

  Future<void> recalculateRoute(LatLng userLocation) async {
    final route = await fetchMapboxRoute(
      origin: userLocation,
      destination: LatLng(convertedLat.value, convertedLng.value),
    );
    if (route == null) {
      return;
    }
    currentStepIndex.value = 0;
    _applyRoute(route);
  }
}
