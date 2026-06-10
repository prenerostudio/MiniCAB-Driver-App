import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:new_minicab_driver/Acount%20Statements/accounts_bottomSheet.dart';
import 'package:new_minicab_driver/bids/bids_bottom_sheet.dart';
import 'package:new_minicab_driver/components/upcommingjob_widget.dart';
import 'package:new_minicab_driver/dashboard/dashboard_bottom_sheet.dart';
import 'package:new_minicab_driver/home/home_view_controller.dart';
import 'package:new_minicab_driver/home/timer_controller.dart';
import 'package:new_minicab_driver/upcomming/upcomming_widget.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/base_auth_user_provider.dart';
import 'auth/simple_auth_user_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

import 'home/home_widget.dart';
import 'package:new_minicab_driver/Data/api_service.dart';

const _defaultMapboxAccessToken =
    'pk.eyJ1IjoicHJlbmVyb3N0dWRpb3MiLCJhIjoiY21vdTAxbDF0MDl5ZzJ0c2h1OWU5cXlvZyJ9.r18j8yamEjiEAmIsBwRnBw';
const _mapboxAccessToken = String.fromEnvironment(
  'MAPBOX_ACCESS_TOKEN',
  defaultValue: '',
);
const _legacyMapboxAccessToken = String.fromEnvironment(
  'ACCESS_TOKEN',
  defaultValue: '',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  mapbox.MapboxOptions.setAccessToken(
    _mapboxAccessToken.isNotEmpty
        ? _mapboxAccessToken
        : _legacyMapboxAccessToken.isNotEmpty
        ? _legacyMapboxAccessToken
        : _defaultMapboxAccessToken,
  );
  notification();
  initializeService();
  runApp(MyApp());
}

// @pragma("vm:entry-point")
// ss
// void overlayMain() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home:TrueCallerOverlay(),
//     ),
//   );
// }
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
JobController myController = Get.put(JobController());

class St extends StatefulWidget {
  const St({super.key});

  @override
  State<St> createState() => _StState();
}

class _StState extends State<St> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Container(height: 300, width: 400, color: Colors.red)],
      ),
    );
  }
}

class _ElegantDriverNavBar extends StatelessWidget {
  const _ElegantDriverNavBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _DriverNavItem(Icons.home_rounded, 'Home'),
    _DriverNavItem(FontAwesomeIcons.carRear, 'Jobs'),
    _DriverNavItem(Icons.space_dashboard_rounded, 'Stats'),
    _DriverNavItem(Icons.local_offer_rounded, 'Bids'),
    _DriverNavItem(Icons.account_balance_wallet_rounded, 'Pay'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x24101820),
              blurRadius: 28,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              height: 74,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE1E7E3)),
              ),
              child: Row(
                children:
                    _items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final selected = index == currentIndex;

                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index == _items.length - 1 ? 0 : 4,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => onTap(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOutCubic,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      selected
                                          ? const Color(0xFF101820)
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedScale(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      curve: Curves.easeOut,
                                      scale: selected ? 1.05 : 1,
                                      child: Icon(
                                        item.icon,
                                        size: selected ? 22 : 20,
                                        color:
                                            selected
                                                ? const Color(0xFFEACB6C)
                                                : const Color(0xFF7D8A83),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      item.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color:
                                            selected
                                                ? Colors.white
                                                : const Color(0xFF7D8A83),
                                        fontSize: 10,
                                        fontWeight:
                                            selected
                                                ? FontWeight.w800
                                                : FontWeight.w600,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DriverNavItem {
  const _DriverNavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}

Future notification() async {
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    '09',
    'Minicab Service',
    description: 'Waiting for upcoming job',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('app_launcher_icon'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  TimerController timerController = Get.put(TimerController());
  DartPluginRegistrant.ensureInitialized();
  // String tsid = '';
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  // timeSlotPusher();
  Timer.periodic(Duration(seconds: 1), (timer) async {
    String? startTime = preferences.getString('startTime');

    // if (startTime != null && timerController.endTime.value != null) {
    service.on('StartRide').listen((event) async {
      // Example: Update the endTime from the UI
      if (event != null && event['startRideEvent1'] != null) {
        print('first triggers');
        String pickLat = event['startRideEvent1'];
        String pickLng = event['startRideEvent2'];
        startTracking(double.parse(pickLat), double.parse(pickLng));
      }
    });
    service.on('StartRide2').listen((event) async {
      // Example: Update the endTime from the UI

      if (event != null && event['startRideSecondEvent1'] != null) {
        print('second triggers');
        String pickLat = event['startRideSecondEvent1'];
        String pickLng = event['startRideSecondEvent2'];
        startTrackingforpickUp(double.parse(pickLat), double.parse(pickLng));
      }
    });
    service.on('StartRide3').listen((event) async {
      // Example: Update the endTime from the UI
      if (event != null && event['startRideThirdEvent1'] != null) {
        print('third triggers');
        String pickLat = event['startRideThirdEvent1'];
        String pickLng = event['startRideThirdEvent2'];
        String timeCount = event['timecount'];
        startTrackingfordropOf(
          double.parse(pickLat),
          double.parse(pickLng),
          timeCount,
        );
      }
    });
    service.on('updateTimer').listen((event) async {
      // Example: Update the endTime from the UI
      if (event != null && event['endTime'] != null) {
        String newEndTime = event['endTime'];

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('endTime', newEndTime);
        timerController.endTime.value = preferences.getString('endTime') ?? '';
      }
    });
    service.on('setTsId').listen((event) async {
      // Example: Update the endTime from the UI
      if (event != null && event['tsId'] != null) {
        String tsId = event['tsId'];

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('ts_id', tsId);
        timerController.tsId.value = preferences.getString('ts_id') ?? '';
      }
    });
    timerController.currentTime.value =
        _getCurrentTime(); // Get current time in "HH:mm:ss"

    // print('check current time ${timerController.currentTime.value}');

    if (timerController.currentTime.value == timerController.endTime.value) {
      completeTimeSlot(
        timerController.tsId.value,
      ); // Send complete status if time is finished
      timer.cancel(); // Stop the timer
    }
  });

  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "Minicab Service",
          content: "Waiting for upcoming job",
        );
      }
    }
    // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    try {
      if (await checkApiStatus()) {
        showNotification();
      }
    } catch (e) {}
    if (await checkLatestTimeslot()) {
      showtimeSlotNoti();
    }
    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }
    service.invoke('update', {
      "current_date": DateTime.now().toIso8601String(),
      "device": device,
    });
  });
}

Timer? locationTrackingTimer;
Future startTracking(double pickLat, double pickLng) async {
  SharedPreferences sp = await SharedPreferences.getInstance();

  locationTrackingTimer?.cancel(); // Stop the tracking
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
      print("first listner");
      //  await     _showOverlay();c
      showNotificationFor1(
        'Customer Location',
        'You have reached on customer location.',
      );
      locationTrackingTimer?.cancel(); // Stop the tracking
      locationTrackingTimer = null; // Stop the tracking
      // Navigator.pop(context);
      await sp.setBool('isWaitingTrue', true);
      await sp.setBool('show', false);
      await sp.setInt('isRideStart', 1);
    } else {
      print("no reached the location");
    }
  });
}

String _getCurrentTime() {
  DateTime now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
}

Timer? locationTrackingTimer1;
Timer? locationTrackingTimer2;
Future startTrackingforpickUp(double pickLat, double pickLng) async {
  SharedPreferences sp = await SharedPreferences.getInstance();

  locationTrackingTimer1?.cancel(); // Stop the tracking
  locationTrackingTimer1 = Timer.periodic(Duration(seconds: 5), (timer) async {
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
      print("secnd listner");
      //  await     _showOverlay();
      await showNotificationFor1(
        'Customer Location',
        'You have reached on customer location.',
      );
      locationTrackingTimer1?.cancel(); // Stop the tracking
      locationTrackingTimer1 = null;
    } else {
      print("no reached the location");
    }
  });
}

Future startTrackingfordropOf(
  double pickLat,
  double pickLng,
  String timerDisplayValue,
) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  String? did = sp.getString('d_id');
  String? jobid = sp.getString('job_id');
  // if (locationTrackingTimer2 != null) {
  //   locationTrackingTimer2!.cancel();
  // }
  locationTrackingTimer2?.cancel(); // Cancel if not null
  locationTrackingTimer2 = Timer.periodic(Duration(seconds: 5), (timer) async {
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
      print("third listner!");
      //  await     _showOverlay();
      await showNotificationFor1(
        'Ride Complete',
        'You have reached on destination',
      );

      locationTrackingTimer2?.cancel();
      locationTrackingTimer2 = null; // Set to null to avoid reuse

      // print('if condtion isridestarted is $isRideStarted');

      await sp.remove('isWaitingTrue');
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCalculateWaitingTime),
      );
      request.fields.addAll({
        'd_id': '$did',
        'job_id': '$jobid',
        'waiting_time': timerDisplayValue,
        // 'waiting_time': _model.timerValue.toString()
      });

      try {
        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
        } else {}
      } catch (e) {}
      // _stopTimer();
      // _model.timerController.onStopTimer();
      // await sp.setString('timerValue', _model.timerValue.toString());
      await sp.setInt('isRideStart', 2);
      // Timer(Duration(seconds: 2), () {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => PobWidget()));
      // });

      // isRideStarted = false;
      // isWaiting = false;
    } else {
      print("no reached the location");
    }
  });
}

Future<void> completeTimeSlot(String tsid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? dId = prefs.getString('d_id');

  final response = await http.post(
    Uri.parse(ApiService.driverCompleteTimeSlot),
    body: {'d_id': dId.toString(), 'ts_id': tsid.toString()},
  );
  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['status'] == true) {
      await prefs.remove('accepted');
      await prefs.remove('ts_id');
      // Assuming the API returns time in "HH:mm:ss" format
      // getTimeSlotFroApi();
    } else {}
  } else {}
}

Future<bool> checkApiStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final dId = prefs.getString('d_id');
  final response = await http.post(
    Uri.parse(ApiService.driverUpcomingJobs),
    body: {'d_id': dId.toString()},
  );

  if (response.statusCode == 200) {
    final parsedResponse = json.decode(response.body);
    if (parsedResponse['status'] == true) {
      final data = parsedResponse['data'];
      final jobs = _backgroundJobMaps(data);

      if (jobs.isEmpty) {
        return false;
      }

      return jobs.any((job) => !_isBackgroundJobAlreadyHandled(job, prefs));
    }
  } else {
    // print("API check failed with status code: ${response.statusCode}");
    throw Exception('API Check Failed');
  }
  // print("No new jobs found.");
  return false;
}

List<Map<String, dynamic>> _backgroundJobMaps(dynamic data) {
  if (data is List) {
    return data
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList(growable: false);
  }

  if (data is Map) {
    return [Map<String, dynamic>.from(data)];
  }

  return const [];
}

String _backgroundText(Map<String, dynamic> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value == null) {
      continue;
    }

    final text = value.toString().trim();
    if (text.isNotEmpty && text != 'null') {
      return text;
    }
  }
  return '';
}

List<String> _backgroundDispatchKeysForIds({
  required String jobId,
  required String bookId,
}) {
  final keys = <String>[];
  if (jobId.isNotEmpty && jobId != '--') {
    keys.add('job:$jobId');
  }
  if (bookId.isNotEmpty && bookId != '--') {
    keys.add('book:$bookId');
  }
  return keys;
}

bool _prefsContainAnyDispatchKey(
  SharedPreferences prefs,
  String prefsKey,
  Iterable<String> dispatchKeys,
) {
  final storedKeys = prefs.getStringList(prefsKey) ?? const <String>[];
  return dispatchKeys.any(storedKeys.contains);
}

bool _isBackgroundJobAlreadyHandled(
  Map<String, dynamic> job,
  SharedPreferences prefs,
) {
  final jobId = _backgroundText(job, ['job_id', 'jobId', 'j_id']);
  final bookId = _backgroundText(job, [
    'book_id',
    'bookId',
    'booking_id',
    'bookingId',
  ]);
  final dispatchKeys = _backgroundDispatchKeysForIds(
    jobId: jobId,
    bookId: bookId,
  );

  if (_prefsContainAnyDispatchKey(prefs, 'acceptedJobKeys', dispatchKeys) ||
      _prefsContainAnyDispatchKey(prefs, 'completedJobKeys', dispatchKeys) ||
      _prefsContainAnyDispatchKey(prefs, 'rejectedJobKeys', dispatchKeys)) {
    return true;
  }

  final storedJobId = (prefs.getString('jobId') ?? '').trim();
  final storedBookId = (prefs.getString('bookingid') ?? '').trim();
  final hasSavedAcceptedJob = prefs.getBool('jobDispatched') ?? false;

  if (hasSavedAcceptedJob &&
      ((storedJobId.isNotEmpty && storedJobId == jobId) ||
          (storedBookId.isNotEmpty && storedBookId == bookId))) {
    return true;
  }

  return false;
}

Future<bool> checkLatestTimeslot() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final dId = prefs.getString('d_id');
    final response = await http.post(
      Uri.parse(ApiService.driverFetchTimeSlot),
      body: {'d_id': dId.toString()},
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);

      if (parsedResponse['status'] == true) {
        await prefs.setString(
          "ts_id",
          parsedResponse['data'][0]['ts_id'].toString(),
        );
        // print('New job available: ${DateTime.now()}');
        return true;
      }
    } else {
      // print("API check failed with status code: ${response.statusCode}");
      throw Exception('API Check Failed');
    }
    // print("No new jobs found.");
    return false;
  } catch (e) {
    return false;
  }
}

Future<void> showNotificationFor1(String title, String subtitle) async {
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
    title,
    subtitle,
    platformChannelSpecifics,
    payload: 'item x',
  );
}

void showNotification() async {
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
    'New Job',
    'You have new upcoming jobs.',
    platformChannelSpecifics,
    payload: 'item x',
  );
}

void showtimeSlotNoti() async {
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
    'New TimeSlot',
    'You have new TimeSlot.',
    platformChannelSpecifics,
    payload: 'item x',
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  late Stream<BaseAuthUser> userStream;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  final service = FlutterBackgroundService();
  @override
  void initState() {
    super.initState();
    service.invoke("stopService");
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream =
        simpleAuthUserStream()
          ..listen((user) => _appStateNotifier.update(user));
    _appStateNotifier.stopShowingSplashImage();
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
    _themeMode = mode;
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'MiniCab',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [Locale('en', '')],
      theme: buildAppTheme(Brightness.light),
      darkTheme: buildAppTheme(Brightness.dark),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key, this.initialPage, this.page});

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'Home';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  void _showupcomming() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! > 20) {
              // Close the BottomSheet on a downward swipe
              Navigator.pop(context);
            }
          },
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: UpcommingjobWidget(dId: ''),
          ),
        );
      },
    );
  }

  void _showbids() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! > 20) {
              // Close the BottomSheet on a downward swipe
              Navigator.pop(context);
            }
          },
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: BidsBottomSheet(),
          ),
        );
      },
    ).then((value) => safeSetState(() {}));
  }

  void _showAccounts() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! > 20) {
              // Close the BottomSheet on a downward swipe
              Navigator.pop(context);
            }
          },
          // onVerticalDragDown: (details) {
          //   Navigator.pop(context);
          //   debugPrint('downSwipped');
          // },
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: AccountsBottomsheet(),
          ),
        );
      },
    ).then((value) => safeSetState(() {}));
  }

  void _showDashoboard() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! > 20) {
              // Close the BottomSheet on a downward swipe
              Navigator.pop(context);
            }
          },
          // onVerticalDragDown: (details) {
          //   Navigator.pop(context);
          //   debugPrint('downSwipped');
          // },
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: DashboardBottomSheet(),
          ),
        );
      },
    ).then((value) => safeSetState(() {}));
  }

  Future<void> _handleNavTap(int index, List<String> tabNames) async {
    bool isjobAvailable = false;
    debugPrint('the current index is $index');
    if (index == 0) {
      myController.isscreenHome.value = true;
    } else if (index == 1) {
      myController.isscreenHome.value = false;
      _showupcomming();
    } else if (index == 2) {
      myController.isscreenHome.value = false;
      _showDashoboard();
    } else if (index == 3) {
      myController.isscreenHome.value = false;
      _showbids();
    } else if (index == 4) {
      myController.isscreenHome.value = false;
      _showAccounts();
    } else {
      myController.isscreenHome.value = false;
    }
    SharedPreferences sp = await SharedPreferences.getInstance();
    isjobAvailable = sp.getBool('jobDispatched') ?? false;
    setState(() {});
    if (isjobAvailable == false) {
      _currentPage = null;
      _currentPageName = tabNames[index];
    } else {
      Fluttertoast.showToast(msg: 'Complete Job First');
    }
  }

  @override
  Widget build(BuildContext context) {
    // checkUserSession();
    final tabs = {
      'Home': HomeWidget(),
      'Upcomming': UpcommingWidget(),
      'Dashboard': HomeWidget(),
      // 'Dashboard': DashboardWidget(),
      'Bids': HomeWidget(),
      // 'Bids': BidHistoryFilterWidget(),
      'AccountStatement': HomeWidget(),
      // 'AccountStatement': AcountStatementsWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    final MediaQueryData queryData = MediaQuery.of(context);
    // body: MediaQuery(
    //         data: queryData
    //             .removeViewInsets(removeBottom: true)
    //             .removeViewPadding(removeBottom: true),
    //         child: _currentPage ?? tabs[_currentPageName]!),
    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      extendBody: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: _ElegantDriverNavBar(
        currentIndex: currentIndex,
        onTap: (index) => _handleNavTap(index, tabs.keys.toList()),
      ),
    );
  }
}
