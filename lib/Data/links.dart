import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class MapUtils {
  MapUtils();

  static Future<void> openMap(double lat, double lng) async {
    String pickupLocation = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    if (await canLaunch(pickupLocation)) {
      await launch(pickupLocation);
    } else {
      throw 'Could not open map';
    }
  }

  static Future<void> navigateTo(double Lat, double Lng) async {
    String navigationUrl = 'https://www.google.com/maps/dir/?api=1&destination=$Lat,$Lng';

    if (await canLaunch(navigationUrl)) {

      await launch(navigationUrl);
    } else {

      throw 'Could not launch navigation';
    }
  }
  static Future<void> openWaze(double Lat, double Lng) async {
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double currentLat = currentPosition.latitude;
    double currentLng = currentPosition.longitude;
    String navigationUrl = 'https://www.waze.com/ul?ll=$Lat,$Lng&navigate=yes&from=$currentLat,$currentLng';

    if (await canLaunch(navigationUrl)) {
      await launch(navigationUrl);
    } else {
      throw 'Could not launch Waze';
    }
  }



}
