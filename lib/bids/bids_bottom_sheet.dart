import 'dart:async';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mini_cab/Data/Alart.dart';
import 'package:mini_cab/upcomming/upcomming_widget.dart';

import '../BidHistory/bid_history_filter_model.dart';
import '../Model/bids.dart';
import '../components/upcommingjob_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Model/bidHistory.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/EditBid_widget.dart';

class BidsBottomSheet extends StatefulWidget {
  const BidsBottomSheet({super.key});

  @override
  State<BidsBottomSheet> createState() => _BidsBottomSheetState();
}

class _BidsBottomSheetState extends State<BidsBottomSheet>
    with TickerProviderStateMixin {
  late BidHistoryFilterModel _model;
  ScrollController controller = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BidHistoryFilterModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
  }

  // @override
  // void dispose() {
  //   _model.dispose();
  //   super.dispose();
  // }

  Future<List<Bid>> fetchBidHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');
    try {
      final uri =
          Uri.parse('https://minicaboffice.com/api/driver/bid-history.php');
      final response = await http.post(uri, body: {'d_id': dId.toString()});

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'];

        List<Bid> bookingList =
            data.map((item) => Bid.fromJson(item)).cast<Bid>().toList();
        return bookingList;
      } else {
        print('Error: ${response.reasonPhrase}');
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchBookings: $e');
      return [];
    }
  }

  Future<List<Bid>> acceptBids() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');

    try {
      final uri =
          Uri.parse('https://minicaboffice.com/api/driver/accepted-bids.php');
      final response = await http.post(uri, body: {'d_id': dId.toString()});

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'];

        List<Bid> bookingList =
            data.map((item) => Bid.fromJson(item)).cast<Bid>().toList();
        return bookingList;
      } else {
        print('Error: ${response.reasonPhrase}');
        throw Exception(
            'Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchBookings: $e');
      return []; // Return an empty list in case of an error.
    }
  }

  Future<List<BidItem>> Bids() async {
    final response = await http.get(
      Uri.parse('https://minicaboffice.com/api/driver/bid-list.php'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print("the bid data is ${jsonResponse}");
      final List<dynamic> data = jsonResponse['data'] ?? [];
      print(data);
      return data.map((item) => BidItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
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
              // height: 600,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment(0, 0),
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
                            unselectedLabelStyle: TextStyle(),
                            indicatorColor:
                                FlutterFlowTheme.of(context).primary,
                            padding: EdgeInsets.all(15),
                            tabs: [
                              Tab(
                                text: 'Available \n   Bids',
                              ),
                              Tab(
                                text: 'Waiting\nConformation',
                              ),
                              Tab(
                                text: '     Bids \nAccepted',
                              ),
                            ],
                            controller: _model.tabBarController,
                            onTap: (i) async {
                              [
                                () async {},
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
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 10.0, 10.0, 30.0),
                                      child: FutureBuilder<List<BidItem>>(
                                        future: Bids(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3, // 30% padding from the top
                                                ),
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3, // 30% padding from the top
                                                ),
                                                child:
                                                    Text('No Bids available.'),
                                              ),
                                            );
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return Center(
                                              child: Text('No Bids available.'),
                                            );
                                          } else {
                                            final data = snapshot.data;

                                            return SingleChildScrollView(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                      30.0), // Adjust the bottom padding as needed
                                              child: ListView.builder(
                                                controller: scrollController,
                                                itemCount: data!.length,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, index) {
                                                  final bidItem = data[index];
                                                  String
                                                      combinedDateTimeString =
                                                      "${bidItem.bdate} ${bidItem.btime}";
                                                  DateTime combinedDateTime =
                                                      DateTime.parse(
                                                          combinedDateTimeString);

                                                  // Format the DateTime object to the desired format
                                                  String formattedDateTime =
                                                      DateFormat(
                                                              'h a, E dd MMM yyyy')
                                                          .format(
                                                              combinedDateTime);

                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 0.0),
                                                    child: InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Container(
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            20.0,
                                                                            12.0,
                                                                            20.0,
                                                                            0.0),
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                                                                                child: Text(
                                                                                  'Bid Id #${bidItem.bookId}',
                                                                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                        fontFamily: 'Readex Pro',
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                              // Padding(
                                                                              //   padding: EdgeInsetsDirectional.fromSTEB(
                                                                              //       0.0,
                                                                              //       0.0,
                                                                              //       0.0,
                                                                              //       10.0),
                                                                              //   child:
                                                                              //       FFButtonWidget(
                                                                              //     onPressed: () {
                                                                              //       print('Button pressed ...');
                                                                              //     },
                                                                              //     text: '${bidItem.bookingStatus}',
                                                                              //     options: FFButtonOptions(
                                                                              //       height: 40.0,
                                                                              //       padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                                                              //       iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                              //       color: FlutterFlowTheme.of(context).primary,
                                                                              //       textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                              //             fontFamily: 'Readex Pro',
                                                                              //             color: Colors.white,
                                                                              //             fontSize: 14.0,
                                                                              //           ),
                                                                              //       elevation: 3.0,
                                                                              //       borderSide: BorderSide(
                                                                              //         color: Colors.transparent,
                                                                              //         width: 1.0,
                                                                              //       ),
                                                                              //       borderRadius: BorderRadius.circular(20.0),
                                                                              //     ),
                                                                              //   ),
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                10.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              children: [
                                                                                FaIcon(
                                                                                  FontAwesomeIcons.clock,
                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                  size: 18.0,
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                  child: Text(
                                                                                    '${bidItem.pickTime}',
                                                                                    style: FlutterFlowTheme.of(context).labelMedium,
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                  child: Text(
                                                                                    '${bidItem.pickDate}',
                                                                                    style: FlutterFlowTheme.of(context).labelMedium,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10.0,
                                                                                  child: VerticalDivider(
                                                                                    thickness: 1.0,
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                  child: Text(
                                                                                    'cash |',
                                                                                    style: FlutterFlowTheme.of(context).labelMedium,
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                                  child: Text(
                                                                                    bidItem.vName,
                                                                                    style: FlutterFlowTheme.of(context).labelMedium,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Wrap(
                                                                            children: [
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.min, // Set this to MainAxisSize.min
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.arrow_circle_up,
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    size: MediaQuery.sizeOf(context).width * 0.05,
                                                                                  ),
                                                                                  Flexible(
                                                                                    // Wrap the Text widget with Flexible
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 0.0, 20.0),
                                                                                      child: Text(
                                                                                        '${bidItem.pickup}',

                                                                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                              fontFamily: 'Readex Pro',
                                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                                              fontSize: 15.0,
                                                                                            ),
                                                                                        overflow: TextOverflow.ellipsis, // Handle text overflow with ellipsis
                                                                                        maxLines: 3, // Limit to a maximum of 2 lines
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
                                                                                mainAxisSize: MainAxisSize.min, // Set this to MainAxisSize.min
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.arrow_circle_down,
                                                                                    color: FlutterFlowTheme.of(context).primary,
                                                                                    size: MediaQuery.sizeOf(context).width * 0.05,
                                                                                  ),
                                                                                  Flexible(
                                                                                    // Wrap the Text widget with Flexible
                                                                                    child: Padding(
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 0.0, 20.0),
                                                                                      child: Text(
                                                                                        '${bidItem.destination}',
                                                                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                              fontFamily: 'Readex Pro',
                                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                                              fontSize: 15.0,
                                                                                            ),
                                                                                        overflow: TextOverflow.ellipsis, // Handle text overflow with ellipsis
                                                                                        maxLines: 3, // Limit to a maximum of 2 lines
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                10.0,
                                                                                10.0,
                                                                                10.0),
                                                                            child:
                                                                                Row(
                                                                              // mainAxisSize:
                                                                              //     MainAxisSize.max,
                                                                              // mainAxisAlignment:
                                                                              //     MainAxisAlignment.end,
                                                                              children: [
                                                                                Text('Total fare: ${bidItem.journeyFare}'),
                                                                                Spacer(),
                                                                                Icon(
                                                                                  Icons.man,
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  size: MediaQuery.sizeOf(context).width * 0.05,
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                                                                                  child: Text(
                                                                                    '${bidItem.passenger}',
                                                                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                          fontFamily: 'Readex Pro',
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          fontSize: 15.0,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                                Icon(
                                                                                  Icons.luggage,
                                                                                  color: FlutterFlowTheme.of(context).primary,
                                                                                  size: MediaQuery.sizeOf(context).width * 0.04,
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                                                                                  child: Text(
                                                                                    '${bidItem.luggage}',
                                                                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                          fontFamily: 'Readex Pro',
                                                                                          color: FlutterFlowTheme.of(context).secondaryText,
                                                                                          fontSize: 15.0,
                                                                                        ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                0.0,
                                                                                0.0,
                                                                                5.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 5.0),
                                                                                  child: FFButtonWidget(
                                                                                    onPressed: () async {
                                                                                      context.pushNamed(
                                                                                        'bidDetails',
                                                                                        queryParameters: {
                                                                                          'bidId': serializeParam(
                                                                                            '${bidItem.bookId}',
                                                                                            ParamType.String,
                                                                                          ),
                                                                                        }.withoutNulls,
                                                                                      );
                                                                                    },
                                                                                    text: 'Offer Price',
                                                                                    options: FFButtonOptions(
                                                                                      height: 40.0,
                                                                                      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                                                                      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                      color: FlutterFlowTheme.of(context).primary,
                                                                                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                            fontFamily: 'Readex Pro',
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                      elevation: 3.0,
                                                                                      borderSide: BorderSide(
                                                                                        color: Colors.transparent,
                                                                                        width: 1.0,
                                                                                      ),
                                                                                      borderRadius: BorderRadius.circular(20.0),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                6,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              FaIcon(
                                                                                FontAwesomeIcons.clock,
                                                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                                                size: 16.0,
                                                                              ),
                                                                              Text('  Expires on ${formattedDateTime} (GMT)')
                                                                            ],
                                                                          ),
                                                                          Divider(
                                                                            thickness:
                                                                                1.0,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
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
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 10.0, 10.0, 30.0),
                                      child: FutureBuilder<List<Bid>>(
                                        future: fetchBidHistory(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3, // 30% padding from the top
                                                ),
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary),
                                                ),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3, // 30% padding from the top
                                                ),
                                                child: Text('No Data Found'),
                                              ),
                                            );
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3, // 30% padding from the top
                                                ),
                                                child: Text('No Data Found'),
                                              ),
                                            );
                                          } else {
                                            final data = snapshot.data;
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                      30.0), // Adjust the bottom padding as needed
                                              child: ListView.builder(
                                                controller: scrollController,
                                                itemCount: data!.length,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, index) {
                                                  final bidItem = data[index];
                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Container(
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        20.0,
                                                                        12.0,
                                                                        20.0,
                                                                        0.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
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
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              4.0),
                                                                          child:
                                                                              Text(
                                                                            'Bid Id #${bidItem.bookId}',
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  fontFamily: 'Readex Pro',
                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "£${bidItem.bidAmount}",
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold),
                                                                        )
                                                                        // Padding(
                                                                        //   padding: EdgeInsetsDirectional.fromSTEB(
                                                                        //       0.0,
                                                                        //       10.0,
                                                                        //       0.0,
                                                                        //       0.0),
                                                                        //   child:
                                                                        //       FFButtonWidget(
                                                                        //     onPressed:
                                                                        //         () {
                                                                        //       print(
                                                                        //           'Button pressed ...');
                                                                        //     },
                                                                        //     text:
                                                                        //         '£${bidItem.bidAmount}',
                                                                        //     options:
                                                                        //         FFButtonOptions(
                                                                        //       height:
                                                                        //           40.0,
                                                                        //       padding: EdgeInsetsDirectional.fromSTEB(
                                                                        //           24.0,
                                                                        //           0.0,
                                                                        //           24.0,
                                                                        //           0.0),
                                                                        //       iconPadding: EdgeInsetsDirectional.fromSTEB(
                                                                        //           0.0,
                                                                        //           0.0,
                                                                        //           0.0,
                                                                        //           0.0),
                                                                        //       color:
                                                                        //           FlutterFlowTheme.of(context).primary,
                                                                        //       textStyle: FlutterFlowTheme.of(context)
                                                                        //           .titleSmall
                                                                        //           .override(
                                                                        //             fontFamily: 'Readex Pro',
                                                                        //             color: Colors.white,
                                                                        //             fontSize: 14.0,
                                                                        //           ),
                                                                        //       elevation:
                                                                        //           3.0,
                                                                        //       borderSide:
                                                                        //           BorderSide(
                                                                        //         color:
                                                                        //             Colors.transparent,
                                                                        //         width:
                                                                        //             1.0,
                                                                        //       ),
                                                                        //       borderRadius:
                                                                        //           BorderRadius.circular(20.0),
                                                                        //     ),
                                                                        //   ),
                                                                        // ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          10.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          FaIcon(
                                                                            FontAwesomeIcons.clock,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            size:
                                                                                MediaQuery.sizeOf(context).width * 0.05,
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              '${bidItem.bookTime}',
                                                                              style: FlutterFlowTheme.of(context).labelMedium,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              '${bidItem.bookDate}',
                                                                              style: FlutterFlowTheme.of(context).labelMedium,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.0,
                                                                            child:
                                                                                VerticalDivider(
                                                                              thickness: 1.0,
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'cash',
                                                                              style: FlutterFlowTheme.of(context).labelMedium,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Wrap(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min, // Set this to MainAxisSize.min
                                                                          children: [
                                                                            Icon(
                                                                              Icons.arrow_circle_up,
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              size: MediaQuery.sizeOf(context).width * 0.05,
                                                                            ),
                                                                            Flexible(
                                                                              // Wrap the Text widget with Flexible
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 0.0, 20.0),
                                                                                child: Text(
                                                                                  '${bidItem.pickup}',

                                                                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: 'Readex Pro',
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        fontSize: 15.0,
                                                                                      ),
                                                                                  overflow: TextOverflow.ellipsis, // Handle text overflow with ellipsis
                                                                                  maxLines: 3, // Limit to a maximum of 2 lines
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
                                                                              MainAxisSize.min, // Set this to MainAxisSize.min
                                                                          children: [
                                                                            Icon(
                                                                              Icons.arrow_circle_down,
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              size: MediaQuery.sizeOf(context).width * 0.05,
                                                                            ),
                                                                            Flexible(
                                                                              // Wrap the Text widget with Flexible
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 0.0, 20.0),
                                                                                child: Text(
                                                                                  '${bidItem.destination}',
                                                                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: 'Readex Pro',
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        fontSize: 15.0,
                                                                                      ),
                                                                                  overflow: TextOverflow.ellipsis, // Handle text overflow with ellipsis
                                                                                  maxLines: 3, // Limit to a maximum of 2 lines
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          10.0,
                                                                          10.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0.0,
                                                                                10.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                FFButtonWidget(
                                                                              onPressed: () async {
                                                                                await showModalBottomSheet(
                                                                                  isScrollControlled: true,
                                                                                  backgroundColor: Colors.transparent,
                                                                                  enableDrag: false,
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    return GestureDetector(
                                                                                      onTap: () => _model.unfocusNode.canRequestFocus ? FocusScope.of(context).requestFocus(_model.unfocusNode) : FocusScope.of(context).unfocus(),
                                                                                      child: Padding(
                                                                                        padding: MediaQuery.viewInsetsOf(context),
                                                                                        child: EditBidWidget(
                                                                                          dId: '${bidItem.dId}',
                                                                                          bidId: '${bidItem.bidId}',
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                ).then((value) => safeSetState(() {}));
                                                                              },
                                                                              text: 'Edit Bid Amount',
                                                                              options: FFButtonOptions(
                                                                                height: 40.0,
                                                                                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                                                                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                                                color: FlutterFlowTheme.of(context).primary,
                                                                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                                                      fontFamily: 'Readex Pro',
                                                                                      color: Colors.white,
                                                                                      fontSize: 14.0,
                                                                                    ),
                                                                                elevation: 3.0,
                                                                                borderSide: BorderSide(
                                                                                  color: Colors.transparent,
                                                                                  width: 1.0,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(20.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Icon(
                                                                            Icons.man,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            size:
                                                                                24.0,
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                0.0,
                                                                                10.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'x ${bidItem.passenger}',
                                                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: 'Readex Pro',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15.0,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                          Icon(
                                                                            Icons.luggage,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            size:
                                                                                MediaQuery.sizeOf(context).width * 0.05,
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                0.0,
                                                                                10.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'x ${bidItem.luggage}',
                                                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: 'Readex Pro',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15.0,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1.0,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
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
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // tap 3
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 10.0, 10.0, 30.0),
                                      child: FutureBuilder<List<Bid>>(
                                        future: acceptBids(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3, // 30% padding from the top
                                                ),
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary),
                                                ),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3, // 30% padding from the top
                                                ),
                                                child: Text('No Data Found'),
                                              ),
                                            );
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.3, // 30% padding from the top
                                                ),
                                                child: Text('No Data Found'),
                                              ),
                                            );
                                          } else {
                                            final data = snapshot.data;
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                      30.0), // Adjust the bottom padding as needed
                                              child: ListView.builder(
                                                controller: scrollController,
                                                itemCount: data!.length,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, index) {
                                                  final bidItem = data[index];
                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 0.0),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Container(
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        20.0,
                                                                        12.0,
                                                                        20.0,
                                                                        0.0),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
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
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0.0,
                                                                              0.0,
                                                                              0.0,
                                                                              4.0),
                                                                          child:
                                                                              Text(
                                                                            'Bid Id #${bidItem.bookId}',
                                                                            style: FlutterFlowTheme.of(context).bodyLarge.override(
                                                                                  fontFamily: 'Readex Pro',
                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          '£${bidItem.bidAmount}',
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          10.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          FaIcon(
                                                                            FontAwesomeIcons.clock,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).secondaryText,
                                                                            size:
                                                                                MediaQuery.sizeOf(context).width * 0.05,
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              '${bidItem.bookTime}',
                                                                              style: FlutterFlowTheme.of(context).labelMedium,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              '${bidItem.bookDate}',
                                                                              style: FlutterFlowTheme.of(context).labelMedium,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.0,
                                                                            child:
                                                                                VerticalDivider(
                                                                              thickness: 1.0,
                                                                              color: FlutterFlowTheme.of(context).secondaryText,
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                0.0,
                                                                                0.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'cash',
                                                                              style: FlutterFlowTheme.of(context).labelMedium,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Wrap(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min, // Set this to MainAxisSize.min
                                                                          children: [
                                                                            Icon(
                                                                              Icons.arrow_circle_up,
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              size: MediaQuery.sizeOf(context).width * 0.05,
                                                                            ),
                                                                            Flexible(
                                                                              // Wrap the Text widget with Flexible
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 0.0, 20.0),
                                                                                child: Text(
                                                                                  '${bidItem.pickup}',

                                                                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: 'Readex Pro',
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        fontSize: 15.0,
                                                                                      ),
                                                                                  overflow: TextOverflow.ellipsis, // Handle text overflow with ellipsis
                                                                                  maxLines: 3, // Limit to a maximum of 2 lines
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
                                                                              MainAxisSize.min, // Set this to MainAxisSize.min
                                                                          children: [
                                                                            Icon(
                                                                              Icons.arrow_circle_down,
                                                                              color: FlutterFlowTheme.of(context).primary,
                                                                              size: MediaQuery.sizeOf(context).width * 0.05,
                                                                            ),
                                                                            Flexible(
                                                                              // Wrap the Text widget with Flexible
                                                                              child: Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 0.0, 20.0),
                                                                                child: Text(
                                                                                  '${bidItem.destination}',
                                                                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                        fontFamily: 'Readex Pro',
                                                                                        color: FlutterFlowTheme.of(context).secondaryText,
                                                                                        fontSize: 15.0,
                                                                                      ),
                                                                                  overflow: TextOverflow.ellipsis, // Handle text overflow with ellipsis
                                                                                  maxLines: 3, // Limit to a maximum of 2 lines
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          10.0,
                                                                          10.0,
                                                                          10.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.man,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            size:
                                                                                24.0,
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                0.0,
                                                                                10.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'x ${bidItem.passenger}',
                                                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: 'Readex Pro',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15.0,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                          Icon(
                                                                            Icons.luggage,
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primary,
                                                                            size:
                                                                                MediaQuery.sizeOf(context).width * 0.05,
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                10.0,
                                                                                0.0,
                                                                                10.0,
                                                                                0.0),
                                                                            child:
                                                                                Text(
                                                                              'x ${bidItem.luggage}',
                                                                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                                    fontFamily: 'Readex Pro',
                                                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                                                    fontSize: 15.0,
                                                                                  ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1.0,
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
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
                                                  );
                                                },
                                              ),
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
                ],
              ),
            );
          }),
    );
  }
}
