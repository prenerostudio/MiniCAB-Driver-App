import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mini_cab/Model/jobDetails.dart';
import 'package:mini_cab/home/start_ride_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class JobController extends GetxController {
  var isPeriodicVisible = false.obs;
  var isJobDetailDone = false.obs;
  Rx<CameraPosition> kGoogleplay = const CameraPosition(
          target: LatLng(31.4064054, 73.0413076), zoom: 12.4746)
      .obs;
  var visiblecontainer = false.obs;
  var jobPusherContainer = false.obs;
  var isTimeSlotDispatched = false.obs;
    final timeSlotDate = '--'.obs;
  final timeSlotStarttime = '--'.obs;
  final timeSlotEndTime = '--'.obs;
  final timeSloPricePerhour = '--'.obs;
  final timeSlottotalPay = '--'.obs;
  final timeSlotid = '--'.obs;
  RxList<Job> listFromPusher = <Job>[].obs;
  RxDouble convertedLat = 0.0.obs;
  RxList<LatLng> decodedPoints = <LatLng>[].obs;
  Position? currentLocation;
  RxDouble convertedLng = 0.0.obs;
  RxSet<Polyline> polylines = <Polyline>{}.obs;
  final longitude = 0.0.obs;
  final latitude = 0.0.obs;
  RxInt initialLabelIndex = 0.obs;
  Rx<BitmapDescriptor> sourceicon = BitmapDescriptor.defaultMarker.obs;
  Rx<BitmapDescriptor> destinationicon = BitmapDescriptor.defaultMarker.obs;
  var parsedResponse =
      RxMap<String, dynamic>({}); // Reactive map for parsed response
  var data = ''.obs; // Reactive variable for 'data' (booking ID)
  var jobId = ''.obs; // Reactive variable for 'data' (booking ID)
  var cid = ''.obs; // Reactive variable for 'data' (booking ID)
  var journeryFare = ''.obs; // Reactive variable for 'data' (booking ID)
  var carParking = ''.obs; // Reactive variable for 'data' (booking ID)
  var extra = ''.obs; // Reactive variable for 'data' (booking ID)
  var waiting = ''.obs; // Reactive variable for 'data' (booking ID)
  var tolls = ''.obs; // Reactive variable for 'data' (booking ID)
  var pickUpdate = ''.obs; // Reactive variable for 'data' (booking ID)
  var pickuptime = ''.obs; // Reactive variable for 'data' (booking ID)
  var pickupLocatoin = ''.obs; // Reactive variable for 'data' (booking ID)
  var dropLocation = ''.obs; // Reactive variable for 'data' (booking ID)
  final mapController = ValueNotifier<GoogleMapController?>(null);
  Timer? timer;
  setMapController(GoogleMapController controller) {
    mapController.value = controller;
  }

  Future jobDetails() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listFromPusher.clear();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    String? jobid = prefs.getString('jobId');

    final response = await http.post(
      Uri.parse(
          'https://www.minicaboffice.com/api/driver/accepted-jobs-today.php'),
      body: {'d_id': dId.toString()},
    );
    print('before if condition');
    if (response.statusCode == 200) {
      parsedResponse.value = json.decode(response.body);
      print('inside if condition');
      if (parsedResponse['status'] == true) {
        print('status is true');
        data.value = parsedResponse['book_id'].toString();
        jobId.value = parsedResponse['data'][0]['job_id'].toString();
        cid.value = parsedResponse['data'][0]['c_id'].toString();
        journeryFare.value =
            parsedResponse['data'][0]['journey_fare'].toString();
        carParking.value = parsedResponse['data'][0]['car_parking'].toString();
        extra.value = parsedResponse['data'][0]['extra'].toString();
        waiting.value = parsedResponse['data'][0]['waiting'].toString();
        tolls.value = parsedResponse['data'][0]['tolls'].toString();
        pickUpdate.value = parsedResponse['data'][0]['pick_date'].toString();
        pickuptime.value = parsedResponse['data'][0]['pick_time'].toString();
        pickupLocatoin.value = parsedResponse['data'][0]['pickup'].toString();
        dropLocation.value =
            parsedResponse['data'][0]['destination'].toString();
        await prefs.setString('bookingid', data.value);
        await prefs.setString('jobId', jobId.value);
        await prefs.setString('c_id', cid.value);
        await prefs.setString('journey_fare', journeryFare.value);
        await prefs.setString('car_parking', carParking.value);
        await prefs.setString('extra', extra.value);
        await prefs.setString('waiting', waiting.value);
        await prefs.setString('tolls', tolls.value);
        await prefs.setString('pickDate', pickUpdate.value);
        await prefs.setString('pickTime', pickuptime.value);
        await prefs.setString('pickLocation', pickupLocatoin.value);
        await prefs.setString('dropLocation', dropLocation.value);
        listFromPusher.add(Job(
            jobId: parsedResponse['data'][0]['job_id'].toString() ?? "",
            bookId: parsedResponse['data'][0]['book_id'].toString() ?? '',
            cId: parsedResponse['data'][0]['00000003'].toString() ?? "",
            dId: parsedResponse['data'][0]['00000000002'].toString() ?? '',
            jobNote: parsedResponse['data'][0]['job_note'].toString() ?? '',
            journeyFare:
                parsedResponse['data'][0]['journey_fare'].toString() ?? '',
            bookingFee:
                parsedResponse['data'][0]['booking_fee'].toString() ?? "",
            carParking:
                parsedResponse['data'][0]['car_parking'].toString() ?? '',
            waiting: parsedResponse['data'][0]['waiting'].toString(),
            tolls: parsedResponse['data'][0]['tolls'].toString() ?? '',
            extra: parsedResponse['data'][0]['extra'].toString() ?? '',
            jobStatus: parsedResponse['data'][0]['job_status'].toString() ?? '',
            dateJobAdd:
                parsedResponse['data'][0]['date_job_add'].toString() ?? '',
            cName: parsedResponse['data'][0]['c_name'].toString() ?? '',
            cEmail: parsedResponse['data'][0]['c_email'].toString() ?? '',
            cPhone: parsedResponse['data'][0]['c_phone'].toString() ?? '',
            cAddress: parsedResponse['data'][0]['c_address'].toString() ?? '',
            dName: parsedResponse['data'][0]['d_name'].toString() ?? '',
            dEmail: parsedResponse['data'][0]['d_email'].toString() ?? '',
            dPhone: parsedResponse['data'][0]['d_phone'].toString() ?? '',
            bTypeId: parsedResponse['data'][0]['b_type_id'].toString() ?? '',
            pickup: parsedResponse['data'][0]['pickup'].toString() ?? '',
            destination:
                parsedResponse['data'][0]['destination'].toString() ?? '',
            address: parsedResponse['data'][0]['address'].toString() ?? '',
            postalCode:
                parsedResponse['data'][0]['postal_code'].toString() ?? '',
            passenger: parsedResponse['data'][0]['passenger'].toString() ?? '',
            pickDate: parsedResponse['data'][0]['pick_date'].toString() ?? '',
            pickTime: parsedResponse['data'][0]['pick_time'].toString() ?? '',
            journeyType:
                parsedResponse['data'][0]['journey_type'].toString() ?? '',
            vId: parsedResponse['data'][0]['v_id'].toString() ?? '',
            luggage: parsedResponse['data'][0]['luggage'].toString() ?? '',
            childSeat: parsedResponse['data'][0]['child_seat'].toString() ?? '',
            flightNumber:
                parsedResponse['data'][0]['flight_number'].toString() ?? '',
            delayTime: parsedResponse['data'][0]['delay_time'].toString() ?? '',
            note: parsedResponse['data'][0]['note'].toString() ?? '',
            journeyDistance:
                parsedResponse['data'][0]['journey_distance'].toString() ?? '',
            bookingStatus:
                parsedResponse['data'][0]['booking_status'].toString() ?? '',
            bidStatus: parsedResponse['data'][0]['bid_status'].toString() ?? '',
            bidNote: parsedResponse['data'][0]['bid_note'].toString() ?? '',
            bookAddDate:
                parsedResponse['data'][0]['bid_status'].toString() ?? ''));
        getCoordinatesFromAddress(listFromPusher[0].pickup);
        visiblecontainer.value = true;
        isJobDetailDone.value = false;
//        if (mounted) {
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (context) {
//       return StartRideAlert(
//         st: listFromPusher,
//       );
//     },
//   );
// }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          getCoordinatesFromAddress('');
          print('staus is false');
          visiblecontainer.value = false;
          listFromPusher.clear();
        });
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('200 condition is false');
        isJobDetailDone.value = false;
      });

      // Failed to load jobs, handle it appropriately
      return null;
    }
    // try {

    // } catch (e) {
    //   // Get.snackbar('Error', 'No data found in job detail',colorText: Colors.white,backgroundColor: Colors.red);
    //   // Get.snackbar('Error', 'No data found in job detail',colorText: Colors.white,backgroundColor: Colors.red);
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     isJobDetailDone.value = false;
    //   });

    //   print('Errorssssss: $e');
    //   // Handle the error, you can return null or an empty job object
    //   return null;
    // }
  }

  Future<Job?> acceptedJobDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      String? jobId = prefs.getString('jobId');

      final response = await http.post(
        Uri.parse(
            'https://www.minicaboffice.com/api/driver/accepted-job-details.php'),
        body: {'d_id': dId.toString(), 'job_id': jobId.toString()},
      );

      if (response.statusCode == 200) {
        parsedResponse.value = json.decode(response.body);
        data.value = parsedResponse['book_id'].toString();
        prefs.setString('bookingid', data.value);

        if (parsedResponse['status'] == true) {
          isPeriodicVisible.value = true;
          if (parsedResponse['data'] is List &&
              parsedResponse['data'].isNotEmpty) {
            return Job.fromJson(parsedResponse['data'].first);
          } else {
            isPeriodicVisible.value = false;
            // No jobs found, return null
            return null;
          }
        } else {
          isPeriodicVisible.value = false;
          // No jobs found, return null
          return null;
        }
      } else {
        // Failed to load jobs, return null
        return null;
      }
    } catch (e) {
      // Handle the error and return null
      return null;
    }
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
            // distance.value = leg['distance']['text'];
            // time.value = leg['duration']['text'];

            final points = route['overview_polyline']['points'];

            // Decode polyline points and add them to the map
            decodedPoints.value = PolylinePoints()
                .decodePolyline(points)
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();
            // polylines.value.clear();
            polylines.clear(); // Clear previous polyline
            polylines.add(Polyline(
              // patterns: [PatternItem.dash(20), PatternItem.gap(10)],
              // patterns: points,
              // polylineId: const PolylineId('updated_route'),
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
Future getCoordinatesFromAddress(String address) async {
  try {
    if (address.isEmpty) {
      print('if getCoordinatesFromAddress');
      // Reset polylines and markers when the pickup address is empty
      polylines.clear();
      convertedLat.value = 0.0;
      convertedLng.value = 0.0;
      return;
    } else {
      print('else getCoordinatesFromAddress');
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        convertedLat.value = locations.first.latitude;
        convertedLng.value = locations.first.longitude;

        getLatLngFromCurrentLocation().then((value) {
          getdistanceandtime(
            locations.first.latitude, locations.first.longitude
          );

          kGoogleplay.value = CameraPosition(
            target: LatLng(latitude.value, longitude.value),
            zoom: 12.4746,
          );
          setcustommarkeritem();
        });
      }
    }
  } catch (e) {
    print("polylines updation exception $e");
  }
}

  // Future getCoordinatesFromAddress(String address) async {
  //   try {
  //     if (address.isEmpty) {
  //       print('if getCoordinatesFromAddress');
  //       // Reset polylines when the pickup address is empty
  //       polylines.clear();
  //       return;
  //     } else {
  //       print('else getCoordinatesFromAddress');
  //       List<Location> locations = await locationFromAddress(address);
  //       if (locations.isNotEmpty) {
  //         convertedLat.value = locations.first.latitude;
  //         convertedLng.value = locations.first.longitude;

  //         getLatLngFromCurrentLocation().then((value) {
  //           getdistanceandtime(
  //               locations.first.latitude, locations.first.longitude);

  //           kGoogleplay.value = CameraPosition(
  //             target: LatLng(latitude.value, longitude.value),
  //             zoom: 12.4746,
  //           );
  //           setcustommarkeritem();
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print("polylines updation exception $e");
  //   }
  // }

  Future<void> updatePolyline() async {
    try {
      // Get destination coordinates
      final destinationLat = convertedLat.value;
      final destinationLng = convertedLng.value;

      // Recalculate distance and polyline with the new current location
      await getdistanceandtime(destinationLat, destinationLng);

      // Optionally, move the camera to the new current location
      mapController.value?.animateCamera(
        CameraUpdate.newLatLng(LatLng(latitude.value, longitude.value)),
      );
    } catch (e) {}
  }

  StreamSubscription<Position>? positionStream;

  @override
  void onInit() {
    super.onInit();
    _trackLocationChanges();
  }

  void _trackLocationChanges() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      // Update current location variables
      latitude.value = position.latitude;
      longitude.value = position.longitude;
// currentLocation.latitude = position.latitude;
      longitude.value = position.longitude;
      // Update polyline with new user location
      updatePolyline();
    });
  }
}
