import '../Model/jobDetails.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'upcomming_model.dart';
export 'upcomming_model.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:new_minicab_driver/Data/api_service.dart';
import 'package:new_minicab_driver/mapbox/mapbox_route_map.dart';

class UpcommingWidget extends StatefulWidget {
  const UpcommingWidget({super.key});

  @override
  _UpcommingWidgetState createState() => _UpcommingWidgetState();
}

class _UpcommingWidgetState extends State<UpcommingWidget> {
  late UpcommingModel _model;
  // LocationData? currentLocation;
  Position? currentLocation;
  bool isLoading = false;
  // late Timer _timer;
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  double pickupLat = 0.0;
  double pickupLng = 0.0;
  List<LatLng> _routePoints = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Uint8List? _driverMarkerImage;
  bool _isInitializingUpcomingMap = false;
  bool _isFetchingCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UpcommingModel());
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    // await
    // showModalBottomSheet(
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   enableDrag: false,
    //   context: context,
    //   builder: (context) {
    //     return GestureDetector(
    //       onVerticalDragUpdate: (details) {
    //         if (details.primaryDelta! > 20) {
    //           // Close the BottomSheet on a downward swipe
    //           Navigator.pop(context);
    //         }
    //       },
    //       // onVerticalDragDown: (details) {
    //       //   Navigator.pop(context);
    //       //   debugPrint('downSwipped');
    //       // },
    //       onTap: () => _model.unfocusNode.canRequestFocus
    //           ? FocusScope.of(context).requestFocus(_model.unfocusNode)
    //           : FocusScope.of(context).unfocus(),
    //       child: Padding(
    //         padding: MediaQuery.viewInsetsOf(context),
    //         child: UpcommingjobWidget(
    //           dId: '',
    //         ),
    //       ),
    //     );
    //   },
    // );

    // });
    unawaited(_initializeUpcomingMap());
  }

  @override
  void dispose() {
    _model.dispose();
    // _timer.cancel();
    super.dispose();
  }

  Future<void> _initializeUpcomingMap() async {
    if (_isInitializingUpcomingMap) {
      return;
    }

    _isInitializingUpcomingMap = true;
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      await jobDetailsFuture();
      await _setupMapboxRoute();
    } finally {
      _isInitializingUpcomingMap = false;
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String? pickup;

  Future<List<Job>> jobDetailsFuture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    print(dId);
    final response = await http.post(
      Uri.parse(ApiService.driverUpcomingJobs),
      body: {'d_id': dId.toString()},
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      print(parsedResponse);

      if (parsedResponse['data'] is List) {
        final jobs = parsedResponse['data'] as List;
        if (jobs.isNotEmpty) {
          pickup = jobs[0]['pickup'];
          return jobs.map((item) => Job.fromJson(item)).toList();
        }
      }
    }

    final acceptedJob = await _fetchSavedAcceptedJob(prefs);
    if (acceptedJob != null) {
      pickup = acceptedJob.pickup;
      return [acceptedJob];
    }

    return [];
    // throw Exception('App Check Now');
  }

  Future<Job?> _fetchSavedAcceptedJob(SharedPreferences prefs) async {
    final hasAcceptedJob = prefs.getBool('jobDispatched') ?? false;
    final storedJobId = (prefs.getString('jobId') ?? '').trim();
    final storedBookId = (prefs.getString('bookingid') ?? '').trim();
    if (!hasAcceptedJob || (storedJobId.isEmpty && storedBookId.isEmpty)) {
      return null;
    }

    try {
      final dId = prefs.getString('d_id');
      final response = await http.post(
        Uri.parse(ApiService.driverAcceptedJobDetails),
        body: {
          'd_id': dId.toString(),
          'job_id': storedJobId.isNotEmpty ? storedJobId : storedBookId,
          'book_id': storedBookId,
        },
      );

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse['status'] == true) {
          final details = parsedResponse['data'];
          if (details is List && details.isNotEmpty && details.first is Map) {
            return Job.fromJson(Map<String, dynamic>.from(details.first));
          }
          if (details is Map) {
            return Job.fromJson(Map<String, dynamic>.from(details));
          }
        }
      }
    } catch (error) {
      print('Accepted upcoming fallback error: $error');
    }

    return _jobFromSavedAcceptedPrefs(prefs);
  }

  Job? _jobFromSavedAcceptedPrefs(SharedPreferences prefs) {
    final jobId = (prefs.getString('jobId') ?? '').trim();
    final bookId = (prefs.getString('bookingid') ?? '').trim();
    final savedPickup = (prefs.getString('pickLocation') ?? '').trim();
    final savedDestination = (prefs.getString('dropLocation') ?? '').trim();

    if (jobId.isEmpty &&
        bookId.isEmpty &&
        savedPickup.isEmpty &&
        savedDestination.isEmpty) {
      return null;
    }

    return Job(
      jobId: jobId.isNotEmpty ? jobId : bookId,
      bookId: bookId,
      cId: prefs.getString('c_id') ?? '',
      dId: prefs.getString('d_id_for_job') ?? prefs.getString('d_id') ?? '',
      jobNote: prefs.getString('job_note') ?? '',
      totalFee: prefs.getString('totalFee') ?? '',
      journeyFare: prefs.getString('journey_fare') ?? '',
      bookingFee: prefs.getString('booking_fee') ?? '',
      carParking: prefs.getString('car_parking') ?? '',
      waiting: prefs.getString('waiting') ?? '',
      tolls: prefs.getString('tolls') ?? '',
      extra: prefs.getString('extra') ?? '',
      jobStatus: prefs.getString('job_status') ?? '',
      dateJobAdd: prefs.getString('date_job_add') ?? '',
      cName: prefs.getString('c_name') ?? '',
      cEmail: prefs.getString('c_email') ?? '',
      cPhone: prefs.getString('c_phone') ?? '',
      cAddress: prefs.getString('c_address') ?? '',
      dName: prefs.getString('d_name') ?? '',
      dEmail: prefs.getString('d_email') ?? '',
      dPhone: prefs.getString('d_phone') ?? '',
      bTypeId: prefs.getString('b_type_id') ?? '',
      pickup: savedPickup,
      destination: savedDestination,
      address: prefs.getString('address') ?? '',
      postalCode: prefs.getString('postal_code') ?? '',
      passenger: prefs.getString('passenger') ?? '',
      pickDate: prefs.getString('pickDate') ?? '',
      pickTime: prefs.getString('pickTime') ?? '',
      journeyType: prefs.getString('journey_type') ?? '',
      vId: prefs.getString('v_id') ?? '',
      luggage: prefs.getString('luggage') ?? '',
      childSeat: prefs.getString('child_seat') ?? '',
      flightNumber: prefs.getString('flight_number') ?? '',
      delayTime: prefs.getString('delay_time') ?? '',
      note: prefs.getString('note') ?? '',
      journeyDistance: prefs.getString('journey_distance') ?? '',
      bookingStatus: prefs.getString('booking_status') ?? '',
      bidStatus: prefs.getString('bid_status') ?? '',
      bidNote: prefs.getString('bid_note') ?? '',
      bookAddDate: prefs.getString('book_add_date') ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }
    DateTime? lastBackPressed;
    return GestureDetector(
      onTap:
          () =>
              _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (lastBackPressed == null ||
              DateTime.now().difference(lastBackPressed!) >
                  Duration(seconds: 2)) {
            context.pushNamed('Home');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Press again to exit')));
            lastBackPressed = DateTime.now();
            return false;
          } else {
            SystemNavigator.pop();
            return true;
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,

          // appBar: AppBar(
          //   backgroundColor: context.appTheme.primaryBackground,
          //   automaticallyImplyLeading: false,
          //   leading: FlutterFlowIconButton(
          //     borderColor: Colors.transparent,
          //     borderRadius: 30,
          //     borderWidth: 1,
          //     buttonSize: 60,
          //     icon: Icon(
          //       Icons.arrow_back_rounded,
          //       color: context.appTheme.primary,
          //       size: 30,
          //     ),
          //     onPressed: () async {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => NavBarPage(
          //                     page: HomeWidget(),
          //                   )));
          //     },
          //   ),
          //   title: Text(
          //     'Upcoming Booking',
          //     style: context.appTheme.headlineMedium.override(
          //           fontFamily: 'Outfit',
          //           color: context.appTheme.primary,
          //           fontSize: 22,
          //         ),
          //   ),
          //   actions: [],
          //   centerTitle: true,
          //   elevation: 2,
          // ),
          body: Stack(
            children: [
              Positioned.fill(child: buildMap()),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.appTheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMap() {
    final center = LatLng(
      currentLocation?.latitude ?? 31.4064054,
      currentLocation?.longitude ?? 73.0413076,
    );

    return MapboxRouteMap(
      center: center,
      initialZoom: 15.5,
      route: _routePoints,
      routeColor: context.appTheme.primary,
      fitRoute: _routePoints.length > 1,
      followCenter: _routePoints.length <= 1,
      markers: [
        if (currentLatitude != 0.0 && currentLongitude != 0.0)
          MapboxRouteMarker(
            id: 'current-location',
            point: LatLng(currentLatitude, currentLongitude),
            image: _driverMarkerImage,
            color: context.appTheme.primary,
            iconSize: 0.52,
          ),
        if (pickupLat != 0.0 && pickupLng != 0.0)
          MapboxRouteMarker(
            id: 'pickup-location',
            point: LatLng(pickupLat, pickupLng),
            color: const Color(0xFF1F7A5B),
          ),
      ],
    );
  }

  Future<void> waitingPassanger() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      print(dId);

      if (dId == null) {
        print('d_id not found in shared preferences.');
      }
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverPassengerWaiting),
      );
      request.fields.addAll({'d_id': dId.toString()});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        print('waiting Passenger');
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error: $error');
      // Handle the error as needed
    }
  }

  Future<void> wayToPickup() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      print(dId);

      if (dId == null) {
        print('d_id not found in shared preferences.');
      }
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverWayToPickup),
      );
      request.fields.addAll({'d_id': dId.toString()});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        print('way to pickup');
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
  }

  Future<void> _getCurrentLocation() async {
    if (_isFetchingCurrentLocation) {
      return;
    }

    _isFetchingCurrentLocation = true;
    try {
      final hasPermission = await _ensureLocationPermission();
      if (!hasPermission) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (mounted) {
        setState(() {
          currentLocation = position;
          currentLatitude = position.latitude;
          currentLongitude = position.longitude;
          print('locat  $position');
        });
      }
    } catch (e) {
      print("Error getting current location: $e");
    } finally {
      _isFetchingCurrentLocation = false;
    }
  }

  Future<void> _setupMapboxRoute() async {
    await _getCurrentLocation();
    await getLocationFromAddress();
    await _loadMarkerIcons();

    final points = <LatLng>[];
    if (currentLatitude != 0.0 && currentLongitude != 0.0) {
      points.add(LatLng(currentLatitude, currentLongitude));
    }

    if (pickupLat != 0.0 && pickupLng != 0.0) {
      points.add(LatLng(pickupLat, pickupLng));
    }

    final route =
        points.length > 1
            ? await fetchMapboxRoute(
              origin: points.first,
              destination: points.last,
            )
            : null;
    _routePoints = route?.points ?? points;

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadMarkerIcons() async {
    _driverMarkerImage ??= await buildDriverMarkerBytes();
  }

  Future<void> getLocationFromAddress() async {
    final address = pickup ?? '';
    if (address.trim().isEmpty) {
      return;
    }
    final locations = await locationFromAddress(address);
    if (locations.isEmpty) {
      return;
    }
    pickupLat = locations.first.latitude;
    pickupLng = locations.first.longitude;
  }
}
