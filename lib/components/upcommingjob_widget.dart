import 'package:fluttertoast/fluttertoast.dart';
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
import 'upcommingjob_model.dart';
export 'upcommingjob_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Model/jobDetails.dart';
import 'package:latlong2/latlong.dart';

class UpcommingjobWidget extends StatefulWidget {
  const UpcommingjobWidget({
    Key? key,
    required this.dId,
  }) : super(key: key);

  final String? dId;

  @override
  _UpcommingjobWidgetState createState() => _UpcommingjobWidgetState();
}

class _UpcommingjobWidgetState extends State<UpcommingjobWidget>
    with TickerProviderStateMixin {
  late UpcommingjobModel _model;
  late double pickupLatitude;
  late double pickupLongitude;
  late double currentLatitude;
  late double currentLongitude;
  String? pickup;
  final ScrollController _scrollController = ScrollController();
  double? pickupLat;
  double? pickupLng;
  int? switchValue1;
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    jobDetails();
    _loadSwitchStatus();
    _model = createModel(context, () => UpcommingjobModel());
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Future<void> _loadSwitchStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      switchValue1 = prefs.getInt('switchValue') ?? 0;
    });
  }

  Future<List<Job>> jobDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    print(dId);
    final response = await http.post(
      Uri.parse('https://www.minicaboffice.com/api/driver/accepted-jobs.php'),
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
    return [];
  }

  Future<List<Job>> jobDetailsNextWeek() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    final response = await http.post(
      Uri.parse(
          'https://www.minicaboffice.com/api/driver/upcoming-next-week.php'),
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
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! > 20) {
          // Close the BottomSheet on a downward swipe
          Navigator.pop(context);
        }
      },
      child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 100.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // FFButtonWidget(
                      //   onPressed: () async {
                      //     Navigator.pop(context);
                      //   },
                      //   text: 'Close',
                      //   icon: Icon(
                      //     Icons.close,
                      //     size: 15,
                      //   ),
                      //   options: FFButtonOptions(
                      //     height: 50,
                      //     padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      //     iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      //     color: Colors.red,
                      //     textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      //         fontFamily: 'Open Sans',
                      //         color: Colors.white,
                      //         fontSize: 10),
                      //     elevation: 3,
                      //     borderSide: BorderSide(
                      //       color: Colors.transparent,
                      //       width: 1,
                      //     ),
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      // ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 7,
                          ),
                          Container(
                            height: 4,
                            width: 36,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(38),
                                color: Colors.grey.withOpacity(0.3)),
                          ),
                          Align(
                            alignment: const Alignment(0, 0),
                            child: TabBar(
                              labelColor: FlutterFlowTheme.of(context).primary,
                              unselectedLabelColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              labelStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Open Sans',
                                    letterSpacing: 0,
                                  ),
                              unselectedLabelStyle: const TextStyle(),
                              indicatorColor:
                                  FlutterFlowTheme.of(context).primary,
                              padding: const EdgeInsets.all(15),
                              tabs: [
                                const Tab(
                                  text: 'Upcoming',
                                ),
                                const Tab(
                                  text: 'Next Week',
                                ),
                              ],
                              controller: _model.tabBarController,
                              onTap: (i) async {
                                [
                                  () async {},
                                  () async {},
                                ][i]();
                              },
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _model.tabBarController,
                              children: [
                                // tap 1
                                SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10.0, 10.0, 10.0, 30.0),
                                        child: FutureBuilder<List<Job>>(
                                          future: jobDetails(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<Job>>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Colors.blueAccent),
                                              ));
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                        'No Job is Available.'),
                                                    const SizedBox(height: 20),
                                                    FFButtonWidget(
                                                      onPressed: () async {
                                                        context.pushNamed(
                                                            'Dashboard');
                                                      },
                                                      text: 'Go To Dashboard',
                                                      options: FFButtonOptions(
                                                        width: double.infinity,
                                                        height: 40.0,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    24.0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                        elevation: 3.0,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return const Center(
                                                  child: Text(
                                                      'No Job is Available.'));
                                            } else {
                                              final jobDetails = snapshot.data;
                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                controller: scrollController,
                                                scrollDirection: Axis.vertical,
                                                itemCount: jobDetails!.length,
                                                itemBuilder: (context, index) {
                                                  final jobItem =
                                                      jobDetails[index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 8),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    '£${jobItem.journeyFare}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .displaySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Outfit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              32,
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
                                                                          fontFamily:
                                                                              'Montserrat',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                  ),
                                                                ].divide(
                                                                    const SizedBox(
                                                                        height:
                                                                            4)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                Icons.business,
                                                                color: Color(
                                                                    0xFF5B68F5),
                                                                size: 45,
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Opacity(
                                                                    opacity:
                                                                        0.5,
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          50,
                                                                      child:
                                                                          VerticalDivider(
                                                                        thickness:
                                                                            2,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Text(
                                                                          'Time',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Roboto',
                                                                                fontSize: 16,
                                                                              ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0,
                                                                              15,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            'Date',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Roboto',
                                                                                  fontSize: 16,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            80,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Text(
                                                                          '${jobItem.pickTime}',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Roboto',
                                                                                fontSize: 16,
                                                                              ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0,
                                                                              15,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            '${jobItem.pickDate}',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Roboto',
                                                                                  fontSize: 16,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ].divide(
                                                                const SizedBox(
                                                                    width: 16)),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        Container(
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFF5B68F5),
                                                                        borderRadius:
                                                                            BorderRadius.circular(50),
                                                                        shape: BoxShape
                                                                            .rectangle,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              const Color(0xFF5B68F5),
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'A',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 5,
                                                                      left: 25,
                                                                    ),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                4,
                                                                            height:
                                                                                80,
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: Color(0xFFE5E7EB),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            top:
                                                                                25,
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                30,
                                                                            height:
                                                                                30,
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: Color.fromRGBO(0, 0, 0, 0.0),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 5),
                                                                    child:
                                                                        Container(
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFF5B68F5),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              const Color(0xFF5B68F5),
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'B',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  width:
                                                                      20), // Added SizedBox for spacing
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Flexible(
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 10,
                                                                                top: 10,
                                                                                bottom: 20),
                                                                            child:
                                                                                Text(
                                                                              '${jobItem.pickup}',
                                                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: 'Readex Pro',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                  ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 3,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              40),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const FaIcon(
                                                                            FontAwesomeIcons.bong,
                                                                            color:
                                                                                Color(0xFF5B68F5),
                                                                            size:
                                                                                18,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 8),
                                                                            child:
                                                                                Text(
                                                                              '${(double.parse(jobItem.journeyDistance) * 0.621371).toStringAsFixed(2)} Mailes ${jobItem.journeyType}',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
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
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 10,
                                                                                top: 10,
                                                                                bottom: 20),
                                                                            child:
                                                                                Text(
                                                                              '${jobItem.destination}',
                                                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: 'Readex Pro',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                  ),
                                                                              overflow: TextOverflow.ellipsis,
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
                                                        Divider(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                        ),
                                                      ]
                                                          .divide(
                                                              const SizedBox(
                                                                  height: 4))
                                                          .addToEnd(
                                                              const SizedBox(
                                                                  height: 12)),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // tap 2
                                SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10.0, 10.0, 10.0, 30.0),
                                        child: FutureBuilder<List<Job>>(
                                          future: jobDetailsNextWeek(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<Job>>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Colors.blueAccent),
                                              ));
                                            } else if (snapshot.hasError) {
                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                        'No Job is Available.'),
                                                    const SizedBox(height: 20),
                                                    FFButtonWidget(
                                                      onPressed: () async {
                                                        context.pushNamed(
                                                            'Dashboard');
                                                      },
                                                      text: 'Go To Dashboard',
                                                      options: FFButtonOptions(
                                                        width: double.infinity,
                                                        height: 40.0,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    24.0),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleSmall
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                        elevation: 3.0,
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return const Center(
                                                  child: Text(
                                                      'No Job is Available.'));
                                            } else {
                                              final jobDetails = snapshot.data;
                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                controller: scrollController,
                                                itemCount: jobDetails!.length,
                                                itemBuilder: (context, index) {
                                                  final jobItem =
                                                      jobDetails[index];
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0, 0, 0, 8),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    '£${jobItem.journeyFare}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .displaySmall
                                                                        .override(
                                                                          fontFamily:
                                                                              'Outfit',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              32,
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
                                                                          fontFamily:
                                                                              'Montserrat',
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                  ),
                                                                ].divide(
                                                                    const SizedBox(
                                                                        height:
                                                                            4)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                Icons.business,
                                                                color: Color(
                                                                    0xFF5B68F5),
                                                                size: 45,
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Opacity(
                                                                    opacity:
                                                                        0.5,
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          50,
                                                                      child:
                                                                          VerticalDivider(
                                                                        thickness:
                                                                            2,
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Text(
                                                                          'Time',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Roboto',
                                                                                fontSize: 16,
                                                                              ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0,
                                                                              15,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            'Date',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Roboto',
                                                                                  fontSize: 16,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            80,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      children: [
                                                                        Text(
                                                                          '${jobItem.pickTime}',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Roboto',
                                                                                fontSize: 16,
                                                                              ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0,
                                                                              15,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            '${jobItem.pickDate}',
                                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                  fontFamily: 'Roboto',
                                                                                  fontSize: 16,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ].divide(
                                                                const SizedBox(
                                                                    width: 16)),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        Container(
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFF5B68F5),
                                                                        borderRadius:
                                                                            BorderRadius.circular(50),
                                                                        shape: BoxShape
                                                                            .rectangle,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              const Color(0xFF5B68F5),
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'A',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .only(
                                                                      top: 5,
                                                                      left: 25,
                                                                    ),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                4,
                                                                            height:
                                                                                80,
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: Color(0xFFE5E7EB),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            top:
                                                                                25,
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                30,
                                                                            height:
                                                                                30,
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: Color.fromRGBO(0, 0, 0, 0.0),
                                                                              shape: BoxShape.circle,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        top: 5),
                                                                    child:
                                                                        Container(
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color(
                                                                            0xFF5B68F5),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              const Color(0xFF5B68F5),
                                                                          width:
                                                                              2,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'B',
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                fontFamily: 'Open Sans',
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w300,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  width:
                                                                      20), // Added SizedBox for spacing
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Flexible(
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 10,
                                                                                top: 10,
                                                                                bottom: 20),
                                                                            child:
                                                                                Text(
                                                                              '${jobItem.pickup}',
                                                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: 'Readex Pro',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                  ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 3,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          bottom:
                                                                              40),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const FaIcon(
                                                                            FontAwesomeIcons.bong,
                                                                            color:
                                                                                Color(0xFF5B68F5),
                                                                            size:
                                                                                18,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 8),
                                                                            child:
                                                                                Text(
                                                                              '${(double.parse(jobItem.journeyDistance) * 0.621371).toStringAsFixed(2)} Mailes ${jobItem.journeyType}',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    fontFamily: 'Open Sans',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
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
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 10,
                                                                                top: 10,
                                                                                bottom: 20),
                                                                            child:
                                                                                Text(
                                                                              '${jobItem.destination}',
                                                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: 'Readex Pro',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15,
                                                                                  ),
                                                                              overflow: TextOverflow.ellipsis,
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
                                                        Divider(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                        ),
                                                      ]
                                                          .divide(
                                                              const SizedBox(
                                                                  height: 4))
                                                          .addToEnd(
                                                              const SizedBox(
                                                                  height: 12)),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
