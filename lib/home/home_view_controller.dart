import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mini_cab/Model/jobDetails.dart';
import 'package:mini_cab/home/start_ride_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class JobController extends GetxController {
  var isPeriodicVisible = false.obs;
  var isJobDetailDone = false.obs;
  var visiblecontainer = false.obs;
  RxList<Job> listFromPusher = <Job>[].obs;
  RxDouble convertedLat = 0.0.obs;
  Position? currentLocation;
  RxDouble convertedLng = 0.0.obs;
  RxSet<Polyline> polylines = <Polyline>{}.obs;
  RxInt initialLabelIndex = 0.obs;
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
  Timer? timer;
  Future jobDetails() async {
    try {
      listFromPusher.clear();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      String? jobid = prefs.getString('jobId');
      print("job id $jobid");
      print("dd id $dId");

      final response = await http.post(
        Uri.parse(
            'https://www.minicaboffice.com/api/driver/accepted-jobs-today.php'),
        body: {'d_id': dId.toString()},
      );
      print('the data response ${response.body}');

      if (response.statusCode == 200) {
        parsedResponse.value = json.decode(response.body);
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
        print('the data from ${parsedResponse['data']}');

        if (parsedResponse['status'] == true) {
          print(
              "json data api call${parsedResponse['data'][0]['journey_fare']}");

          listFromPusher.value.add(Job(
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
              waiting: parsedResponse['data'][0]['waiting'].toString() ?? '',
              tolls: parsedResponse['data'][0]['tolls'].toString() ?? '',
              extra: parsedResponse['data'][0]['extra'].toString() ?? '',
              jobStatus:
                  parsedResponse['data'][0]['job_status'].toString() ?? '',
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
              passenger:
                  parsedResponse['data'][0]['passenger'].toString() ?? '',
              pickDate: parsedResponse['data'][0]['pick_date'].toString() ?? '',
              pickTime: parsedResponse['data'][0]['pick_time'].toString() ?? '',
              journeyType:
                  parsedResponse['data'][0]['journey_type'].toString() ?? '',
              vId: parsedResponse['data'][0]['v_id'].toString() ?? '',
              luggage: parsedResponse['data'][0]['luggage'].toString() ?? '',
              childSeat:
                  parsedResponse['data'][0]['child_seat'].toString() ?? '',
              flightNumber:
                  parsedResponse['data'][0]['flight_number'].toString() ?? '',
              delayTime:
                  parsedResponse['data'][0]['delay_time'].toString() ?? '',
              note: parsedResponse['data'][0]['note'].toString() ?? '',
              journeyDistance:
                  parsedResponse['data'][0]['journey_distance'].toString() ??
                      '',
              bookingStatus:
                  parsedResponse['data'][0]['booking_status'].toString() ?? '',
              bidStatus: parsedResponse['data'][0]['bid_status'].toString() ?? '',
              bidNote: parsedResponse['data'][0]['bid_note'].toString() ?? '',
              bookAddDate: parsedResponse['data'][0]['bid_status'].toString() ?? ''));

          visiblecontainer.value = true;
          isJobDetailDone.value = true;
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
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          isJobDetailDone.value = false;
        });

        // Failed to load jobs, handle it appropriately
        return null;
      }
    } catch (e) {
      // Get.snackbar('Error', 'No data found in job detail',colorText: Colors.white,backgroundColor: Colors.red);
      // Get.snackbar('Error', 'No data found in job detail',colorText: Colors.white,backgroundColor: Colors.red);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isJobDetailDone.value = false;
      });

      print('Errorssssss: $e');
      // Handle the error, you can return null or an empty job object
      return null;
    }
  }

  Future<Job?> acceptedJobDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      String? jobId = prefs.getString('jobId');
      print("dd id $jobId");

      final response = await http.post(
        Uri.parse(
            'https://www.minicaboffice.com/api/driver/accepted-job-details.php'),
        body: {'d_id': dId.toString(), 'job_id': jobId.toString()},
      );

      if (response.statusCode == 200) {
        parsedResponse.value = json.decode(response.body);
        data.value = parsedResponse['book_id'].toString();
        prefs.setString('bookingid', data.value);
        print('the data from api ${parsedResponse['data']}');

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
      print('Error: $e');
      // Handle the error and return null
      return null;
    }
  }
}
