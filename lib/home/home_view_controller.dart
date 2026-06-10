import 'dart:async';
import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:new_minicab_driver/Model/jobDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:new_minicab_driver/Data/api_service.dart';
import 'package:new_minicab_driver/mapbox/mapbox_route_map.dart';

class JobController extends GetxController {
  var isPeriodicVisible = false.obs;
  final isscreenHome = false.obs;
  var isJobDetailDone = false.obs;
  var visiblecontainer = false.obs;
  var jobPusherContainer = false.obs;
  var currentLoggedInid = ''.obs;
  var isTimeSlotDispatched = false.obs;
  var isTimeSlotAccepted = false.obs;
  final timeSlotDate = '2024-09-09'.obs;
  final timeSlotStarttime = '21:10:00'.obs;
  final startTime = '--'.obs;
  final endTime = '--'.obs;
  final timeSlotEndTime = '21:10:00'.obs;
  final timeSloPricePerhour = '--'.obs;
  final timeSlottotalPay = '--'.obs;
  final timeSlotid = '--'.obs;
  RxList<Job> listFromPusher = <Job>[].obs;
  RxList<Job> pendingDispatchJobs = <Job>[].obs;
  RxDouble convertedLat = 0.0.obs;
  RxList<LatLng> decodedPoints = <LatLng>[].obs;
  final routeDuration = '--'.obs;
  final routeDistance = '--'.obs;
  final nextInstruction = ''.obs;
  final navigationRouteActive = false.obs;
  Position? currentLocation;
  RxDouble convertedLng = 0.0.obs;
  final longitude = 0.0.obs;
  final latitude = 0.0.obs;
  RxInt initialLabelIndex = 0.obs;

  var parsedResponse = RxMap<String, dynamic>(
    {},
  ); // Reactive map for parsed response
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

  List<String> acceptedDispatchKeysFor(Job job) {
    return dispatchKeysForIds(jobId: job.jobId, bookId: job.bookId);
  }

  List<String> dispatchKeysForIds({String? jobId, String? bookId}) {
    final keys = <String>[];
    final normalizedJobId = jobId?.trim() ?? '';
    final normalizedBookId = bookId?.trim() ?? '';
    if (normalizedJobId.isNotEmpty && normalizedJobId != '--') {
      keys.add('job:$normalizedJobId');
    }
    if (normalizedBookId.isNotEmpty && normalizedBookId != '--') {
      keys.add('book:$normalizedBookId');
    }
    return keys;
  }

  bool hasAcceptedDispatchKey(Job job, SharedPreferences prefs) {
    final acceptedKeys =
        prefs.getStringList('acceptedJobKeys') ?? const <String>[];
    return acceptedDispatchKeysFor(
      job,
    ).any((key) => acceptedKeys.contains(key));
  }

  bool hasCompletedDispatchKey(Job job, SharedPreferences prefs) {
    final completedKeys =
        prefs.getStringList('completedJobKeys') ?? const <String>[];
    return acceptedDispatchKeysFor(
      job,
    ).any((key) => completedKeys.contains(key));
  }

  bool hasAlertedDispatchKey(Job job, SharedPreferences prefs) {
    final alertedKeys =
        prefs.getStringList('alertedDispatchKeys') ?? const <String>[];
    return acceptedDispatchKeysFor(job).any((key) => alertedKeys.contains(key));
  }

  bool hasRejectedDispatchKey(Job job, SharedPreferences prefs) {
    final rejectedKeys =
        prefs.getStringList('rejectedDispatchKeys') ?? const <String>[];
    return acceptedDispatchKeysFor(
      job,
    ).any((key) => rejectedKeys.contains(key));
  }

  Future<void> rememberAcceptedJob(Job job) async {
    final prefs = await SharedPreferences.getInstance();
    await _rememberAcceptedJobs([job], prefs);
  }

  Future<void> rememberAlertedJob(Job job) async {
    final prefs = await SharedPreferences.getInstance();
    await _rememberDispatchKeys(
      'alertedDispatchKeys',
      acceptedDispatchKeysFor(job),
      prefs,
    );
  }

  Future<void> rememberRejectedJobByIds({String? jobId, String? bookId}) async {
    final prefs = await SharedPreferences.getInstance();
    await _rememberDispatchKeys(
      'rejectedDispatchKeys',
      dispatchKeysForIds(jobId: jobId, bookId: bookId),
      prefs,
    );
  }

  Future<void> rememberCompletedJobByIds({
    String? jobId,
    String? bookId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await _rememberDispatchKeys(
      'completedJobKeys',
      dispatchKeysForIds(jobId: jobId, bookId: bookId),
      prefs,
    );
  }

  Future<void> _rememberDispatchKeys(
    String prefsKey,
    Iterable<String> keys,
    SharedPreferences prefs,
  ) async {
    final dispatchKeys = keys.where((key) => key.trim().isNotEmpty).toList();
    if (dispatchKeys.isEmpty) {
      return;
    }

    final rememberedKeys = <String>[
      ...?prefs.getStringList(prefsKey),
      ...dispatchKeys,
    ];
    await prefs.setStringList(
      prefsKey,
      rememberedKeys
          .toSet()
          .toList()
          .reversed
          .take(100)
          .toList()
          .reversed
          .toList(),
    );
  }

  Future<void> _rememberAcceptedJobs(
    Iterable<Job> jobs,
    SharedPreferences prefs,
  ) async {
    final acceptedKeys = <String>{
      ...?prefs.getStringList('acceptedJobKeys'),
      for (final job in jobs) ...acceptedDispatchKeysFor(job),
    };
    await prefs.setStringList('acceptedJobKeys', acceptedKeys.toList());
  }

  Job _jobFromAcceptedMap(Map<String, dynamic> acceptedJob) {
    String value(String key) => acceptedJob[key]?.toString() ?? '';

    return Job(
      jobId: value('job_id'),
      bookId: value('book_id'),
      cId: value('c_id'),
      dId: value('d_id'),
      jobNote: value('job_note'),
      journeyFare: value('journey_fare'),
      bookingFee: value('booking_fee'),
      carParking: value('car_parking'),
      waiting: value('waiting'),
      tolls: value('tolls'),
      extra: value('extra'),
      jobStatus: value('job_status'),
      dateJobAdd: value('date_job_add'),
      cName: value('c_name'),
      cEmail: value('c_email'),
      cPhone: value('c_phone'),
      cAddress: value('c_address'),
      dName: value('d_name'),
      dEmail: value('d_email'),
      dPhone: value('d_phone'),
      bTypeId: value('b_type_id'),
      pickup: value('pickup'),
      destination: value('destination'),
      address: value('address'),
      postalCode: value('postal_code'),
      passenger: value('passenger'),
      pickDate: value('pick_date'),
      pickTime: value('pick_time'),
      journeyType: value('journey_type'),
      vId: value('v_id'),
      luggage: value('luggage'),
      totalFee: value('totalFee'),
      childSeat: value('child_seat'),
      flightNumber: value('flight_number'),
      delayTime: value('delay_time'),
      note: value('note'),
      journeyDistance: value('journey_distance'),
      bookingStatus: value('booking_status'),
      bidStatus: value('bid_status'),
      bidNote: value('bid_note'),
      bookAddDate: value('book_add_date'),
    );
  }

  DateTime? _pickupDateTime(Job job) {
    final date = job.pickDate.trim();
    final time = job.pickTime.trim();
    final combined =
        [date, time].where((part) => part.isNotEmpty).join(' ').trim();
    if (combined.isEmpty) {
      return null;
    }

    final normalized = combined.replaceAll('/', '-').replaceAll(',', '');
    final parsedIso = DateTime.tryParse(normalized);
    if (parsedIso != null) {
      return parsedIso;
    }

    final formats = [
      'yyyy-MM-dd HH:mm:ss',
      'yyyy-MM-dd HH:mm',
      'yyyy-MM-dd hh:mm a',
      'dd-MM-yyyy HH:mm:ss',
      'dd-MM-yyyy HH:mm',
      'dd-MM-yyyy hh:mm a',
      'MM-dd-yyyy HH:mm:ss',
      'MM-dd-yyyy HH:mm',
      'MM-dd-yyyy hh:mm a',
      'MMMM d yyyy HH:mm',
      'MMMM d yyyy hh:mm a',
      'MMM d yyyy HH:mm',
      'MMM d yyyy hh:mm a',
    ];

    for (final pattern in formats) {
      try {
        return DateFormat(pattern).parseStrict(normalized);
      } catch (_) {}
    }

    return null;
  }

  int _comparePickupDateTime(Job first, Job second) {
    final firstPickup = _pickupDateTime(first);
    final secondPickup = _pickupDateTime(second);
    if (firstPickup != null && secondPickup != null) {
      return firstPickup.compareTo(secondPickup);
    }
    if (firstPickup != null) {
      return -1;
    }
    if (secondPickup != null) {
      return 1;
    }
    return first.bookAddDate.compareTo(second.bookAddDate);
  }

  Job? earliestAcceptedJob(Iterable<Job> jobs) {
    final sortedJobs = jobs.toList()..sort(_comparePickupDateTime);
    return sortedJobs.isEmpty ? null : sortedJobs.first;
  }

  Future<void> _saveAcceptedJobToPrefs(
    Job acceptedJob,
    SharedPreferences prefs,
  ) async {
    data.value = acceptedJob.bookId;
    jobId.value = acceptedJob.jobId;
    cid.value = acceptedJob.cId;
    journeryFare.value = acceptedJob.journeyFare;
    carParking.value = acceptedJob.carParking;
    extra.value = acceptedJob.extra;
    waiting.value = acceptedJob.waiting;
    tolls.value = acceptedJob.tolls;
    pickUpdate.value = acceptedJob.pickDate;
    pickuptime.value = acceptedJob.pickTime;
    pickupLocatoin.value = acceptedJob.pickup;
    dropLocation.value = acceptedJob.destination;

    await prefs.setBool('jobDispatched', true);
    await prefs.setString('bookingid', acceptedJob.bookId);
    await prefs.setString('jobId', acceptedJob.jobId);
    await prefs.setString('c_id', acceptedJob.cId);
    await prefs.setString('journey_fare', acceptedJob.journeyFare);
    await prefs.setString('booking_fee', acceptedJob.bookingFee);
    await prefs.setString('car_parking', acceptedJob.carParking);
    await prefs.setString('extra', acceptedJob.extra);
    await prefs.setString('waiting', acceptedJob.waiting);
    await prefs.setString('tolls', acceptedJob.tolls);
    await prefs.setString('pickDate', acceptedJob.pickDate);
    await prefs.setString('totalFee', acceptedJob.totalFee ?? '');
    await prefs.setString('pickTime', acceptedJob.pickTime);
    await prefs.setString('pickLocation', acceptedJob.pickup);
    await prefs.setString('dropLocation', acceptedJob.destination);
    await prefs.setString('job_note', acceptedJob.jobNote);
    await prefs.setString('job_status', acceptedJob.jobStatus);
    await prefs.setString('date_job_add', acceptedJob.dateJobAdd);
    await prefs.setString('c_name', acceptedJob.cName);
    await prefs.setString('c_email', acceptedJob.cEmail);
    await prefs.setString('c_phone', acceptedJob.cPhone);
    await prefs.setString('c_address', acceptedJob.cAddress);
    await prefs.setString('d_id_for_job', acceptedJob.dId);
    await prefs.setString('d_name', acceptedJob.dName);
    await prefs.setString('d_email', acceptedJob.dEmail);
    await prefs.setString('d_phone', acceptedJob.dPhone);
    await prefs.setString('b_type_id', acceptedJob.bTypeId);
    await prefs.setString('address', acceptedJob.address);
    await prefs.setString('postal_code', acceptedJob.postalCode);
    await prefs.setString('passenger', acceptedJob.passenger);
    await prefs.setString('journey_type', acceptedJob.journeyType);
    await prefs.setString('v_id', acceptedJob.vId);
    await prefs.setString('luggage', acceptedJob.luggage);
    await prefs.setString('child_seat', acceptedJob.childSeat);
    await prefs.setString('flight_number', acceptedJob.flightNumber);
    await prefs.setString('delay_time', acceptedJob.delayTime);
    await prefs.setString('note', acceptedJob.note);
    await prefs.setString('journey_distance', acceptedJob.journeyDistance);
    await prefs.setString('booking_status', acceptedJob.bookingStatus);
    await prefs.setString('bid_status', acceptedJob.bidStatus);
    await prefs.setString('bid_note', acceptedJob.bidNote);
    await prefs.setString('book_add_date', acceptedJob.bookAddDate);
  }

  Future jobDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');

    final response = await http.post(
      Uri.parse(ApiService.driverAcceptedJobs),
      body: {'d_id': dId.toString()},
    );
    print('before if condition');
    if (response.statusCode == 200) {
      parsedResponse.value = json.decode(response.body);
      print('inside if condition');
      if (parsedResponse['status'] == true) {
        print('status is true');
        final acceptedJobs = parsedResponse['data'];
        if (acceptedJobs is! List || acceptedJobs.isEmpty) {
          visiblecontainer.value = false;
          listFromPusher.clear();
          clearNavigationRoute();
          await prefs.remove('jobDispatched');
          await prefs.remove('acceptedJobKeys');
          return;
        }

        final jobs =
            acceptedJobs
                .whereType<Map>()
                .map(
                  (job) => _jobFromAcceptedMap(Map<String, dynamic>.from(job)),
                )
                .where((job) => !hasCompletedDispatchKey(job, prefs))
                .toList()
              ..sort(_comparePickupDateTime);
        if (jobs.isEmpty) {
          visiblecontainer.value = false;
          listFromPusher.clear();
          clearNavigationRoute();
          await prefs.remove('jobDispatched');
          await prefs.remove('acceptedJobKeys');
          return;
        }

        final acceptedJob = earliestAcceptedJob(jobs)!;
        await _rememberAcceptedJobs(jobs, prefs);
        await _saveAcceptedJobToPrefs(acceptedJob, prefs);

        listFromPusher
          ..clear()
          ..add(acceptedJob);
        final rideState = prefs.getInt('isRideStart') ?? 0;
        final flowStage = prefs.getString('jobFlowStage') ?? 'accepted';
        if (flowStage == 'accepted' || rideState > 2) {
          clearNavigationRoute();
        } else if (flowStage == 'pobRouteReady') {
          getCoordinatesFromAddress(
            acceptedJob.destination,
            drawRoute: true,
            routeOriginAddress: acceptedJob.pickup,
          );
        } else if (flowStage == 'rideToDropoff' || rideState == 2) {
          getCoordinatesFromAddress(acceptedJob.destination, drawRoute: true);
        } else {
          getCoordinatesFromAddress(acceptedJob.pickup, drawRoute: true);
        }
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
        getCoordinatesFromAddress('');
        print('staus is false');
        visiblecontainer.value = false;
        listFromPusher.clear();
        await prefs.remove('jobDispatched');
        await prefs.remove('acceptedJobKeys');
      }
    } else {
      print('200 condition is false');
      isJobDetailDone.value = false;

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
      final storedJobId = (prefs.getString('jobId') ?? '').trim();
      final storedBookId = (prefs.getString('bookingid') ?? '').trim();

      final response = await http.post(
        Uri.parse(ApiService.driverAcceptedJobDetails),
        body: {
          'd_id': dId.toString(),
          'job_id': storedJobId.isNotEmpty ? storedJobId : storedBookId,
          'book_id': storedBookId,
        },
      );

      if (response.statusCode == 200) {
        parsedResponse.value = json.decode(response.body);
        final bookId = parsedResponse['book_id']?.toString();
        if (bookId != null && bookId.trim().isNotEmpty && bookId != 'null') {
          data.value = bookId;
          await prefs.setString('bookingid', data.value);
        }

        if (parsedResponse['status'] == true) {
          isPeriodicVisible.value = true;
          final details = parsedResponse['data'];
          if (details is List && details.isNotEmpty && details.first is Map) {
            return Job.fromJson(Map<String, dynamic>.from(details.first));
          }
          if (details is Map) {
            return Job.fromJson(Map<String, dynamic>.from(details));
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
    double destinationLat,
    double destinationLng, {
    double? originLat,
    double? originLng,
  }) async {
    final route = await fetchMapboxRoute(
      origin: LatLng(originLat ?? latitude.value, originLng ?? longitude.value),
      destination: LatLng(destinationLat, destinationLng),
    );
    if (route == null) {
      return;
    }
    decodedPoints.value = route.points;
    routeDistance.value = route.distanceText;
    routeDuration.value = route.durationText;
    nextInstruction.value = route.nextInstruction;
  }

  void clearNavigationRoute() {
    navigationRouteActive.value = false;
    decodedPoints.clear();
    routeDistance.value = '--';
    routeDuration.value = '--';
    nextInstruction.value = '';
  }

  Future getCoordinatesFromAddress(
    String address, {
    bool drawRoute = true,
    String? routeOriginAddress,
  }) async {
    try {
      if (address.isEmpty) {
        print('if getCoordinatesFromAddress');
        // Reset route state when the pickup address is empty.
        clearNavigationRoute();
        convertedLat.value = 0.0;
        convertedLng.value = 0.0;
        return;
      } else {
        print('else getCoordinatesFromAddress');
        List<Location> locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          convertedLat.value = locations.first.latitude;
          convertedLng.value = locations.first.longitude;
          navigationRouteActive.value = drawRoute;

          if (!drawRoute) {
            decodedPoints.clear();
            routeDistance.value = '--';
            routeDuration.value = '--';
            nextInstruction.value = '';
            return;
          }

          double? routeOriginLat;
          double? routeOriginLng;
          final originAddress = routeOriginAddress?.trim() ?? '';
          if (originAddress.isNotEmpty) {
            try {
              final originLocations = await locationFromAddress(originAddress);
              if (originLocations.isNotEmpty) {
                routeOriginLat = originLocations.first.latitude;
                routeOriginLng = originLocations.first.longitude;
              }
            } catch (_) {
              routeOriginLat = null;
              routeOriginLng = null;
            }
          }

          final currentLatLng = await getLatLngFromCurrentLocation();
          if (currentLatLng == null && routeOriginLat == null) {
            return;
          }

          await getdistanceandtime(
            locations.first.latitude,
            locations.first.longitude,
            originLat: routeOriginLat,
            originLng: routeOriginLng,
          );
        }
      }
    } catch (e) {
      print("route update exception $e");
    }
  }

  Future<void> updatePolyline() async {
    try {
      if (!navigationRouteActive.value ||
          convertedLat.value == 0.0 ||
          convertedLng.value == 0.0) {
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('jobFlowStage') == 'pobRouteReady') {
        return;
      }

      // Get destination coordinates
      final destinationLat = convertedLat.value;
      final destinationLng = convertedLng.value;

      // Recalculate distance and polyline with the new current location
      await getdistanceandtime(destinationLat, destinationLng);
    } catch (e) {}
  }

  StreamSubscription<Position>? positionStream;
  @override
  void onInit() {
    super.onInit();
    _trackLocationChanges();

    // Listen to changes in showAlert and show a dialog when it becomes true
    // ever(visiblecontainer, (bool value) {
    //   if (value) {
    //     Get.dialog(
    //       AlertDialog(
    //         title: Text("Alert"),
    //         content: Text("This is an alert dialog."),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               // Close the dialog and reset the value
    //               Get.back();
    //               showAlert.value = false;
    //             },
    //             child: Text("OK"),
    //           ),
    //         ],
    //       ),
    //       barrierDismissible:
    //           false, // Prevent dialog from closing by tapping outside
    //     );
    //   }
    // });
  }

  RxBool showAlert = false.obs;

  void _trackLocationChanges() {
    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      // Update current location variables
      currentLocation = position;
      latitude.value = position.latitude;
      longitude.value = position.longitude;
      // currentLocation.latitude = position.latitude;
      longitude.value = position.longitude;
      // Update polyline with new user location
      updatePolyline();
    });
  }
}
