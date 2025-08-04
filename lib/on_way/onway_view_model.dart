import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'dart:ui' as ui;

class AccpetingOrderViewModel extends GetxController {
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
}
