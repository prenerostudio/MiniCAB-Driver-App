import 'package:new_minicab_driver/Model/invoiceDetails.dart';

import '../Model/invoivce.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'account_details_model.dart';
export 'account_details_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:new_minicab_driver/Data/api_service.dart';

class AccountDetailsWidget extends StatefulWidget {
  const AccountDetailsWidget({super.key, required this.Id});

  final String Id;

  @override
  _AccountDetailsWidgetState createState() => _AccountDetailsWidgetState();
}

class _AccountDetailsWidgetState extends State<AccountDetailsWidget> {
  late AccountDetailsModel _model;
  ScrollController controller = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    invoice();
    _model = createModel(context, () => AccountDetailsModel());
  }

  Future<List<Invoice>> invoice() async {
    final uri = Uri.parse(ApiService.driverInvoiceDetails);
    final response = await http.post(uri, body: {'invoice_id': widget.Id});
    print(response);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse[''] ?? [];

      List<Invoice> paymentData =
          data.map((item) => Invoice.fromJson(item)).cast<Invoice>().toList();
      print(paymentData);
      return paymentData;
    } else {
      print('Error: ${response.reasonPhrase}');
      return []; // Return an empty list in case of an error.
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: context.appTheme.primaryBackground,
      appBar: AppBar(
        backgroundColor: context.appTheme.primary,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          buttonSize: 46,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: context.appTheme.alternate,
            size: 24,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      body: Align(
        alignment: AlignmentDirectional(0, -1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 70),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.appTheme.secondaryBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x33000000),
                          offset: Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FutureBuilder<List<Invoice>>(
                      future: invoice(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<List<Invoice>> snapshot,
                      ) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Display a loading indicator while waiting for data
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top:
                                    MediaQuery.of(context).size.height *
                                    0.2, // 30% padding from the top
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
                                    0.2, // 30% padding from the top
                              ),
                              child: Text('No Data Found'),
                            ),
                          );
                        } else {
                          // Data has been successfully loaded, extract and use it
                          final invoiceData = snapshot.data;

                          // Replace the comment below with your actual UI components using invoiceData
                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              15,
                              0,
                              0,
                            ),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: invoiceData!.length,
                              controller: controller,
                              itemBuilder: (BuildContext context, int index) {
                                final invoice = invoiceData[index];
                                return Padding(
                                  padding: EdgeInsets.all(16),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Invoice INV / ${invoice.invoiceId}',
                                          style: context.appTheme.titleLarge.override(
                                            fontFamily: 'Outfit',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0,
                                                4,
                                                0,
                                                0,
                                              ),
                                          child: Text(
                                            'Booking Details',
                                            style:
                                                context.appTheme.labelLarge,
                                          ),
                                        ),
                                        Align(
                                          alignment: AlignmentDirectional(1, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  0,
                                                  10,
                                                  0,
                                                  10,
                                                ),
                                            child: Text(
                                              'Status: ${invoice.invoiceStatus}',
                                              style:
                                                  context.appTheme.titleLarge,
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding:
                                        //       EdgeInsetsDirectional.fromSTEB(
                                        //           0, 10, 0, 10),
                                        //   child: Row(
                                        //     mainAxisSize: MainAxisSize.max,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment
                                        //             .spaceBetween,
                                        //     children: [
                                        //       Text(
                                        //         'Name',
                                        //         style: AppTheme.of(
                                        //                 context)
                                        //             .labelMedium
                                        //             .override(
                                        //               fontFamily:
                                        //                   'Readex Pro',
                                        //               fontWeight:
                                        //                   FontWeight.w600,
                                        //             ),
                                        //       ),
                                        //       Text(
                                        //         'Atiq Ramzan',
                                        //         style: AppTheme.of(
                                        //                 context)
                                        //             .labelMedium,
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding:
                                        //       EdgeInsetsDirectional.fromSTEB(
                                        //           0, 10, 0, 10),
                                        //   child: Row(
                                        //     mainAxisSize: MainAxisSize.max,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment
                                        //             .spaceBetween,
                                        //     children: [
                                        //       Text(
                                        //         'Phone',
                                        //         style: AppTheme.of(
                                        //                 context)
                                        //             .labelMedium
                                        //             .override(
                                        //               fontFamily:
                                        //                   'Readex Pro',
                                        //               fontWeight:
                                        //                   FontWeight.w600,
                                        //             ),
                                        //       ),
                                        //       Text(
                                        //         '032511511565',
                                        //         style: AppTheme.of(
                                        //                 context)
                                        //             .labelMedium,
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding:
                                        //       EdgeInsetsDirectional.fromSTEB(
                                        //           0, 10, 0, 10),
                                        //   child: Row(
                                        //     mainAxisSize: MainAxisSize.max,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment
                                        //             .spaceBetween,
                                        //     children: [
                                        //       Text(
                                        //         'Email',
                                        //         style: AppTheme.of(
                                        //                 context)
                                        //             .labelMedium
                                        //             .override(
                                        //               fontFamily:
                                        //                   'Readex Pro',
                                        //               fontWeight:
                                        //                   FontWeight.w600,
                                        //             ),
                                        //       ),
                                        //       Text(
                                        //         'AtiqRamzan.coom',
                                        //         style: AppTheme.of(
                                        //                 context)
                                        //             .labelMedium,
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // Padding(
                                        //   padding:
                                        //       EdgeInsetsDirectional.fromSTEB(
                                        //           0, 10, 0, 10),
                                        //   child: Row(
                                        //     mainAxisSize: MainAxisSize.max,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment
                                        //             .spaceBetween,
                                        //     children: [
                                        //       Text(
                                        //         'Address',
                                        //         style: AppTheme.of(
                                        //                 context)
                                        //             .labelMedium
                                        //             .override(
                                        //               fontFamily:
                                        //                   'Readex Pro',
                                        //               fontWeight:
                                        //                   FontWeight.w600,
                                        //             ),
                                        //       ),
                                        //       Text(
                                        //         'Lahore',
                                        //         style: AppTheme.of(
                                        //                 context)
                                        //             .labelMedium,
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // Divider(
                                        //   height: 32,
                                        //   thickness: 2,
                                        //   // color: context.appTheme.secondar,
                                        // ),
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Text(
                                            'Customer Details:',
                                            style:
                                                context.appTheme.titleLarge,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0,
                                                10,
                                                0,
                                                10,
                                              ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Name',
                                                style: context.appTheme.labelMedium.override(
                                                  fontFamily: 'Readex Pro',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                '${invoice.cName}',
                                                style: context.appTheme.labelMedium.override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize:
                                                      MediaQuery.sizeOf(
                                                        context,
                                                      ).width *
                                                      0.04,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0,
                                                10,
                                                0,
                                                10,
                                              ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Phone',
                                                style: context.appTheme.labelMedium.override(
                                                  fontFamily: 'Readex Pro',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                '${invoice.cPhone}',
                                                style: context.appTheme.labelMedium.override(
                                                  fontFamily: 'Readex Pro',
                                                  fontSize:
                                                      MediaQuery.sizeOf(
                                                        context,
                                                      ).width *
                                                      0.04,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0,
                                                10,
                                                0,
                                                10,
                                              ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Email',
                                                style: context.appTheme.labelMedium.override(
                                                  fontFamily: 'Readex Pro',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 30.0,
                                                  ),
                                                  child: Text(
                                                    '${invoice.cEmail}',
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: context.appTheme.labelMedium.override(
                                                      fontFamily: 'Readex Pro',
                                                      fontSize:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.04,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0,
                                                10,
                                                0,
                                                10,
                                              ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Address',
                                                style: context.appTheme.labelMedium.override(
                                                  fontFamily: 'Readex Pro',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        20,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                  child: Text(
                                                    invoice.cAddress ?? '',
                                                    style: context.appTheme.labelMedium.override(
                                                      fontFamily: 'Readex Pro',
                                                      fontSize:
                                                          MediaQuery.sizeOf(
                                                            context,
                                                          ).width *
                                                          0.04,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(height: 32, thickness: 2),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                0,
                                                12,
                                                0,
                                                0,
                                              ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      10,
                                                      0,
                                                      10,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Booking ID',
                                                      style: context.appTheme.labelMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        '${invoice.bookId}',
                                                        style: context.appTheme.labelMedium.override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          fontSize:
                                                              MediaQuery.sizeOf(
                                                                context,
                                                              ).width *
                                                              0.04,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      10,
                                                      0,
                                                      10,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional.fromSTEB(
                                                            0,
                                                            0,
                                                            10,
                                                            0,
                                                          ),
                                                      child: Icon(
                                                        Icons.arrow_circle_up,
                                                        color:
                                                            context.appTheme.primary,
                                                        size:
                                                            MediaQuery.sizeOf(
                                                              context,
                                                            ).width *
                                                            0.05,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${invoice.pickup}',
                                                        style: context.appTheme.labelMedium.override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      10,
                                                      0,
                                                      10,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional.fromSTEB(
                                                            0,
                                                            0,
                                                            10,
                                                            0,
                                                          ),
                                                      child: Icon(
                                                        Icons.arrow_circle_down,
                                                        color:
                                                            context.appTheme.primary,
                                                        size:
                                                            MediaQuery.sizeOf(
                                                              context,
                                                            ).width *
                                                            0.05,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${invoice.destination}',
                                                        style: context.appTheme.labelMedium.override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      10,
                                                      0,
                                                      10,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(
                                                      Icons.timer_sharp,
                                                      color:
                                                          context.appTheme.primary,
                                                      size:
                                                          MediaQuery.sizeOf(
                                                            context,
                                                          ).width *
                                                          0.05,
                                                    ),
                                                    Text(
                                                      '${invoice.pickTime}',
                                                      style:
                                                          context.appTheme.labelMedium,
                                                    ),
                                                    Icon(
                                                      Icons.date_range,
                                                      color:
                                                          context.appTheme.primary,
                                                      size:
                                                          MediaQuery.sizeOf(
                                                            context,
                                                          ).width *
                                                          0.05,
                                                    ),
                                                    Text(
                                                      '${invoice.pickDate}',
                                                      style:
                                                          context.appTheme.labelMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      10,
                                                      0,
                                                      10,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Journey Fare',
                                                      style: context.appTheme.labelMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      '£ ${invoice.journeyFare}',
                                                      style: context.appTheme.labelMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize:
                                                            MediaQuery.sizeOf(
                                                              context,
                                                            ).width *
                                                            0.04,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      10,
                                                      0,
                                                      10,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Car Parking',
                                                      style: context.appTheme.labelMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      '£ ${invoice.carParking}',
                                                      style: context.appTheme.labelMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize:
                                                            MediaQuery.sizeOf(
                                                              context,
                                                            ).width *
                                                            0.04,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      10,
                                                      0,
                                                      10,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Waiting',
                                                      style: context.appTheme.labelMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      '£ ${invoice.waiting}',
                                                      style: context.appTheme.labelMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize:
                                                            MediaQuery.sizeOf(
                                                              context,
                                                            ).width *
                                                            0.04,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      10,
                                                      0,
                                                      10,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Tolls',
                                                      style: context.appTheme.labelMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      '£ ${invoice.tolls}',
                                                      style: context.appTheme.labelMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize:
                                                            MediaQuery.sizeOf(
                                                              context,
                                                            ).width *
                                                            0.04,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      10,
                                                      0,
                                                      10,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Extra',
                                                      style: context.appTheme.labelMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      '£ ${invoice.extra}',
                                                      style: context.appTheme.labelMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize:
                                                            MediaQuery.sizeOf(
                                                              context,
                                                            ).width *
                                                            0.04,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(height: 32, thickness: 2),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      0,
                                                      0,
                                                      8,
                                                    ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional.fromSTEB(
                                                            0,
                                                            0,
                                                            0,
                                                            8,
                                                          ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          // Text(
                                                          //   'Company Charges',
                                                          //   style: AppTheme
                                                          //           .of(context)
                                                          //       .bodySmall
                                                          //       .override(
                                                          //         fontFamily:
                                                          //             'Outfit',
                                                          //         color: AppTheme.of(
                                                          //                 context)
                                                          //             .secondaryText,
                                                          //         fontSize:
                                                          //             14,
                                                          //         fontWeight:
                                                          //             FontWeight
                                                          //                 .w600,
                                                          //       ),
                                                          // ),
                                                          // Text(
                                                          //   '£156.00',
                                                          //   textAlign:
                                                          //       TextAlign.end,
                                                          //   style: AppTheme
                                                          //           .of(context)
                                                          //       .bodyLarge,
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional.fromSTEB(
                                                            0,
                                                            0,
                                                            0,
                                                            8,
                                                          ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Driver Commission',
                                                            style: context.appTheme.bodySmall.override(
                                                              fontFamily:
                                                                  'Outfit',
                                                              color:
                                                                  context.appTheme.secondaryText,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Text(
                                                            '20%',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: context.appTheme.labelMedium.override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize:
                                                                  MediaQuery.sizeOf(
                                                                    context,
                                                                  ).width *
                                                                  0.04,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional.fromSTEB(
                                                            0,
                                                            0,
                                                            0,
                                                            8,
                                                          ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Driver Amount',
                                                            style: context.appTheme.bodySmall.override(
                                                              fontFamily:
                                                                  'Outfit',
                                                              color:
                                                                  context.appTheme.secondaryText,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Text(
                                                            '£ ${invoice.driverCommission}',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: context.appTheme.labelMedium.override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize:
                                                                  MediaQuery.sizeOf(
                                                                    context,
                                                                  ).width *
                                                                  0.04,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional.fromSTEB(
                                                            0,
                                                            8,
                                                            0,
                                                            8,
                                                          ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Text(
                                                                'SubTotal',
                                                                style: context.appTheme.titleMedium.override(
                                                                  fontFamily:
                                                                      'Outfit',
                                                                  color:
                                                                      context.appTheme.secondaryText,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            '£ ${invoice.totalPay}',
                                                            style: context.appTheme.displaySmall.override(
                                                              fontFamily:
                                                                  'Outfit',
                                                              fontSize:
                                                                  MediaQuery.sizeOf(
                                                                    context,
                                                                  ).width *
                                                                  0.05,
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
                                  ),
                                );
                              },
                            ),
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
      ),
    );
  }
}
