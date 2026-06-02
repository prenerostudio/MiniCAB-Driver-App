import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'bids_model.dart';
export 'bids_model.dart';
import 'package:http/http.dart' as http;
import '../Model/bids.dart';
import 'package:new_minicab_driver/Data/api_service.dart';

class BidsWidget extends StatefulWidget {
  const BidsWidget({super.key});

  @override
  _BidsWidgetState createState() => _BidsWidgetState();
}

class _BidsWidgetState extends State<BidsWidget> {
  late BidsModel _model;

  ScrollController controller = ScrollController();

  List<BidItem> bidItems = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BidsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<List<BidItem>> Bids() async {
    final response = await http.get(Uri.parse(ApiService.driverBidList));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      final List<dynamic> data = jsonResponse[''];
      print("the bids respnse is $jsonResponse");
      return data.map((item) => BidItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
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
    DateTime? lastBackPressed;
    return GestureDetector(
      onTap:
          () =>
              _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (lastBackPressed == null ||
              DateTime.now().difference(lastBackPressed!) >
                  const Duration(seconds: 2)) {
            context.pushNamed('Home');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Press again to exit')),
            );
            lastBackPressed = DateTime.now();
            return false;
          } else {
            SystemNavigator.pop();
            return true;
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: context.appTheme.primaryBackground,
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Row(
                  //   mainAxisSize: MainAxisSize.max,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Padding(
                  //       padding:
                  //           EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                  //       child: FlutterFlowIconButton(
                  //         borderColor: Colors.transparent,
                  //         borderRadius: 30.0,
                  //         borderWidth: 1.0,
                  //         buttonSize: 50.0,
                  //         icon: Icon(
                  //           Icons.arrow_back_rounded,
                  //           color: context.appTheme.primary,
                  //           size: 30.0,
                  //         ),
                  //         onPressed: () async {
                  //           context.pushNamed('Home');
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              10.0,
                              0.0,
                              30.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                    10.0,
                                    10.0,
                                    10.0,
                                    10.0,
                                  ),
                                  child: Text(
                                    'Bids',
                                    style: context.appTheme.labelMedium.override(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 24.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        FutureBuilder<List<BidItem>>(
                          future: Bids(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.3, // 30% padding from the top
                                  ),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      context.appTheme.primary,
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.3, // 30% padding from the top
                                  ),
                                  child: const Text('No Bid available.'),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('No Bidsss available.'),
                              );
                            } else {
                              final data = snapshot.data;

                              return SingleChildScrollView(
                                padding: const EdgeInsets.only(
                                  bottom: 30.0,
                                ), // Adjust the bottom padding as needed
                                child: ListView.builder(
                                  controller: controller,
                                  itemCount: data!.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    final bidItem = data[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                            0.0,
                                            10.0,
                                            0.0,
                                            0.0,
                                          ),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: SingleChildScrollView(
                                          child: Container(
                                            child: SingleChildScrollView(
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
                                                          const EdgeInsetsDirectional.fromSTEB(
                                                            20.0,
                                                            12.0,
                                                            20.0,
                                                            0.0,
                                                          ),
                                                      child: SingleChildScrollView(
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
                                                                      const EdgeInsetsDirectional.fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        4.0,
                                                                      ),
                                                                  child: Text(
                                                                    'Bid Id #${bidItem.bookId}',
                                                                    style: context.appTheme.bodyLarge.override(
                                                                      fontFamily:
                                                                          'Readex Pro',
                                                                      color:
                                                                          context.appTheme.secondaryText,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional.fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        0.0,
                                                                        10.0,
                                                                      ),
                                                                  child: FFButtonWidget(
                                                                    onPressed: () {
                                                                      print(
                                                                        'Button pressed ...',
                                                                      );
                                                                    },
                                                                    text:
                                                                        bidItem
                                                                            .bookingStatus,
                                                                    options: FFButtonOptions(
                                                                      height:
                                                                          40.0,
                                                                      padding:
                                                                          const EdgeInsetsDirectional.fromSTEB(
                                                                            24.0,
                                                                            0.0,
                                                                            24.0,
                                                                            0.0,
                                                                          ),
                                                                      iconPadding:
                                                                          const EdgeInsetsDirectional.fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                          ),
                                                                      color:
                                                                          context.appTheme.primary,
                                                                      textStyle: context.appTheme.titleSmall.override(
                                                                        fontFamily:
                                                                            'Readex Pro',
                                                                        color:
                                                                            Colors.white,
                                                                        fontSize:
                                                                            14.0,
                                                                      ),
                                                                      elevation:
                                                                          3.0,
                                                                      borderSide: const BorderSide(
                                                                        color:
                                                                            Colors.transparent,
                                                                        width:
                                                                            1.0,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            20.0,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional.fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    10.0,
                                                                  ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  FaIcon(
                                                                    FontAwesomeIcons
                                                                        .clock,
                                                                    color:
                                                                        context.appTheme.secondaryText,
                                                                    size: 18.0,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional.fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                        ),
                                                                    child: Text(
                                                                      bidItem
                                                                          .pickTime,
                                                                      style:
                                                                          context.appTheme.labelMedium,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional.fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                        ),
                                                                    child: Text(
                                                                      bidItem
                                                                          .pickDate,
                                                                      style:
                                                                          context.appTheme.labelMedium,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        10.0,
                                                                    child: VerticalDivider(
                                                                      thickness:
                                                                          1.0,
                                                                      color:
                                                                          context.appTheme.secondaryText,
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional.fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                        ),
                                                                    child: Text(
                                                                      'cash',
                                                                      style:
                                                                          context.appTheme.labelMedium,
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
                                                                      color:
                                                                          context.appTheme.primary,
                                                                      size:
                                                                          MediaQuery.sizeOf(
                                                                            context,
                                                                          ).width *
                                                                          0.05,
                                                                    ),
                                                                    Flexible(
                                                                      // Wrap the Text widget with Flexible
                                                                      child: Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          10.0,
                                                                          10.0,
                                                                          0.0,
                                                                          20.0,
                                                                        ),
                                                                        child: Text(
                                                                          bidItem
                                                                              .pickup,

                                                                          style: context.appTheme.labelMedium.override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            color:
                                                                                context.appTheme.secondaryText,
                                                                            fontSize:
                                                                                15.0,
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
                                                                      color:
                                                                          context.appTheme.primary,
                                                                      size:
                                                                          MediaQuery.sizeOf(
                                                                            context,
                                                                          ).width *
                                                                          0.05,
                                                                    ),
                                                                    Flexible(
                                                                      // Wrap the Text widget with Flexible
                                                                      child: Padding(
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          10.0,
                                                                          10.0,
                                                                          0.0,
                                                                          20.0,
                                                                        ),
                                                                        child: Text(
                                                                          bidItem
                                                                              .destination,
                                                                          style: context.appTheme.labelMedium.override(
                                                                            fontFamily:
                                                                                'Readex Pro',
                                                                            color:
                                                                                context.appTheme.secondaryText,
                                                                            fontSize:
                                                                                15.0,
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
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional.fromSTEB(
                                                                    0.0,
                                                                    10.0,
                                                                    10.0,
                                                                    10.0,
                                                                  ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Icon(
                                                                    Icons.man,
                                                                    color:
                                                                        context.appTheme.primary,
                                                                    size:
                                                                        MediaQuery.sizeOf(
                                                                          context,
                                                                        ).width *
                                                                        0.05,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional.fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                        ),
                                                                    child: Text(
                                                                      'x ${bidItem.passenger}',
                                                                      style: context.appTheme.labelMedium.override(
                                                                        fontFamily:
                                                                            'Readex Pro',
                                                                        color:
                                                                            context.appTheme.secondaryText,
                                                                        fontSize:
                                                                            15.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .luggage,
                                                                    color:
                                                                        context.appTheme.primary,
                                                                    size:
                                                                        MediaQuery.sizeOf(
                                                                          context,
                                                                        ).width *
                                                                        0.05,
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional.fromSTEB(
                                                                          10.0,
                                                                          0.0,
                                                                          10.0,
                                                                          0.0,
                                                                        ),
                                                                    child: Text(
                                                                      'x ${bidItem.luggage}',
                                                                      style: context.appTheme.labelMedium.override(
                                                                        fontFamily:
                                                                            'Readex Pro',
                                                                        color:
                                                                            context.appTheme.secondaryText,
                                                                        fontSize:
                                                                            15.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional.fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    5.0,
                                                                  ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional.fromSTEB(
                                                                          5.0,
                                                                          5.0,
                                                                          5.0,
                                                                          5.0,
                                                                        ),
                                                                    child: FFButtonWidget(
                                                                      onPressed: () async {
                                                                        context.pushNamed(
                                                                          'bidDetails',
                                                                          queryParameters:
                                                                              {
                                                                                'bidId': serializeParam(
                                                                                  bidItem.bookId,
                                                                                  ParamType.String,
                                                                                ),
                                                                              }.withoutNulls,
                                                                        );
                                                                      },
                                                                      text:
                                                                          'Offer Price',
                                                                      options: FFButtonOptions(
                                                                        height:
                                                                            40.0,
                                                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          24.0,
                                                                          0.0,
                                                                          24.0,
                                                                          0.0,
                                                                        ),
                                                                        iconPadding: const EdgeInsetsDirectional.fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                        ),
                                                                        color:
                                                                            context.appTheme.primary,
                                                                        textStyle: context.appTheme.titleSmall.override(
                                                                          fontFamily:
                                                                              'Readex Pro',
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        elevation:
                                                                            3.0,
                                                                        borderSide: const BorderSide(
                                                                          color:
                                                                              Colors.transparent,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              20.0,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Divider(
                                                              thickness: 1.0,
                                                              color:
                                                                  context.appTheme.secondaryText,
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
