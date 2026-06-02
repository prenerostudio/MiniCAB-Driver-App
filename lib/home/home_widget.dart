import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:new_minicab_driver/Data/links.dart';
import 'package:new_minicab_driver/home/home_screen_alert.dart';
import 'package:new_minicab_driver/home/home_view_controller.dart';
import 'package:new_minicab_driver/home/notifier.dart';

import 'package:pusher_client_fixed/pusher_client_fixed.dart';
// import 'package:root_checker_plus/root_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../Model/jobDetails.dart';
import '../components/notes_widget.dart';
import '../drawer_widget/drawer_view.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'home_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:new_minicab_driver/Data/api_service.dart';

class HomeWidget extends StatefulWidget {
  bool? isFromOnway;
  HomeWidget({this.isFromOnway, super.key});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with WidgetsBindingObserver {
  static const _green = Color(0xFF0E7C66);
  static const _gold = Color(0xFFE2A84F);
  static const _pusherAppKey = 'ef80ba163503f394d9c3';
  static const _pusherCluster = 'ap2';
  static const _legacyJobsChannel = 'jobs-channel';
  static const _dispatchBookingChannel = 'dispatch-booking';

  late HomeModel _model;
  LatLng? selectedLocation;
  // GoogleMapController? mapController;

  bool isLoading = true;
  String? phone;
  String? email;
  bool? switchValue1;
  String? driverStatus;
  String locationMessage = "";
  Timer? locationTimer;
  Timer? userSession;
  Timer? _dispatchPollingTimer;
  bool status = false;
  final ScrollController _scrollController = ScrollController();
  String? pickup;

  bool rootedCheck = false;
  bool jailbreak = false;
  bool devMode = false;
  final bool _isVisible = false;
  final animationsMap = <String, AnimationInfo>{};
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool jobStatus = false;
  bool periodicStatus = false;
  mapbox.MapboxMap? _mapboxMap;
  mapbox.PointAnnotationManager? _mapPointManager;
  mapbox.PolylineAnnotationManager? _mapPolylineManager;
  Uint8List? _driverMarkerImage;
  Uint8List? _destinationMarkerImage;
  bool _mapboxStyleReady = false;
  bool _isFetchingCurrentLocation = false;
  // bool isPeriodicVisible = false;
  // Timer? _timer;
  // Timer? _timerVisible;
  // bool visiblecontainer = false;
  final controller = MyController(); // Or use a globally provided instance
  String? _lastAlertedDispatchId;

  Map<String, dynamic> _decodePusherEvent(dynamic event) {
    final rawData = event?.data;
    if (rawData == null) {
      return {};
    }

    final decoded = json.decode(rawData.toString());
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }
    return {};
  }

  Map<String, dynamic> _pusherJobData(Map<String, dynamic> eventData) {
    final details = eventData['details'];
    if (details is List && details.isNotEmpty && details.first is Map) {
      return Map<String, dynamic>.from(details.first as Map);
    }

    final data = eventData['data'];
    if (data is List && data.isNotEmpty && data.first is Map) {
      return Map<String, dynamic>.from(data.first as Map);
    }

    return eventData;
  }

  String _pusherText(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value == null) {
        continue;
      }

      final text = value.toString();
      if (text.trim().isNotEmpty && text != 'null') {
        return text;
      }
    }
    return '';
  }

  String _normalizeDriverId(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    final numeric = int.tryParse(trimmed);
    return numeric?.toString() ?? trimmed;
  }

  bool _isPusherJobForCurrentDriver(
    Map<String, dynamic> data,
    SharedPreferences prefs,
  ) {
    final currentDriverId = _normalizeDriverId(prefs.getString('d_id') ?? '');
    final target = _pusherText(data, ['target']).toLowerCase();

    if (target == 'all-drivers' || target == 'all_drivers') {
      return true;
    }

    final pushedDriverId = _pusherText(data, [
      'd_id',
      'assigned_driver_id',
      'target_driver_id',
      '00000000002',
    ]);

    return currentDriverId.isNotEmpty &&
        _normalizeDriverId(pushedDriverId) == currentDriverId;
  }

  Job _jobFromPusherData(Map<String, dynamic> data) {
    final bookId = _pusherText(data, ['book_id']);
    final jobId = _pusherText(data, ['job_id']);

    return Job(
      jobId: jobId.isNotEmpty ? jobId : bookId,
      bookId: bookId,
      cId: _pusherText(data, ['c_id', 'customer_id', '00000003']),
      dId: _pusherText(data, [
        'd_id',
        'assigned_driver_id',
        'target_driver_id',
        '00000000002',
      ]),
      jobNote: _pusherText(data, ['job_note', 'note']),
      totalFee: _pusherText(data, ['totalFee', 'total_fee']),
      journeyFare: _pusherText(data, ['journey_fare']),
      bookingFee: _pusherText(data, ['booking_fee']),
      carParking: _pusherText(data, ['car_parking']),
      waiting: _pusherText(data, ['waiting']),
      tolls: _pusherText(data, ['tolls']),
      extra: _pusherText(data, ['extra', 'extras']),
      jobStatus: _pusherText(data, ['job_status']),
      dateJobAdd: _pusherText(data, ['date_job_add', 'book_add_date']),
      cName: _pusherText(data, ['c_name', 'customer_name']),
      cEmail: _pusherText(data, ['c_email', 'customer_email']),
      cPhone: _pusherText(data, ['c_phone', 'customer_phone']),
      cAddress: _pusherText(data, ['c_address', 'customer_address']),
      dName: _pusherText(data, ['d_name', 'driver_name']),
      dEmail: _pusherText(data, ['d_email', 'driver_email']),
      dPhone: _pusherText(data, ['d_phone', 'driver_phone']),
      bTypeId: _pusherText(data, ['b_type_id', 'booking_type']),
      pickup: _pusherText(data, ['pickup']),
      destination: _pusherText(data, ['destination']),
      address: _pusherText(data, ['address', 'stops']),
      postalCode: _pusherText(data, ['postal_code']),
      passenger: _pusherText(data, ['passenger']),
      pickDate: _pusherText(data, ['pick_date', 'pickup_date']),
      pickTime: _pusherText(data, ['pick_time', 'pickup_time']),
      journeyType: _pusherText(data, ['journey_type']),
      vId: _pusherText(data, ['v_id', 'vehicle_type']),
      luggage: _pusherText(data, ['luggage']),
      childSeat: _pusherText(data, ['child_seat']),
      flightNumber: _pusherText(data, ['flight_number']),
      delayTime: _pusherText(data, ['delay_time']),
      note: _pusherText(data, ['note']),
      journeyDistance: _pusherText(data, ['journey_distance']),
      bookingStatus: _pusherText(data, ['booking_status']),
      bidStatus: _pusherText(data, ['bid_status']),
      bidNote: _pusherText(data, ['bid_note']),
      bookAddDate: _pusherText(data, ['book_add_date', 'date_job_add']),
    );
  }

  void _handleDispatchedPusherJob(
    Map<String, dynamic> eventData,
    SharedPreferences prefs,
  ) {
    final data = _pusherJobData(eventData);
    if (!_isPusherJobForCurrentDriver(data, prefs)) {
      debugPrint(
        'Ignored dispatch for driver ${_pusherText(data, ['assigned_driver_id', 'target_driver_id', 'd_id'])}; current driver is ${prefs.getString('d_id') ?? ''}',
      );
      return;
    }

    debugPrint('Dispatch accepted by app: ${jsonEncode(data)}');
    _publishDispatchedJob(_jobFromPusherData(data), prefs, playAlert: true);
  }

  void _handleWithdrawnPusherJob(dynamic event, SharedPreferences prefs) {
    final eventData = _decodePusherEvent(event);
    final data = _pusherJobData(eventData);

    if (data.isEmpty || _isPusherJobForCurrentDriver(data, prefs)) {
      checkJobStatus();
    }
  }

  Future<void> _startDispatchPolling() async {
    _dispatchPollingTimer?.cancel();
    await jobDetailsFuture(playAlertForNewJob: true);
    _dispatchPollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      jobDetailsFuture(playAlertForNewJob: true);
    });
  }

  Future<void> _publishDispatchedJob(
    Job job,
    SharedPreferences prefs, {
    required bool playAlert,
  }) async {
    final dispatchId = job.jobId.isNotEmpty ? job.jobId : job.bookId;
    final isNewDispatch =
        dispatchId.isEmpty || dispatchId != _lastAlertedDispatchId;

    await prefs.setBool('jobDispatched', true);
    if (job.jobId.isNotEmpty) {
      await prefs.setString('jobId', job.jobId);
    }
    if (job.bookId.isNotEmpty) {
      await prefs.setString('bookingid', job.bookId);
    }

    listFromPusher
      ..clear()
      ..add(job);
    myController.listFromPusher
      ..clear()
      ..add(job);

    if (playAlert && isNewDispatch) {
      _lastAlertedDispatchId = dispatchId;
      startRingtoneAndVibrateLoop();
    }

    myController.jobPusherContainer.value = false;
    myController.jobPusherContainer.value = true;
    controller.toggleVariable(
      myController.jobPusherContainer.value,
      listFromPusher,
    );

    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildAcceptedJobOverlay(BuildContext context) {
    final job = myController.listFromPusher.first;
    final distance = double.tryParse(job.journeyDistance);
    final distanceText =
        distance == null
            ? '${job.journeyDistance} miles'
            : '${(distance * 0.621371).toStringAsFixed(2)} miles';

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.appTheme.secondaryBackground,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              color: Color(0x33000000),
              offset: Offset(0, 8),
            ),
          ],
          border: Border.all(color: context.appTheme.lineColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\u00A3${job.journeyFare}',
                        style: context.appTheme.headlineMedium.override(
                          fontFamily: 'Outfit',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${job.pickDate} at ${job.pickTime}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.appTheme.bodySmall.override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: context.appTheme.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    await _openStartNavigationDialog(context);
                  },
                  text: 'Start Now',
                  icon: const Icon(Icons.east, size: 15),
                  options: FFButtonOptions(
                    height: 40,
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    color: context.appTheme.primary,
                    textStyle: context.appTheme.titleSmall.override(
                      fontFamily: 'Open Sans',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    elevation: 0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildJobLocationLine(
              context,
              label: 'A',
              text: job.pickup,
              color: context.appTheme.success,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.route_rounded,
                  color: context.appTheme.secondaryText,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$distanceText ${job.journeyType}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.appTheme.bodySmall.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: context.appTheme.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildJobLocationLine(
              context,
              label: 'B',
              text: job.destination,
              color: context.appTheme.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobLocationLine(
    BuildContext context, {
    required String label,
    required String text,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.appTheme.bodySmall.override(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.appTheme.bodyMedium.override(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openStartNavigationDialog(BuildContext context) async {
    if (myController.listFromPusher.isEmpty) {
      return;
    }

    final job = myController.listFromPusher.first;
    final sp = await SharedPreferences.getInstance();
    _getCurrentTime();
    await sp.setString('jobStartTime', formattedTime);

    if (!mounted) {
      return;
    }

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Start navigation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: SizedBox(
                  width: 25,
                  height: 25,
                  child: Image.asset('assets/images/google.png'),
                ),
                title: const Text('Open Google Maps'),
                onTap: () async {
                  await getLatLngFromAddress(job.pickup);
                  await sp.setInt('isRideStart', 1);
                  myController.visiblecontainer.value = false;
                  startRideTracking(
                    latitudeforGooglmap.toString(),
                    lngforGooglmap.toString(),
                  );
                  await startTracking(latitudeforGooglmap, lngforGooglmap);
                  if (Navigator.of(dialogContext).canPop()) {
                    Navigator.pop(dialogContext);
                  }
                  await MapUtils.navigateTo(
                    latitudeforGooglmap,
                    lngforGooglmap,
                  );
                },
              ),
              ListTile(
                leading: SizedBox(
                  width: 25,
                  height: 25,
                  child: Image.asset('assets/driver-app-icon.jpg'),
                ),
                title: const Text('Use in-app Mapbox route'),
                onTap: () async {
                  Navigator.pop(dialogContext);
                  if (myController.initialLabelIndex.value == 1) {
                    await sp.setBool('show', false);
                    await sp.setInt('isRideStart', 1);
                    myController.visiblecontainer.value = false;
                    if (!mounted) {
                      return;
                    }
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: NotesWidget(
                            dId: job.dId,
                            jobId: job.jobId,
                            pickTime: job.pickTime,
                            pickDate: job.pickDate,
                            passenger: job.passenger,
                            pickup: job.pickup,
                            dropoff: job.destination,
                            luggage: job.luggage,
                            cName: job.cName,
                            cnumber: job.cPhone,
                            cemail: job.cEmail,
                            note: job.note,
                            fare: job.journeyFare,
                            distance: job.journeyDistance,
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  } else {
                    Fluttertoast.showToast(
                      msg: "Please be online before starting the ride.",
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pushercallbg() async {
    myController.timer?.cancel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var pusher = PusherClient(
        _pusherAppKey,
        PusherOptions(cluster: _pusherCluster, encrypted: true),
      );
      pusher.connect();

      var legacyChannel = pusher.subscribe(_legacyJobsChannel);
      legacyChannel.bind('job-dispatched', (event) {
        _handleDispatchedPusherJob(_decodePusherEvent(event), prefs);
      });
      legacyChannel.bind('job-withdrawn', (event) {
        _handleWithdrawnPusherJob(event, prefs);
      });

      var dispatchChannel = pusher.subscribe(_dispatchBookingChannel);
      dispatchChannel.bind('booking-dispatch', (event) {
        _handleDispatchedPusherJob(_decodePusherEvent(event), prefs);
      });
      dispatchChannel.bind('booking-withdraw', (event) {
        _handleWithdrawnPusherJob(event, prefs);
      });
    } catch (e) {}
  }

  Future<void> timeSlotPusher() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.remove('ts_id');

      var pusher = PusherClient(
        _pusherAppKey,
        PusherOptions(cluster: _pusherCluster, encrypted: true),
      );
      pusher.connect();

      var channel = pusher.subscribe('times-channel');

      // Listen for new events
      channel.bind('slot-dispatched', (event) async {
        Map<String, dynamic> jsonMap = json.decode(event!.data!);

        myController.currentLoggedInid.value = prefs.getString('d_id') ?? '';
        if (myController.currentLoggedInid.value ==
            jsonMap['details'][0]['d_id'].toString()) {
          // startToon();

          startRingtoneAndVibrateLoop();
          await prefs.setString(
            'ts_id',
            jsonMap['details'][0]['ts_id'].toString(),
          );
          myController.timeSlotid.value =
              jsonMap['details'][0]['ts_id'].toString();
          myController.timeSlotDate.value =
              jsonMap['details'][0]['ts_date'].toString();
          myController.timeSlotStarttime.value =
              jsonMap['details'][0]['start_time'].toString();
          _startTime = jsonMap['details'][0]['start_time'].toString();
          await prefs.remove('accepted');
          myController.isTimeSlotAccepted.value =
              prefs.getBool('accepted') ?? false;
          _endTime =
              jsonMap['details'][0]['end_time'].toString(); // e.g., "15:00:00"
          myController.timeSlotEndTime.value =
              jsonMap['details'][0]['end_time'].toString();
          myController.timeSloPricePerhour.value =
              jsonMap['details'][0]['price_hour'].toString();
          myController.timeSlottotalPay.value =
              jsonMap['details'][0]['total_pay'].toString();
          myController.isTimeSlotDispatched.value = true;
          _loadSavedState();
        }
      });
      channel.bind('slot-withdrawn', (event) {
        Map<String, dynamic> jsonMap = json.decode(event!.data!);
        getTimeSlotFroApi();
      });
    } catch (e) {}
  }

  Future<void> checkUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('loginToken');
    String? did = prefs.getString('d_id');
    final response = await http.post(
      Uri.parse(ApiService.driverAuthenticationCheckLoginToken),
      body: {'d_id': did.toString()},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // print('user session token${token}');
      // print('user session token${did}');
      // print('user from api token${data['data']['login_token']}');
      if (data['status'] == false || token != data['data']['login_token']) {
        await prefs.setString('loginToken', '');
        await prefs.setBool('isLogin', false);
        await prefs.clear();
        userSession?.cancel();
        context.pushNamed('Login');
        // if (!mounted) return setState(() {});
      } else {
        // Handle the job details as normal
      }
    } else {
      // Handle the error
    }
  }

  final JobController myController = Get.put(JobController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myController.polylines.clear();
      myController.visiblecontainer.value = false;
      myController.isscreenHome.value == false;
    });

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    setState(() {
      // myController.visiblecontainer.value = true;
    });
    // Check if overlay permission is granted
    FlutterOverlayWindow.isPermissionGranted().then((granted) {
      if (!granted) {
        print('granted');
        FlutterOverlayWindow.requestPermission();
      }
    });
    userSession = Timer.periodic(Duration(seconds: 4), (s) {
      // checkUserSession();
    });
    myController.setcustommarkeritem();
    pushercallbg();
    timeSlotPusher();
    myController.jobDetails().then((s) {
      // print(
      //     'the available pickup address is  ${myController.listFromPusher[0].pickup} ');
      // if (myController.listFromPusher.isNotEmpty) {
      //   getCoordinatesFromAddress(myController.listFromPusher[0].pickup);
      // }
    });
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isAndroid) {
      androidRootChecker();
      developerMode();
    }
    if (Platform.isIOS) {
      iosJailbreak();
    }

    getTimeSlotFroApi();

    callAp();
    _startDispatchPolling();
    fetchJobStatus();

    _loadSwitchStatus();
    _initMapAndLocation();
    checkVehicleDocuments();
    DueBalance();
    _model = createModel(context, () => HomeModel());
    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        loop: true,
        // reverse: true,
        trigger: AnimationTrigger.onPageLoad,
        effects: [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 310.0.ms,
            duration: 600.0.ms,
            begin: const Offset(1, 1),
            end: const Offset(1, 1),
          ),
        ],
      ),
    });
  }

  Future _showOverlay() async {
    await FlutterOverlayWindow.showOverlay();
    FlutterOverlayWindow.showOverlay(
      startPosition: OverlayPosition(30, 40),
      overlayContent: 'this is overlay contenet',
      height: 300,
      width: 100,
      // positionGravity:PositionGravity.left,
    );
  }

  Future<void> checkId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String st = '';
    st = prefs.getString('d_id') ?? '';
  }

  Future getTimeSlotFroApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      myController.isTimeSlotDispatched.value = false;
      String? dId = prefs.getString('d_id');
      String? tsid = prefs.getString('ts_id');

      var fields = {'d_id': dId.toString(), 'ts_id': tsid.toString()};
      var uri = Uri.parse(ApiService.driverTimeslotsFetchTimeSlot);

      var response = await http.post(uri, body: fields);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (dId == jsonData['data'][0]['d_id']) {
          myController.isTimeSlotAccepted.value =
              prefs.getBool('accepted') ?? false;
          myController.isTimeSlotDispatched.value = true;

          myController.timeSlotDate.value = jsonData['data'][0]['ts_date'];
          myController.timeSlotStarttime.value =
              jsonData['data'][0]['start_time'];
          myController.timeSlotEndTime.value = jsonData['data'][0]['end_time'];
          myController.timeSloPricePerhour.value =
              jsonData['data'][0]['price_hour'];
          myController.timeSlottotalPay.value =
              jsonData['data'][0]['total_pay'];
          _startTime = jsonData['data'][0]['start_time']; // e.g., "14:00:00"
          _endTime = jsonData['data'][0]['end_time']; // e.g., "15:00:00"
          _loadSavedState();
        }

        // myController.visiblecontainer.value = true;

        // closeOverlay();
      } else {
        await prefs.remove('accepted');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          myController.isTimeSlotDispatched.value = false;
          setState(() {});
          myController.isTimeSlotAccepted.value =
              prefs.getBool('accepted') ?? false;
        });
      }
    } catch (e) {}
  }

  double latitudeforGooglmap = 0;
  double lngforGooglmap = 0;
  Future<void> getLatLngFromAddress(String address) async {
    try {
      // Geocode the address to get a list of locations
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        // The first location in the list will be the best match
        latitudeforGooglmap = locations[0].latitude;
        lngforGooglmap = locations[0].longitude;
        setState(() {});
      } else {}
    } catch (e) {}
  }

  // AccpetingOrderViewModel accpetingOrderViewModel =
  //     Get.put(AccpetingOrderViewModel());
  Future<void> checkJobStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    String? jobId = prefs.getString('jobId');
    final response = await http.post(
      Uri.parse(ApiService.driverJobsCheckJobStatus),
      body: {'d_id': dId.toString(), 'job_id': jobId.toString()},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == false) {
        prefs.remove("jobDispatched");
        prefs.remove("isRideStart");
        setState(() {});
        myController.visiblecontainer.value = false;
        myController.isJobDetailDone.value = false;
        myController.polylines.clear();
        print('the polyline list data is ${myController.polylines.value}');
        context.pushNamed('Home');
      } else {
        // Handle the job details as normal
      }
    } else {
      // Handle the error
    }
  }

  List<Job> listFromPusher = [];

  Future<void> showNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          ticker: 'ticker',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Customer Location',
      'You have reached on customer location.',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Timer? locationTrackingTimer;
  Future startTracking(double pickLat, double pickLng) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    locationTrackingTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        pickLat,
        pickLng,
      );

      if (distance < 4000) {
        // You can set the threshold to any value (e.g., 50 meters)
        // User has reached the destination
        print("Ride complete!");
        //  await     _showOverlay();
        await showNotification();
        locationTrackingTimer!.cancel(); // Stop the tracking
        locationTrackingTimer != null; // Stop the tracking
        // Navigator.pop(context);
        if (myController.initialLabelIndex.value == 1) {
          await sp.setBool('isWaitingTrue', true);
          await sp.setBool('show', false);
          await sp.setInt('isRideStart', 1);
          await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            enableDrag: false,
            context: context,
            builder: (context) {
              return Padding(
                padding: MediaQuery.viewInsetsOf(context),
                child: NotesWidget(
                  dId: myController.listFromPusher[0].dId,
                  jobId: myController.listFromPusher[0].jobId,
                  pickTime: myController.listFromPusher[0].pickTime,
                  pickDate: myController.listFromPusher[0].pickDate,
                  passenger: myController.listFromPusher[0].passenger,
                  pickup: myController.listFromPusher[0].pickup,
                  dropoff: myController.listFromPusher[0].destination,
                  luggage: myController.listFromPusher[0].luggage,
                  cName: myController.listFromPusher[0].cName,
                  cnumber: myController.listFromPusher[0].cPhone,
                  cemail: myController.listFromPusher[0].cEmail,
                  note: myController.listFromPusher[0].note,
                  fare: myController.listFromPusher[0].journeyFare,
                  distance: myController.listFromPusher[0].journeyDistance,
                ),
              );
            },
          ).then((value) => safeSetState(() {}));
        } else {
          Fluttertoast.showToast(
            msg: "Please be online before starting the ride.",
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        print("no reached the location");
      }
    });
  }

  bool isjobAvailable = false;
  Future<void> checkJob() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    isjobAvailable = sp.getBool('jobDispatched') ?? false;
    setState(() {});
  }

  Future<void> callAp() async {
    checkJob();
    await jobDetailsFuture().then((_) {
      periodicStatus = true;

      // _timer!.cancel();
    });
  }

  @override
  void dispose() {
    myController.mapController.value?.dispose();
    myController.mapController.value = null;
    _dispatchPollingTimer?.cancel();
    userSession?.cancel();
    locationTrackingTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void _initMapAndLocation() {
    unawaited(_getLocation());
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
    // getCoordinatesFromAddress(myController.listFromPusher.isNotEmpty
    //     ? myController.listFromPusher[0].pickup
    //     : '');
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
                  const Duration(seconds: 2)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Press again to exit')),
            );
            lastBackPressed = DateTime.now();
            await saveSwitchStatus(0);
            await sendOnlineStatus();
            stopLocationDataPeriodicUpdates();
            return false;
          } else {
            SystemNavigator.pop();
            return true;
          }
        },
        child: Scaffold(
          drawerEnableOpenDragGesture: false,
          backgroundColor: Colors.transparent,
          extendBody: true,
          key: scaffoldKey,
          drawer: DrawerWidget(),
          body: Stack(
            children: [
              Positioned.fill(child: buildMap()),
              SafeArea(
                top: true,
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Stack(
                          children: [
                            // Obx(() => )
                            const SizedBox.expand(),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 150.0),
                            //   child: TextButton(
                            //       onPressed: () {
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) => Dummy3View()));
                            //       },
                            //       child: Text('Navigation')),
                            // ),
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Obx(
                                () => Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                context.appTheme.primary,
                                                context.appTheme.secondary,
                                              ],
                                              stops: [0, 1],
                                              begin: const AlignmentDirectional(
                                                1,
                                                -0.98,
                                              ),
                                              end: const AlignmentDirectional(
                                                -1,
                                                0.98,
                                              ),
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                    30,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    30,
                                                  ),
                                                  topLeft: Radius.circular(0),
                                                  topRight: Radius.circular(0),
                                                ),
                                          ),
                                          child: InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional.fromSTEB(
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    myController
                                                                .initialLabelIndex
                                                                .value !=
                                                            1
                                                        ? 'Offline'
                                                        : 'Online',
                                                    style: context
                                                        .appTheme
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          fontSize: 18,
                                                          color:
                                                              context
                                                                  .appTheme
                                                                  .info,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.fromSTEB(
                                                0,
                                                0,
                                                0,
                                                0,
                                              ),
                                          child: Row(
                                            // mainAxisSize: MainAxisSize.max,
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 15),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    setState(() {});
                                                    print(
                                                      'the value is ${myController.jobPusherContainer.value}',
                                                    );
                                                    await checkJob();
                                                    if (isjobAvailable ==
                                                        false) {
                                                      scaffoldKey.currentState!
                                                          .openDrawer();
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            'Complete Job First',
                                                      );
                                                    }
                                                  },
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    elevation: 4,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            50,
                                                          ),
                                                    ),
                                                    child: Container(
                                                      width: 45,
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            context
                                                                .appTheme
                                                                .secondaryBackground,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              50,
                                                            ),
                                                        border: Border.all(
                                                          color:
                                                              context
                                                                  .appTheme
                                                                  .secondaryBackground,
                                                        ),
                                                      ),
                                                      alignment:
                                                          const AlignmentDirectional(
                                                            0,
                                                            0,
                                                          ),
                                                      child: FaIcon(
                                                        FontAwesomeIcons.listUl,
                                                        color:
                                                            context
                                                                .appTheme
                                                                .secondaryText,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                child: AnimatedGradientBorder(
                                                  borderSize: 4,
                                                  glowSize: 0,
                                                  gradientColors: [
                                                    Colors.transparent,
                                                    Colors.transparent,
                                                    Colors.transparent,
                                                    if (myController
                                                            .initialLabelIndex
                                                            .value ==
                                                        1)
                                                      context.appTheme.primary
                                                    else
                                                      Colors.red,
                                                  ],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                        Radius.circular(999),
                                                      ),
                                                  child: SizedBox(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                              Radius.circular(
                                                                999,
                                                              ),
                                                            ),
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .secondaryContainer,
                                                      ),
                                                      child: ToggleSwitch(
                                                        minWidth:
                                                            MediaQuery.sizeOf(
                                                              context,
                                                            ).width *
                                                            0.30,
                                                        minHeight: 50,
                                                        initialLabelIndex:
                                                            myController
                                                                .initialLabelIndex
                                                                .value,
                                                        cornerRadius: 30.0,
                                                        activeFgColor:
                                                            Colors.white,
                                                        inactiveBgColor:
                                                            Colors.grey,
                                                        inactiveFgColor:
                                                            Colors.white,
                                                        totalSwitches: 2,
                                                        labels: [
                                                          'Offline',
                                                          'Online',
                                                        ],
                                                        icons: [
                                                          FontAwesomeIcons
                                                              .powerOff,
                                                          FontAwesomeIcons
                                                              .dotCircle,
                                                        ],
                                                        activeBgColors: [
                                                          [
                                                            context
                                                                .appTheme
                                                                .error,
                                                          ],
                                                          [
                                                            context
                                                                .appTheme
                                                                .primary,
                                                          ],
                                                        ],
                                                        onToggle: (
                                                          index,
                                                        ) async {
                                                          setState(() {});
                                                          await checkVehicleDocuments();

                                                          await checkJob();
                                                          if (myController
                                                                      .initialLabelIndex
                                                                      .value ==
                                                                  1 &&
                                                              isjobAvailable ==
                                                                  true) {
                                                            Fluttertoast.showToast(
                                                              msg:
                                                                  'Complete Job First',
                                                            );
                                                          } else {
                                                            debugPrint(
                                                              'the selection is $status',
                                                            );
                                                            final service =
                                                                FlutterBackgroundService();
                                                            fetchJobStatus();
                                                            if (rootedCheck &&
                                                                jailbreak &&
                                                                devMode) {
                                                              showToast(
                                                                "Device is rooted",
                                                              );
                                                              showToast(
                                                                "Device is jailbreak",
                                                              );
                                                            } else {
                                                              var stb = true;
                                                              if (true ==
                                                                  true) {
                                                                await saveSwitchStatus(
                                                                  index!,
                                                                );
                                                                myController
                                                                    .initialLabelIndex
                                                                    .value = index;
                                                                if (!jobStatus) {
                                                                  if (index ==
                                                                      1) {
                                                                    print(
                                                                      'its online',
                                                                    );
                                                                    makeBeep();
                                                                    // startRingtoneAndVibrateLoop();
                                                                    sendOnlineStatus();
                                                                    sendLocationDataPeriodically();
                                                                    service
                                                                        .startService();
                                                                    await Future.delayed(
                                                                      const Duration(
                                                                        seconds:
                                                                            5,
                                                                      ),
                                                                    );
                                                                  } else if (index ==
                                                                      0) {
                                                                    makeBeep();
                                                                    // startRingtoneAndVibrateLoop();
                                                                    sendOnlineStatus();
                                                                    stopLocationDataPeriodicUpdates();
                                                                    service.invoke(
                                                                      "stopService",
                                                                    );
                                                                    await Future.delayed(
                                                                      const Duration(
                                                                        seconds:
                                                                            5,
                                                                      ),
                                                                    );
                                                                  } else {}
                                                                } else {
                                                                  // Fluttertoast
                                                                  //     .showToast(
                                                                  //   msg:
                                                                  //       "You Can't Go Offline.  You Go offline to Contact Support.",
                                                                  // );
                                                                }
                                                                if (mounted) {
                                                                  setState(() {
                                                                    // Update your state here
                                                                  });
                                                                }
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (
                                                                    BuildContext
                                                                    context,
                                                                  ) {
                                                                    return AlertDialog(
                                                                      title: const Text(
                                                                        'Upload Vehicle Documents Required',
                                                                      ),
                                                                      content:
                                                                          const Text(
                                                                            'You are not Online. Uploading vehicle documents is required before switching to the Online state.',
                                                                          ),
                                                                      actions: <
                                                                        Widget
                                                                      >[
                                                                        TextButton(
                                                                          child: const Text(
                                                                            'Cancel',
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.of(
                                                                              context,
                                                                            ).pop();
                                                                          },
                                                                        ),
                                                                        TextButton(
                                                                          child: const Text(
                                                                            'Upload',
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.of(
                                                                              context,
                                                                            ).pop();
                                                                            context.pushNamed(
                                                                              'AllDocoments',
                                                                            );
                                                                          },
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // TextButton(
                                        //   onPressed: () {
                                        //     Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //         builder:
                                        //             (context) => DummyViewMap(),
                                        //       ),
                                        //     );
                                        //   },
                                        //   child: Text('Map Testing'),
                                        // ),
                                        Obx(
                                          () =>
                                              myController
                                                      .isTimeSlotDispatched
                                                      .value
                                                  ? Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    width: double.infinity,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 10),
                                                        Text(
                                                          _formatTime(_seconds),
                                                          style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Text(
                                                              'TimeSlot-Date :',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              myController
                                                                  .timeSlotDate
                                                                  .value,
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                            Container(
                                                              height: 15,
                                                              width: 1,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            Text(
                                                              'Start time :',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              myController
                                                                  .timeSlotStarttime
                                                                  .value,
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Text(
                                                              'End time :',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              myController
                                                                  .timeSlotEndTime
                                                                  .value,
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                            Container(
                                                              height: 15,
                                                              width: 1,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            Text(
                                                              'Price per hour :',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                            Text(
                                                              '£${myController.timeSloPricePerhour.value}',
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text(
                                                                  '  Total pay : £${myController.timeSlottotalPay.value}',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            myController
                                                                        .isTimeSlotAccepted
                                                                        .value ==
                                                                    false
                                                                ? InkWell(
                                                                  onTap: () async {
                                                                    await FlutterRingtonePlayer()
                                                                        .stop();

                                                                    await Vibration.cancel();
                                                                    acceptTimeSlot();
                                                                    // _startTimer();
                                                                    // getTimeSlotFroApi();
                                                                    // timeSlotPusher();
                                                                  },
                                                                  child: Container(
                                                                    height: 40,
                                                                    width: 90,
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          context
                                                                              .appTheme
                                                                              .primary,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'Accept',
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                                : Container(),
                                                            myController
                                                                        .isTimeSlotAccepted
                                                                        .value ==
                                                                    false
                                                                ? GestureDetector(
                                                                  onTap: () async {
                                                                    await FlutterRingtonePlayer()
                                                                        .stop();
                                                                    await Vibration.cancel();
                                                                    rejectTimeSlot();
                                                                    // _stopTimer();
                                                                  },
                                                                  child: Container(
                                                                    height: 40,
                                                                    width: 90,
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          Colors
                                                                              .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        'Reject',
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                                : Container(),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5),
                                                      ],
                                                    ),
                                                  )
                                                  : Container(),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                            0,
                                            0,
                                            20,
                                            0,
                                          ),
                                      child: Align(
                                        alignment: const AlignmentDirectional(
                                          1,
                                          1,
                                        ),
                                        child: InkWell(
                                          onTap: _animateToCurrentLocation,
                                          child: Icon(
                                            Icons.my_location,
                                            color:
                                                Theme.of(context).primaryColor,
                                            size: 27,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 300.0,
                                right: 20,
                                left: 20,
                              ),
                              child: Obx(
                                () =>
                                    myController.isJobDetailDone.value
                                        ? Container(
                                          decoration: BoxDecoration(
                                            color:
                                                context
                                                    .appTheme
                                                    .primaryBackground,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          height: 80,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14.0,
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      const CircularProgressIndicator(
                                                        color: Colors.green,
                                                      ),
                                                ),
                                                const SizedBox(width: 20),
                                                Text(
                                                  'Please wait...',
                                                  style: TextStyle(
                                                    color:
                                                        context
                                                            .appTheme
                                                            .primaryText,
                                                    fontFamily: 'Satoshi',
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        : Container(),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Obx(
                                () =>
                                    myController.jobPusherContainer.value ==
                                            true
                                        ? AnimatedGradientBorder(
                                          glowSize: 0,
                                          gradientColors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.transparent,
                                            if (myController
                                                    .initialLabelIndex
                                                    .value ==
                                                1)
                                              context.appTheme.primary
                                            else
                                              Colors.transparent,
                                          ],
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                          child: HomeScreenAlert(
                                            isfromUi: true,
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.44,
                                            st:
                                                myController.listFromPusher
                                                    .toList(),
                                          ),
                                        )
                                        : SizedBox.shrink(),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom:
                                  MediaQuery.viewPaddingOf(context).bottom +
                                  104,
                              child: Obx(
                                () =>
                                    myController.visiblecontainer.value ==
                                                true &&
                                            myController
                                                .listFromPusher
                                                .isNotEmpty
                                        ? _buildAcceptedJobOverlay(context)
                                        : const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        false &&
                                myController.visiblecontainer.value == true &&
                                myController.listFromPusher.isNotEmpty
                            ? Container(
                              // height: 580,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SingleChildScrollView(
                                    child: Container(
                                      color: context.appTheme.primaryBackground,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional.fromSTEB(
                                                    0,
                                                    0,
                                                    0,
                                                    8,
                                                  ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '£${myController.listFromPusher[0].journeyFare}',
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: context
                                                            .appTheme
                                                            .displaySmall
                                                            .override(
                                                              fontFamily:
                                                                  'Outfit',
                                                              color:
                                                                  context
                                                                      .appTheme
                                                                      .primaryText,
                                                              fontSize: 32,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                      Text(
                                                        '(Estimated maximum value)',
                                                        style: context
                                                            .appTheme
                                                            .labelMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Montserrat',
                                                              color:
                                                                  context
                                                                      .appTheme
                                                                      .primaryText,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                    ].divide(
                                                      const SizedBox(height: 1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.car,
                                                    color: Color(0xFF5B68F5),
                                                    size: 35,
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Opacity(
                                                        opacity: 0.5,
                                                        child: SizedBox(
                                                          height: 30,
                                                          child: VerticalDivider(
                                                            thickness: 2,
                                                            color:
                                                                context
                                                                    .appTheme
                                                                    .secondaryText,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional.fromSTEB(
                                                              0,
                                                              0,
                                                              0,
                                                              0,
                                                            ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              'Time',
                                                              style: context
                                                                  .appTheme
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional.fromSTEB(
                                                                    0,
                                                                    5,
                                                                    0,
                                                                    0,
                                                                  ),
                                                              child: Text(
                                                                'Date',
                                                                style: context
                                                                    .appTheme
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional.fromSTEB(
                                                              80,
                                                              0,
                                                              0,
                                                              0,
                                                            ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                              myController
                                                                  .listFromPusher[0]
                                                                  .pickTime,
                                                              style: context
                                                                  .appTheme
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional.fromSTEB(
                                                                    0,
                                                                    5,
                                                                    0,
                                                                    0,
                                                                  ),
                                                              child: Text(
                                                                myController
                                                                    .listFromPusher[0]
                                                                    .pickDate,
                                                                style: context
                                                                    .appTheme
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Roboto',
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ].divide(
                                                  const SizedBox(width: 16),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                            color: const Color(
                                                              0xFF5B68F5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  50,
                                                                ),
                                                            shape:
                                                                BoxShape
                                                                    .rectangle,
                                                            border: Border.all(
                                                              color:
                                                                  const Color(
                                                                    0xFF5B68F5,
                                                                  ),
                                                              width: 2,
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'A',
                                                              style: context
                                                                  .appTheme
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Open Sans',
                                                                    color:
                                                                        context
                                                                            .appTheme
                                                                            .secondaryBackground,
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 25,
                                                            ),
                                                        child: Stack(
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Container(
                                                                width: 4,
                                                                height: 40,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                      color: Color(
                                                                        0xFFE5E7EB,
                                                                      ),
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    top: 5,
                                                                  ),
                                                              child: Container(
                                                                width: 30,
                                                                height: 30,
                                                                decoration: const BoxDecoration(
                                                                  color:
                                                                      Color.fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0.0,
                                                                      ),
                                                                  shape:
                                                                      BoxShape
                                                                          .circle,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          color: const Color(
                                                            0xFF5B68F5,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: const Color(
                                                              0xFF5B68F5,
                                                            ),
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'B',
                                                            style: context
                                                                .appTheme
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color:
                                                                      context
                                                                          .appTheme
                                                                          .secondaryBackground,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ), // Added SizedBox for spacing
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Flexible(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                      left: 10,
                                                                      // top: 10,
                                                                      bottom:
                                                                          10,
                                                                    ),
                                                                child: Text(
                                                                  myController
                                                                      .listFromPusher[0]
                                                                      .pickup,
                                                                  style: context
                                                                      .appTheme
                                                                      .labelMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Readex Pro',
                                                                        color:
                                                                            context.appTheme.secondaryText,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 3,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                bottom: 10,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              const FaIcon(
                                                                FontAwesomeIcons
                                                                    .bong,
                                                                color: Color(
                                                                  0xFF5B68F5,
                                                                ),
                                                                size: 18,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                      left: 8,
                                                                    ),
                                                                child: Text(
                                                                  '${(double.parse(myController.listFromPusher[0].journeyDistance) * 0.621371).toStringAsFixed(2)} Miles ${myController.listFromPusher[0].journeyType}',
                                                                  style: context
                                                                      .appTheme
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Open Sans',
                                                                        color:
                                                                            context.appTheme.secondaryText,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Flexible(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                      left: 10,
                                                                      bottom: 5,
                                                                    ),
                                                                child: Text(
                                                                  myController
                                                                      .listFromPusher[0]
                                                                      .destination,
                                                                  style: context
                                                                      .appTheme
                                                                      .labelMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Readex Pro',
                                                                        color:
                                                                            context.appTheme.secondaryText,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 3,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                FFButtonWidget(
                                                  onPressed: () async {
                                                    print(
                                                      'the value is ${myController.initialLabelIndex.value}',
                                                    );
                                                    SharedPreferences sp =
                                                        await SharedPreferences.getInstance();

                                                    _getCurrentTime();
                                                    await sp.setString(
                                                      'jobStartTime',
                                                      formattedTime,
                                                    );

                                                    showDialog(
                                                      context: context,
                                                      builder: (
                                                        BuildContext context,
                                                      ) {
                                                        return AlertDialog(
                                                          title: Text(
                                                            'Start navigation',
                                                          ),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              ListTile(
                                                                leading: SizedBox(
                                                                  width: 25,
                                                                  height: 25,
                                                                  child: Image.asset(
                                                                    'assets/images/google.png',
                                                                  ), // Replace 'your_image.png' with your image asset path
                                                                ),
                                                                title: Text(
                                                                  'Open Google Maps',
                                                                ),
                                                                onTap: () async {
                                                                  await getLatLngFromAddress(
                                                                    myController
                                                                        .listFromPusher[0]
                                                                        .pickup,
                                                                  );
                                                                  await sp.setInt(
                                                                    'isRideStart',
                                                                    1,
                                                                  );
                                                                  myController
                                                                      .visiblecontainer
                                                                      .value = false;
                                                                  // first background
                                                                  startRideTracking(
                                                                    latitudeforGooglmap
                                                                        .toString(),
                                                                    lngforGooglmap
                                                                        .toString(),
                                                                  );
                                                                  await startTracking(
                                                                    latitudeforGooglmap,
                                                                    lngforGooglmap,
                                                                  );
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                  await MapUtils.navigateTo(
                                                                    latitudeforGooglmap,
                                                                    lngforGooglmap,
                                                                  );
                                                                  // start from here
                                                                },
                                                              ),
                                                              ListTile(
                                                                leading: SizedBox(
                                                                  width: 25,
                                                                  height: 25,
                                                                  child: Image.asset(
                                                                    'assets/driver-app-icon.jpg',
                                                                  ), // Replace 'your_image.png' with your image asset path
                                                                ),
                                                                title: Text(
                                                                  'Use in-app Mapbox route',
                                                                ),
                                                                onTap: () async {
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                  if (myController
                                                                          .initialLabelIndex
                                                                          .value ==
                                                                      1) {
                                                                    await sp
                                                                        .setBool(
                                                                          'show',
                                                                          false,
                                                                        );
                                                                    await sp.setInt(
                                                                      'isRideStart',
                                                                      1,
                                                                    );
                                                                    myController
                                                                        .visiblecontainer
                                                                        .value = false;
                                                                    await showModalBottomSheet(
                                                                      isScrollControlled:
                                                                          true,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      enableDrag:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder: (
                                                                        context,
                                                                      ) {
                                                                        return Padding(
                                                                          padding: MediaQuery.viewInsetsOf(
                                                                            context,
                                                                          ),
                                                                          child: NotesWidget(
                                                                            dId:
                                                                                myController.listFromPusher[0].dId,
                                                                            jobId:
                                                                                myController.listFromPusher[0].jobId,
                                                                            pickTime:
                                                                                myController.listFromPusher[0].pickTime,
                                                                            pickDate:
                                                                                myController.listFromPusher[0].pickDate,
                                                                            passenger:
                                                                                myController.listFromPusher[0].passenger,
                                                                            pickup:
                                                                                myController.listFromPusher[0].pickup,
                                                                            dropoff:
                                                                                myController.listFromPusher[0].destination,
                                                                            luggage:
                                                                                myController.listFromPusher[0].luggage,
                                                                            cName:
                                                                                myController.listFromPusher[0].cName,
                                                                            cnumber:
                                                                                myController.listFromPusher[0].cPhone,
                                                                            cemail:
                                                                                myController.listFromPusher[0].cEmail,
                                                                            note:
                                                                                myController.listFromPusher[0].note,
                                                                            fare:
                                                                                myController.listFromPusher[0].journeyFare,
                                                                            distance:
                                                                                myController.listFromPusher[0].journeyDistance,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).then(
                                                                      (
                                                                        value,
                                                                      ) => safeSetState(
                                                                        () {},
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    Fluttertoast.showToast(
                                                                      msg:
                                                                          "Please be online before starting the ride.",
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          16.0,
                                                                    );
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  text: 'Start Now',
                                                  icon: const Icon(
                                                    Icons.east,
                                                    size: 15,
                                                  ),
                                                  options: FFButtonOptions(
                                                    height: 40,
                                                    padding:
                                                        const EdgeInsetsDirectional.fromSTEB(
                                                          24,
                                                          0,
                                                          24,
                                                          0,
                                                        ),
                                                    iconPadding:
                                                        const EdgeInsetsDirectional.fromSTEB(
                                                          0,
                                                          0,
                                                          0,
                                                          0,
                                                        ),
                                                    color:
                                                        context
                                                            .appTheme
                                                            .primary,
                                                    textStyle: context
                                                        .appTheme
                                                        .titleSmall
                                                        .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                        ),
                                                    elevation: 3,
                                                    borderSide:
                                                        const BorderSide(
                                                          color:
                                                              Colors
                                                                  .transparent,
                                                          width: 1,
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ].divide(const SizedBox(height: 4)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getCurrentTime() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm a');
    setState(() {
      formattedTime = formatter.format(now);
    });
  }

  String formattedTime = "";
  Widget buildMap() {
    return Obx(() {
      final latitude = myController.latitude.value;
      final longitude = myController.longitude.value;
      final destinationLat = myController.convertedLat.value;
      final destinationLng = myController.convertedLng.value;
      final routeCount = myController.decodedPoints.length;
      final currentLatitude =
          latitude != 0.0
              ? latitude
              : myController.currentLocation?.latitude ?? 0.0;
      final currentLongitude =
          longitude != 0.0
              ? longitude
              : myController.currentLocation?.longitude ?? 0.0;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncMapboxAnnotations(
          latitude: currentLatitude,
          longitude: currentLongitude,
          destinationLat: destinationLat,
          destinationLng: destinationLng,
          routeCount: routeCount,
        );
      });

      final centerLat = currentLatitude != 0.0 ? currentLatitude : 51.5074;
      final centerLng = currentLongitude != 0.0 ? currentLongitude : -0.1278;

      return mapbox.MapWidget(
        key: const ValueKey('home-mapbox-map'),
        styleUri: mapbox.MapboxStyles.STANDARD,
        cameraOptions: mapbox.CameraOptions(
          center: _mapboxPoint(centerLng, centerLat),
          zoom: 15.5,
          pitch: 54,
        ),
        onMapCreated: _onMapboxMapCreated,
        onStyleLoadedListener: (_) async {
          _mapboxStyleReady = true;
          await _syncMapboxAnnotations(
            latitude: currentLatitude,
            longitude: currentLongitude,
            destinationLat: destinationLat,
            destinationLng: destinationLng,
            routeCount: routeCount,
          );
        },
      );
    });
  }

  mapbox.Point _mapboxPoint(double longitude, double latitude) {
    return mapbox.Point(coordinates: mapbox.Position(longitude, latitude));
  }

  Future<void> _onMapboxMapCreated(mapbox.MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    _mapPointManager =
        await mapboxMap.annotations.createPointAnnotationManager();
    _mapPolylineManager =
        await mapboxMap.annotations.createPolylineAnnotationManager();

    await mapboxMap.location.updateSettings(
      mapbox.LocationComponentSettings(
        enabled: false,
        pulsingEnabled: false,
        puckBearingEnabled: false,
      ),
    );
    unawaited(_getLocation());
  }

  Future<void> _syncMapboxAnnotations({
    required double latitude,
    required double longitude,
    required double destinationLat,
    required double destinationLng,
    required int routeCount,
  }) async {
    if (!_mapboxStyleReady ||
        _mapPointManager == null ||
        _mapPolylineManager == null) {
      return;
    }

    _driverMarkerImage ??= await _buildDriverMarkerBytes();
    _destinationMarkerImage ??= await _loadMarkerBytes(
      'assets/images/userg.png',
    );

    await _mapPointManager!.deleteAll();
    final pointOptions = <mapbox.PointAnnotationOptions>[];
    if (latitude != 0.0 && longitude != 0.0 && _driverMarkerImage != null) {
      pointOptions.add(
        mapbox.PointAnnotationOptions(
          geometry: _mapboxPoint(longitude, latitude),
          image: _driverMarkerImage,
          iconSize: 0.52,
          iconAnchor: mapbox.IconAnchor.BOTTOM,
          symbolSortKey: 2,
        ),
      );
    }

    if (destinationLat != 0.0 &&
        destinationLng != 0.0 &&
        _destinationMarkerImage != null) {
      pointOptions.add(
        mapbox.PointAnnotationOptions(
          geometry: _mapboxPoint(destinationLng, destinationLat),
          image: _destinationMarkerImage,
          iconSize: 0.72,
          iconAnchor: mapbox.IconAnchor.BOTTOM,
          symbolSortKey: 3,
        ),
      );
    }

    if (pointOptions.isNotEmpty) {
      await _mapPointManager!.createMulti(pointOptions);
    }

    await _mapPolylineManager!.deleteAll();
    if (routeCount > 1) {
      final coordinates =
          myController.decodedPoints
              .map((point) => mapbox.Position(point.longitude, point.latitude))
              .toList();
      await _mapPolylineManager!.create(
        mapbox.PolylineAnnotationOptions(
          geometry: mapbox.LineString(coordinates: coordinates),
          lineColor: _green.value,
          lineOpacity: 0.92,
          lineWidth: 6,
          lineBorderColor: Colors.white.value,
          lineBorderWidth: 1.5,
        ),
      );
    }
  }

  Future<Uint8List> _buildDriverMarkerBytes() async {
    const markerWidth = 112;
    const markerHeight = 136;
    const center = Offset(markerWidth / 2, 52);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final pinPath =
        Path()
          ..moveTo(markerWidth / 2, markerHeight - 8)
          ..cubicTo(47, 116, 16, 90, 16, 52)
          ..cubicTo(16, 26, 34, 8, markerWidth / 2, 8)
          ..cubicTo(78, 8, 96, 26, 96, 52)
          ..cubicTo(96, 90, 65, 116, markerWidth / 2, markerHeight - 8)
          ..close();

    canvas.drawPath(
      pinPath.shift(const Offset(0, 5)),
      Paint()
        ..color = const Color(0x33000000)
        ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8),
    );
    canvas.drawPath(pinPath, Paint()..color = Colors.white);
    canvas.drawPath(
      pinPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = _green,
    );

    canvas.drawCircle(center, 34, Paint()..color = _green);
    canvas.drawCircle(
      center,
      27,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0x26FFFFFF),
    );

    final carIcon = Icons.local_taxi_rounded;
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(carIcon.codePoint),
        style: TextStyle(
          color: Colors.white,
          fontFamily: carIcon.fontFamily,
          package: carIcon.fontPackage,
          fontSize: 42,
          height: 1,
        ),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    iconPainter.paint(
      canvas,
      Offset(
        center.dx - iconPainter.width / 2,
        center.dy - iconPainter.height / 2,
      ),
    );

    canvas.drawCircle(
      const Offset(markerWidth / 2, markerHeight - 13),
      4,
      Paint()..color = _gold,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(markerWidth, markerHeight);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    picture.dispose();
    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> _loadMarkerBytes(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  // Widget buildMap() {
  //   return GoogleMap(
  //     onMapCreated: (GoogleMapController controller) {
  //       // myController.mapController.value = controller;

  final LatLng _destination = LatLng(34.0522, -118.2437);
  void fetchJobStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');

      if (dId != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(ApiService.driverJobsAcceptedJobsToday),
        );
        request.fields.addAll({'d_id': dId});

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          var responseString = await response.stream.bytesToString();
          var responseData = jsonDecode(responseString);

          jobStatus = responseData['status'];
        } else {}
      } else {}
    } catch (e) {}
  }

  void _animateToCurrentLocation() {
    final latitude =
        myController.latitude.value != 0.0
            ? myController.latitude.value
            : myController.currentLocation?.latitude;
    final longitude =
        myController.longitude.value != 0.0
            ? myController.longitude.value
            : myController.currentLocation?.longitude;

    if (latitude == null || longitude == null) {
      return;
    }

    _mapboxMap?.flyTo(
      mapbox.CameraOptions(
        center: _mapboxPoint(longitude, latitude),
        zoom: 16.5,
        pitch: 56,
      ),
      mapbox.MapAnimationOptions(duration: 900),
    );
    if (_mapboxMap == null) {
      myController.mapController.value?.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 14.5),
      );
    }
  }

  Future<void> androidRootChecker() async {
    try {
      // rootedCheck = (await RootCheckerPlus.isRootChecker())!;
    } on PlatformException {
      rootedCheck = false;
    }
    if (!mounted) return;
    setState(() {
      rootedCheck = rootedCheck;
    });
  }

  Future<void> developerMode() async {
    try {
      // devMode = (await RootCheckerPlus.isDeveloperMode())!;
    } on PlatformException {
      devMode = false;
    }
    if (!mounted) return;
    setState(() {
      devMode = devMode;
    });
  }

  Future<void> iosJailbreak() async {
    try {
      // jailbreak = (await RootCheckerPlus.isJailbreak())!;
    } on PlatformException {
      jailbreak = false;
    }
    if (!mounted) return;
    setState(() {
      jailbreak = jailbreak;
    });
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Timer? _checkTimer;
  int _seconds = 0;
  final bool _isRunning = false;
  String? _startTime; // Start time from API in "HH:mm:ss"
  String? _endTime; // End time from API in "HH:mm:ss"
  // bool myController.isTimeSlotAccepted.value = false;
  Future<void> acceptTimeSlot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    String? tsid = prefs.getString('ts_id');

    final response = await http.post(
      Uri.parse(ApiService.driverTimeslotsAcceptTimeSlot),
      body: {'d_id': dId.toString(), 'ts_id': tsid.toString()},
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true) {
        // Assuming the API returns time in "HH:mm:ss" format
        await prefs.setBool('accepted', true);
        setState(() {});

        // await prefs.setString('startTime', _startTime!);
        // await prefs.setString('endTime', _endTime!);

        updateEndTime(myController.timeSlotEndTime.value);
        setTsId(myController.timeSlotid.value);
        await prefs.setBool('isAccepted', true);

        myController.isTimeSlotAccepted.value = true;
        _startCounter(); // Start checking for time match
        //  start
      } else {}
    } else {}
  }

  void updateEndTime(String newEndTime) async {
    setState(() {});
    final service = FlutterBackgroundService();
    // This will send the 'updateTimer' event to the background service
    service.invoke('updateTimer', {'endTime': newEndTime});
  }

  void startRideTracking(
    String customerLocation1,
    String customerLocation2,
  ) async {
    setState(() {});
    final service = FlutterBackgroundService();
    // This will send the 'updateTimer' event to the background service
    service.invoke('StartRide', {
      'startRideEvent1': customerLocation1,
      'startRideEvent2': customerLocation2,
    });
  }

  void setTsId(String tsId) async {
    setState(() {});
    final service = FlutterBackgroundService();
    // This will send the 'updateTimer' event to the background service
    service.invoke('setTsId', {'tsId': tsId});
  }

  // Parse time from strings to DateTime
  DateTime _parseTime(String date, String time) {
    String dateTimeString = "$date $time";
    return DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTimeString);
  }

  DateTime? startTime;
  DateTime? endTime;
  // Load saved state from SharedPreferences
  Future<void> _loadSavedState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? startTimeString = prefs.getString('start-Time');
    String? endTimeString = prefs.getString('end-Time');

    if (startTimeString != null && endTimeString != null) {
      startTime = DateTime.parse(startTimeString);
      endTime = DateTime.parse(endTimeString);

      DateTime now = DateTime.now();
      if (now.isBefore(endTime!)) {
        if (now.isAfter(startTime!)) {
          // Timer should be running, calculate how long the counter should be
          Duration elapsed = now.difference(startTime!);
          _seconds = elapsed.inSeconds;
          _startCounter();
        } else {
          // Wait for the startTime
          _startCounter();
        }
      } else {
        // Timer has already finished, no action needed
        await prefs.remove('start-Time');
        await prefs.remove('end-Time');
      }
    } else {
      // Initialize fresh times if there's no saved state
      String dateString =
          myController.timeSlotDate.value; // Change date accordingly
      startTime = _parseTime(
        dateString,
        myController.timeSlotStarttime.value,
      ); // hh:mm:ss
      endTime = _parseTime(
        dateString,
        myController.timeSlotEndTime.value,
      ); // hh:mm:ss
    }
  }

  void _startCounter() async {
    if (startTime == null || endTime == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save startTime, endTime to SharedPreferences
    await prefs.setString('start-Time', startTime!.toIso8601String());
    await prefs.setString('end-Time', endTime!.toIso8601String());

    DateTime now = DateTime.now();

    // If the current time is after start time, calculate the delay
    if (now.isAfter(startTime!)) {
      setState(() {
        // isRunning = true;
      });
      Duration remainingTime = endTime!.difference(now);

      // Start counting up from the already elapsed time
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        setState(() {
          _seconds++;
        });

        // Save the counter value to SharedPreferences
        await prefs.setInt('counter', _seconds);

        // If current time reaches endTime, stop the counter
        if (DateTime.now().isAfter(endTime!)) {
          _stopCounter();
        }
      });

      Future.delayed(remainingTime, () {
        _stopCounter();
      });
    } else {
      // If current time is before start time, wait until start time
      Duration initialDelay = startTime!.difference(now);
      Future.delayed(initialDelay, () {
        setState(() {
          // isRunning = true;
        });
        _startCounter(); // Recursive call to start when start time is reached
      });
    }
  }

  void _stopCounter() async {
    _timer?.cancel();
    // setState(() {
    //   isRunning = false;
    // });

    if (mounted) {
      setState(() {
        completeTimeSlot();
        // isRunning = false;
      });
    }
    // Clear the saved state when the timer stops
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('start-Time');
    await prefs.remove('end-Time');
  }

  Timer? _timer;

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> completeTimeSlot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    String? tsid = prefs.getString('ts_id');

    final response = await http.post(
      Uri.parse(ApiService.driverTimeslotsCompleteTimeSlot),
      body: {'d_id': dId.toString(), 'ts_id': tsid.toString()},
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true) {
        await prefs.remove('accepted');
        // Assuming the API returns time in "HH:mm:ss" format
        getTimeSlotFroApi();
      } else {}
    } else {}
  }

  Future<void> rejectTimeSlot() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    String? tsid = prefs.getString('ts_id');

    final response = await http.post(
      Uri.parse(ApiService.driverTimeslotsRejectTimeSlot),
      body: {'d_id': dId.toString(), 'ts_id': tsid.toString()},
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true) {
        // Assuming the API returns time in "HH:mm:ss" format
        getTimeSlotFroApi();
      } else {}
    } else {}
  }

  Future<void> jobDetailsFuture({bool playAlertForNewJob = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');

    try {
      final response = await http.post(
        Uri.parse(ApiService.driverJobsUpcomingJobs),
        body: {'d_id': dId.toString()},
      );

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);

        final status = jsonMap['status'] == true;

        if (status == true &&
            jsonMap['data'] is List &&
            (jsonMap['data'] as List).isNotEmpty) {
          periodicStatus = true;

          final firstJob = Map<String, dynamic>.from(
            (jsonMap['data'] as List).first as Map,
          );
          await _publishDispatchedJob(
            _jobFromPusherData(firstJob),
            prefs,
            playAlert: playAlertForNewJob,
          );
        } else {
          periodicStatus = false;
          myController.jobPusherContainer.value = false;
          listFromPusher.clear();
        }

        // // Process and return jobs if available
        // if (parsedResponse['data'] is List &&
        //     parsedResponse['data'].isNotEmpty) {
        //   List<Job> jobs = [];
        //   for (var jobJson in parsedResponse['data']) {
        //     jobs.add(Job.fromJson(jobJson));
        //   }
        //   return jobs;
        // } else {
        //   throw Exception('No jobs found');
        // }
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      debugPrint('Dispatch polling failed: $e');
    }
  }

  AudioPlayer player = AudioPlayer();
  Future<void> makeBeep() async {
    player.setReleaseMode(ReleaseMode.stop);

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(AssetSource('audios/beep.mp3'));
      await player.resume();
    });
  }

  void startRingtoneAndVibrateLoop() {
    FlutterRingtonePlayer().play(
      android: AndroidSounds.alarm,
      ios: IosSounds.alarm,
      looping: true,
      volume: 1.0,
    );
    Vibration.vibrate(duration: 3000);

    Timer(const Duration(seconds: 34), () {
      FlutterRingtonePlayer().stop();
      Vibration.cancel();
    });
  }

  Future<void> DueBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiService.driverAccountsTotalDueBalance),
    );
    request.fields.addAll({'d_id': dId.toString()});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      String totalCommission = jsonResponse['data']?['total_commission'] ?? '';
      if (mounted) {
        setState(() {
          dueBalance = totalCommission;
        });
      } else {}
    } else {}
  }

  String? dueBalance = '0';
  Future<void> checkVehicleDocuments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    print('the driver id is $dId');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiService.driverDocumentsCheckVehicleDocuments),
    );
    request.fields.addAll({'d_id': dId.toString(), 'status': 'online'});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(
        await response.stream.bytesToString(),
      );
      if (responseData['status'] == true) {
        status = true;
      } else {
        status = false;
      }
    } else {
      status = false;
    }
  }

  Future<void> saveIsLoginInPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
  }

  Future<void> _loadSwitchStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedIndex = prefs.getInt('switchValue') ?? 0;
    setState(() {
      myController.initialLabelIndex.value = savedIndex;
    });
  }

  Future<void> saveSwitchStatus(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('switchValue', index);
  }

  Future<void> sendOnlineStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      int index = prefs.getInt('switchValue') ?? 0; // Retrieve switch value

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverActivityOnlineStatus),
      );
      request.fields.addAll({
        'd_id': dId.toString(),
        'status': index == 1 ? 'Online' : 'Offline',
      });
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {}
  }

  Future<void> sendLocationData(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String driverId = prefs.getString('d_id') ?? '';
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiService.driverActivityRealLocation),
    );
    request.fields.addAll({
      'd_id': driverId.toString(),
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    });

    request.fields.forEach((key, value) {});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    } else {}
  }

  void sendLocationDataPeriodically() {
    locationTimer = Timer.periodic(const Duration(seconds: 10), (
      Timer timer,
    ) async {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        double latitude = position.latitude;
        double longitude = position.longitude;

        await sendLocationData(latitude, longitude);
      } catch (e) {}
    });
  }

  void stopLocationDataPeriodicUpdates() {
    locationTimer?.cancel();
    locationTimer = null;
  }

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable location services.');
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Location permission is required.');
      return false;
    }

    return true;
  }

  Future<void> _getLocation() async {
    if (_isFetchingCurrentLocation) {
      return;
    }

    _isFetchingCurrentLocation = true;
    try {
      final hasPermission = await _ensureLocationPermission();
      if (!hasPermission) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      myController.currentLocation = position;
      myController.latitude.value = position.latitude;
      myController.longitude.value = position.longitude;

      final currentLatLng = LatLng(position.latitude, position.longitude);
      _mapboxMap?.flyTo(
        mapbox.CameraOptions(
          center: _mapboxPoint(position.longitude, position.latitude),
          zoom: 16.2,
          pitch: 54,
        ),
        mapbox.MapAnimationOptions(duration: 700),
      );
      myController.mapController.value?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng, 16.2),
      );

      await _syncMapboxAnnotations(
        latitude: position.latitude,
        longitude: position.longitude,
        destinationLat: myController.convertedLat.value,
        destinationLng: myController.convertedLng.value,
        routeCount: myController.decodedPoints.length,
      );

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } finally {
      _isFetchingCurrentLocation = false;
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
