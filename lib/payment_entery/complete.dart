import 'dart:convert';

import 'package:get/get.dart';
import 'package:mini_cab/Acount%20Statements/acount_statements_widget.dart';
import 'package:mini_cab/home/home_view_controller.dart';
import 'package:mini_cab/index.dart';
import 'package:mini_cab/main.dart';
import 'package:mini_cab/on_way/on_way_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

    _model = createModel(context as BuildContext, () => OnWayModel());
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

  getCompleteViewData() async {
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
    print('timer value $time');
    setState(() {});
// sp.setString('timerValue', time)
  }

  Future<void> fetchAndSaveFares() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    jobid = sp.getString('jobId') ?? '';
    setState(() {});
    final url = Uri.parse(
      'https://www.minicaboffice.com/api/driver/fetch-fares.php',
    );

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
          String totalFee = (double.parse(journeyFare) +
                  double.parse(carParking) +
                  double.parse(waiting) +
                  double.parse(tolls) +
                  double.parse(extras))
              .toString();

          // Save to SharedPreferences
          await saveData(
              journeyFare, carParking, extras, waiting, tolls, totalFee);

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
  Future<void> saveData(String jfare, String carparking, String extra,
      String waiting, String tolls, String totalFee) async {
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
  completeJob() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {});
    try {
      isrequest = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      String? cid = prefs.getString('c_id');
      print('the cid is $cid');
      // print('d_id not found in shared preferences.${widget.jobid}');
      // print('d_id not found in shared preferences.${dId}');
      // print('d_id not found in shared preferences.${parkingController.text}');
      // print('d_id not found in shared preferences.${tollsController.text}');
      // print('d_id not found in shared preferences.${watingController.text}');

      var response = await http.post(
          Uri.parse(
              'https://www.minicaboffice.com/api/driver/complete-job.php'),
          body: {
            'job_id': jobid,
            'd_id': dId.toString(),
            'c_id': cid ?? '',
            'journey_fare': jounreryFare,
            'car_parking': parking,
            'extra': extra,
            'waiting': waiting,
            'tolls': tolls,
          });

      if (response.statusCode == 200) {
        isrequest = false;
        myController.visiblecontainer.value = false;
        setState(() {});
        // await fetchFareData();
        final data = json.decode(response.body);
        await sp.remove('isWaitingTrue');
        await sp.remove('arrivalDone');
        sp.setInt('isRideStart', 0);
        // context.pushNamed('AcountStatements');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NavBarPage(
                      initialPage: 'AcountStatements',
                      page: AcountStatementsWidget(),
                    )));
        // Navigator.push(context,MaterialPageRoute(builder: (context)=>account))
        print('the complete job data is ${data}');
      } else {
        isrequest = false;
        print('Failed to add fares: ${response.reasonPhrase}');
      }
    } catch (error) {
      isrequest = false;
      print('Error: $error');
    }
  }

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
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFF1C1F28),
                    ),
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
                            color: widget.isfromfare == null
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
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Open Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
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
                                          8, 0, 0, 0),
                                      child: Text(
                                        'Cash',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Open Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
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
                                      0, 0, 0, 5),
                                  child: Text(
                                    'CLIENT PAYS',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        '£ $totalFee',
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              fontFamily: 'Open Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              letterSpacing: 0,
                                            ),
                                      ),
                                      Text(
                                        'Inc, VAT',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Open Sans',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
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
                        Icon(
                          Icons.arrow_back,
                          color: Colors.transparent,
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
                          'Job Details',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
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
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '${jobid}',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '${pickupDate}',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '${pickupTime}',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Container(
                          width: 120,
                          height: 70,
                          child: SingleChildScrollView(
                            child: Text(
                              pickUplocation,
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    fontFamily: 'Open Sans',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 18,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        )
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
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Container(
                          width: 130,
                          height: 60,
                          child: SingleChildScrollView(
                            child: Text(
                              dropOflocation,
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    fontFamily: 'Open Sans',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 18,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        )
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
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
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
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '£${jounreryFare}',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '£${waiting}',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '£${parking}',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '£${tolls}',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
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
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '£${extra}',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Open Sans',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 18,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
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
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.85,
                                  height: 49,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 0, 24, 0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  color: Color(0xFF1C1F28),
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
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
