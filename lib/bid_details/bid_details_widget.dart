import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'bid_details_model.dart';
export 'bid_details_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Model/bidDetails.dart';
import 'package:new_minicab_driver/Data/api_service.dart';

class BidDetailsWidget extends StatefulWidget {
  const BidDetailsWidget({super.key, required this.bidId});

  final String? bidId;

  @override
  _BidDetailsWidgetState createState() => _BidDetailsWidgetState();
}

class _BidDetailsWidgetState extends State<BidDetailsWidget> {
  late BidDetailsModel _model;

  ScrollController controller = ScrollController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BidDetailsModel());

    _model.emailAddressController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  TextEditingController emailAddressController = TextEditingController();

  Future bidNow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dId = prefs.getString('d_id');

    if (dId == null) {
      print('d_id not found in shared preferences.');
      return [];
    }

    String? bidId = widget.bidId;
    if (bidId == null) {
      print('not found in bidId.');
      return [];
    }
    print(bidId);
    String bidAmount = emailAddressController.text;

    if (bidAmount.isEmpty) {
      print('Bid amount is empty. Please enter a bid amount.');
      return;
    }

    try {
      final uri = Uri.parse(ApiService.driverBidNow);
      final response = await http.post(
        uri,
        body: {
          'book_id': bidId.toString(),
          'd_id': dId.toString(),
          'bid_amount': bidAmount,
        },
      );

      if (response.statusCode == 200) {
        print('Bid Now Submitted');
        context.pushNamed('Bids');
      } else {
        print('Error: ${response.reasonPhrase}');
        throw Exception(
          'Failed to load data. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in bidNow: $e');
      return [];
    }
  }

  Future<List<BidItem>> jobDetailsFuture() async {
    String? bidId = widget.bidId;
    print(bidId);
    final response = await http.post(
      Uri.parse(ApiService.driverBidDetails),
      body: {'book_id': bidId.toString()},
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      print(parsedResponse);
      if (parsedResponse['data'] is List) {
        return (parsedResponse['data'] as List)
            .map((item) => BidItem.fromJson(item))
            .toList();
      }
    }
    throw Exception('An error occurred while fetching job items.');
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
      onTap:
          () =>
              _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: context.appTheme.primaryBackground,
        appBar: AppBar(
          backgroundColor: context.appTheme.primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: context.appTheme.primary,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'bid Details',
            style: context.appTheme.headlineMedium.override(
              fontFamily: 'Outfit',
              color: context.appTheme.primary,
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
                Align(
                  alignment: AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 26),
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
                      child: FutureBuilder<List<BidItem>>(
                        future: jobDetailsFuture(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<List<BidItem>> snapshot,
                        ) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  context.appTheme.primary,
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No details available.'));
                          } else {
                            final jobDetails = snapshot.data;
                            return ListView.builder(
                              controller: controller,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: jobDetails!.length,
                              itemBuilder: (context, index) {
                                final BidItem = jobDetails[index];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    16,
                                    16,
                                    16,
                                    16,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                10,
                                                10,
                                                10,
                                                10,
                                              ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          8,
                                                          0,
                                                          0,
                                                          0,
                                                        ),
                                                    child: Text(
                                                      'Booking Id',
                                                      textAlign: TextAlign.end,
                                                      style:
                                                          context.appTheme.titleLarge,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          8,
                                                          0,
                                                          0,
                                                          0,
                                                        ),
                                                    child: Text(
                                                      '#${BidItem.bookId}',
                                                      textAlign: TextAlign.end,
                                                      style:
                                                          context.appTheme.labelMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                2,
                                                10,
                                                5,
                                                10,
                                              ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.clock,
                                                color:
                                                    context.appTheme.secondaryText,
                                                size:
                                                    MediaQuery.sizeOf(
                                                      context,
                                                    ).width *
                                                    0.04,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      5,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                child: Text(
                                                  '${BidItem.bookTime}',
                                                  style:
                                                      context.appTheme.labelMedium,
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              FaIcon(
                                                FontAwesomeIcons.calendar,
                                                color:
                                                    context.appTheme.secondaryText,
                                                size:
                                                    MediaQuery.sizeOf(
                                                      context,
                                                    ).width *
                                                    0.04,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      7,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                child: Text(
                                                  '${BidItem.bookDate}',
                                                  style:
                                                      context.appTheme.labelMedium,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      4,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                child: Text(
                                                  '| cash |',
                                                  style:
                                                      context.appTheme.labelMedium,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      4,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                child: Text(
                                                  BidItem.vName.toString(),
                                                  style:
                                                      context.appTheme.labelMedium,
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
                                                12,
                                              ),
                                          child: Container(
                                            width:
                                                MediaQuery.sizeOf(
                                                  context,
                                                ).width,
                                            decoration: BoxDecoration(
                                              color:
                                                  context.appTheme.secondaryBackground,
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Divider(
                                                    thickness: 1,
                                                    color: Color(0xCCC3C2C2),
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
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                    10.0,
                                                                    10.0,
                                                                    0.0,
                                                                    20.0,
                                                                  ),
                                                              child: Text(
                                                                '${BidItem.pickup}',
                                                                style: context.appTheme.labelMedium.override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  fontSize:
                                                                      MediaQuery.sizeOf(
                                                                        context,
                                                                      ).width *
                                                                      0.04,
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
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                    10.0,
                                                                    10.0,
                                                                    0.0,
                                                                    20.0,
                                                                  ),
                                                              child: Text(
                                                                '${BidItem.destination}',

                                                                style: context.appTheme.labelMedium.override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  fontSize:
                                                                      MediaQuery.sizeOf(
                                                                        context,
                                                                      ).width *
                                                                      0.04,
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
                                                    thickness: 1,
                                                    color: Color(0xCCC3C2C2),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          0.0,
                                                          10.0,
                                                          10.0,
                                                          10.0,
                                                        ),
                                                    child: Row(
                                                      // mainAxisSize:
                                                      //     MainAxisSize.max,
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          'Total fare: ${BidItem.journeyfare}',
                                                        ),
                                                        Spacer(),
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
                                                              EdgeInsetsDirectional.fromSTEB(
                                                                10.0,
                                                                0.0,
                                                                10.0,
                                                                0.0,
                                                              ),
                                                          child: Text(
                                                            '${BidItem.passenger}',
                                                            style: context.appTheme.labelMedium.override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              color:
                                                                  context.appTheme.secondaryText,
                                                              fontSize: 15.0,
                                                            ),
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.luggage,
                                                          color:
                                                              context.appTheme.primary,
                                                          size:
                                                              MediaQuery.sizeOf(
                                                                context,
                                                              ).width *
                                                              0.04,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional.fromSTEB(
                                                                10.0,
                                                                0.0,
                                                                10.0,
                                                                0.0,
                                                              ),
                                                          child: Text(
                                                            '${BidItem.luggage}',
                                                            style: context.appTheme.labelMedium.override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              color:
                                                                  context.appTheme.secondaryText,
                                                              fontSize: 15.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          10,
                                                          4,
                                                          10,
                                                          12,
                                                        ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Client Name',
                                                          style:
                                                              context.appTheme.titleLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        'Outfit',
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional.fromSTEB(
                                                                0,
                                                                5,
                                                                0,
                                                                0,
                                                              ),
                                                          child: Text(
                                                            '${BidItem.cName}',
                                                            style: context.appTheme.bodyMedium.override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                    color: Color(0xCCC3C2C2),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          10,
                                                          4,
                                                          10,
                                                          12,
                                                        ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Client Pic',
                                                          style:
                                                              context.appTheme.titleLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        'Outfit',
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                        ),
                                                        Container(
                                                          width: 80,
                                                          height: 80,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          decoration:
                                                              BoxDecoration(
                                                                shape:
                                                                    BoxShape
                                                                        .circle,
                                                              ),
                                                          child:
                                                              BidItem
                                                                      .cPic!
                                                                      .isNotEmpty
                                                                  ? Image.network(
                                                                    'https://minicab.com/img/customers/${BidItem.cPic}',
                                                                    fit:
                                                                        BoxFit
                                                                            .cover,
                                                                  )
                                                                  : Image.asset(
                                                                    'assets/images/user.png', // Replace with the actual path to your default asset image
                                                                    fit:
                                                                        BoxFit
                                                                            .cover,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                    color: Color(0xCCC3C2C2),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          10,
                                                          4,
                                                          10,
                                                          12,
                                                        ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'No. Of Passengers',
                                                          style:
                                                              context.appTheme.titleLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        'Outfit',
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional.fromSTEB(
                                                                0,
                                                                5,
                                                                0,
                                                                0,
                                                              ),
                                                          child: Text(
                                                            '${BidItem.passenger}',
                                                            style: context.appTheme.bodyMedium.override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                    color: Color(0xCCC3C2C2),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          10,
                                                          4,
                                                          10,
                                                          12,
                                                        ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Distance',
                                                          style:
                                                              context.appTheme.titleLarge
                                                                  .override(
                                                                    fontFamily:
                                                                        'Outfit',
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional.fromSTEB(
                                                                0,
                                                                5,
                                                                0,
                                                                0,
                                                              ),
                                                          child: Text(
                                                            '${BidItem.journeydistance} miles',
                                                            style: context.appTheme.bodyMedium.override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                    color: Color(0xCCC3C2C2),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                20,
                                                20,
                                                20,
                                                120,
                                              ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: TextFormField(
                                                    controller:
                                                        emailAddressController,
                                                    focusNode:
                                                        _model
                                                            .emailAddressFocusNode,
                                                    autofocus: true,
                                                    autofillHints: [
                                                      AutofillHints.name,
                                                    ],
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      labelText: '£00.00',
                                                      labelStyle:
                                                          context.appTheme.labelMedium,
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              context.appTheme.secondaryText,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              context.appTheme.primary,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color:
                                                              context.appTheme.error,
                                                          width: 2,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                                  context.appTheme.error,
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  20,
                                                                ),
                                                          ),
                                                      filled: true,
                                                      fillColor:
                                                          context.appTheme.secondaryBackground,
                                                      contentPadding:
                                                          EdgeInsetsDirectional.fromSTEB(
                                                            24,
                                                            24,
                                                            24,
                                                            24,
                                                          ),
                                                    ),
                                                    style:
                                                        context.appTheme.bodyMedium,
                                                    textAlign: TextAlign.start,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: _model
                                                        .emailAddressControllerValidator
                                                        .asValidator(context),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      20,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                child: FFButtonWidget(
                                                  onPressed: () async {
                                                    await bidNow();
                                                    Navigator.pop(context);
                                                    // context.pushNamed(
                                                    //     'BidsHistory');
                                                  },
                                                  text: 'Offer Price',
                                                  options: FFButtonOptions(
                                                    height: 50,
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          24,
                                                          0,
                                                          24,
                                                          0,
                                                        ),
                                                    iconPadding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          0,
                                                          0,
                                                          0,
                                                          0,
                                                        ),
                                                    color:
                                                        context.appTheme.primary,
                                                    textStyle:
                                                        context.appTheme.titleSmall.override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: Colors.white,
                                                        ),
                                                    elevation: 3,
                                                    borderSide: BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
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
      ),
    );
  }
}
