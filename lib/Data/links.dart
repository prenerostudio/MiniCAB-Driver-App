import 'package:geolocator/geolocator.dart';
import 'package:new_minicab_driver/Data/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils();

  static Future<void> openMap(double lat, double lng) async {
    String pickupLocation = ApiService.googleMapsSearchUrl(lat, lng);

    if (await canLaunch(pickupLocation)) {
      await launch(pickupLocation);
    } else {
      throw 'Could not open map';
    }
  }

  static Future<void> navigateTo(double Lat, double Lng) async {
    String navigationUrl = ApiService.googleMapsNavigationUrl(Lat, Lng);

    if (await canLaunch(navigationUrl)) {
      await launch(navigationUrl);
    } else {
      throw 'Could not launch navigation';
    }
  }

  static Future<void> openWaze(double Lat, double Lng) async {
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double currentLat = currentPosition.latitude;
    double currentLng = currentPosition.longitude;
    String navigationUrl = ApiService.wazeNavigationUrl(
      destinationLat: Lat,
      destinationLng: Lng,
      currentLat: currentLat,
      currentLng: currentLng,
    );

    if (await canLaunch(navigationUrl)) {
      await launch(navigationUrl);
    } else {
      throw 'Could not launch Waze';
    }
  }
}
