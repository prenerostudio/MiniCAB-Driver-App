import 'package:get/get.dart';
import 'package:new_minicab_driver/All%20Docoments/widget/bottomSheetForDouble.dart';
import 'package:new_minicab_driver/All%20Docoments/widget/bottom_sheet_widget.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
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
import 'package:new_minicab_driver/Data/api_service.dart';
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
    Fluttertoast.showToast(msg: message, textColor: Colors.white);
  }

  Future<void> document(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: source);
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
      final pickedFile = await picker.pickImage(source: source);
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
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: context.appTheme.secondaryText,
              size: 30,
            ),
            onPressed: () async {
              context.pushNamed('Home');
            },
          ),
          title: Text(
            'Documents',
            style: context.appTheme.headlineMedium.override(
              fontFamily: 'Open Sans',
              color: context.appTheme.secondaryText,
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
                          color: context.appTheme.primaryBackground,
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(
                            color:
                                context.appTheme.primaryBackground,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment(0, 0),
                              child: TabBar(
                                // isScrollable: true,
                                labelColor:
                                    context.appTheme.primaryText,
                                unselectedLabelColor:
                                    context.appTheme.secondaryText,
                                labelPadding: EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  0,
                                  0,
                                  0,
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                unselectedLabelStyle: TextStyle(),
                                indicatorColor:
                                    context.appTheme.primary,
                                indicatorWeight: 3,
                                tabs: [
                                  Tab(text: 'Driving License Verification'),
                                  Tab(text: '  Vehicle Verification'),
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
                                      10,
                                      20,
                                      10,
                                      30,
                                    ),
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
                                                  context.appTheme.secondaryText,
                                            ),
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    20,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Document Name',
                                                    style:
                                                        context.appTheme.titleMedium,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          50,
                                                          0,
                                                          0,
                                                          0,
                                                        ),
                                                    child: Text(
                                                      'Status',
                                                      style:
                                                          context.appTheme.titleMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  0,
                                                  20,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Driving Licence Photo\nCard (Front)',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  Fornt == ''
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                            isDateAvaiabl: true,
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
                                                                ApiService
                                                                    .driverCheckDrivingLicense,
                                                            parameter:
                                                                "dl_front",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadDrivingLicense,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/driving-license/",
                                                          );
                                                        },
                                                      );
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Driving Licence Photo Card (Front)',
                                                      //             forInsideArray:
                                                      //                 'd_license_front',
                                                      //             getUrl:
                                                      //                 ApiService.driverCheckDLicenseFront,
                                                      //             parameter:
                                                      //                 "dl_front",
                                                      //             postUrl:
                                                      //                 ApiService.driverUploadLicenseFront,
                                                      //             showImageUrl:
                                                      //                 "https://atiqramzan.online/img/drivers/driving-license/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
                                                      ),
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
                                          //         style: AppTheme.of(
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
                                          //         style: AppTheme.of(
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
                                          //                           ApiService.driverCheckDLicenseBack,
                                          //                       parameter:
                                          //                           "dl_back",
                                          //                       postUrl:
                                          //                           ApiService.driverUploadLicenseBack,
                                          //                       showImageUrl:
                                          //                           "https://atiqramzan.online/img/drivers/driving-license/");
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
                                          //             //                 ApiService.driverCheckDLicenseBack,
                                          //             //             parameter:
                                          //             //                 "dl_back",
                                          //             //             postUrl:
                                          //             //                 ApiService.driverUploadLicenseBack,
                                          //             //             showImageUrl:
                                          //             //                 "https://atiqramzan.online/img/drivers/driving-license/")));
                                          //           },
                                          //           child: Text(
                                          //             'View Upload',
                                          //             style: AppTheme
                                          //                     .of(context)
                                          //                 .bodyMedium
                                          //                 .override(
                                          //                     fontFamily:
                                          //                         'Readex Pro',
                                          //                     fontSize: 12.0,
                                          //                     color: AppTheme
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
                                                  0,
                                                  20,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Proof of Address         ',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  AddressProof == ''
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (context) {
                                                        return DoubleDocumentBottomSheet(
                                                          name2:
                                                              'Proof of Address Two ',
                                                          forInsideArray2:
                                                              'ap_2',
                                                          parameter2: 'pa2',
                                                          name:
                                                              'Proof of Address One ',
                                                          forInsideArray:
                                                              'ap_1',
                                                          getUrl:
                                                              ApiService
                                                                  .driverCheckAddressProof,
                                                          parameter: "pa1",
                                                          postUrl:
                                                              ApiService
                                                                  .driverUploadAddressProof,
                                                          showImageUrl:
                                                              "https://atiqramzan.online/img/drivers/address-proof/",
                                                        );
                                                      },
                                                    );
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) => DocumentsUploadView(
                                                    //             name:
                                                    //                 'Proof of Address One ',
                                                    //             forInsideArray:
                                                    //                 'address_proof_1',
                                                    //             getUrl:
                                                    //                 ApiService.driverCheckAddressProof1,
                                                    //             parameter:
                                                    //                 "pa1",
                                                    //             postUrl:
                                                    //                 ApiService.driverUploadPa1,
                                                    //             showImageUrl:
                                                    //                 "https://atiqramzan.online/img/drivers/address-proof/")));
                                                  },
                                                  child: Text(
                                                    'View Upload',
                                                    style: context.appTheme.bodyMedium.override(
                                                      fontFamily: 'Readex Pro',
                                                      fontSize: 12.0,
                                                      color:
                                                          context.appTheme.primary,
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
                                          //         style: AppTheme.of(
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
                                          //         style: AppTheme.of(
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
                                          //                           ApiService.driverCheckAddressProof2,
                                          //                       parameter:
                                          //                           "pa2",
                                          //                       postUrl:
                                          //                           ApiService.driverUploadPa2,
                                          //                       showImageUrl:
                                          //                           "https://atiqramzan.online/img/drivers/address-proof/");
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
                                          //             //                 ApiService.driverCheckAddressProof2,
                                          //             //             parameter:
                                          //             //                 "pa2",
                                          //             //             postUrl:
                                          //             //                 ApiService.driverUploadPa2,
                                          //             //             showImageUrl:
                                          //             //                 "https://atiqramzan.online/img/drivers/address-proof/")));
                                          //           },
                                          //           child: Text(
                                          //             'View Upload',
                                          //             style: AppTheme
                                          //                     .of(context)
                                          //                 .bodyMedium
                                          //                 .override(
                                          //                     fontFamily:
                                          //                         'Readex Pro',
                                          //                     fontSize: 12.0,
                                          //                     color: AppTheme
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
                                                  0,
                                                  20,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'PCO Licence               ',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  PCO == ''
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                            isDateAvaiabl: true,
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
                                                                ApiService
                                                                    .driverCheckPcoLicense,
                                                            parameter: "pl_img",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadPco,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/pco-license/",
                                                          );
                                                        },
                                                      );
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'PCO Licence ',
                                                      //             forInsideArray:
                                                      //                 'pco_license',
                                                      //             getUrl:
                                                      //                 ApiService.driverCheckPcoLicense,
                                                      //             parameter:
                                                      //                 "pco",
                                                      //             postUrl:
                                                      //                 ApiService.driverUploadPco,
                                                      //             showImageUrl:
                                                      //                 "https://atiqramzan.online/img/drivers/pco-license/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
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
                                                  20,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'DVLA Check Code      ',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  DVLA == ''
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                                ApiService
                                                                    .driverCheckDvlaCode,
                                                            parameter:
                                                                "dvla_img",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadDvla,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/dvla/",
                                                          );
                                                        },
                                                      );
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'DVLA Check Code',
                                                      //             forInsideArray:
                                                      //                 'dvla_check_code',
                                                      //             getUrl:
                                                      //                 ApiService.driverCheckDvlaCode,
                                                      //             parameter:
                                                      //                 "dvla",
                                                      //             postUrl:
                                                      //                 ApiService.driverUploadDvla,
                                                      //             showImageUrl:
                                                      //                 "https://atiqramzan.online/img/drivers/dvla/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
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
                                                  20,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Proof of National        \n Insurance',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  Insurance == ''
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                                ApiService
                                                                    .driverCheckNationalInsurance,
                                                            parameter: "ni_img",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadNi,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/ni/",
                                                          );
                                                        },
                                                      );
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Proof of National Insurance',
                                                      //             forInsideArray:
                                                      //                 'national_insurance',
                                                      //             getUrl:
                                                      //                 ApiService.driverCheckNationalInsurance,
                                                      //             parameter:
                                                      //                 "ni",
                                                      //             postUrl:
                                                      //                 ApiService.driverUploadNi,
                                                      //             showImageUrl:
                                                      //                 "https://atiqramzan.online/img/drivers/ni/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
                                                      ),
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
                                          //         style: AppTheme.of(
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
                                          //         style: AppTheme.of(
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
                                          //                           ApiService.driverCheckExtraDocument,
                                          //                       parameter:
                                          //                           "extra",
                                          //                       postUrl:
                                          //                           ApiService.driverUploadExtra,
                                          //                       showImageUrl:
                                          //                           "https://atiqramzan.online/img/drivers/extra/");
                                          //                 });
                                          //             // Navigator.push(
                                          //             //     context,
                                          //             //     MaterialPageRoute(
                                          //             //         builder: (context) => DocumentsUploadView(
                                          //             //             name: 'Extra',
                                          //             //             forInsideArray:
                                          //             //                 'extra',
                                          //             //             getUrl:
                                          //             //                 ApiService.driverCheckExtraDocument,
                                          //             //             parameter:
                                          //             //                 "extra",
                                          //             //             postUrl:
                                          //             //                 ApiService.driverUploadExtra,
                                          //             //             showImageUrl:
                                          //             //                 "https://atiqramzan.online/img/drivers/extra/")));
                                          //           },
                                          //           child: Text(
                                          //             'View Upload',
                                          //             style: AppTheme
                                          //                     .of(context)
                                          //                 .bodyMedium
                                          //                 .override(
                                          //                     fontFamily:
                                          //                         'Readex Pro',
                                          //                     fontSize: 12.0,
                                          //                     color: AppTheme
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
                                          //                 AppTheme.of(
                                          //                         context)
                                          //                     .primary,
                                          //             textStyle:
                                          //                 AppTheme.of(
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
                                      10,
                                      20,
                                      10,
                                      30,
                                    ),
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
                                                  context.appTheme.secondaryText,
                                            ),
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    20,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Document Name',
                                                    style:
                                                        context.appTheme.titleMedium,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          50,
                                                          0,
                                                          0,
                                                          0,
                                                        ),
                                                    child: Text(
                                                      'Status',
                                                      style:
                                                          context.appTheme.titleMedium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  0,
                                                  30,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Log Book                ',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                  child: Text(
                                                    LogBook == ''
                                                        ? "Awaited\nUpload"
                                                        : "Uploaded",
                                                    style: context.appTheme.bodyMedium.override(
                                                      fontFamily: 'Readex Pro',
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                                ApiService
                                                                    .driverCheckLogBook,
                                                            parameter: "lb_img",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadLogBook,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/vehicle/log-book/",
                                                          );
                                                        },
                                                      );
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 "Vehicle Log Book",
                                                      //             forInsideArray:
                                                      //                 'log_book',
                                                      //             getUrl:
                                                      //                 ApiService.driverCheckLogBook,
                                                      //             parameter:
                                                      //                 "log_book",
                                                      //             postUrl:
                                                      //                 ApiService.driverUploadLogBook,
                                                      //             showImageUrl:
                                                      //                 "https://atiqramzan.online/img/drivers/vehicle/log-book/")));
                                                      // context.pushNamed(
                                                      //     'VehicleLogBook');
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
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
                                                  30,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Mot Certificate      ',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  MotCertificate == ""
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                            isDateAvaiabl: true,
                                                            name:
                                                                "Vehicle Mot Certificate",
                                                            forInsideArray:
                                                                'mot_img',
                                                            getUrl:
                                                                ApiService
                                                                    .driverCheckMotCertificate,
                                                            parameter:
                                                                "mot_img",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadMot,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/vehicle/mot-certificate/",
                                                          );
                                                        },
                                                      );
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 "Vehicle Mot Certificate",
                                                      //             forInsideArray:
                                                      //                 'mot_certificate',
                                                      //             getUrl:
                                                      //                 ApiService.driverCheckMotCertificate,
                                                      //             parameter:
                                                      //                 "mot",
                                                      //             postUrl:
                                                      //                 ApiService.driverUploadMot,
                                                      //             showImageUrl:
                                                      //                 "https://atiqramzan.online/img/drivers/vehicle/mot-certificate/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
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
                                                  30,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle PCO                       ',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  Vpco == ''
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                            isDateAvaiabl: true,
                                                            dateTitle:
                                                                'Vehicle PCO Expiry',
                                                            name: 'Vehicle PCO',
                                                            forInsideArray:
                                                                'vpco_img',
                                                            dateParamter:
                                                                'vpco_exp',
                                                            numberParamter:
                                                                "vpco_num",
                                                            getUrl:
                                                                ApiService
                                                                    .driverCheckPco,
                                                            parameter:
                                                                "vpco_img",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadVpco,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/vehicle/pco/",
                                                          );
                                                        },
                                                      );
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Vehicle PCO',
                                                      //             forInsideArray:
                                                      //                 'pco_license',
                                                      //             getUrl:
                                                      //                 ApiService.driverCheckPcoLicense,
                                                      //             parameter:
                                                      //                 "vpco",
                                                      //             postUrl:
                                                      //                 ApiService.driverUploadVpco,
                                                      //             showImageUrl:
                                                      //                 "https://atiqramzan.online/img/drivers/vehicle/pco/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
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
                                                  30,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Picture                 ',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  vFornt == ''
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                            parameter2: 'pic2',
                                                            name:
                                                                'Vehicle Picture Fornt',
                                                            forInsideArray:
                                                                'vp_front',
                                                            getUrl:
                                                                ApiService
                                                                    .driverCheckPictures,
                                                            parameter: "pic1",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadVehiclePictures,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/vehicle/picture/",
                                                          );
                                                        },
                                                      );
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Vehicle Picture Fornt',
                                                      //             forInsideArray:
                                                      //                 'vehicle_picture_front',
                                                      //             getUrl:
                                                      //                 ApiService.driverCheckVPicFront,
                                                      //             parameter:
                                                      //                 "pic1",
                                                      //             postUrl:
                                                      //                 ApiService.driverUploadVehiclePictureFront,
                                                      //             showImageUrl:
                                                      //                 "https://atiqramzan.online/img/drivers/vehicle/picture/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
                                                      ),
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
                                          //         style: AppTheme.of(
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
                                          //         style: AppTheme.of(
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
                                          //                           ApiService.driverCheckVPicBack,
                                          //                       parameter:
                                          //                           "pic2",
                                          //                       postUrl:
                                          //                           ApiService.driverUploadVehiclePictureBack,
                                          //                       showImageUrl:
                                          //                           "https://atiqramzan.online/img/drivers/vehicle/picture/");
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
                                          //             //                 ApiService.driverCheckVPicBack,
                                          //             //             parameter:
                                          //             //                 "pic2",
                                          //             //             postUrl:
                                          //             //                 ApiService.driverUploadVehiclePictureBack,
                                          //             //             showImageUrl:
                                          //             //                 "https://atiqramzan.online/img/drivers/vehicle/picture/")));
                                          //           },
                                          //           child: Text(
                                          //             'View Upload',
                                          //             style: AppTheme
                                          //                     .of(context)
                                          //                 .bodyMedium
                                          //                 .override(
                                          //                     fontFamily:
                                          //                         'Readex Pro',
                                          //                     fontSize: 12.0,
                                          //                     color: AppTheme
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
                                                  0,
                                                  30,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Road Tax              ',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  roadTax == ''
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                            isDateAvaiabl: true,
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
                                                                ApiService
                                                                    .driverCheckRoadTax,
                                                            parameter: "rt_img",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadRoadTax,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/vehicle/road-tax/",
                                                          );
                                                        },
                                                      );
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Vehicle Road Tax',
                                                      //             forInsideArray:
                                                      //                 'road_tax',
                                                      //             getUrl:
                                                      //                 ApiService.driverCheckRoadTax,
                                                      //             parameter:
                                                      //                 "rt",
                                                      //             postUrl:
                                                      //                 ApiService.driverUploadRoadTax,
                                                      //             showImageUrl:
                                                      //                 "https://atiqramzan.online/img/drivers/vehicle/road-tax/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
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
                                                  30,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Rental Agreement',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  VRental == ''
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                            isDateAvaiabl: true,
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
                                                                ApiService
                                                                    .driverCheckRentalAgreement,
                                                            parameter: "ra_img",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadRentalAgreement,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/vehicle/rental-agreement/",
                                                          );
                                                        },
                                                      );
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Vehicle Rental Agreement',
                                                      //             forInsideArray:
                                                      //                 'rental_agreement',
                                                      //             getUrl:
                                                      //                 ApiService.driverCheckRentalAgreement,
                                                      //             parameter:
                                                      //                 "ra",
                                                      //             postUrl:
                                                      //                 ApiService.driverUploadRentalAgreement,
                                                      //             showImageUrl:
                                                      //                 "https://atiqramzan.online/img/drivers/vehicle/rental-agreement/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
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
                                                  30,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Insurance Schedule          ',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  InsuranceSchedule == null
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                                ApiService
                                                                    .driverCheckInsuranceSchedule,
                                                            parameter: "is_img",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadInsSche,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/vehicle/insurance-schedule/",
                                                          );
                                                        },
                                                      );
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Insurance Schedule',
                                                      //             forInsideArray:
                                                      //                 'insurance_schedule',
                                                      //             getUrl:
                                                      //                 ApiService.driverCheckInsuranceSchedule,
                                                      //             parameter:
                                                      //                 "sche",
                                                      //             postUrl:
                                                      //                 ApiService.driverUploadInsSche,
                                                      //             showImageUrl:
                                                      //                 "https://atiqramzan.online/img/drivers/vehicle/insurance-schedule/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
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
                                                  30,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Insurance            ',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  VInsurance == ''
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                            isDateAvaiabl: true,
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
                                                                ApiService
                                                                    .driverCheckInsurance,
                                                            parameter: "vi_img",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadInsurance,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/vehicle/insurance/",
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
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
                                                  30,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Vehicle Extra            ',
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  VInsurance == ''
                                                      ? "Awaited\nUpload"
                                                      : "Uploaded",
                                                  style: context.appTheme.bodyMedium.override(
                                                    fontFamily: 'Readex Pro',
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
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
                                                            isDateAvaiabl: true,
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
                                                                ApiService
                                                                    .driverCheckInsurance,
                                                            parameter: "vi_img",
                                                            postUrl:
                                                                ApiService
                                                                    .driverUploadInsurance,
                                                            showImageUrl:
                                                                "https://atiqramzan.online/img/drivers/vehicle/insurance/",
                                                          );
                                                        },
                                                      );
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => DocumentsUploadView(
                                                      //             name:
                                                      //                 'Vehicle Insurance',
                                                      //             forInsideArray:
                                                      //                 'insurance',
                                                      //             getUrl:
                                                      //                 ApiService.driverCheckInsurance,
                                                      //             parameter:
                                                      //                 "ins",
                                                      //             postUrl:
                                                      //                 ApiService.driverUploadInsurance,
                                                      //             showImageUrl:
                                                      //                 "https://atiqramzan.online/img/drivers/vehicle/insurance/")));
                                                    },
                                                    child: Text(
                                                      'View Upload',
                                                      style: context.appTheme.bodyMedium.override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontSize: 12.0,
                                                        color:
                                                            context.appTheme.primary,
                                                      ),
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
                                          //                 AppTheme.of(
                                          //                         context)
                                          //                     .primary,
                                          //             textStyle:
                                          //                 AppTheme.of(
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
        Uri.parse(ApiService.driverCheckDLicenseFront),
      );
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
        print('vFornt  img is exception');
        debugPrint('Failed to load address proof: ${response.statusCode}');
        return null;
      }
    } catch (e) {}
    return null;
  }

  String? Back;

  Future<String?> back() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckDLicenseBack),
      );
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
    return null;
  }

  String? AddressProof;
  Future<String?> addressProof() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckAddressProof1),
      );
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
        Uri.parse(ApiService.driverCheckAddressProof2),
      );
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
    return null;
  }

  String? PCO;

  Future<String?> pco() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckPcoLicense),
      );
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
    return null;
  }

  String? DVLA;

  Future<String?> dvla() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckDvlaCode),
      );
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
    return null;
  }

  String? Insurance;

  Future<String?> insurance() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckNationalInsurance),
      );
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
    return null;
  }

  String? Extra;

  Future<String?> extra() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckExtraDocument),
      );
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
    return null;
  }

  // Vehicle Docments

  String? LogBook;

  Future<String?> logBook() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckLogBook),
      );
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
    return null;
  }

  String? MotCertificate;

  Future<String?> motCertificate() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckMotCertificate),
      );
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
    return null;
  }

  String? Vpco;

  Future<String?> vPCO() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckPco),
      );
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
    return null;
  }

  String? vFornt;

  Future<String?> vPicFornt() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckVPicFront),
      );
      request.fields.addAll({'d_id': dId});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          vFornt = jsonResponse['data'][0]['vehicle_picture_front'];
        });
        print('vFornt  img is ${jsonResponse['data']}');
        return vFornt;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
    return null;
  }

  String? vBack;

  Future<String?> vPicBack() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckVPicBack),
      );
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
    return null;
  }

  String? roadTax;

  Future<String?> vRoad() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckRoadTax),
      );
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
    return null;
  }

  String? VRental;

  Future<String?> vRental() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckRentalAgreement),
      );
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
    return null;
  }

  String? InsuranceSchedule;

  Future<String?> insuranceSchedule() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckInsuranceSchedule),
      );
      request.fields.addAll({'d_id': dId});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseString);
        setState(() {
          InsuranceSchedule = jsonResponse['data'][0]['is_img'];
        });
        return InsuranceSchedule;
      } else {
        debugPrint('Failed to load : ${response.statusCode}');
      }
    } catch (e) {}
    return null;
  }

  String? VInsurance;

  Future<String?> vInsurance() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String dId = prefs.getString('d_id') ?? '';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverCheckInsurance),
      );
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
    return null;
  }
}
