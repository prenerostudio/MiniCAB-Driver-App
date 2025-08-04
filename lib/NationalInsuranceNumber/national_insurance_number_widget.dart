import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'national_insurance_number_model.dart';
export 'national_insurance_number_model.dart';

class NationalInsuranceNumberWidget extends StatefulWidget {
  const NationalInsuranceNumberWidget({super.key});

  @override
  State<NationalInsuranceNumberWidget> createState() =>
      _NationalInsuranceNumberWidgetState();
}

class _NationalInsuranceNumberWidgetState
    extends State<NationalInsuranceNumberWidget> {
  late NationalInsuranceNumberModel _model;
  File? selectedImage;
  String? License;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchDLicense();
    _model = createModel(context, () => NationalInsuranceNumberModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
    );
  }

  Future<String?> fetchDLicense() async {
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
        License = jsonResponse['data'][0]['d_license_back'];
      });

      return License;
    } else {
      throw Exception('Failed to load d_license_back');
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.chevron_left_outlined,
              color: FlutterFlowTheme.of(context).secondaryText,
              size: 30,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'National Insurance Number',
                    style: FlutterFlowTheme.of(context).headlineMedium,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Select Image Source"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        child: Text("Gallery"),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          document(ImageSource.gallery);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        child: Text("Camera"),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          document(ImageSource.camera);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: selectedImage != null
                            ? Image.file(
                                selectedImage!,
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/pngwing.com.png',
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    fit: BoxFit.contain,
                                  );
                                },
                              )
                            : License != null
                                ? Image.network(
                                    'https://minicaboffice.com/img/drivers/driving-license/$License',
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/pngwing.com.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'assets/images/pngwing.com.png',
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/pngwing.com.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
                        child: FFButtonWidget(
                          onPressed: () async {
                            if (selectedImage == null) {
                              _showToastMessage("Please select an image.");
                              return;
                            }
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? dId = prefs.getString('d_id');
                            try {
                              var request = http.MultipartRequest(
                                  'POST',
                                  Uri.parse(
                                      'https://www.minicaboffice.com/api/driver/upload-ni.php'));
                              request.fields.addAll({
                                'd_id': dId.toString(),
                              });
                              request.files.add(
                                  await http.MultipartFile.fromPath(
                                      'ni', selectedImage!.path));
                              http.StreamedResponse response =
                                  await request.send();

                              if (response.statusCode == 200) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                bool? isLogin = prefs.getBool('isLogin');
                                if (isLogin == true) {
                                  await context.pushNamed('AllDocoments');
                                } else {
                                  await context.pushNamed('Documents');
                                }
                              } else {
                                print('Error: ${response.reasonPhrase}');
                              }
                            } catch (e) {
                              print('Error: $e');
                            }
                          },
                          text:
                              '${selectedImage != null ? 'Uploaded' : 'Awaiting Upload'}',
                          icon: Icon(
                            Icons.cloud_upload_outlined,
                            size: 12,
                          ),
                          options: FFButtonOptions(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            height: 50,
                            padding: EdgeInsets.all(0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Open Sans',
                                  color: Colors.white,
                                ),
                            elevation: 4,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
                        child: FFButtonWidget(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            bool isLogin = prefs.getBool('isLogin') ?? false;
                            if (isLogin == true) {
                              context.pushNamed('Home');
                            } else {
                              context.pushNamed('Login');
                            }
                          },
                          text: 'Skip',
                          options: FFButtonOptions(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            height: 50,
                            padding: EdgeInsets.all(0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).secondary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Open Sans',
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                            elevation: 4,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
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
