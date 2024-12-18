import '../flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'jobshistory_model.dart';
export 'jobshistory_model.dart';
import '../Model/resentJobs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobHistorySheet extends StatefulWidget {
  const JobHistorySheet({super.key});

  @override
  State<JobHistorySheet> createState() => _JobHistorySheetState();
}

class _JobHistorySheetState extends State<JobHistorySheet>
    with TickerProviderStateMixin {
  late JobshistoryModel _model;
  ScrollController controller = ScrollController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => JobshistoryModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<List<Booked>> fetchBookings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');

    final uri =
        Uri.parse('https://minicaboffice.com/api/driver/job-history.php');
    final response = await http.post(uri, body: {'d_id': dId.toString()});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      List<Booked> bookingList =
          data.map((item) => Booked.fromJson(item)).cast<Booked>().toList();
      return bookingList;
    } else {
      print('Error: ${response.reasonPhrase}');
      return [];
    }
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
            initialChildSize: 0.8,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                height: 600,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.0,
                            color: Color(0x33000000),
                            offset: Offset(0.0, 1.0),
                          )
                        ],
                      ),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 10.0, 10.0, 10.0),
                              child: Text(
                                ' Jobs History',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 24.0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment(0.0, 0),
                            child: MediaQuery(
                              data: MediaQueryData(
                                size: MediaQuery.of(context).size,
                              ),
                              child: FlutterFlowButtonTabBar(
                                useToggleButtonStyle: true,
                                isScrollable: true,
                                labelStyle:
                                    FlutterFlowTheme.of(context).titleMedium,
                                unselectedLabelStyle: TextStyle(),
                                labelColor: FlutterFlowTheme.of(context).info,
                                unselectedLabelColor:
                                    FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                unselectedBackgroundColor:
                                    FlutterFlowTheme.of(context).primary,
                                backgroundColor: Colors.black,
                                borderColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                borderWidth: 1.0,
                                borderRadius: 12.0,
                                elevation: 0.0,
                                labelPadding: EdgeInsetsDirectional.fromSTEB(
                                  MediaQuery.of(context).size.width * 0.05,
                                  0.0,
                                  MediaQuery.of(context).size.width * 0.05,
                                  0.0,
                                ),
                                tabs: [
                                  Tab(
                                    text: 'This Week',
                                  ),
                                  Tab(
                                    text: 'Last Week',
                                  ),
                                ],
                                controller: _model.tabBarController,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        children: [
                          FutureBuilder<List<Booked>>(
                            future:
                                fetchBookings(), // Assuming you've renamed the function from 'Booking' to 'fetchBookings'
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Booked>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.2), // 50% padding from the top
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).primary),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('No History available.'),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text('No History available.'),
                                );
                              } else {
                                List<Booked>? bookingList = snapshot.data;
                                return ListView(
                                  controller: scrollController,
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  children:
                                      (bookingList ?? []).map((bookingData) {
                                    return SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 30.0),
                                        child: GestureDetector(
                                          // onVerticalDragUpdate: (details) {
                                          //   if (details.primaryDelta! > 20) {
                                          //     debugPrint('listens');
                                          //     // Close the BottomSheet on a downward swipe
                                          //     Navigator.pop(context);
                                          //   }
                                          // },
                                          // splashColor: Colors.transparent,
                                          // focusColor: Colors.transparent,
                                          // hoverColor: Colors.transparent,
                                          // highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.pushNamed(
                                              'JobHistoryDetails',
                                              queryParameters: {
                                                'did': serializeParam(
                                                  '${bookingData.jobId}',
                                                  ParamType.String,
                                                ),
                                                'pickup': serializeParam(
                                                  '${bookingData.pickup}',
                                                  ParamType.String,
                                                ),
                                                'dropoff': serializeParam(
                                                  '${bookingData.destination}',
                                                  ParamType.String,
                                                ),
                                                'bookId': serializeParam(
                                                  '${bookingData.bookId}',
                                                  ParamType.String,
                                                ),
                                                'date': serializeParam(
                                                  '${bookingData.bookDate}',
                                                  ParamType.String,
                                                ),
                                                'time': serializeParam(
                                                  '${bookingData.bookTime}',
                                                  ParamType.String,
                                                ),
                                                'passanger': serializeParam(
                                                  '${bookingData.passenger}',
                                                  ParamType.String,
                                                ),
                                                'cId': serializeParam(
                                                  '${bookingData.cId}',
                                                  ParamType.String,
                                                ),
                                                'cName': serializeParam(
                                                  '${bookingData.cName}',
                                                  ParamType.String,
                                                ),
                                                'cNotes': serializeParam(
                                                  '${bookingData.note}',
                                                  ParamType.String,
                                                ),
                                                'cNumber': serializeParam(
                                                  '${bookingData.cPhone}',
                                                  ParamType.String,
                                                ),
                                                'fare': serializeParam(
                                                  '${bookingData.fare}',
                                                  ParamType.String,
                                                ),
                                              }.withoutNulls,
                                            );
                                          },
                                          child: Container(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                20.0,
                                                                10.0,
                                                                20.0,
                                                                0.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          4.0),
                                                              child: Text(
                                                                ' Job Id #${bookingData.jobId}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      fontFamily:
                                                                          'Readex Pro',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                          0.0),
                                                              child: Text(
                                                                ' ${bookingData.status}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .override(
                                                                      fontFamily:
                                                                          'Readex Pro',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primary,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0.0,
                                                                      0.0,
                                                                      0.0,
                                                                      10.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .clock,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                size: 18.0,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  '${bookingData.bookTime}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  '${bookingData.bookDate}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMedium,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10.0,
                                                                child:
                                                                    VerticalDivider(
                                                                  thickness:
                                                                      1.0,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  'cash',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLarge,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Wrap(
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min, // Set this to MainAxisSize.min
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .arrow_circle_up,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  size: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.05,
                                                                ),
                                                                Flexible(
                                                                  // Wrap the Text widget with Flexible
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            10.0,
                                                                            0.0,
                                                                            20.0),
                                                                    child: Text(
                                                                      '${bookingData.pickup}',

                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                15.0,
                                                                          ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis, // Handle text overflow with ellipsis
                                                                      maxLines:
                                                                          3, // Limit to a maximum of 2 lines
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Wrap(
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min, // Set this to MainAxisSize.min
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .arrow_circle_down,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  size: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      0.05,
                                                                ),
                                                                Flexible(
                                                                  // Wrap the Text widget with Flexible
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10.0,
                                                                            10.0,
                                                                            0.0,
                                                                            20.0),
                                                                    child: Text(
                                                                      '${bookingData.destination}',

                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelMedium
                                                                          .override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            fontSize:
                                                                                15.0,
                                                                          ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis, // Handle text overflow with ellipsis
                                                                      maxLines:
                                                                          3, // Limit to a maximum of 2 lines
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Divider(
                                                          thickness: 1.0,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                          FutureBuilder<List<Booked>>(
                            future:
                                fetchBookings(), // Assuming you've renamed the function from 'Booking' to 'fetchBookings'
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Booked>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.2), // 50% padding from the top
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).primary),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('No History available.'),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text('No History available.'),
                                );
                              } else {
                                List<Booked>? bookingList = snapshot.data;
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          20.0), // Adjust the bottom padding as needed
                                  child: ListView(
                                    controller: scrollController,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    children:
                                        (bookingList ?? []).map((bookingData) {
                                      return SingleChildScrollView(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 15.0),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                'JobHistoryDetails',
                                                queryParameters: {
                                                  'did': serializeParam(
                                                    '${bookingData.jobId}',
                                                    ParamType.String,
                                                  ),
                                                  'pickup': serializeParam(
                                                    '${bookingData.pickup}',
                                                    ParamType.String,
                                                  ),
                                                  'dropoff': serializeParam(
                                                    '${bookingData.destination}',
                                                    ParamType.String,
                                                  ),
                                                  'bookId': serializeParam(
                                                    '${bookingData.bookId}',
                                                    ParamType.String,
                                                  ),
                                                  'date': serializeParam(
                                                    '${bookingData.bookDate}',
                                                    ParamType.String,
                                                  ),
                                                  'time': serializeParam(
                                                    '${bookingData.bookTime}',
                                                    ParamType.String,
                                                  ),
                                                  'passanger': serializeParam(
                                                    '${bookingData.passenger}',
                                                    ParamType.String,
                                                  ),
                                                  'cId': serializeParam(
                                                    '${bookingData.cId}',
                                                    ParamType.String,
                                                  ),
                                                  'cName': serializeParam(
                                                    '${bookingData.cName}',
                                                    ParamType.String,
                                                  ),
                                                  'cNotes': serializeParam(
                                                    '${bookingData.note}',
                                                    ParamType.String,
                                                  ),
                                                  'cNumber': serializeParam(
                                                    '${bookingData.cPhone}',
                                                    ParamType.String,
                                                  ),
                                                  'fare': serializeParam(
                                                    '${bookingData.fare}',
                                                    ParamType.String,
                                                  ),
                                                }.withoutNulls,
                                              );
                                            },
                                            child: Container(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  20.0,
                                                                  10.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            4.0),
                                                                child: Text(
                                                                  'Job Id #${bookingData.jobId}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .override(
                                                                        fontFamily:
                                                                            'Readex Pro',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                      ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            10.0,
                                                                            0.0,
                                                                            0.0),
                                                                child: Text(
                                                                  ' ${bookingData.status}',
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .override(
                                                                        fontFamily:
                                                                            'Readex Pro',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primary,
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        10.0),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                FaIcon(
                                                                  FontAwesomeIcons
                                                                      .clock,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  size: 18.0,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    '${bookingData.bookTime}',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    '${bookingData.bookDate}',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMedium,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10.0,
                                                                  child:
                                                                      VerticalDivider(
                                                                    thickness:
                                                                        1.0,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .secondaryText,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child: Text(
                                                                    'cash',
                                                                    style: FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelLarge,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Wrap(
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min, // Set this to MainAxisSize.min
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_circle_up,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    size: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.05,
                                                                  ),
                                                                  Flexible(
                                                                    // Wrap the Text widget with Flexible
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          10.0,
                                                                          10.0,
                                                                          0.0,
                                                                          20.0),
                                                                      child:
                                                                          Text(
                                                                        '${bookingData.pickup}',

                                                                        style: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .override(
                                                                              fontFamily: 'Readex Pro',
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              fontSize: 15.0,
                                                                            ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Handle text overflow with ellipsis
                                                                        maxLines:
                                                                            3, // Limit to a maximum of 2 lines
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Wrap(
                                                            children: [
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min, // Set this to MainAxisSize.min
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_circle_down,
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    size: MediaQuery.sizeOf(context)
                                                                            .width *
                                                                        0.05,
                                                                  ),
                                                                  Flexible(
                                                                    // Wrap the Text widget with Flexible
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          10.0,
                                                                          10.0,
                                                                          0.0,
                                                                          20.0),
                                                                      child:
                                                                          Text(
                                                                        '${bookingData.destination}',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .labelMedium
                                                                            .override(
                                                                              fontFamily: 'Readex Pro',
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                              fontSize: 15.0,
                                                                            ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis, // Handle text overflow with ellipsis
                                                                        maxLines:
                                                                            3, // Limit to a maximum of 2 lines
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Divider(
                                                            thickness: 1.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
