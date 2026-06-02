import 'dart:convert';

import 'package:get/get.dart';
import 'package:new_minicab_driver/Acount%20Statements/acount_statements_widget.dart';
import 'package:new_minicab_driver/home/home_view_controller.dart';
import 'package:new_minicab_driver/main.dart';
import 'package:new_minicab_driver/on_way/on_way_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_minicab_driver/Data/api_service.dart';

class CompleteWidget extends StatefulWidget {
  bool? isfromfare;
  CompleteWidget({super.key, this.isfromfare});

  @override
  State<CompleteWidget> createState() => _CompleteWidgetState();
}

class _CompleteWidgetState extends State<CompleteWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchAndSaveFares();

    _model = createModel(context, () => OnWayModel());
  }

  @override
  void dispose() {
    super.dispose();
  }

  String totalFee = '0.0';
  String jounreryFare = '0.0';
  String parking = '0.0';
  String tolls = '0.0';
  String extra = '0.0';
  // String jobid = '0.0';
  String did = '0.0';
  String waiting = '0.0';
  String time = '--';
  String jobid = '--';
  String pickupDate = '--';
  String pickupTime = '--';
  String pickUplocation = '--';
  String dropOflocation = '--';

  Future<void> getCompleteViewData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt('isRideStart', 3);
    time = sp.getString('timerValue') ?? '';
    totalFee = sp.getString('totalFee') ?? '';
    print('the total fee is $totalFee');
    jounreryFare = sp.getString('journey_fare') ?? '';
    parking = sp.getString('car_parking') ?? '';
    tolls = sp.getString('tolls') ?? '';
    extra = sp.getString('extra') ?? '';
    waiting = sp.getString('waiting') ?? '';
    jobid = sp.getString('jobId') ?? '';
    pickupDate = sp.getString('pickDate') ?? '';
    pickupTime = sp.getString('pickTime') ?? '';
    pickUplocation = sp.getString('pickLocation') ?? '';
    dropOflocation = sp.getString('dropLocation') ?? '';
    jobAccptTime = sp.getString('jobAcceptedTime') ?? '';
    jobStart = sp.getString('jobStartTime') ?? '';
    waytoPickup = sp.getString('jobWayToPickupTime') ?? '';
    arrivalTime = sp.getString('jobArrivalNowTime') ?? '';
    pobTime = sp.getString('jobPOBTime') ?? '';
    dropOffTime = sp.getString('jobAtDropOffTime') ?? '';
    print('timer value $time');
    setState(() {});
    // sp.setString('timerValue', time)
  }

  Future<void> fetchAndSaveFares() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    jobid = sp.getString('jobId') ?? '';
    setState(() {});
    final url = Uri.parse(ApiService.driverFetchFares);

    try {
      final Map<String, String> body = {'job_id': jobid};

      // Make POST request
      final response = await http.post(
        url,
        // headers: {"Content-Type": "application/json"}, // Set headers
        body: body, // Convert body to JSON string
      );
      print('the response is ${response.body}');
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Check if the API call was successful and contains data
        if (responseBody['status'] == true) {
          final fare = responseBody['data'][0];

          // Extract parameters
          String journeyFare = fare['journey_fare'] ?? '0';
          String carParking = fare['car_parking'] ?? '0';
          String waiting = fare['waiting'] ?? '0';
          String tolls = fare['tolls'] ?? '0';
          String extras = fare['extras'] ?? '0';

          // Calculate total fee
          String totalFee =
              (double.parse(journeyFare) +
                      double.parse(carParking) +
                      double.parse(waiting) +
                      double.parse(tolls) +
                      double.parse(extras))
                  .toString();

          // Save to SharedPreferences
          await saveData(
            journeyFare,
            carParking,
            extras,
            waiting,
            tolls,
            totalFee,
          );

          await getCompleteViewData();
        } else {
          print("No data available or invalid response status.");
        }
      } else {
        print("API call failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      await getCompleteViewData();
      print("Error while fetching fares: $e");
    }
  }

  // Function to save data to SharedPreferences
  Future<void> saveData(
    String jfare,
    String carparking,
    String extra,
    String waiting,
    String tolls,
    String totalFee,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('journey_fare', jfare);
    await prefs.setString('car_parking', carparking);
    await prefs.setString('extra', extra);
    await prefs.setString('waiting', waiting);
    await prefs.setString('tolls', tolls);
    await prefs.setString('totalFee', totalFee);
    setState(() {});
    print("Data saved successfully to SharedPreferences!");
  }

  final JobController myController = Get.put(JobController());
  Future<void> completeJob() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {});
    _getCurrentTime();
    try {
      isrequest = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      String? cid = prefs.getString('c_id');
      List<String>? routeData2 = prefs.getStringList('user_route');

      String coordinatesString = routeData2!.join(",");

      print('the cid is $coordinatesString');
      // print('d_id not found in shared preferences.${widget.jobid}');
      // print('d_id not found in shared preferences.${dId}');
      // print('d_id not found in shared preferences.${parkingController.text}');
      // print('d_id not found in shared preferences.${tollsController.text}');
      // print('d_id not found in shared preferences.${watingController.text}');

      var response = await http.post(
        Uri.parse(ApiService.driverCompleteJob),
        body: {
          'job_id': jobid,
          'd_id': dId.toString(),
          'c_id': cid ?? '',
          'journey_fare': jounreryFare,
          'car_parking': parking,
          'extra': extra,
          'waiting': waiting,
          'tolls': tolls,
          'job_accepted_time': jobAccptTime,
          'job_started_time': jobStart,
          'way_to_pickup_time': waytoPickup,
          'arrived_at_pickup_time': arrivalTime,
          'pob_time': pobTime,
          'dropoff_time': dropOffTime,
          'job_completed_time': formattedTime,
          'driver_route': coordinatesString,
        },
      );

      if (response.statusCode == 200) {
        isrequest = false;
        myController.visiblecontainer.value = false;
        setState(() {});
        // await fetchFareData();
        final data = json.decode(response.body);
        await sp.remove('isWaitingTrue');
        await sp.remove('arrivalDone');
        await sp.remove('jobDispatched');
        await sp.remove('jobAcceptedTime');
        await sp.remove('jobAtDropOffTime');
        await sp.remove('jobPOBTime');
        await sp.remove('jobArrivalNowTime');
        await sp.remove('jobWayToPickupTime');
        await sp.remove('jobStartTime');
        await sp.remove('user_route');
        myController.polylines.clear();
        sp.setInt('isRideStart', 0);
        // context.pushNamed('AcountStatements');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => NavBarPage(
                  initialPage: 'AcountStatements',
                  page: AcountStatementsWidget(),
                ),
          ),
        );
        // Navigator.push(context,MaterialPageRoute(builder: (context)=>account))
        print('the complete job data is $data');
      } else {
        isrequest = false;
        print('Failed to add fares: ${response.reasonPhrase}');
      }
    } catch (error) {
      isrequest = false;
      print('Error: $error');
    }
  }

  String jobAccptTime = '--';
  String jobStart = '--';
  String waytoPickup = '--';
  String arrivalTime = '--';
  String pobTime = '--';
  String dropOffTime = '--';

  void _getCurrentTime() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm a');
    setState(() {
      formattedTime = formatter.format(now);
    });
  }

  String formattedTime = "";
  bool isrequest = false;
  late OnWayModel _model;
  @override
  Widget build(BuildContext context) {
    // print('the jobs id $cid');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: context.appTheme.primaryBackground,
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 100,
                    decoration: BoxDecoration(color: Color(0xFF1C1F28)),
                    child: Row(
                      // mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            // Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color:
                                widget.isfromfare == null
                                    ? Colors.transparent
                                    : Colors.transparent,
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PAY BY',
                                  style: context.appTheme.bodyMedium.override(
                                    fontFamily: 'Open Sans',
                                    color: Colors.white,
                                    // color: context.appTheme
                                    //     .primaryBackground,
                                    fontSize: 16,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.moneyBillWaveAlt,
                                      color: Color(0xFF5B68F5),
                                      size: 28,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        8,
                                        0,
                                        0,
                                        0,
                                      ),
                                      child: Text(
                                        'Cash',
                                        style: context.appTheme.bodyMedium.override(
                                          color: Colors.white,
                                          fontFamily: 'Open Sans',
                                          // color:
                                          //     context.appTheme
                                          //         .primaryBackground,
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0,
                                    0,
                                    0,
                                    5,
                                  ),
                                  child: Text(
                                    'CLIENT PAYS',
                                    style: context.appTheme.bodyMedium.override(
                                      fontFamily: 'Open Sans',
                                      color: Colors.white,
                                      // color: context.appTheme
                                      //     .primaryBackground,
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0,
                                    0,
                                    0,
                                    5,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        totalFee.isEmpty
                                            ? "£ $jounreryFare"
                                            : '£ $totalFee',
                                        style: context.appTheme.titleLarge.override(
                                          fontFamily: 'Open Sans',
                                          color: Colors.white,
                                          // color:
                                          //     context.appTheme
                                          //         .primaryBackground,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                      Text(
                                        'Inc, VAT',
                                        style: context.appTheme.bodyMedium.override(
                                          fontFamily: 'Open Sans',
                                          color: Colors.white,
                                          // color:
                                          //     context.appTheme
                                          //         .primaryBackground,
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_back, color: Colors.transparent),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Job Details',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Job id',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          jobid,
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pick-up date",
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          pickupDate,
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pick-up time",
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          pickupTime,
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 15, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pickup",
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          height: 70,
                          child: SingleChildScrollView(
                            child: Text(
                              pickUplocation,
                              style: context.appTheme.headlineSmall.override(
                                fontFamily: 'Open Sans',
                                color:
                                    context.appTheme.secondaryText,
                                fontSize: 18,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 15, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dropoff",
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          height: 60,
                          child: SingleChildScrollView(
                            child: Text(
                              dropOflocation,
                              style: context.appTheme.headlineSmall.override(
                                fontFamily: 'Open Sans',
                                color:
                                    context.appTheme.secondaryText,
                                fontSize: 18,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fare Details',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Journey',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '£$jounreryFare',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          time,
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '£$waiting',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Parking',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '£$parking',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tolls',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '£$tolls',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Extra',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '£$extra',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time tracking',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Job Accepted',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          jobAccptTime,
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Job Started',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          jobStart,
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Way to pickup',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          waytoPickup,
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Arrival at pickup',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          arrivalTime,
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'POB',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          pobTime,
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dropoff',
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          dropOffTime,
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            color: context.appTheme.secondaryText,
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // completed button
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isrequest
                            ? CircularProgressIndicator()
                            : FFButtonWidget(
                              onPressed: () {
                                completeJob();
                                print('Button pressed ...');
                              },
                              text: 'COMPLETE',
                              options: FFButtonOptions(
                                width: MediaQuery.sizeOf(context).width * 0.85,
                                height: 49,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  24,
                                  0,
                                  24,
                                  0,
                                ),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  0,
                                  0,
                                  0,
                                ),
                                color: Color(0xFF1C1F28),
                                textStyle: context.appTheme.titleSmall.override(
                                  fontFamily: 'Open Sans',
                                  color: Colors.white,
                                  fontSize: 18,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                                elevation: 3,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
