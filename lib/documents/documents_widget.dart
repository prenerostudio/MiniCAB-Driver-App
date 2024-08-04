

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'documents_model.dart';
export 'documents_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DocumentsWidget extends StatefulWidget {
  const DocumentsWidget({
    Key? key,}) : super(key: key);

  @override
  _DocumentsWidgetState createState() => _DocumentsWidgetState();
}

class _DocumentsWidgetState extends State<DocumentsWidget> {
  late DocumentsModel _model;


  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fornt();
    back();
    addressProof();
    addressProofSec();
    pco();
    insurance();
    dvla();
    extra();
    _model = createModel(context, () => DocumentsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  String? Fornt;

  Future<String?> fornt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dId = prefs.getString('d_id') ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://minicaboffice.com/api/driver/check-d-license-front.php'));
    request.fields.addAll({'d_id': dId});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseString);
      setState(() {
        Fornt = jsonResponse[''][0]['d_license_front'];
      });

      return Fornt;
    } else {
      throw Exception('Failed to load d_license_back');
    }
  }
 String? Back;

  Future<String?> back() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dId = prefs.getString('d_id') ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://minicaboffice.com/api/driver/check-d-license-back.php'));
    request.fields.addAll({'d_id': dId});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseString);
      setState(() {
        Back = jsonResponse[''][0]['d_license_back'];

      });
      return Back;
    } else {
      throw Exception('Failed to load d_license_back');
    }
  }
  String? AddressProof;

  Future<String?> addressProof() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dId = prefs.getString('d_id') ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://minicaboffice.com/api/driver/check-address-proof-1.php'));
    request.fields.addAll({'d_id': dId});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseString);
      setState(() {
        AddressProof = jsonResponse[''][0]['address_proof_1'];

      });
      return AddressProof;
    } else {
      throw Exception('Failed to load d_license_back');
    }
  }
  String? AddressProofsec;

  Future<String?> addressProofSec() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dId = prefs.getString('d_id') ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://minicaboffice.com/api/driver/check-address-proof-2.php'));
    request.fields.addAll({'d_id': dId});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseString);
      setState(() {
        AddressProofsec = jsonResponse[''][0]['address_proof_2'];
      });
      return AddressProofsec;
    } else {
      throw Exception('Failed to load d_license_back');
    }
  }

  String? PCO;

  Future<String?> pco() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dId = prefs.getString('d_id') ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://minicaboffice.com/api/driver/check-pco-license.php'));
    request.fields.addAll({'d_id': dId});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseString);
      setState(() {
        PCO = jsonResponse[''][0]['pco_license'];

      });
      return PCO;
    } else {
      throw Exception('Failed to load d_license_back');
    }
  }
  String? DVLA;

  Future<String?> dvla() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dId = prefs.getString('d_id') ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://minicaboffice.com/api/driver/check-dvla-code.php'));
    request.fields.addAll({'d_id': dId});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseString);
      setState(() {
        DVLA = jsonResponse[''][0]['dvla_check_code'];
      });
      return DVLA;
    } else {
      throw Exception('Failed to load d_license_back');
    }
  }
  String? Insurance;

  Future<String?> insurance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dId = prefs.getString('d_id') ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://minicaboffice.com/api/driver/check-national-insurance.php'));
    request.fields.addAll({'d_id': dId});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseString);
      setState(() {
        Insurance = jsonResponse[''][0]['national_insurance'];
      });
      return Insurance;
    } else {
      throw Exception('Failed to load d_license_back');
    }
  }
  String? Extra;

  Future<String?> extra() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dId = prefs.getString('d_id') ?? '';
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://minicaboffice.com/api/driver/check-extra-document.php'));
    request.fields.addAll({'d_id': dId});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(responseString);
      setState(() {
        Extra = jsonResponse[''][0]['extra'];
      });
      return Extra;
    } else {
      throw Exception('Failed to load d_license_back');
    }
  }



  void _showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
    );
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
          body: SafeArea(
            top: true,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Your Documents',
                              style: FlutterFlowTheme.of(context).titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 25),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              'Please Ensure the images you upload are correct and legible. Failure to do so may delay your application',
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Document Name',
                              style: FlutterFlowTheme.of(context).titleMedium,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(50, 0, 0, 0),
                              child: Text(
                                'Status',
                                style: FlutterFlowTheme.of(context).titleMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Driving Licence Photo\nCard (Front)',
                             style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 12.0,
                                        ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: Text(
                              '${Fornt == '' ? "Awaited\nUpload" : "Uploaded"}',
                               style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 12.0,
                                        ),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: InkWell(
                              onTap: () {
                                context.pushNamed('DrivingLicenceCardFornt');
                              },
                              child: Text(
                                'View Upload',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 12.0,
                                  color:  FlutterFlowTheme.of(context).primary
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Driving Licence Photo\nCard (Back)',
                             style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 12.0,
                                          ),
                          ),
                          Text(
                            '${Back == "" ? "Awaited\nUpload" : "Uploaded"}',
                             style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 12.0,
                                          ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: InkWell(
                              onTap: () {
                                context.pushNamed('DrivingLicenceCardBack');
                              },
                              child: Text(
                                'View Upload',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 12.0,
                                    color:  FlutterFlowTheme.of(context).primary
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Proof of Address\n One',
                             style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 12.0,
                                          ),
                          ),
                          Text(
                            '${AddressProof == '' ? "Awaited\nUpload" : "Uploaded"}',
                             style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 12.0,
                                          ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: InkWell(
                              onTap: () {
                                context.pushNamed('ProofofAddressOne');
                              },
                              child: Text(
                                'View Upload',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 12.0,
                                    color:  FlutterFlowTheme.of(context).primary
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Proof of Address\n Two',
                             style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 12.0,
                                          ),
                          ),
                          Text(
                            '${AddressProofsec == '' ? "Awaited\nUpload" : "Uploaded"}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                              fontFamily: 'Readex Pro',
                              fontSize: 12.0,
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: InkWell(
                              onTap: () {
                                context.pushNamed('ProofofAddressTwo');
                              },
                              child: Text(
                                'View Upload',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 12.0,
                                    color:  FlutterFlowTheme.of(context).primary
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PCO Licence',
                             style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 12.0,
                                          ),
                          ), Text(
                            '${PCO == '' ? "Awaited\nUpload" : "Uploaded"}',
                             style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 12.0,
                                          ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: InkWell(
                              onTap: () {
                                context.pushNamed('DriverPCOLicense');
                              },
                              child: Text(
                                'View Upload',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 12.0,
                                    color:  FlutterFlowTheme.of(context).primary
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'DVLA Check Code',
                             style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 12.0,
                                          ),
                          ),
                          Text(
                            '${DVLA == '' ? "Awaited\nUpload" : "Uploaded"}',
                             style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            fontSize: 12.0,
                                          ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: InkWell(
                              onTap: () {
                                context.pushNamed('DvlaCheckCode');
                              },
                              child: Text(
                                'View Upload',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 12.0,
                                    color:  FlutterFlowTheme.of(context).primary
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Proof of National\nInsurance',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                              fontFamily: 'Readex Pro',
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            '${Insurance == '' ? "Awaited\nUpload" : "Uploaded"}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                              fontFamily: 'Readex Pro',
                              fontSize: 12.0,
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: InkWell(
                              onTap: () {
                                context.pushNamed('NationalInsuranceNumber');
                              },
                              child: Text(
                                'View Upload',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 12.0,
                                    color:  FlutterFlowTheme.of(context).primary
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Extra',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                              fontFamily: 'Readex Pro',
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            '${Extra == '' ? "Awaited\nUpload" : "Uploaded"}',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                              fontFamily: 'Readex Pro',
                              fontSize: 12.0,
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            child: InkWell(
                              onTap: () {
                                context.pushNamed('ExtaOne');
                              },
                              child: Text(
                                'View Upload',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 12.0,
                                    color:  FlutterFlowTheme.of(context).primary
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed('Login');
                              },
                              text: 'Submit Application',
                              options: FFButtonOptions(
                                height: 40,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24, 0, 24, 0),
                                iconPadding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                    ),
                                elevation: 3,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
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
