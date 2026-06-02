
import 'package:get/get.dart';
import 'package:new_minicab_driver/home/home_view_controller.dart';
import 'package:new_minicab_driver/on_way/on_way_model.dart';


import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountStatementDetails extends StatefulWidget {
  String totalFee;
  String jounreryFare;
  String parking;
  String tolls;
  String extra;
  // String jobid = '0.0';
  String did;
  String waiting;
  String time;
  String jobid;
  String pickupDate;
  String pickupTime;
  String pickUplocation;
  String dropOflocation;
  AccountStatementDetails({
    super.key,
    required this.totalFee,
    required this.jounreryFare,
    required this.parking,
    required this.tolls,
    required this.did,
    required this.waiting,
    required this.time,
    required this.jobid,
    required this.pickupDate,
    required this.pickUplocation,
    required this.dropOflocation,
    required this.pickupTime,
    required this.extra,
  });

  @override
  State<AccountStatementDetails> createState() =>
      _AccountStatementDetailsState();
}

class _AccountStatementDetailsState extends State<AccountStatementDetails> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => OnWayModel());
  }

  @override
  void dispose() {
    super.dispose();
  }

  final JobController myController = Get.put(JobController());
  // completeJob() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   setState(() {});
  //   try {
  //     isrequest = true;
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? dId = prefs.getString('d_id');
  //     String? cid = prefs.getString('c_id');
  //     print(dId);
  //     // print('d_id not found in shared preferences.${widget.jobid}');
  //     // print('d_id not found in shared preferences.${dId}');
  //     // print('d_id not found in shared preferences.${parkingController.text}');
  //     // print('d_id not found in shared preferences.${tollsController.text}');
  //     // print('d_id not found in shared preferences.${watingController.text}');

  //     var response = await http.post(
  //         Uri.parse(
  //             ApiService.driverCompleteJob),
  //         body: {
  //           'job_id': jobid,
  //           'd_id': dId.toString(),
  //           'c_id': cid ?? '',
  //           'journey_fare': jounreryFare,
  //           'car_parking': parking,
  //           'extra': extra,
  //           'waiting': waiting,
  //           'tolls': tolls,
  //         });

  //     if (response.statusCode == 200) {
  //       isrequest = false;
  //       myController.visiblecontainer.value = false;
  //       setState(() {});
  //       // await fetchFareData();
  //       final data = json.decode(response.body);
  //       sp.setInt('isRideStart', 0);
  //       // context.pushNamed('AcountStatements');
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => NavBarPage(
  //                     initialPage: 'AcountStatements',
  //                     page: AcountStatementsWidget(),
  //                   )));
  //       // Navigator.push(context,MaterialPageRoute(builder: (context)=>account))
  //       print('the complete job data is ${data}');
  //     } else {
  //       isrequest = false;
  //       print('Failed to add fares: ${response.reasonPhrase}');
  //     }
  //   } catch (error) {
  //     isrequest = false;
  //     print('Error: $error');
  //   }
  // }

  bool isrequest = false;
  late OnWayModel _model;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
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
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back, color: Colors.white),
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
                                    color:
                                        context.appTheme.primaryBackground,
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
                                          fontFamily: 'Open Sans',
                                          color:
                                              context.appTheme.primaryBackground,
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
                                      color:
                                          context.appTheme.primaryBackground,
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
                                        '£ ${widget.totalFee}',
                                        style: context.appTheme.titleLarge.override(
                                          fontFamily: 'Open Sans',
                                          color:
                                              context.appTheme.primaryBackground,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                      Text(
                                        'Inc, VAT',
                                        style: context.appTheme.bodyMedium.override(
                                          fontFamily: 'Open Sans',
                                          color:
                                              context.appTheme.primaryBackground,
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
                        IconButton(
                          onPressed: () {
                            // Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.transparent,
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
                          widget.jobid,
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
                          widget.pickupDate,
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
                          widget.pickupTime,
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
                              widget.pickUplocation,
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
                              widget.dropOflocation,
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
                          '£${widget.jounreryFare}',
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
                          widget.time,
                          style: context.appTheme.headlineSmall.override(
                            fontFamily: 'Open Sans',
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '£${widget.waiting}',
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
                          '£${widget.parking}',
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
                          '£${widget.tolls}',
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
                          '£${widget.extra}',
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
                  // Padding(
                  //   padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.max,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       isrequest
                  //           ? CircularProgressIndicator()
                  //           : FFButtonWidget(
                  //               onPressed: () {
                  //                 // completeJob();
                  //                 print('Button pressed ...');
                  //               },
                  //               text: 'COMPLETE',
                  //               options: FFButtonOptions(
                  //                 width:
                  //                     MediaQuery.sizeOf(context).width * 0.85,
                  //                 height: 49,
                  //                 padding: EdgeInsetsDirectional.fromSTEB(
                  //                     24, 0, 24, 0),
                  //                 iconPadding: EdgeInsetsDirectional.fromSTEB(
                  //                     0, 0, 0, 0),
                  //                 color: Color(0xFF1C1F28),
                  //                 textStyle: context.appTheme
                  //                     .titleSmall
                  //                     .override(
                  //                       fontFamily: 'Open Sans',
                  //                       color: Colors.white,
                  //                       fontSize: 18,
                  //                       letterSpacing: 1,
                  //                       fontWeight: FontWeight.w600,
                  //                     ),
                  //                 elevation: 3,
                  //                 borderSide: BorderSide(
                  //                   color: Colors.transparent,
                  //                   width: 1,
                  //                 ),
                  //                 borderRadius: BorderRadius.circular(0),
                  //               ),
                  //             ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
