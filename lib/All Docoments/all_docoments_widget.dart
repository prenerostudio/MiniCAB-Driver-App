import 'package:get/get.dart';
import 'package:mini_cab/All%20Docoments/documents_view_upload.dart';
import 'package:mini_cab/All%20Docoments/widget/bottomSheetForDouble.dart';
import 'package:mini_cab/All%20Docoments/widget/bottom_sheet_widget.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'all_docoments_model.dart';
export 'all_docoments_model.dart';

class AllDocomentsWidget extends StatefulWidget {
  const AllDocomentsWidget({super.key});

  @override
  State<AllDocomentsWidget> createState() => _AllDocomentsWidgetState();
}

class _AllDocomentsWidgetState extends State<AllDocomentsWidget>
    with TickerProviderStateMixin {
  late AllDocomentsModel _model;
  File? selectedImage;
  File? selectedImageV;
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
    logBook();
    motCertificate();
    vPCO();
    vPicFornt();
    vPicBack();
    vRental();
    vRoad();
    vInsurance();
    insuranceSchedule();
    _model = createModel(context, () => AllDocomentsModel());

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

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
    );
  }

  Future<void> document(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.getImage(source: source);
      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> vDocument(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.getImage(source: source);
      if (pickedFile != null) {
        setState(() {
          selectedImageV = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 30,
            ),
            onPressed: () async {
              context.pushNamed('Home');
            },
          ),
          title: Text(
            'Documents',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Open Sans',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  fontSize: 22,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0, -1),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 1,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment(0, 0),
                              child: TabBar(
                                isScrollable: true,
                                labelColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                unselectedLabelColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                labelPadding: EdgeInsetsDirectional.fromSTEB(
                                    15, 0, 15, 0),
                                labelStyle:
                                    FlutterFlowTheme.of(context).titleMedium,
                                unselectedLabelStyle: TextStyle(),
                                indicatorColor:
                                    FlutterFlowTheme.of(context).primary,
                                indicatorWeight: 3,
                                tabs: [
                                  Tab(
                                    text: 'Driving License\n    Verification',
                                  ),
                                  Tab(
                                    text: '  Vehicle\nVerification',
                                  ),
                                ],
                                controller: _model.tabBarController,
                                onTap: (i) async {
                                  [() async {}, () async {}][i]();
                                },
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                controller: _model.tabBarController,
                                children: [
                                  // tap1
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 20, 10, 30),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Document Name',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                50, 0, 0, 0),
                                                    child: Text(
                                                      'Status',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 20, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Driving Licence Photo\nCard (Front)',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: Text(
                                                    '${Fornt == '' ? "Awaited\nUpload" : "Uploaded"}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          fontSize: 12.0,
                                                        ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DoubleDocumentBottomSheet(
                                                                fieldTitle:
                                                                    'License Number',
                                                                dateTitle:
                                                                    'License Expiry Date',
                                                                isfieldAvailable:
                                                                    true,
                                                                isDateAvaiabl:
                                                                    true,
                                                                numberParamter:
                                                                    'license_number',
                                                                dateParamter:
                                                                    'licence_exp',
                                                                parameter2:
                                                                    'dl_back',
                                                                name:
                                                                    'Driving Licence Photo Card (Front)',
                                                                name2:
                                                                    'Driving Licence Photo Card (Back)',
                                                                forInsideArray:
                                                                    'dl_front',
                                                                forInsideArray2:
                                                                    'dl_back',
                                                                getUrl:
                                                                    "https://www.minicaboffice.com/api/driver/check-driving-license.php",
                                                                parameter:
                                                                    "dl_front",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-driving-license.php",
                                                                showImageUrl:
                                                                    "https://www.minicaboffice.com/img/drivers/driving-license/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Driving Licence Photo Card (Front)',
                                                      //             forInsideArray:
                                                      //                 'd_license_front',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-d-license-front.php',
                                                      //             parameter:
                                                      //                 "dl_front",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-license-front.php",
                                                      //             showImageUrl:
                                                      //                 "https://www.minicaboffice.com/img/drivers/driving-license/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Padding(
                                          //   padding:
                                          //       EdgeInsetsDirectional.fromSTEB(
                                          //           0, 20, 0, 0),
                                          //   child: Row(
                                          //     mainAxisSize: MainAxisSize.max,
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment
                                          //             .spaceBetween,
                                          //     children: [
                                          //       Text(
                                          //         'Driving Licence Photo\nCard (Back)',
                                          //         style: FlutterFlowTheme.of(
                                          //                 context)
                                          //             .bodyMedium
                                          //             .override(
                                          //               fontFamily:
                                          //                   'Readex Pro',
                                          //               fontSize: 12.0,
                                          //             ),
                                          //       ),
                                          //       Text(
                                          //         '${Back == "" ? "Awaited\nUpload" : "Uploaded"}',
                                          //         style: FlutterFlowTheme.of(
                                          //                 context)
                                          //             .bodyMedium
                                          //             .override(
                                          //               fontFamily:
                                          //                   'Readex Pro',
                                          //               fontSize: 12.0,
                                          //             ),
                                          //       ),
                                          //       Padding(
                                          //         padding: EdgeInsetsDirectional
                                          //             .fromSTEB(0, 0, 0, 0),
                                          //         child: InkWell(
                                          //           onTap: () {
                                          //             showModalBottomSheet(
                                          //                 isScrollControlled:
                                          //                     true,
                                          //                 context: context,
                                          //                 builder: (context) {
                                          //                   return DocumentBottomSheet(
                                          //                       name:
                                          //                           'Driving Licence Photo Card (Back)',
                                          //                       forInsideArray:
                                          //                           "d_license_back",
                                          //                       getUrl:
                                          //                           'https://minicaboffice.com/api/driver/check-d-license-back.php',
                                          //                       parameter:
                                          //                           "dl_back",
                                          //                       postUrl:
                                          //                           "https://www.minicaboffice.com/api/driver/upload-license-back.php",
                                          //                       showImageUrl:
                                          //                           "https://www.minicaboffice.com/img/drivers/driving-license/");
                                          //                 });
                                          //             // Navigator.push(
                                          //             //     context,
                                          //             //     MaterialPageRoute(
                                          //             //         builder: (context) => DocumentsUploadView(
                                          //             //             name:
                                          //             //                 'Driving Licence Photo Card (Back)',
                                          //             //             forInsideArray:
                                          //             //                 "d_license_back",
                                          //             //             getUrl:
                                          //             //                 'https://minicaboffice.com/api/driver/check-d-license-back.php',
                                          //             //             parameter:
                                          //             //                 "dl_back",
                                          //             //             postUrl:
                                          //             //                 "https://www.minicaboffice.com/api/driver/upload-license-back.php",
                                          //             //             showImageUrl:
                                          //             //                 "https://www.minicaboffice.com/img/drivers/driving-license/")));
                                          //           },
                                          //           child: Text(
                                          //             'View Upload',
                                          //             style: FlutterFlowTheme
                                          //                     .of(context)
                                          //                 .bodyMedium
                                          //                 .override(
                                          //                     fontFamily:
                                          //                         'Readex Pro',
                                          //                     fontSize: 12.0,
                                          //                     color: FlutterFlowTheme
                                          //                             .of(context)
                                          //                         .primary),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),

                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 20, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Proof of Address',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Text(
                                                  '${AddressProof == '' ? "Awaited\nUpload" : "Uploaded"}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DoubleDocumentBottomSheet(
                                                                name2:
                                                                    'Proof of Address Two ',
                                                                forInsideArray2:
                                                                    'ap_2',
                                                                parameter2:
                                                                    'pa2',
                                                                name:
                                                                    'Proof of Address One ',
                                                                forInsideArray:
                                                                    'ap_1',
                                                                getUrl:
                                                                    "https://www.minicaboffice.com/api/driver/check-address-proof.php",
                                                                parameter:
                                                                    "pa1",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-address-proof.php",
                                                                showImageUrl:
                                                                    "https://minicaboffice.com/img/drivers/address-proof/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Proof of Address One ',
                                                      //             forInsideArray:
                                                      //                 'address_proof_1',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-address-proof-1.php',
                                                      //             parameter:
                                                      //                 "pa1",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-pa1.php",
                                                      //             showImageUrl:
                                                      //                 "https://minicaboffice.com/img/drivers/address-proof/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Padding(
                                          //   padding:
                                          //       EdgeInsetsDirectional.fromSTEB(
                                          //           0, 20, 0, 0),
                                          //   child: Row(
                                          //     mainAxisSize: MainAxisSize.max,
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment
                                          //             .spaceBetween,
                                          //     children: [
                                          //       Text(
                                          //         'Proof of Address Two ',
                                          //         style: FlutterFlowTheme.of(
                                          //                 context)
                                          //             .bodyMedium
                                          //             .override(
                                          //               fontFamily:
                                          //                   'Readex Pro',
                                          //               fontSize: 12.0,
                                          //             ),
                                          //       ),
                                          //       Text(
                                          //         '${AddressProofsec == '' ? "Awaited\nUpload" : "Uploaded"}',
                                          //         style: FlutterFlowTheme.of(
                                          //                 context)
                                          //             .bodyMedium
                                          //             .override(
                                          //               fontFamily:
                                          //                   'Readex Pro',
                                          //               fontSize: 12.0,
                                          //             ),
                                          //       ),
                                          //       Padding(
                                          //         padding: EdgeInsetsDirectional
                                          //             .fromSTEB(0, 0, 0, 0),
                                          //         child: InkWell(
                                          //           onTap: () {
                                          //             showModalBottomSheet(
                                          //                 isScrollControlled:
                                          //                     true,
                                          //                 context: context,
                                          //                 builder: (context) {
                                          //                   return DocumentBottomSheet(
                                          //                       name:
                                          //                           'Proof of Address Two ',
                                          //                       forInsideArray:
                                          //                           'address_proof_2',
                                          //                       getUrl:
                                          //                           'https://minicaboffice.com/api/driver/check-address-proof-2.php',
                                          //                       parameter:
                                          //                           "pa2",
                                          //                       postUrl:
                                          //                           "https://www.minicaboffice.com/api/driver/upload-pa2.php",
                                          //                       showImageUrl:
                                          //                           "https://minicaboffice.com/img/drivers/address-proof/");
                                          //                 });
                                          //             // Navigator.push(
                                          //             //     context,
                                          //             //     MaterialPageRoute(
                                          //             //         builder: (context) => DocumentsUploadView(
                                          //             //             name:
                                          //             //                 'Proof of Address Two ',
                                          //             //             forInsideArray:
                                          //             //                 'address_proof_2',
                                          //             //             getUrl:
                                          //             //                 'https://minicaboffice.com/api/driver/check-address-proof-2.php',
                                          //             //             parameter:
                                          //             //                 "pa2",
                                          //             //             postUrl:
                                          //             //                 "https://www.minicaboffice.com/api/driver/upload-pa2.php",
                                          //             //             showImageUrl:
                                          //             //                 "https://minicaboffice.com/img/drivers/address-proof/")));
                                          //           },
                                          //           child: Text(
                                          //             'View Upload',
                                          //             style: FlutterFlowTheme
                                          //                     .of(context)
                                          //                 .bodyMedium
                                          //                 .override(
                                          //                     fontFamily:
                                          //                         'Readex Pro',
                                          //                     fontSize: 12.0,
                                          //                     color: FlutterFlowTheme
                                          //                             .of(context)
                                          //                         .primary),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),

                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 20, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'PCO Licence               ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Text(
                                                  '${PCO == '' ? "Awaited\nUpload" : "Uploaded"}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DocumentBottomSheet(
                                                                fieldTitle:
                                                                    'PCO License Number',
                                                                dateTitle:
                                                                    'PCO License Expiry Date',
                                                                isDateAvaiabl:
                                                                    true,
                                                                isfieldAvailable:
                                                                    true,
                                                                dateParamter:
                                                                    'pl_exp',
                                                                numberParamter:
                                                                    'pl_number',
                                                                name:
                                                                    'PCO Licence ',
                                                                forInsideArray:
                                                                    'pl_img',
                                                                getUrl:
                                                                    'https://minicaboffice.com/api/driver/check-pco-license.php',
                                                                parameter:
                                                                    "pl_img",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-pco.php",
                                                                showImageUrl:
                                                                    "https://minicaboffice.com/img/drivers/pco-license/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'PCO Licence ',
                                                      //             forInsideArray:
                                                      //                 'pco_license',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-pco-license.php',
                                                      //             parameter:
                                                      //                 "pco",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-pco.php",
                                                      //             showImageUrl:
                                                      //                 "https://minicaboffice.com/img/drivers/pco-license/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 20, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'DVLA Check Code      ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Text(
                                                  '${DVLA == '' ? "Awaited\nUpload" : "Uploaded"}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DocumentBottomSheet(
                                                                fieldTitle:
                                                                    'DVLA Check Number',
                                                                isfieldAvailable:
                                                                    true,
                                                                numberParamter:
                                                                    'dvla_number',
                                                                name:
                                                                    'DVLA Check Code',
                                                                forInsideArray:
                                                                    'dvla_img',
                                                                getUrl:
                                                                    'https://minicaboffice.com/api/driver/check-dvla-code.php',
                                                                parameter:
                                                                    "dvla_img",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-dvla.php",
                                                                showImageUrl:
                                                                    "https://minicaboffice.com/img/drivers/dvla/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'DVLA Check Code',
                                                      //             forInsideArray:
                                                      //                 'dvla_check_code',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-dvla-code.php',
                                                      //             parameter:
                                                      //                 "dvla",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-dvla.php",
                                                      //             showImageUrl:
                                                      //                 "https://minicaboffice.com/img/drivers/dvla/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 20, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Proof of National        \n Insurance',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Text(
                                                  '${Insurance == '' ? "Awaited\nUpload" : "Uploaded"}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DocumentBottomSheet(
                                                                fieldTitle:
                                                                    'National Insurance Number',
                                                                isfieldAvailable:
                                                                    true,
                                                                numberParamter:
                                                                    'ni_number',
                                                                name:
                                                                    'Proof of National Insurance',
                                                                forInsideArray:
                                                                    'ni_img',
                                                                getUrl:
                                                                    'https://minicaboffice.com/api/driver/check-national-insurance.php',
                                                                parameter:
                                                                    "ni_img",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-ni.php",
                                                                showImageUrl:
                                                                    "https://minicaboffice.com/img/drivers/ni/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Proof of National Insurance',
                                                      //             forInsideArray:
                                                      //                 'national_insurance',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-national-insurance.php',
                                                      //             parameter:
                                                      //                 "ni",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-ni.php",
                                                      //             showImageUrl:
                                                      //                 "https://minicaboffice.com/img/drivers/ni/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Padding(
                                          //   padding:
                                          //       EdgeInsetsDirectional.fromSTEB(
                                          //           0, 20, 0, 0),
                                          //   child: Row(
                                          //     mainAxisSize: MainAxisSize.max,
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment
                                          //             .spaceBetween,
                                          //     children: [
                                          //       Text(
                                          //         'Extra                          ',
                                          //         style: FlutterFlowTheme.of(
                                          //                 context)
                                          //             .bodyMedium
                                          //             .override(
                                          //               fontFamily:
                                          //                   'Readex Pro',
                                          //               fontSize: 12.0,
                                          //             ),
                                          //       ),
                                          //       Text(
                                          //         '${Extra == '' ? "Awaited\nUpload" : "Uploaded"}',
                                          //         style: FlutterFlowTheme.of(
                                          //                 context)
                                          //             .bodyMedium
                                          //             .override(
                                          //               fontFamily:
                                          //                   'Readex Pro',
                                          //               fontSize: 12.0,
                                          //             ),
                                          //       ),
                                          //       Padding(
                                          //         padding: EdgeInsetsDirectional
                                          //             .fromSTEB(0, 0, 0, 0),
                                          //         child: InkWell(
                                          //           onTap: () {
                                          //             showModalBottomSheet(
                                          //                 isScrollControlled:
                                          //                     true,
                                          //                 context: context,
                                          //                 builder: (context) {
                                          //                   return DocumentBottomSheet(
                                          //                       name: 'Extra',
                                          //                       forInsideArray:
                                          //                           'extra',
                                          //                       getUrl:
                                          //                           'https://minicaboffice.com/api/driver/check-extra-document.php',
                                          //                       parameter:
                                          //                           "extra",
                                          //                       postUrl:
                                          //                           "https://www.minicaboffice.com/api/driver/upload-extra.php",
                                          //                       showImageUrl:
                                          //                           "https://minicaboffice.com/img/drivers/extra/");
                                          //                 });
                                          //             // Navigator.push(
                                          //             //     context,
                                          //             //     MaterialPageRoute(
                                          //             //         builder: (context) => DocumentsUploadView(
                                          //             //             name: 'Extra',
                                          //             //             forInsideArray:
                                          //             //                 'extra',
                                          //             //             getUrl:
                                          //             //                 'https://minicaboffice.com/api/driver/check-extra-document.php',
                                          //             //             parameter:
                                          //             //                 "extra",
                                          //             //             postUrl:
                                          //             //                 "https://www.minicaboffice.com/api/driver/upload-extra.php",
                                          //             //             showImageUrl:
                                          //             //                 "https://minicaboffice.com/img/drivers/extra/")));
                                          //           },
                                          //           child: Text(
                                          //             'View Upload',
                                          //             style: FlutterFlowTheme
                                          //                     .of(context)
                                          //                 .bodyMedium
                                          //                 .override(
                                          //                     fontFamily:
                                          //                         'Readex Pro',
                                          //                     fontSize: 12.0,
                                          //                     color: FlutterFlowTheme
                                          //                             .of(context)
                                          //                         .primary),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),

                                          // Row(
                                          //   mainAxisSize: MainAxisSize.max,
                                          //   children: [
                                          //     Expanded(
                                          //       child: Padding(
                                          //         padding: EdgeInsetsDirectional
                                          //             .fromSTEB(0, 20, 0, 0),
                                          //         child: FFButtonWidget(
                                          //           onPressed: () async {
                                          //             context
                                          //                 .pushNamed('Login');
                                          //           },
                                          //           text: 'Submit Application',
                                          //           options: FFButtonOptions(
                                          //             height: 40,
                                          //             padding:
                                          //                 EdgeInsetsDirectional
                                          //                     .fromSTEB(
                                          //                         24, 0, 24, 0),
                                          //             iconPadding:
                                          //                 EdgeInsetsDirectional
                                          //                     .fromSTEB(
                                          //                         0, 0, 0, 0),
                                          //             color:
                                          //                 FlutterFlowTheme.of(
                                          //                         context)
                                          //                     .primary,
                                          //             textStyle:
                                          //                 FlutterFlowTheme.of(
                                          //                         context)
                                          //                     .titleSmall
                                          //                     .override(
                                          //                       fontFamily:
                                          //                           'Readex Pro',
                                          //                       color: Colors
                                          //                           .white,
                                          //                     ),
                                          //             elevation: 3,
                                          //             borderSide: BorderSide(
                                          //               color:
                                          //                   Colors.transparent,
                                          //               width: 1,
                                          //             ),
                                          //             borderRadius:
                                          //                 BorderRadius.circular(
                                          //                     8),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // tap2
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10, 20, 10, 30),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 0, 0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Document Name',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                50, 0, 0, 0),
                                                    child: Text(
                                                      'Status',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 30, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Log Book                ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: Text(
                                                    '${LogBook == '' ? "Awaited\nUpload" : "Uploaded"}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          fontSize: 12.0,
                                                        ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DocumentBottomSheet(
                                                                numberParamter:
                                                                    'lb_number',
                                                                isfieldAvailable:
                                                                    true,
                                                                fieldTitle:
                                                                    'Log Book Number',
                                                                name:
                                                                    "Vehicle Log Book",
                                                                forInsideArray:
                                                                    'lb_img',
                                                                getUrl:
                                                                    'https://minicaboffice.com/api/driver/check-log-book.php',
                                                                parameter:
                                                                    "lb_img",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-log-book.php",
                                                                showImageUrl:
                                                                    "https://minicaboffice.com/img/drivers/vehicle/log-book/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 "Vehicle Log Book",
                                                      //             forInsideArray:
                                                      //                 'log_book',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-log-book.php',
                                                      //             parameter:
                                                      //                 "log_book",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-log-book.php",
                                                      //             showImageUrl:
                                                      //                 "https://minicaboffice.com/img/drivers/vehicle/log-book/")));
                                                      // context.pushNamed(
                                                      //     'VehicleLogBook');
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 30, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Mot Certificate      ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Text(
                                                  '${MotCertificate == "" ? "Awaited\nUpload" : "Uploaded"}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DocumentBottomSheet(
                                                                isfieldAvailable:
                                                                    true,
                                                                numberParamter:
                                                                    'mot_num',
                                                                dateParamter:
                                                                    'mot_expiry',
                                                                dateTitle:
                                                                    'MOT Certificate Expiry',
                                                                fieldTitle:
                                                                    'MOT Certificate Number',
                                                                isDateAvaiabl:
                                                                    true,
                                                                name:
                                                                    "Vehicle Mot Certificate",
                                                                forInsideArray:
                                                                    'mot_img',
                                                                getUrl:
                                                                    'https://minicaboffice.com/api/driver/check-mot-certificate.php',
                                                                parameter:
                                                                    "mot_img",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-mot.php",
                                                                showImageUrl:
                                                                    "https://minicaboffice.com/img/drivers/vehicle/mot-certificate/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 "Vehicle Mot Certificate",
                                                      //             forInsideArray:
                                                      //                 'mot_certificate',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-mot-certificate.php',
                                                      //             parameter:
                                                      //                 "mot",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-mot.php",
                                                      //             showImageUrl:
                                                      //                 "https://minicaboffice.com/img/drivers/vehicle/mot-certificate/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 30, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle PCO                       ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Text(
                                                  '${Vpco == '' ? "Awaited\nUpload" : "Uploaded"}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DocumentBottomSheet(
                                                                isfieldAvailable:
                                                                    true,
                                                                fieldTitle:
                                                                    'Vehicle PCO Number',
                                                                isDateAvaiabl:
                                                                    true,
                                                                dateTitle:
                                                                    'Vehicle PCO Expiry',
                                                                name:
                                                                    'Vehicle PCO',
                                                                forInsideArray:
                                                                    'vpco_img',
                                                                dateParamter:
                                                                    'vpco_exp',
                                                                numberParamter:
                                                                    "vpco_num",
                                                                getUrl:
                                                                    'https://www.minicaboffice.com/api/driver/check-pco.php',
                                                                parameter:
                                                                    "vpco_img",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-vpco.php",
                                                                showImageUrl:
                                                                    "https://minicaboffice.com/img/drivers/vehicle/pco/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Vehicle PCO',
                                                      //             forInsideArray:
                                                      //                 'pco_license',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-pco-license.php',
                                                      //             parameter:
                                                      //                 "vpco",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-vpco.php",
                                                      //             showImageUrl:
                                                      //                 "https://minicaboffice.com/img/drivers/vehicle/pco/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 30, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Picture        ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Text(
                                                  '${vFornt == '' ? "Awaited\nUpload" : "Uploaded"}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DoubleDocumentBottomSheet(
                                                                name2:
                                                                    'Vehicle Picture Back',
                                                                forInsideArray2:
                                                                    'vp_back',
                                                                parameter2:
                                                                    'pic2',
                                                                name:
                                                                    'Vehicle Picture Fornt',
                                                                forInsideArray:
                                                                    'vp_front',
                                                                getUrl:
                                                                    'https://www.minicaboffice.com/api/driver/check-pictures.php',
                                                                parameter:
                                                                    "pic1",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-vehicle-pictures.php",
                                                                showImageUrl:
                                                                    "https://minicaboffice.com/img/drivers/vehicle/picture/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Vehicle Picture Fornt',
                                                      //             forInsideArray:
                                                      //                 'vehicle_picture_front',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-v-pic-front.php',
                                                      //             parameter:
                                                      //                 "pic1",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-vehicle-picture-front.php",
                                                      //             showImageUrl:
                                                      //                 "https://minicaboffice.com/img/drivers/vehicle/picture/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Padding(
                                          //   padding:
                                          //       EdgeInsetsDirectional.fromSTEB(
                                          //           0, 30, 0, 0),
                                          //   child: Row(
                                          //     mainAxisSize: MainAxisSize.max,
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment
                                          //             .spaceBetween,
                                          //     children: [
                                          //       Text(
                                          //         'Vehicle Picture Back         ',
                                          //         style: FlutterFlowTheme.of(
                                          //                 context)
                                          //             .bodyMedium
                                          //             .override(
                                          //               fontFamily:
                                          //                   'Readex Pro',
                                          //               fontSize: 12.0,
                                          //             ),
                                          //       ),
                                          //       Text(
                                          //         '${vBack == '' ? "Awaited\nUpload" : "Uploaded"}',
                                          //         style: FlutterFlowTheme.of(
                                          //                 context)
                                          //             .bodyMedium
                                          //             .override(
                                          //               fontFamily:
                                          //                   'Readex Pro',
                                          //               fontSize: 12.0,
                                          //             ),
                                          //       ),
                                          //       Padding(
                                          //         padding: EdgeInsetsDirectional
                                          //             .fromSTEB(0, 0, 0, 0),
                                          //         child: InkWell(
                                          //           onTap: () {
                                          //             showModalBottomSheet(
                                          //                 isScrollControlled:
                                          //                     true,
                                          //                 context: context,
                                          //                 builder: (context) {
                                          //                   return DocumentBottomSheet(
                                          //                       name:
                                          //                           'Vehicle Picture Back',
                                          //                       forInsideArray:
                                          //                           'vehicle_picture_back',
                                          //                       getUrl:
                                          //                           'https://minicaboffice.com/api/driver/check-v-pic-back.php',
                                          //                       parameter:
                                          //                           "pic2",
                                          //                       postUrl:
                                          //                           "https://www.minicaboffice.com/api/driver/upload-vehicle-picture-back.php",
                                          //                       showImageUrl:
                                          //                           "https://minicaboffice.com/img/drivers/vehicle/picture/");
                                          //                 });
                                          //             // Navigator.push(
                                          //             //     context,
                                          //             //     MaterialPageRoute(
                                          //             //         builder: (context) => DocumentsUploadView(
                                          //             //             name:
                                          //             //                 'Vehicle Picture Back',
                                          //             //             forInsideArray:
                                          //             //                 'vehicle_picture_back',
                                          //             //             getUrl:
                                          //             //                 'https://minicaboffice.com/api/driver/check-v-pic-back.php',
                                          //             //             parameter:
                                          //             //                 "pic2",
                                          //             //             postUrl:
                                          //             //                 "https://www.minicaboffice.com/api/driver/upload-vehicle-picture-back.php",
                                          //             //             showImageUrl:
                                          //             //                 "https://minicaboffice.com/img/drivers/vehicle/picture/")));
                                          //           },
                                          //           child: Text(
                                          //             'View Upload',
                                          //             style: FlutterFlowTheme
                                          //                     .of(context)
                                          //                 .bodyMedium
                                          //                 .override(
                                          //                     fontFamily:
                                          //                         'Readex Pro',
                                          //                     fontSize: 12.0,
                                          //                     color: FlutterFlowTheme
                                          //                             .of(context)
                                          //                         .primary),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),

                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 30, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Road Tax              ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Text(
                                                  '${roadTax == '' ? "Awaited\nUpload" : "Uploaded"}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DocumentBottomSheet(
                                                                fieldTitle:
                                                                    'Road TAX Number',
                                                                dateTitle:
                                                                    'Road TAX Expiry',
                                                                isDateAvaiabl:
                                                                    true,
                                                                isfieldAvailable:
                                                                    true,
                                                                dateParamter:
                                                                    'rt_exp',
                                                                numberParamter:
                                                                    'rt_num',
                                                                name:
                                                                    'Vehicle Road Tax',
                                                                forInsideArray:
                                                                    'rt_img',
                                                                getUrl:
                                                                    'https://minicaboffice.com/api/driver/check-road-tax.php',
                                                                parameter:
                                                                    "rt_img",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-road-tax.php",
                                                                showImageUrl:
                                                                    "https://minicaboffice.com/img/drivers/vehicle/road-tax/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Vehicle Road Tax',
                                                      //             forInsideArray:
                                                      //                 'road_tax',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-road-tax.php',
                                                      //             parameter:
                                                      //                 "rt",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-road-tax.php",
                                                      //             showImageUrl:
                                                      //                 "https://minicaboffice.com/img/drivers/vehicle/road-tax/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 30, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Rental Agreement',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Text(
                                                  '${VRental == '' ? "Awaited\nUpload" : "Uploaded"}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DocumentBottomSheet(
                                                                fieldTitle:
                                                                    'Vehicle Rental Agreement Number',
                                                                dateTitle:
                                                                    'Vehicle Rental Agreement Expiry',
                                                                isDateAvaiabl:
                                                                    true,
                                                                isfieldAvailable:
                                                                    true,
                                                                dateParamter:
                                                                    'ra_exp',
                                                                numberParamter:
                                                                    'ra_num',
                                                                name:
                                                                    'Vehicle Rental Agreement',
                                                                forInsideArray:
                                                                    'ra_img',
                                                                getUrl:
                                                                    'https://minicaboffice.com/api/driver/check-rental-agreement.php',
                                                                parameter:
                                                                    "ra_img",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-rental-agreement.php",
                                                                showImageUrl:
                                                                    "https://minicaboffice.com/img/drivers/vehicle/rental-agreement/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Vehicle Rental Agreement',
                                                      //             forInsideArray:
                                                      //                 'rental_agreement',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-rental-agreement.php',
                                                      //             parameter:
                                                      //                 "ra",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-rental-agreement.php",
                                                      //             showImageUrl:
                                                      //                 "https://minicaboffice.com/img/drivers/vehicle/rental-agreement/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 30, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Insurance Schedule          ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Text(
                                                  '${InsuranceSchedule == '' ? "Awaited\nUpload" : "Uploaded"}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DocumentBottomSheet(
                                                                fieldTitle:
                                                                    'Insurance Schedule Number',
                                                                isfieldAvailable:
                                                                    true,
                                                                // dateParamter:
                                                                //     'is_img',
                                                                numberParamter:
                                                                    'is_num',
                                                                name:
                                                                    'Insurance Schedule',
                                                                forInsideArray:
                                                                    'is_img',
                                                                getUrl:
                                                                    'https://minicaboffice.com/api/driver/check-insurance-schedule.php',
                                                                parameter:
                                                                    "is_img",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-ins-sche.php",
                                                                showImageUrl:
                                                                    "https://minicaboffice.com/img/drivers/vehicle/insurance-schedule/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Insurance Schedule',
                                                      //             forInsideArray:
                                                      //                 'insurance_schedule',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-insurance-schedule.php',
                                                      //             parameter:
                                                      //                 "sche",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-ins-sche.php",
                                                      //             showImageUrl:
                                                      //                 "https://minicaboffice.com/img/drivers/vehicle/insurance-schedule/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 30, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Insurance            ',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Text(
                                                  '${VInsurance == '' ? "Awaited\nUpload" : "Uploaded"}',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder: (context) {
                                                            return DocumentBottomSheet(
                                                                fieldTitle:
                                                                    'Vehicle Insurance Number',
                                                                dateTitle:
                                                                    'Vehicle Insurance Expiry',
                                                                isDateAvaiabl:
                                                                    true,
                                                                isfieldAvailable:
                                                                    true,
                                                                dateParamter:
                                                                    'vi_exp',
                                                                numberParamter:
                                                                    'vi_num',
                                                                name:
                                                                    'Vehicle Insurance',
                                                                forInsideArray:
                                                                    'vi_img',
                                                                getUrl:
                                                                    'https://minicaboffice.com/api/driver/check-insurance.php',
                                                                parameter:
                                                                    "vi_img",
                                                                postUrl:
                                                                    "https://www.minicaboffice.com/api/driver/upload-insurance.php",
                                                                showImageUrl:
                                                                    "https://minicaboffice.com/img/drivers/vehicle/insurance/");
                                                          });
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Vehicle Insurance',
                                                      //             forInsideArray:
                                                      //                 'insurance',
                                                      //             getUrl:
                                                      //                 'https://minicaboffice.com/api/driver/check-insurance.php',
                                                      //             parameter:
                                                      //                 "ins",
                                                      //             postUrl:
                                                      //                 "https://www.minicaboffice.com/api/driver/upload-insurance.php",
                                                      //             showImageUrl:
                                                      //                 "https://minicaboffice.com/img/drivers/vehicle/insurance/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Readex Pro',
                                                              fontSize: 12.0,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Row(
                                          //   mainAxisSize: MainAxisSize.max,
                                          //   children: [
                                          //     Expanded(
                                          //       child: Padding(
                                          //         padding: EdgeInsetsDirectional
                                          //             .fromSTEB(0, 30, 0, 0),
                                          //         child: FFButtonWidget(
                                          //           onPressed: () async {
                                          //             context
                                          //                 .pushNamed('Login');
                                          //           },
                                          //           text: 'Submit Application',
                                          //           options: FFButtonOptions(
                                          //             height: 40,
                                          //             padding:
                                          //                 EdgeInsetsDirectional
                                          //                     .fromSTEB(
                                          //                         24, 0, 24, 0),
                                          //             iconPadding:
                                          //                 EdgeInsetsDirectional
                                          //                     .fromSTEB(
                                          //                         0, 0, 0, 0),
                                          //             color:
                                          //                 FlutterFlowTheme.of(
                                          //                         context)
                                          //                     .primary,
                                          //             textStyle:
                                          //                 FlutterFlowTheme.of(
                                          //                         context)
                                          //                     .titleSmall
                                          //                     .override(
                                          //                       fontFamily:
                                          //                           'Readex Pro',
                                          //                       color: Colors
                                          //                           .white,
                                          //                     ),
                                          //             elevation: 3,
                                          //             borderSide: BorderSide(
                                          //               color:
                                          //                   Colors.transparent,
                                          //               width: 1,
                                          //             ),
                                          //             borderRadius:
                                          //                 BorderRadius.circular(
                                          //                     8),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? Fornt;

  Future<String?> fornt() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-d-license-front.php'));
      request.fields.addAll({'d_id': dId});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          Fornt = jsonResponse['data'][0]['d_license_front'];
        });

        return Fornt;
      } else {
        debugPrint('Failed to load address proof: ${response.statusCode}');
        return null;
      }
    } catch (e) {}
  }

  String? Back;

  Future<String?> back() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-d-license-back.php'));
      request.fields.addAll({'d_id': dId});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          Back = jsonResponse['data'][0]['d_license_back'];
        });
        return Back;
      } else {
        debugPrint('Failed to load address proof: ${response.statusCode}');
        return null;
      }
    } catch (e) {}
  }

  String? AddressProof;
  Future<String?> addressProof() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-address-proof-1.php'));
      request.fields.addAll({'d_id': dId});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          AddressProof = jsonResponse['data'][0]['address_proof_1'] ?? '';
        });
        return AddressProof;
      } else {
        // Handle error response more gracefully
        debugPrint('Failed to load address proof: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Catch and handle exceptions
      debugPrint('Error occurred: $e');
      return null;
    }
  }

  String? AddressProofsec;

  Future<String?> addressProofSec() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-address-proof-2.php'));
      request.fields.addAll({'d_id': dId});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          AddressProofsec = jsonResponse['data'][0]['address_proof_2'];
        });
        return AddressProofsec;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
        return null;
      }
    } catch (e) {}
  }

  String? PCO;

  Future<String?> pco() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-pco-license.php'));
      request.fields.addAll({'d_id': dId});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          PCO = jsonResponse['data'][0]['pco_license'] ?? [];
        });
        return PCO;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  String? DVLA;

  Future<String?> dvla() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-dvla-code.php'));
      request.fields.addAll({'d_id': dId});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        print('the reponse is $jsonResponse');
        if (jsonResponse['message'] == 'No Record Found') {
        } else {
          setState(() {
            DVLA = jsonResponse['data'][0]['dvla_check_code'];
          });
        }

        return DVLA;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  String? Insurance;

  Future<String?> insurance() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-national-insurance.php'));
      request.fields.addAll({'d_id': dId});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          Insurance = jsonResponse['data'][0]['national_insurance'];
        });
        return Insurance;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  String? Extra;

  Future<String?> extra() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-extra-document.php'));
      request.fields.addAll({'d_id': dId});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          Extra = jsonResponse['data'][0]['extra'];
        });
        return Extra;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  // Vehicle Docments

  String? LogBook;

  Future<String?> logBook() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest('POST',
          Uri.parse('https://minicaboffice.com/api/driver/check-log-book.php'));
      request.fields.addAll({'d_id': dId});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          LogBook = jsonResponse['data'][0]['log_book'];
        });
        return LogBook;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  String? MotCertificate;

  Future<String?> motCertificate() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-mot-certificate.php'));
      request.fields.addAll({'d_id': dId});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          MotCertificate = jsonResponse['data'][0]['mot_certificate'];
        });
        return MotCertificate;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  String? Vpco;

  Future<String?> vPCO() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest('POST',
          Uri.parse('https://minicaboffice.com/api/driver/check-pco.php'));
      request.fields.addAll({'d_id': dId});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          Vpco = jsonResponse['data'][0]['pco'];
        });
        return Vpco;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  String? vFornt;

  Future<String?> vPicFornt() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-v-pic-front.php'));
      request.fields.addAll({'d_id': dId});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          vFornt = jsonResponse['data'][0]['vehicle_picture_front'];
        });
        return vFornt;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  String? vBack;

  Future<String?> vPicBack() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-v-pic-back.php'));
      request.fields.addAll({'d_id': dId});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          vBack = jsonResponse['data'][0]['vehicle_picture_back'];
        });
        return vBack;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  String? roadTax;

  Future<String?> vRoad() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest('POST',
          Uri.parse('https://minicaboffice.com/api/driver/check-road-tax.php'));
      request.fields.addAll({'d_id': dId});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          roadTax = jsonResponse['data'][0]['road_tax'];
        });
        return roadTax;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  String? VRental;

  Future<String?> vRental() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-rental-agreement.php'));
      request.fields.addAll({'d_id': dId});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          VRental = jsonResponse['data'][0]['rental_agreement'];
        });
        return VRental;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  String? InsuranceSchedule;

  Future<String?> insuranceSchedule() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-insurance-schedule.php'));
      request.fields.addAll({'d_id': dId});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          InsuranceSchedule = jsonResponse['data'][0]['insurance_schedule'];
        });
        return InsuranceSchedule;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }

  String? VInsurance;

  Future<String?> vInsurance() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://minicaboffice.com/api/driver/check-insurance.php'));
      request.fields.addAll({'d_id': dId});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          VInsurance = jsonResponse['data'][0]['insurance'];
        });
        return VInsurance;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
  }
}
