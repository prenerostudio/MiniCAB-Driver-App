import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/foundation.dart';
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
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'flutter_flow/nav/nav.dart';
import 'package:http/http.dart' as http;

import 'home/home_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  try {
    await initFirebase();
    print('firebase succesffuly');
  } catch (e) {
    print('firebase make issue');
  }
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

        await prefs.setString('endTime', newEndTime!);
        timerController.endTime.value = preferences.getString('endTime') ?? '';
      }
    });
    service.on('setTsId').listen((event) async {
      // Example: Update the endTime from the UI
      if (event != null && event['tsId'] != null) {
        String tsId = event['tsId'];

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('ts_id', tsId!);
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
  String _timerDisplayValue,
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
        Uri.parse(
          'https://www.minicaboffice.com/api/driver/calculate-waiting-time.php',
        ),
      );
      request.fields.addAll({
        'd_id': '${did}',
        'job_id': '${jobid}',
        'waiting_time': _timerDisplayValue,
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
    Uri.parse(
      'https://www.minicaboffice.com/api/driver/complete-time-slot.php',
    ),
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
    Uri.parse('https://minicaboffice.com/api/driver/upcoming-jobs.php'),
    body: {'d_id': dId.toString()},
  );

  if (response.statusCode == 200) {
    final parsedResponse = json.decode(response.body);
    if (parsedResponse['status'] == true) {
      // print('New job available: ${DateTime.now()}');
      return true;
    }
  } else {
    // print("API check failed with status code: ${response.statusCode}");
    throw Exception('API Check Failed');
  }
  // print("No new jobs found.");
  return false;
}

Future<bool> checkLatestTimeslot() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final dId = prefs.getString('d_id');
    final response = await http.post(
      Uri.parse('https://www.minicaboffice.com/api/driver/fetch-time-slot.php'),
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

showNotificationFor1(String title, String subtitle) async {
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
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

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
        miniCabFirebaseUserStream()
          ..listen((user) => _appStateNotifier.update(user));
    jwtTokenStream.listen((_) {});
    _appStateNotifier.stopShowingSplashImage();
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
    _themeMode = mode;
    FlutterFlowTheme.saveThemeMode(mode);
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
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: ScrollbarThemeData(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scrollbarTheme: ScrollbarThemeData(),
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

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
      extendBody: false,
      backgroundColor: Colors.white,
      bottomNavigationBar: FloatingNavbar(
        currentIndex: currentIndex,
        onTap: (index) async {
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
            _currentPageName = tabs.keys.toList()[index];
          } else {
            Fluttertoast.showToast(msg: 'Complete Job First');
          }
        },
        backgroundColor: Colors.white,
        selectedItemColor: FlutterFlowTheme.of(context).primary,
        unselectedItemColor: Color(0x8A000000),
        selectedBackgroundColor: Color(0x00000000),
        borderRadius: 8.0,
        itemBorderRadius: 0.0,
        margin: EdgeInsets.zero, // Adjust margin
        padding: EdgeInsets.zero, //
        width: double.infinity,
        elevation: 0.0,
        items: [
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  currentIndex == 0 ? Icons.home_outlined : Icons.home_outlined,
                  color:
                      currentIndex == 0
                          ? FlutterFlowTheme.of(context).primary
                          : Color(0x8A000000),
                  size: currentIndex == 0 ? 24.0 : 24.0,
                ),
                Text(
                  'Home',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        currentIndex == 0
                            ? FlutterFlowTheme.of(context).primary
                            : Color(0x8A000000),
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  currentIndex == 1
                      ? FontAwesomeIcons.carAlt
                      : FontAwesomeIcons.carAlt,
                  color:
                      currentIndex == 1
                          ? FlutterFlowTheme.of(context).primary
                          : Color(0x8A000000),
                  size: currentIndex == 1 ? 24.0 : 24.0,
                ),
                Text(
                  'UpComing',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        currentIndex == 1
                            ? FlutterFlowTheme.of(context).primary
                            : Color(0x8A000000),
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dashboard_sharp,
                  color:
                      currentIndex == 2
                          ? FlutterFlowTheme.of(context).primary
                          : Color(0x8A000000),
                  size: 24.0,
                ),
                Text(
                  'Dashboard',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        currentIndex == 2
                            ? FlutterFlowTheme.of(context).primary
                            : Color(0x8A000000),
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.capsules,
                  color:
                      currentIndex == 3
                          ? FlutterFlowTheme.of(context).primary
                          : Color(0x8A000000),
                  size: 24.0,
                ),
                Text(
                  'Bids',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        currentIndex == 3
                            ? FlutterFlowTheme.of(context).primary
                            : Color(0x8A000000),
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          FloatingNavbarItem(
            customWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.payments_rounded,
                  color:
                      currentIndex == 4
                          ? FlutterFlowTheme.of(context).primary
                          : Color(0x8A000000),
                  size: 24.0,
                ),
                Text(
                  'AccountStatement',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color:
                        currentIndex == 4
                            ? FlutterFlowTheme.of(context).primary
                            : Color(0x8A000000),
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
