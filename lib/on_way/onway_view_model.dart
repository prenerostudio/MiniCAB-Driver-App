import 'package:get/get.dart';
import 'package:new_minicab_driver/mapbox/mapbox_route_map.dart';
import 'package:url_launcher/url_launcher.dart';

class AccpetingOrderViewModel extends GetxController {
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

  void _launchDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    await launch(url);
  }
}
