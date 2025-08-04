import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:new_minicab_driver/Data/Alart.dart';

// import 'package:mini_cab/components/upcommingjob_Accepted_model.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/notes_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'customer_details_widget.dart';
import 'onway_widget.dart';
// import 'Upcommingjob_Accepted_model.dart';
// export 'Upcommingjob_Accepted_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Model/jobDetails.dart';
import 'package:latlong2/latlong.dart';

class UpcommingjobAcceptedWidget extends StatefulWidget {
  const UpcommingjobAcceptedWidget({
    Key? key,
    required this.dId,
  }) : super(key: key);

  final String? dId;

  @override
  _UpcommingjobAcceptedWidgetState createState() =>
      _UpcommingjobAcceptedWidgetState();
}

class _UpcommingjobAcceptedWidgetState
    extends State<UpcommingjobAcceptedWidget> {
  // late UpcommingjobAcceptedModel _model;
  late double pickupLatitude;
  late double pickupLongitude;
  late double currentLatitude;
  late double currentLongitude;
  String? pickup;
  double? pickupLat;
  double? pickupLng;
  int? switchValue1;
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    // _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    jobDetailsFuture();
    _loadSwitchStatus();

    // _model = createModel(context, () => UpcommingjobAcceptedModel());
  }

  @override
  void dispose() {
    // _model.maybeDispose();

    super.dispose();
  }

  Future<void> _loadSwitchStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switchValue1 = prefs.getInt('switchValue') ?? 0;
    });
  }

  Future<List<Job>> jobDetailsFuture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    print(dId);
    final response = await http.post(
      Uri.parse('https://minicaboffice.com/api/driver/upcoming-jobs.php'),
      body: {
        'd_id': dId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      print(parsedResponse);

      if (parsedResponse['data'] is List) {
        if (parsedResponse.containsKey('data')) {
          pickup = parsedResponse['data'][0]['pickup'];
        }
        return (parsedResponse['data'] as List)
            .map((item) => Job.fromJson(item))
            .toList();
      }
    }
    throw Exception('App Check Now');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 100.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional(0.00, 0.00),
             child: AnimatedGradientBorder(
                borderSize: 4,
                glowSize: 0,
                gradientColors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                  FlutterFlowTheme.of(context).primary
                ],
                borderRadius: BorderRadius.all(Radius.circular(50)),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width* 1.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Color(0x33000000),
                          offset: Offset(0.0, 2.0),
                        )
                      ],
                    ),
                    child: FutureBuilder<List<Job>>(
                      future: jobDetailsFuture(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Job>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return Container();
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Container();
                        } else {
                          final jobDetails = snapshot.data;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: jobDetails!.length,
                            itemBuilder: (context, index) {
                              final jobItem = jobDetails[index];
                              return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '£${jobItem.journeyFare}',
                                                textAlign: TextAlign.end,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .displaySmall
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                              ),
                                              Text(
                                                '(Estimated maximum value)',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .labelMedium
                                                    .override(
                                                      fontFamily: 'Montserrat',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                            ].divide(SizedBox(height: 4)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.business,
                                            color: Color(0xFF5B68F5),
                                            size: 45,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Opacity(
                                                opacity: 0.5,
                                                child: SizedBox(
                                                  height: 50,
                                                  child: VerticalDivider(
                                                    thickness: 2,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 0, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      'Time',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 16,
                                                              ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 15, 0, 0),
                                                      child: Text(
                                                        'Date',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 16,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(80, 0, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      '${jobItem.pickTime}',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontSize: 16,
                                                              ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 15, 0, 0),
                                                      child: Text(
                                                        '${jobItem.pickDate}',
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 16,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ].divide(SizedBox(width: 16)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF5B68F5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all(
                                                      color: Color(0xFF5B68F5),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'A',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: 5,
                                                  left: 25,
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        width: 4,
                                                        height: 80,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xFFE5E7EB),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top: 25,
                                                      ),
                                                      child: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 0.0),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF5B68F5),
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Color(0xFF5B68F5),
                                                      width: 2,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'B',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              width:
                                                  20), // Added SizedBox for spacing
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                top: 10,
                                                                bottom: 20),
                                                        child: Text(
                                                          '${jobItem.pickup}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 15,
                                                              ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 3,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 40),
                                                  child: Row(
                                                    children: [
                                                      FaIcon(
                                                        FontAwesomeIcons.bong,
                                                        color:
                                                            Color(0xFF5B68F5),
                                                        size: 18,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8),
                                                        child: Text(
                                                          '${(double.parse(jobItem.journeyDistance) * 0.621371).toStringAsFixed(2)} Mailes ${jobItem.journeyType}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 16,
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
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                top: 10,
                                                                bottom: 20),
                                                        child: Text(
                                                          '${jobItem.destination}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 15,
                                                              ),
                                                          overflow: TextOverflow
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FFButtonWidget(
                                          onPressed: () async {
                                            print('${jobItem.cName}');
                                            var url = Uri.parse(
                                                'https://minicaboffice.com/api/driver/cancel-booking.php');
                                            try {
                                              var response = await http.post(
                                                url,
                                                body: {
                                                  'book_id':
                                                      '${jobItem.bookId}',
                                                  'job_id': '${jobItem.jobId}'
                                                },
                                              );
                                              if (response.statusCode == 200) {
                                                Alarts().showOverlay(context);
                                                print(response.body);
                                              } else {
                                                print(response.reasonPhrase);
                                              }
                                            } catch (e) {
                                              print('Error: $e');
                                            }
                                          },
                                          text: 'cancel',
                                          icon: Icon(
                                            Icons.delete_outline,
                                            size: 15,
                                          ),
                                          options: FFButtonOptions(
                                            height: 50,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24, 0, 24, 0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 0, 0),
                                            color: Colors.red,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                        fontFamily: 'Open Sans',
                                                        color: Colors.white,
                                                        fontSize: 10),
                                            elevation: 3,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        FFButtonWidget(
                                          onPressed: () async {
                                            if (switchValue1 == 1) {
                                              try {
                                                var fields = {'job_id': '${jobItem.jobId}'};
                                                var response = await http.post(
                                                  Uri.parse('https://www.minicaboffice.com/api/driver/accept-job.php'),
                                                  body: fields,
                                                );
                                                if (response.statusCode == 200) {
                                                  Navigator.pop(context);
                                                } else {
                                                  print('Request failed with status: ${response.statusCode}');
                                                  print('Reason: ${response.reasonPhrase}');
                                                }
                                              } catch (e) {
                                                print('Error during request: $e');
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                msg:
                                                    "Please be online before starting the ride.",
                                                textColor: Colors.white,
                                                fontSize: 16.0,
                                              );
                                            }
                                          },
                                          text: 'Accepted',
                                          icon: Icon(
                                            Icons.east,
                                            size: 15,
                                          ),
                                          options: FFButtonOptions(
                                            height: 50,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    24, 0, 24, 0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 0, 0),
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .override(
                                                        fontFamily: 'Open Sans',
                                                        color: Colors.white,
                                                        fontSize: 10),
                                            elevation: 3,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]
                                      .divide(SizedBox(height: 4))
                                      .addToEnd(SizedBox(height: 12)),

                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
