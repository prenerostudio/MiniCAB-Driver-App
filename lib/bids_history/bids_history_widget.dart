import '../components/EditBid_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bids_history_model.dart';
export 'bids_history_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Model/bidHistory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BidsHistoryWidget extends StatefulWidget {
  const BidsHistoryWidget({
    Key? key,
    required this.did,
  }) : super(key: key);

  final String? did;

  @override
  _BidsHistoryWidgetState createState() => _BidsHistoryWidgetState();
}

class _BidsHistoryWidgetState extends State<BidsHistoryWidget> {
  late BidsHistoryModel _model;

  ScrollController controller = ScrollController();
  List<Bid> bidItems = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BidsHistoryModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<List<Bid>> fetchBidHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');

    try {
      final uri =
          Uri.parse('https://minicaboffice.com/api/driver/bid-history.php');
      final response = await http.post(uri, body: {'d_id': dId.toString()});

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse[''];

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

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: 30.0,
              ),
              onPressed: () async {
                context.pop();
              },
            ),
            title: Text(
              'Bids History',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 22.0,
                  ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 2.0,
          ),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0),
                    child: FutureBuilder<List<Bid>>(
                      future: fetchBidHistory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height *
                                    0.3, // 30% padding from the top
                              ),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
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
                                top: MediaQuery.of(context).size.height *
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
                                top: MediaQuery.of(context).size.height *
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
                              controller: controller,
                              itemCount: data!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final bidItem = data[index];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  child: SingleChildScrollView(
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
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      20.0, 12.0, 20.0, 0.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                          'Bid Id #${bidItem.bookId}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
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
                                                        child: FFButtonWidget(
                                                          onPressed: () {
                                                            print(
                                                                'Button pressed ...');
                                                          },
                                                          text:
                                                              '£${bidItem.bidAmount}',
                                                          options:
                                                              FFButtonOptions(
                                                            height: 40.0,
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        24.0,
                                                                        0.0,
                                                                        24.0,
                                                                        0.0),
                                                            iconPadding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            color: FlutterFlowTheme
                                                                    .of(context)
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
                                                                      fontSize:
                                                                          14.0,
                                                                    ),
                                                            elevation: 3.0,
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 10.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .clock,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          size: MediaQuery.sizeOf(
                                                                      context)
                                                                  .width *
                                                              0.05,
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
                                                            '${bidItem.bookTime}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
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
                                                            '${bidItem.bookDate}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                          child:
                                                              VerticalDivider(
                                                            thickness: 1.0,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
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
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Wrap(
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Set this to MainAxisSize.min
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .arrow_circle_up,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            size: MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.05,
                                                          ),
                                                          Flexible(
                                                            // Wrap the Text widget with Flexible
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          10.0,
                                                                          0.0,
                                                                          20.0),
                                                              child: Text(
                                                                '${bidItem.pickup}',

                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Readex Pro',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
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
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Set this to MainAxisSize.min
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .arrow_circle_down,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            size: MediaQuery.sizeOf(
                                                                        context)
                                                                    .width *
                                                                0.05,
                                                          ),
                                                          Flexible(
                                                            // Wrap the Text widget with Flexible
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10.0,
                                                                          10.0,
                                                                          0.0,
                                                                          20.0),
                                                              child: Text(
                                                                '${bidItem.destination}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Readex Pro',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
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
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                10.0, 10.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              0.0,
                                                              10.0,
                                                              0.0,
                                                              0.0),
                                                          child: FFButtonWidget(
                                                            onPressed: () async {
                                                              await showModalBottomSheet(
                                                                isScrollControlled: true,
                                                                backgroundColor: Colors.transparent,
                                                                enableDrag: false,
                                                                context: context,
                                                                builder: (context) {
                                                                  return GestureDetector(
                                                                    onTap: () => _model.unfocusNode.canRequestFocus
                                                                        ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                                                                        : FocusScope.of(context).unfocus(),
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
                                                            text:
                                                            'Edit Bid Amount',
                                                            options:
                                                            FFButtonOptions(
                                                              height: 40.0,
                                                              padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  24.0,
                                                                  0.0,
                                                                  24.0,
                                                                  0.0),
                                                              iconPadding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                              color: FlutterFlowTheme
                                                                  .of(context)
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
                                                                fontSize:
                                                                14.0,
                                                              ),
                                                              elevation: 3.0,
                                                              borderSide:
                                                              BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1.0,
                                                              ),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  20.0),
                                                            ),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.man,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          size: 24.0,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Text(
                                                            'x ${bidItem.passenger}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      15.0,
                                                                ),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.luggage,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primary,
                                                          size: MediaQuery.sizeOf(
                                                                      context)
                                                                  .width *
                                                              0.05,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      10.0,
                                                                      0.0,
                                                                      10.0,
                                                                      0.0),
                                                          child: Text(
                                                            'x ${bidItem.luggage}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  fontSize:
                                                                      15.0,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    thickness: 1.0,
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
          ),
        ),

    );
  }
}
