// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';
import 'dart:convert';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class AccpetingOrderViewModel extends GetxController {
  final mapTheme = ''.obs;
  Rx<bool> isRecenterPressed = false.obs;
  RxSet<Polyline> polylines = <Polyline>{}.obs;
  Rx<BitmapDescriptor> sourceicon = BitmapDescriptor.defaultMarker.obs;
  Rx<BitmapDescriptor> destinationicon = BitmapDescriptor.defaultMarker.obs;
  Rx<BitmapDescriptor> currenticon = BitmapDescriptor.defaultMarker.obs;
  Rx<CameraPosition> kGoogleplay = const CameraPosition(
          target: LatLng(31.4064054, 73.0413076), zoom: 12.4746)
      .obs;
  RxBool isOnline = false.obs;
  final longitude = 0.0.obs;
  final latitude = 0.0.obs;
  final userListResponse = [].obs;
  final mapController = ValueNotifier<GoogleMapController?>(null);
  // Completer<GoogleMapController> mapController = Completer();
  final isridestart = false.obs;
  final index = 0.obs;
  // final resturantaddress = '1024, Hemioton Street, Union Market, USA'.obs;
  // final customeraddress = 'customer address will here'.obs;
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
    mapController.value
        ?.dispose(); // Dispose the controller when the widget is disposed
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
      // Handle the case where location access is denied
      // print('Error getting location: $e');
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

  Future<void> getdistanceandtime(
      double destinationLat, double destinationLng) async {
    const apiKey =
        'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA'; // Replace with your Google Maps API key
    var origin =
        '${latitude.value},${longitude.value}'; // Replace with your source coordinates
    var destination =
        // '31.414050,73.0613070'; // Replace with your destination coordinates // Replace with your destination coordinates
        '${destinationLat},${destinationLng}'; // Replace with your destination coordinates // Replace with your destination coordinates
    final response = await http.post(Uri.parse(// can be get and post request
        // 'https://maps.googleapis.com/maps/api/directions/json?origin=31.4064054,73.0413076&destination=31.6404050,73.2413070&key=AIzaSyBBSmpcyEaIojvZznYVNpCU0Htvdabe__Y'));
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);
      // print(data);
      if (data.containsKey('routes') && data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        if (route.containsKey('legs') && route['legs'].isNotEmpty) {
          final leg = route['legs'][0];

          if (leg.containsKey('distance')) {
            distance.value = leg['distance']['text'];
            time.value = leg['duration']['text'];

            final points = route['overview_polyline']['points'];

            // Decode polyline points and add them to the map
            decodedPoints.value = PolylinePoints()
                .decodePolyline(points)
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();
            // polylines.value.clear();
            polylines.add(Polyline(
              // patterns: [PatternItem.dash(20), PatternItem.gap(10)],
              // patterns: points,
              polylineId: const PolylineId('route'),
              color: Colors.blue,
              width: 5,
              points: decodedPoints,
            ));
          }
        }
      }
    }
  }

  Future<Uint8List> getbytesfromimages(
      String path, int width, int height) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void setcustommarkeritem() async {
    final Uint8List sourceImage =
        await getbytesfromimages('assets/images/car.png', 80, 80);
    final Uint8List destinationImage =
        await getbytesfromimages('assets/images/userg.png', 80, 80);

    sourceicon.value = BitmapDescriptor.fromBytes(sourceImage);
    destinationicon.value = BitmapDescriptor.fromBytes(destinationImage);
  }

  void updatePolyline(Position position) {
    mapController.value!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(latitude.value, longitude.value), zoom: 18)));
    // Update the polyline on the map with the new position
    // For simplicity, you can just add the new position to the polyline points list
    if (polylines.isNotEmpty) {
      polylines.first.points.add(LatLng(position.latitude, position.longitude));
    }
  }
}
