import 'package:mini_cab/payment_entery/complete.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/jobDetails.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'payment_entery_model.dart';
export 'payment_entery_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentEnteryWidget extends StatefulWidget {
  const PaymentEnteryWidget({
    Key? key,
    required this.jobid,
    required this.did,
    required this.fare,
  }) : super(key: key);

  final String? jobid;
  final String? fare;
  final String? did;

  @override
  _PaymentEnteryWidgetState createState() => _PaymentEnteryWidgetState();
}

class _PaymentEnteryWidgetState extends State<PaymentEnteryWidget> {
  late PaymentEnteryModel _model;
  String? CarParking;
  String? Waiting;
  String? Tolls;
  String? Extra;

  TextEditingController journeyController = TextEditingController();
  TextEditingController extraWaitingController = TextEditingController();
  TextEditingController parkingController = TextEditingController();
  TextEditingController tollsController = TextEditingController();
  TextEditingController watingController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    jobDetailsFuture();
    getFares();
    pushercallbg();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _model = createModel(context, () => PaymentEnteryModel());
    extraWaitingController = TextEditingController(text: '${Extra ?? '0'}');
    parkingController = TextEditingController(text: '${CarParking ?? '0'}');
    tollsController = TextEditingController(text: '${Tolls ?? '0'}');
    watingController = TextEditingController(text: '${Waiting ?? '0'}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 4), () {
        setState(() {
          watingController?.text =
              '${Waiting ?? '0'}'; // Replace 'Waiting' with your actual value
        });
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 4), () {
        setState(() {
          tollsController?.text =
              '${Tolls ?? '0'}'; // Replace 'Waiting' with your actual value
        });
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 4), () {
        setState(() {
          parkingController?.text =
              '${CarParking ?? '0'}'; // Replace 'Waiting' with your actual value
        });
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 4), () {
        setState(() {
          extraWaitingController?.text =
              '${Extra ?? '0'}'; // Replace 'Waiting' with your actual value
        });
      });
    });
  }

  @override
  void dispose() {
    _model.dispose();
    extraWaitingController.dispose();
    parkingController.dispose();
    tollsController.dispose();
    watingController.dispose();
    super.dispose();
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
          CarParking = parsedResponse['data'][0]['car_parking'];
          Waiting = parsedResponse['data'][0]['waiting'];
          Tolls = parsedResponse['data'][0]['tolls'];
          Extra = parsedResponse['data'][0]['extra'];
          print(CarParking);
          print(Waiting);
          print(Tolls);
          print(Extra);
        }

        return (parsedResponse['data'] as List)
            .map((item) => Job.fromJson(item))
            .toList();
      }
    }

    // Return an empty list or handle the error in a way that fits your use case.
    return [];
  }

  int isExcapted = 0;
  pushercallbg() async {
    try {
      var pusher = PusherClient(
        '28691ac9c0c5ac41b64a',
        PusherOptions(
          host:
              'https://www.minicaboffice.com/api/driver/check-fare-status.php',
          cluster: 'ap2',
          encrypted: false,
        ),
      );
      pusher.connect();

      var channel = pusher.subscribe('jobs-channel');

      // Listen for new events
      channel.bind('fare-approved', (event) {
        Map<String, dynamic> jsonMap = json.decode(event!.data!);
        print('the message is ${jsonMap['message']}');
        if (jsonMap['message'] == 'Fares have been approved by controller.') {
          isExcapted = 2;
          extraWaitingController.text = jsonMap['details']['extras'].toString();
          parkingController.text = jsonMap['details']['car_parking'].toString();
          tollsController.text = jsonMap['details']['tolls'].toString();
          watingController.text = jsonMap['details']['waiting'].toString();

          print('the message is ${jsonMap['total_fee']}');
          saveData(
              jsonMap['details']['journey_fare'].toString(),
              jsonMap['details']['car_parking'].toString(),
              jsonMap['details']['extras'].toString(),
              jsonMap['details']['waiting'].toString(),
              jsonMap['details']['tolls'].toString(),
              jsonMap['total_fee'].toString());
          setState(() {});
        }
      });
    } catch (e) {
      print('the exception is $e');
    }
  }

  saveData(String jfare, String carparking, String extra, String waiting,
      String tolls, String totalFee) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('journey_fare', jfare);
    await prefs.setString('car_parking', carparking);
    await prefs.setString('extra', extra);
    await prefs.setString('waiting', waiting);
    await prefs.setString('tolls', tolls);
    await prefs.setString('totalFee', totalFee);
    setState(() {});
  }
  // Future fetchFareData() async {
  //   try {
  //     final uri = Uri.parse(
  //         'https://www.minicaboffice.com/api/driver/check-fare-status.php');
  //     final response = await http.post(uri, body: {'fare_id': ' '});

  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       print(jsonResponse);
  //       isExcapted = 1;
  //       // setState(() {});
  //       final List<dynamic> data = jsonResponse['data'];
  //     } else {
  //       print('Error: ${response.reasonPhrase}');
  //       return [];
  //     }
  //   } catch (e) {
  //     print('the exception is $e');
  //     return [];
  //   }
  // }

  getFares() async {
    setState(() {});
    SharedPreferences sp = await SharedPreferences.getInstance();
    extraWaitingController.text = sp.getString('extra') ?? '0';
    parkingController.text = sp.getString('car_parking') ?? '0';
    tollsController.text = sp.getString('tolls') ?? '0';
    watingController.text = sp.getString('waiting') ?? '0';
    print("the waiting fare is ${extraWaitingController.text}");
  }

  Future<void> addFares() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? dId = prefs.getString('d_id');
      print(dId);
      print('d_id not found in shared preferences.${widget.jobid}');
      print('d_id not found in shared preferences.${dId}');
      print('d_id not found in shared preferences.${parkingController.text}');
      print('d_id not found in shared preferences.${tollsController.text}');
      print('d_id not found in shared preferences.${watingController.text}');

      if (dId == null) {}
      var request = http.MultipartRequest('POST',
          Uri.parse('https://www.minicaboffice.com/api/driver/add-fares.php'));
      request.fields.addAll({
        'job_id': '${widget.jobid}',
        'd_id': dId.toString(),
        'extra': extraWaitingController.text,
        'car_parking': parkingController.text,
        'tolls': tollsController.text,
        'journey_fare': '${widget.fare}',
        'waiting': watingController.text,
      });
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        // await fetchFareData();

        print('done');
      } else {
        print('Failed to add fares: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
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
    getFares();
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          body: SafeArea(
            top: true,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // TextButton(
                //     onPressed: () {
                //       getFares();
                //     },
                //     child: Text('data')),
                Expanded(
                  flex: 8,
                  child: Container(
                    width: 100.0,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    alignment: AlignmentDirectional(0.00, -1.00),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 140.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0),
                                topLeft: Radius.circular(0.0),
                                topRight: Radius.circular(0.0),
                              ),
                            ),
                            alignment: AlignmentDirectional(-1.00, 0.00),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.00, 0.00),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  32.0, 32.0, 32.0, 32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Enter Charges',
                                    style: FlutterFlowTheme.of(context)
                                        .displaySmall,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 24.0),
                                    child: Text(
                                      'Let\'s get filling out the form below.',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 16.0),
                                    child: Container(
                                      width: 370.0,
                                      child: TextFormField(
                                        controller: extraWaitingController,
                                        focusNode: _model.extraWaitingFocusNode,
                                        autofocus: true,
                                        autofillHints: [AutofillHints.email],
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Extra',
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Open Sans',
                                                    fontSize: 18,
                                                  ),
                                          hintText: 'Extra',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        keyboardType: TextInputType.phone,
                                        validator: _model
                                            .extraWaitingControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 16.0),
                                    child: Container(
                                      width: 370.0,
                                      child: TextFormField(
                                        controller: parkingController,
                                        autofocus: true,
                                        autofillHints: [AutofillHints.email],
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Parking',
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Open Sans',
                                                    fontSize: 18,
                                                  ),
                                          hintText: 'Parking',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        keyboardType: TextInputType.phone,
                                        validator: _model
                                            .parkingControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 16.0),
                                    child: Container(
                                      width: 370.0,
                                      child: TextFormField(
                                        controller: watingController,
                                        autofocus: true,
                                        autofillHints: [AutofillHints.email],
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Waiting',
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Open Sans',
                                                    fontSize: 18,
                                                  ),
                                          hintText: 'Waiting',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        keyboardType: TextInputType.phone,
                                        validator: _model
                                            .parkingControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 16.0),
                                    child: Container(
                                      width: 370.0,
                                      child: TextFormField(
                                        controller: tollsController,
                                        focusNode: _model.emailAddressFocusNode,
                                        autofocus: true,
                                        autofillHints: [AutofillHints.email],
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Tolls',
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .override(
                                                    fontFamily: 'Open Sans',
                                                    fontSize: 18,
                                                  ),
                                          hintText: 'Tolls',
                                          hintStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primary,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              width: 2,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium,
                                        keyboardType: TextInputType.phone,
                                        validator: _model
                                            .emailAddressControllerValidator
                                            .asValidator(context),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 16.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             CompleteWidget()));
                                        setState(() {});
                                        if (isExcapted == 2) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CompleteWidget()));
                                        } else {
                                          addFares();
                                          isExcapted = 1;
                                        }

                                        // context.pushNamed(
                                        //   'invoiecs',
                                        //   queryParameters: {
                                        //     'did': serializeParam(
                                        //       '${widget.did}',
                                        //       ParamType.String,
                                        //     ),
                                        //     'jobid': serializeParam(
                                        //       '${widget.jobid}',
                                        //       ParamType.String,
                                        //     ),
                                        //     'fare': serializeParam(
                                        //       '${widget.fare}',
                                        //       ParamType.String,
                                        //     ),
                                        //     'parking': serializeParam(
                                        //       '${parkingController.text}',
                                        //       ParamType.String,
                                        //     ),
                                        //     'waiting': serializeParam(
                                        //       '${extraWaitingController.text}',
                                        //       ParamType.String,
                                        //     ),
                                        //     'tolls': serializeParam(
                                        //       '${tollsController.text}',
                                        //       ParamType.String,
                                        //     ),
                                        //   }.withoutNulls,
                                        // );
                                      },
                                      text: isExcapted == 0
                                          ? 'Correct'
                                          : isExcapted == 1
                                              ? 'Waiting for approval'
                                              : 'Proceed to complete',
                                      options: FFButtonOptions(
                                        width: 370.0,
                                        height: 44.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: isExcapted == 0
                                            ? FlutterFlowTheme.of(context)
                                                .primary
                                            : isExcapted == 1
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                    .withOpacity(0.3)
                                                : FlutterFlowTheme.of(context)
                                                    .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color: Colors.white,
                                            ),
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
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
                if (responsiveVisibility(
                  context: context,
                  phone: false,
                  tablet: false,
                ))
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 16.0, 16.0, 16.0),
                      child: Container(
                        width: 100.0,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              'https://images.unsplash.com/photo-1514924013411-cbf25faa35bb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1380&q=80',
                            ),
                          ),
                          borderRadius: BorderRadius.circular(16.0),
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
