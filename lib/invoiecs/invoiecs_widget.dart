import 'dart:async';
import 'dart:convert';

import 'package:new_minicab_driver/invoiecs/view_reports_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart'

import 'invoiecs_model.dart';
export 'invoiecs_model.dart';
import 'package:http/http.dart' as http;
import '../Model/fare.dart';

class InvoiecsWidget extends StatefulWidget {
  const InvoiecsWidget({
    Key? key,
    required this.did,
    required this.jobid,
    required this.tolls,
    required this.waiting,
    required this.parking,
    required this.fare,
  }) : super(key: key);

  final String? did;
  final String? jobid;
  final String? tolls;
  final String? waiting;
  final String? parking;
  final String? fare;

  @override
  _InvoiecsWidgetState createState() => _InvoiecsWidgetState();
}

class _InvoiecsWidgetState extends State<InvoiecsWidget> {
  // late InvoiecsModel _model;
  String? fareId;
  String? journeyFare;
  String? extraWaiting;
  String? parking;
  String? tolls;
  String? fareStatus;

  // String newjourneyFare = '';
  // String newcarParking = '';
  // String newwaiting = '';
  // String newtolls = '';
  // String newextras = '';
  // String newfareStatus = '';

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Map<String, dynamic>>> getReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String? d_id = prefs.getString('d_id');

      // Get current date
      DateTime currentDate = DateTime.now();

      // Calculate next day date
      DateTime firstdate = currentDate.subtract(Duration(days: 7));
      DateTime nextDayDate = currentDate.add(Duration(days: 7));

      // Format the dates to 'yyyy-MM-dd'
      String startDate =
          "${firstdate.year}-${firstdate.month.toString().padLeft(2, '0')}-${firstdate.day.toString().padLeft(2, '0')}";
      String endDate =
          "${nextDayDate.year}-${nextDayDate.month.toString().padLeft(2, '0')}-${nextDayDate.day.toString().padLeft(2, '0')}";
      print('the start date is :$startDate');
      print('the end date is :$endDate');
      final uri =
          Uri.parse('https://www.minicaboffice.com/api/driver/report.php');
      final response = await http.post(uri, body: {
        'd_id': '$d_id',
        'start_date': startDate,
        'end_date': endDate,
      });

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('the response from report api $jsonResponse');
        return List<Map<String, dynamic>>.from(jsonResponse['data']);
      } else {
        print('Error: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('the exception is $e');
      return [];
    }
  }

  Map<String, Map<int, List<Map<String, dynamic>>>> groupDataByMonthAndWeek(
      List<Map<String, dynamic>> data) {
    Map<String, Map<int, List<Map<String, dynamic>>>> groupedData = {};

    for (var item in data) {
      DateTime date = DateTime.parse(item['pick_date']);
      String month = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      int weekOfMonth = ((date.day - 1) ~/ 7) + 1;

      if (!groupedData.containsKey(month)) {
        groupedData[month] = {};
      }
      if (!groupedData[month]!.containsKey(weekOfMonth)) {
        groupedData[month]![weekOfMonth] = [];
      }
      groupedData[month]![weekOfMonth]!.add(item);
    }

    return groupedData;
  }

  @override
  void initState() {
    super.initState();
    getReport(); // Fetch and group the data when the screen initializes
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // _model = createModel(context, () => InvoiecsModel());
  }

  @override
  void dispose() {
    // _model.dispose();
    super.dispose();
  }

  // Future<void> fetchDataAndUpdateState() async {
  //   List<FareData> fareDataList = await fetchFareData();
  //   if (fareDataList.isNotEmpty) {
  //     setState(() {
  //       newjourneyFare = fareDataList[0].journeyFare;
  //       newcarParking = fareDataList[0].carParking;
  //       newwaiting = fareDataList[0].waiting;
  //       newtolls = fareDataList[0].tolls;
  //       newextras = fareDataList[0].extras;
  //       newfareStatus = fareDataList[0].fareStatus;
  //     });
  //   }
  // }

  // Future<List<FareData>> fetchFareData() async {
  //   try {
  //     await fetchData();
  //     final uri = Uri.parse(
  //         'https://www.minicaboffice.com/api/driver/check-fare-status.php');
  //     final response = await http.post(uri, body: {'fare_id': '${fareId}'});

  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       print(jsonResponse);
  //       final List<dynamic> data = jsonResponse['data'];

  //       List<FareData> bookingList = data
  //           .map((item) => FareData.fromJson(item))
  //           .cast<FareData>()
  //           .toList();
  //       return bookingList;
  //     } else {
  //       print('Error: ${response.reasonPhrase}');
  //       return [];
  //     }
  //   } catch (e) {
  //     print('the exception is $e');
  //     return [];
  //   }
  // }
  // Future getReport() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   try {
  //     String? d_id = prefs.getString('d_id');
  //     final uri =
  //         Uri.parse('https://www.minicaboffice.com/api/driver/report.php');
  //     final response = await http.post(uri, body: {
  //       'd_id': '${d_id}',
  //       'start_date': '2024-08-01',
  //       'end_date': "2024-10-01"
  //     });

  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       print(jsonResponse);
  //     } else {
  //       print('Error: ${response.reasonPhrase}');
  //       return [];
  //     }
  //   } catch (e) {
  //     print('the exception is $e');
  //     return [];
  //   }
  // }

  // Future<void> fetchData() async {
  //   try {

  //     var url =
  //         Uri.parse('https://www.minicaboffice.com/api/driver/fetch-fares.php');

  //     var response = await http.post(
  //       url,
  //       body: {
  //         'job_id': '${widget.jobid}',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> jsonResponse = json.decode(response.body);
  //       fareId = jsonResponse['data'][0]['fare_id'];
  //       print('fare id:  ${fareId}');
  //     } else {
  //       print(
  //           'Request failed with status: ${response.statusCode}. ${response.reasonPhrase}');
  //     }
  //   } catch (error) {
  //     print('Error: $error');
  //   }
  // }

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
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            title: Text(
              'View Reports',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              icon: Icon(
                Icons.arrow_back,
                color: FlutterFlowTheme.of(context).info,
                size: 30,
              ),
              onPressed: () async {
                Navigator.pop(context);
                // context.pushNamed('PaymentEntery');
              },
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getReport(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final groupedData = groupDataByMonthAndWeek(snapshot.data!);

                  return ListView.builder(
                    itemCount: groupedData.length,
                    itemBuilder: (context, index) {
                      // String month = groupedData.keys.elementAt(index);
                      // var weeksData = groupedData[month];
                      String month = groupedData.keys.elementAt(index);

                      // Parse the 'month' string into a DateTime object
                      DateTime parsedMonth = DateTime.parse('$month-01');

                      // Format the DateTime object to 'August-2024'
                      String formattedMonth =
                          DateFormat('MMMM-yyyy').format(parsedMonth);

                      var weeksData = groupedData[month];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(formattedMonth,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: weeksData!.length,
                              itemBuilder: (context, weekIndex) {
                                var week = weeksData.keys.elementAt(weekIndex);

                                return Column(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WeekDetailScreen(
                                                weekData: weeksData[week] as List<
                                                    Map<String,
                                                        dynamic>>?, // Explicitly casting
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image.asset(
                                            'assets/images/pdf.png')),
                                    Text('Week $week'),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ));
  }
}
  //  FutureBuilder<List<FareData>>(
            //   future: fetchFareData(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(
            //         child: Padding(
            //           padding: EdgeInsets.only(
            //             top: MediaQuery.of(context).size.height *
            //                 0.1, // 20% padding from the top
            //           ),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               CircularProgressIndicator(
            //                 valueColor: AlwaysStoppedAnimation<Color>(
            //                     FlutterFlowTheme.of(context).primary),
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     } else if (snapshot.hasError) {
            //       return Text('No Data Found');
            //     } else {
            //       final List<FareData> fareDataList = snapshot.data!;
            //       return ListView.builder(
            //         itemCount: fareDataList.length,
            //         itemBuilder: (context, index) {
            //           final FareData fareData = fareDataList[index];
            //           var fare = '£${fareData.journeyFare}';
            //           print(fare);
            //           return SingleChildScrollView(
            //             child: Column(
            //               mainAxisSize: MainAxisSize.max,
            //               children: [
            //                 Padding(
            //                   padding:
            //                       EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
            //                   child: Container(
            //                     height: MediaQuery.sizeOf(context).height * 0.2,
            //                     width: MediaQuery.sizeOf(context).width * 1.0,
            //                     decoration: BoxDecoration(
            //                       color: FlutterFlowTheme.of(context).primary,
            //                       boxShadow: [
            //                         BoxShadow(
            //                           blurRadius: 5,
            //                           color: Color(0x32171717),
            //                           offset: Offset(0, 2),
            //                         )
            //                       ],
            //                       borderRadius: BorderRadius.only(
            //                         bottomLeft: Radius.circular(16),
            //                         bottomRight: Radius.circular(16),
            //                         topLeft: Radius.circular(0),
            //                         topRight: Radius.circular(0),
            //                       ),
            //                     ),
            //                     child: Padding(
            //                       padding:
            //                           EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
            //                       child: Column(
            //                         mainAxisSize: MainAxisSize.max,
            //                         children: [
            //                           Padding(
            //                             padding: EdgeInsetsDirectional.fromSTEB(
            //                                 40, 0, 40, 0),
            //                             child: Row(
            //                               mainAxisSize: MainAxisSize.max,
            //                               mainAxisAlignment:
            //                                   MainAxisAlignment.spaceEvenly,
            //                               children: [
            //                                 Padding(
            //                                   padding:
            //                                       EdgeInsetsDirectional.fromSTEB(
            //                                           0, 0, 40, 0),
            //                                   child: Column(
            //                                     mainAxisSize: MainAxisSize.max,
            //                                     children: [
            //                                       Padding(
            //                                         padding: EdgeInsetsDirectional
            //                                             .fromSTEB(0, 10, 0, 0),
            //                                         child: Text(
            //                                           'PAY BY',
            //                                           textAlign: TextAlign.center,
            //                                           style: FlutterFlowTheme.of(
            //                                                   context)
            //                                               .labelMedium
            //                                               .override(
            //                                                 fontFamily:
            //                                                     'Readex Pro',
            //                                                 color: Colors.white,
            //                                                 fontSize: 16,
            //                                                 fontWeight:
            //                                                     FontWeight.w500,
            //                                               ),
            //                                         ),
            //                                       ),
            //                                       Padding(
            //                                         padding: EdgeInsetsDirectional
            //                                             .fromSTEB(0, 10, 0, 0),
            //                                         child: Text(
            //                                           'CASH',
            //                                           textAlign: TextAlign.center,
            //                                           style: FlutterFlowTheme.of(
            //                                                   context)
            //                                               .labelMedium
            //                                               .override(
            //                                                 fontFamily:
            //                                                     'Readex Pro',
            //                                                 color: Colors.white,
            //                                                 fontSize: 16,
            //                                                 fontWeight:
            //                                                     FontWeight.w500,
            //                                               ),
            //                                         ),
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 ),
            //                                 SizedBox(
            //                                   height: 100,
            //                                   child: VerticalDivider(
            //                                     thickness: 1,
            //                                     color:
            //                                         FlutterFlowTheme.of(context)
            //                                             .accent4,
            //                                   ),
            //                                 ),
            //                                 Expanded(
            //                                   child: Column(
            //                                     mainAxisSize: MainAxisSize.max,
            //                                     crossAxisAlignment:
            //                                         CrossAxisAlignment.end,
            //                                     children: [
            //                                       Padding(
            //                                         padding: EdgeInsetsDirectional
            //                                             .fromSTEB(0, 10, 0, 0),
            //                                         child: Text(
            //                                           'CLIENT PAYS',
            //                                           style: FlutterFlowTheme.of(
            //                                                   context)
            //                                               .displaySmall
            //                                               .override(
            //                                                 fontFamily: 'Outfit',
            //                                                 color: Colors.white,
            //                                                 fontSize: 16,
            //                                               ),
            //                                         ),
            //                                       ),
            //                                       Padding(
            //                                         padding: EdgeInsetsDirectional
            //                                             .fromSTEB(0, 10, 0, 0),
            //                                         child: Text(
            //                                           '£${fareData.journeyFare}',
            //                                           style: FlutterFlowTheme.of(
            //                                                   context)
            //                                               .displaySmall
            //                                               .override(
            //                                                 fontFamily: 'Outfit',
            //                                                 color: Colors.white,
            //                                                 fontSize: 20,
            //                                                 fontWeight:
            //                                                     FontWeight.bold,
            //                                               ),
            //                                         ),
            //                                       ),
            //                                     ],
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //                 Column(
            //                   mainAxisSize: MainAxisSize.max,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Padding(
            //                       padding: EdgeInsetsDirectional.fromSTEB(
            //                           0, 12, 0, 24),
            //                       child: Column(
            //                         mainAxisSize: MainAxisSize.max,
            //                         children: [
            //                           Padding(
            //                             padding: EdgeInsetsDirectional.fromSTEB(
            //                                 0, 0, 0, 8),
            //                             child: Container(
            //                               width:
            //                                   MediaQuery.sizeOf(context).width *
            //                                       0.92,
            //                               height: 70,
            //                               decoration: BoxDecoration(
            //                                 color: FlutterFlowTheme.of(context)
            //                                     .secondaryBackground,
            //                                 boxShadow: [
            //                                   BoxShadow(
            //                                     blurRadius: 3,
            //                                     color: Color(0x35000000),
            //                                     offset: Offset(0, 1),
            //                                   )
            //                                 ],
            //                                 borderRadius:
            //                                     BorderRadius.circular(8),
            //                                 border: Border.all(
            //                                   color: FlutterFlowTheme.of(context)
            //                                       .primaryBackground,
            //                                   width: 1,
            //                                 ),
            //                               ),
            //                               child: Padding(
            //                                 padding:
            //                                     EdgeInsetsDirectional.fromSTEB(
            //                                         4, 4, 4, 4),
            //                                 child: Row(
            //                                   mainAxisSize: MainAxisSize.max,
            //                                   children: [
            //                                     Padding(
            //                                       padding: EdgeInsetsDirectional
            //                                           .fromSTEB(8, 0, 0, 0),
            //                                       child: Card(
            //                                         clipBehavior: Clip
            //                                             .antiAliasWithSaveLayer,
            //                                         color: FlutterFlowTheme.of(
            //                                                 context)
            //                                             .primaryBackground,
            //                                         elevation: 0,
            //                                         shape: RoundedRectangleBorder(
            //                                           borderRadius:
            //                                               BorderRadius.circular(
            //                                                   40),
            //                                         ),
            //                                         child: Padding(
            //                                           padding:
            //                                               EdgeInsetsDirectional
            //                                                   .fromSTEB(
            //                                                       8, 8, 8, 8),
            //                                           child: Icon(
            //                                             Icons.local_parking,
            //                                             color:
            //                                                 FlutterFlowTheme.of(
            //                                                         context)
            //                                                     .primary,
            //                                             size: MediaQuery.sizeOf(
            //                                                         context)
            //                                                     .width *
            //                                                 0.05,
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     ),
            //                                     Expanded(
            //                                       child: Padding(
            //                                         padding: EdgeInsetsDirectional
            //                                             .fromSTEB(12, 0, 0, 0),
            //                                         child: Column(
            //                                           mainAxisSize:
            //                                               MainAxisSize.max,
            //                                           mainAxisAlignment:
            //                                               MainAxisAlignment
            //                                                   .center,
            //                                           crossAxisAlignment:
            //                                               CrossAxisAlignment
            //                                                   .start,
            //                                           children: [
            //                                             Text(
            //                                               'PARKING CHARGES',
            //                                               style:
            //                                                   FlutterFlowTheme.of(
            //                                                           context)
            //                                                       .bodyLarge,
            //                                             ),
            //                                           ],
            //                                         ),
            //                                       ),
            //                                     ),
            //                                     Padding(
            //                                       padding: EdgeInsetsDirectional
            //                                           .fromSTEB(12, 0, 12, 0),
            //                                       child: Column(
            //                                         mainAxisSize:
            //                                             MainAxisSize.max,
            //                                         mainAxisAlignment:
            //                                             MainAxisAlignment.center,
            //                                         crossAxisAlignment:
            //                                             CrossAxisAlignment.end,
            //                                         children: [
            //                                           Text(
            //                                             '£${fareData.carParking}',
            //                                             textAlign: TextAlign.end,
            //                                             style:
            //                                                 FlutterFlowTheme.of(
            //                                                         context)
            //                                                     .titleLarge,
            //                                           ),
            //                                         ],
            //                                       ),
            //                                     ),
            //                                   ],
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsetsDirectional.fromSTEB(
            //                                 0, 0, 0, 8),
            //                             child: Container(
            //                               width:
            //                                   MediaQuery.sizeOf(context).width *
            //                                       0.92,
            //                               height: 70,
            //                               decoration: BoxDecoration(
            //                                 color: FlutterFlowTheme.of(context)
            //                                     .secondaryBackground,
            //                                 boxShadow: [
            //                                   BoxShadow(
            //                                     blurRadius: 3,
            //                                     color: Color(0x35000000),
            //                                     offset: Offset(0, 1),
            //                                   )
            //                                 ],
            //                                 borderRadius:
            //                                     BorderRadius.circular(8),
            //                                 border: Border.all(
            //                                   color: FlutterFlowTheme.of(context)
            //                                       .primaryBackground,
            //                                   width: 1,
            //                                 ),
            //                               ),
            //                               child: Padding(
            //                                 padding:
            //                                     EdgeInsetsDirectional.fromSTEB(
            //                                         4, 4, 4, 4),
            //                                 child: Row(
            //                                   mainAxisSize: MainAxisSize.max,
            //                                   children: [
            //                                     Padding(
            //                                       padding: EdgeInsetsDirectional
            //                                           .fromSTEB(8, 0, 0, 0),
            //                                       child: Card(
            //                                         clipBehavior: Clip
            //                                             .antiAliasWithSaveLayer,
            //                                         color: FlutterFlowTheme.of(
            //                                                 context)
            //                                             .primaryBackground,
            //                                         elevation: 0,
            //                                         shape: RoundedRectangleBorder(
            //                                           borderRadius:
            //                                               BorderRadius.circular(
            //                                                   40),
            //                                         ),
            //                                         child: Padding(
            //                                           padding:
            //                                               EdgeInsetsDirectional
            //                                                   .fromSTEB(
            //                                                       8, 8, 8, 8),
            //                                           child: Icon(
            //                                             Icons.more_time,
            //                                             color:
            //                                                 FlutterFlowTheme.of(
            //                                                         context)
            //                                                     .primary,
            //                                             size: MediaQuery.sizeOf(
            //                                                         context)
            //                                                     .width *
            //                                                 0.05,
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     ),
            //                                     Expanded(
            //                                       child: Padding(
            //                                         padding: EdgeInsetsDirectional
            //                                             .fromSTEB(12, 0, 0, 0),
            //                                         child: Column(
            //                                           mainAxisSize:
            //                                               MainAxisSize.max,
            //                                           mainAxisAlignment:
            //                                               MainAxisAlignment
            //                                                   .center,
            //                                           crossAxisAlignment:
            //                                               CrossAxisAlignment
            //                                                   .start,
            //                                           children: [
            //                                             Text(
            //                                               'WAITING CHARGES',
            //                                               style:
            //                                                   FlutterFlowTheme.of(
            //                                                           context)
            //                                                       .bodyLarge,
            //                                             ),
            //                                           ],
            //                                         ),
            //                                       ),
            //                                     ),
            //                                     Padding(
            //                                       padding: EdgeInsetsDirectional
            //                                           .fromSTEB(12, 0, 12, 0),
            //                                       child: Column(
            //                                         mainAxisSize:
            //                                             MainAxisSize.max,
            //                                         mainAxisAlignment:
            //                                             MainAxisAlignment.center,
            //                                         crossAxisAlignment:
            //                                             CrossAxisAlignment.end,
            //                                         children: [
            //                                           Text(
            //                                             '£${fareData.waiting}',
            //                                             textAlign: TextAlign.end,
            //                                             style:
            //                                                 FlutterFlowTheme.of(
            //                                                         context)
            //                                                     .titleLarge
            //                                                     .override(
            //                                                       fontFamily:
            //                                                           'Outfit',
            //                                                     ),
            //                                           ),
            //                                         ],
            //                                       ),
            //                                     ),
            //                                   ],
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsetsDirectional.fromSTEB(
            //                                 0, 0, 0, 8),
            //                             child: Container(
            //                               width:
            //                                   MediaQuery.sizeOf(context).width *
            //                                       0.92,
            //                               height: 70,
            //                               decoration: BoxDecoration(
            //                                 color: FlutterFlowTheme.of(context)
            //                                     .secondaryBackground,
            //                                 boxShadow: [
            //                                   BoxShadow(
            //                                     blurRadius: 3,
            //                                     color: Color(0x35000000),
            //                                     offset: Offset(0, 1),
            //                                   )
            //                                 ],
            //                                 borderRadius:
            //                                     BorderRadius.circular(8),
            //                                 border: Border.all(
            //                                   color: FlutterFlowTheme.of(context)
            //                                       .primaryBackground,
            //                                   width: 1,
            //                                 ),
            //                               ),
            //                               child: Padding(
            //                                 padding:
            //                                     EdgeInsetsDirectional.fromSTEB(
            //                                         4, 4, 4, 4),
            //                                 child: Row(
            //                                   mainAxisSize: MainAxisSize.max,
            //                                   children: [
            //                                     Padding(
            //                                       padding: EdgeInsetsDirectional
            //                                           .fromSTEB(8, 0, 0, 0),
            //                                       child: Card(
            //                                         clipBehavior: Clip
            //                                             .antiAliasWithSaveLayer,
            //                                         color: FlutterFlowTheme.of(
            //                                                 context)
            //                                             .primaryBackground,
            //                                         elevation: 0,
            //                                         shape: RoundedRectangleBorder(
            //                                           borderRadius:
            //                                               BorderRadius.circular(
            //                                                   40),
            //                                         ),
            //                                         child: Padding(
            //                                           padding:
            //                                               EdgeInsetsDirectional
            //                                                   .fromSTEB(
            //                                                       8, 8, 8, 8),
            //                                           child: FaIcon(
            //                                             FontAwesomeIcons
            //                                                 .toriiGate,
            //                                             color:
            //                                                 FlutterFlowTheme.of(
            //                                                         context)
            //                                                     .primary,
            //                                             size: MediaQuery.sizeOf(
            //                                                         context)
            //                                                     .width *
            //                                                 0.05,
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     ),
            //                                     Expanded(
            //                                       child: Padding(
            //                                         padding: EdgeInsetsDirectional
            //                                             .fromSTEB(12, 0, 0, 0),
            //                                         child: Column(
            //                                           mainAxisSize:
            //                                               MainAxisSize.max,
            //                                           mainAxisAlignment:
            //                                               MainAxisAlignment
            //                                                   .center,
            //                                           crossAxisAlignment:
            //                                               CrossAxisAlignment
            //                                                   .start,
            //                                           children: [
            //                                             Text(
            //                                               'TOLLS CHARGES',
            //                                               style:
            //                                                   FlutterFlowTheme.of(
            //                                                           context)
            //                                                       .bodyLarge,
            //                                             ),
            //                                           ],
            //                                         ),
            //                                       ),
            //                                     ),
            //                                     Padding(
            //                                       padding: EdgeInsetsDirectional
            //                                           .fromSTEB(12, 0, 12, 0),
            //                                       child: Column(
            //                                         mainAxisSize:
            //                                             MainAxisSize.max,
            //                                         mainAxisAlignment:
            //                                             MainAxisAlignment.center,
            //                                         crossAxisAlignment:
            //                                             CrossAxisAlignment.end,
            //                                         children: [
            //                                           Text(
            //                                             '£${fareData.tolls}',
            //                                             textAlign: TextAlign.end,
            //                                             style:
            //                                                 FlutterFlowTheme.of(
            //                                                         context)
            //                                                     .titleLarge,
            //                                           ),
            //                                         ],
            //                                       ),
            //                                     ),
            //                                   ],
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsetsDirectional.fromSTEB(
            //                                 0, 0, 0, 8),
            //                             child: Container(
            //                               width:
            //                                   MediaQuery.sizeOf(context).width *
            //                                       0.92,
            //                               height: 70,
            //                               decoration: BoxDecoration(
            //                                 color: FlutterFlowTheme.of(context)
            //                                     .secondaryBackground,
            //                                 boxShadow: [
            //                                   BoxShadow(
            //                                     blurRadius: 3,
            //                                     color: Color(0x35000000),
            //                                     offset: Offset(0, 1),
            //                                   )
            //                                 ],
            //                                 borderRadius:
            //                                     BorderRadius.circular(8),
            //                                 border: Border.all(
            //                                   color: FlutterFlowTheme.of(context)
            //                                       .primaryBackground,
            //                                   width: 1,
            //                                 ),
            //                               ),
            //                               child: Padding(
            //                                 padding:
            //                                     EdgeInsetsDirectional.fromSTEB(
            //                                         4, 4, 4, 4),
            //                                 child: Row(
            //                                   mainAxisSize: MainAxisSize.max,
            //                                   children: [
            //                                     Padding(
            //                                       padding: EdgeInsetsDirectional
            //                                           .fromSTEB(8, 0, 0, 0),
            //                                       child: Card(
            //                                         clipBehavior: Clip
            //                                             .antiAliasWithSaveLayer,
            //                                         color: FlutterFlowTheme.of(
            //                                                 context)
            //                                             .primaryBackground,
            //                                         elevation: 0,
            //                                         shape: RoundedRectangleBorder(
            //                                           borderRadius:
            //                                               BorderRadius.circular(
            //                                                   40),
            //                                         ),
            //                                         child: Padding(
            //                                           padding:
            //                                               EdgeInsetsDirectional
            //                                                   .fromSTEB(
            //                                                       8, 8, 8, 8),
            //                                           child: FaIcon(
            //                                             FontAwesomeIcons
            //                                                 .handHoldingMedical,
            //                                             color:
            //                                                 FlutterFlowTheme.of(
            //                                                         context)
            //                                                     .primary,
            //                                             size: MediaQuery.sizeOf(
            //                                                         context)
            //                                                     .width *
            //                                                 0.05,
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     ),
            //                                     Expanded(
            //                                       child: Padding(
            //                                         padding: EdgeInsetsDirectional
            //                                             .fromSTEB(12, 0, 0, 0),
            //                                         child: Column(
            //                                           mainAxisSize:
            //                                               MainAxisSize.max,
            //                                           mainAxisAlignment:
            //                                               MainAxisAlignment
            //                                                   .center,
            //                                           crossAxisAlignment:
            //                                               CrossAxisAlignment
            //                                                   .start,
            //                                           children: [
            //                                             Text(
            //                                               'EXTRA CHARGES',
            //                                               style:
            //                                                   FlutterFlowTheme.of(
            //                                                           context)
            //                                                       .bodyLarge,
            //                                             ),
            //                                           ],
            //                                         ),
            //                                       ),
            //                                     ),
            //                                     Padding(
            //                                       padding: EdgeInsetsDirectional
            //                                           .fromSTEB(12, 0, 12, 0),
            //                                       child: Column(
            //                                         mainAxisSize:
            //                                             MainAxisSize.max,
            //                                         mainAxisAlignment:
            //                                             MainAxisAlignment.center,
            //                                         crossAxisAlignment:
            //                                             CrossAxisAlignment.end,
            //                                         children: [
            //                                           Text(
            //                                             '£${fareData.extras}',
            //                                             textAlign: TextAlign.end,
            //                                             style:
            //                                                 FlutterFlowTheme.of(
            //                                                         context)
            //                                                     .titleLarge,
            //                                           ),
            //                                         ],
            //                                       ),
            //                                     ),
            //                                   ],
            //                                 ),
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 Padding(
            //                   padding:
            //                       EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
            //                   child: FFButtonWidget(
            //                     onPressed: () async {
            //                       var request = http.MultipartRequest(
            //                           'POST',
            //                           Uri.parse(
            //                               'https://www.minicaboffice.com/api/driver/complete-job.php'));
            //                       request.fields.addAll({
            //                         'job_id': '${fareData.jobId}',
            //                         'd_id': '${fareData.driverId}',
            //                         'journey_fare': '${fareData.journeyFare}',
            //                         'car_parking': '${fareData.carParking}',
            //                         'extra': '${fareData.extras}',
            //                         'waiting': '${fareData.waiting}',
            //                         'tolls': '${fareData.tolls}'
            //                       });

            //                       http.StreamedResponse response =
            //                           await request.send();
            //                       if (response.statusCode == 200) {
            //                         print(await response.stream.bytesToString());
            //                         await context.pushNamed('Home');
            //                       } else {
            //                         print(response.reasonPhrase);
            //                       }
            //                     },
            //                     text: 'Complete',
            //                     options: FFButtonOptions(
            //                       width: MediaQuery.sizeOf(context).width * 0.8,
            //                       height: 40,
            //                       padding: EdgeInsetsDirectional.fromSTEB(
            //                           24, 0, 24, 0),
            //                       iconPadding:
            //                           EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            //                       color: fareStatus == 'Pending'
            //                           ? FlutterFlowTheme.of(context).primary
            //                           : FlutterFlowTheme.of(context).primary,
            //                       textStyle: FlutterFlowTheme.of(context)
            //                           .titleSmall
            //                           .override(
            //                             fontFamily: 'Readex Pro',
            //                             color: Colors.white,
            //                           ),
            //                       elevation: 3,
            //                       borderSide: BorderSide(
            //                         color: Colors.transparent,
            //                         width: 1,
            //                       ),
            //                       borderRadius: BorderRadius.circular(8),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       );
            //     }
            //   },
            // ),

          