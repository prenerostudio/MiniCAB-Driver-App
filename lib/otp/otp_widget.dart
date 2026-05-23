import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_minicab_driver/login/login_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'otp_model.dart';
export 'otp_model.dart';
import 'package:new_minicab_driver/Data/api_service.dart';

class OtpWidget extends StatefulWidget {
  const OtpWidget({
    super.key,
    required this.phoneNumber,
    required this.varifyId,
    required this.email,
    required this.password,
    required this.name,
    required this.dropDownValue2,
    required this.licenseAuth,
  });

  final String? phoneNumber;
  final String? email;
  final String? password;
  final String? licenseAuth;
  final String? name;
  final String? dropDownValue2;
  final String? varifyId;

  @override
  _OtpWidgetState createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  // late OtpModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  void _showToastMessage(String message) {
    Fluttertoast.showToast(msg: message, textColor: Colors.white);
  }

  Future<void> registerUser(BuildContext context) async {
    if (!mounted) return; // Check if the widget is still mounted
    setState(() {});

    try {
      final response = await http.post(
        Uri.parse(ApiService.driverRegister),
        body: {
          'd_name': widget.name ?? '', // Use default values or handle nulls
          'd_email': widget.email ?? '',
          'd_phone': widget.phoneNumber ?? '',
          'd_password': widget.password ?? '',
          'licence_authority': widget.dropDownValue2 ?? '',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          int dataId = responseData['data'];
          print('The else condition is $dataId');
          await saveDataIdInSharedPreferences(dataId.toString());
          if (!mounted) return; // Check if the widget is still mounted

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginWidget()),
          );
          _showToastMessage(responseData['message']);
        } else {
          print('The else condition is ${responseData['message']}');
          ispressed = false;
          if (!mounted) return; // Check if the widget is still mounted
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginWidget()),
          );
          _showToastMessage(responseData['message']);
        }
      } else {
        ispressed = false;
        _showToastMessage("Check your internet connection. Please try again.");
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('The register exception $e');
      _showToastMessage(e.toString());
      ispressed = false;
    }
  }

  final animationsMap = {
    'textOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 100.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 400.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 400.ms,
          begin: Offset(0.0, 40.0),
          end: Offset(0.0, 0.0),
        ),
        TiltEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 400.ms,
          begin: Offset(0.349, 0),
          end: Offset(0, 0),
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 400.ms,
          begin: Offset(0.9, 0.9),
          end: Offset(1.0, 1.0),
        ),
      ],
    ),
  };
  Future<void> saveDataIdInSharedPreferences(String dataId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('d_id', dataId);
    print('Data ID saved in SharedPreferences: $dataId');
  }

  bool ispressed = false;
  @override
  void initState() {
    super.initState();
    // _model = createModel(context, () => OtpModel());
  }

  TextEditingController? pinCodeController;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  //  pinCodeController = TextEditingController();
  var code = "";
  @override
  Widget build(BuildContext context) {
    // if (isiOS) {
    //   SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(
    //       statusBarBrightness: Theme.of(context).brightness,
    //       systemStatusBarContrastEnforced: true,
    //     ),
    //   );
    // }

    return GestureDetector(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          // key: scaffoldKey,
          backgroundColor: context.appTheme.secondaryBackground,
          appBar: AppBar(
            backgroundColor: context.appTheme.secondaryBackground,
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
            actions: [],
            centerTitle: false,
            elevation: 0.0,
          ),
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Align(
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: 670.0),
                  decoration: BoxDecoration(
                    color: context.appTheme.secondaryBackground,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          24.0,
                          0.0,
                          24.0,
                          0.0,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  32.0,
                                  0.0,
                                  8.0,
                                ),
                                child: Text(
                                  'Verify Code',
                                  textAlign: TextAlign.start,
                                  style: context.appTheme.displayMedium,
                                ).animateOnPageLoad(
                                  animationsMap['textOnPageLoadAnimation']!,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  4.0,
                                  0.0,
                                  8.0,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'Enter the 6 digit code we sent to the number below: ',
                                        style: TextStyle(),
                                      ),
                                      TextSpan(
                                        text: valueOrDefault<String>(
                                          widget.phoneNumber,
                                          '--',
                                        ),
                                        style: TextStyle(
                                          color: context.appTheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                    style: context.appTheme.labelLarge.override(
                                      fontFamily: 'Readex Pro',
                                      lineHeight: 1.2,
                                    ),
                                  ),
                                  textScaler: TextScaler.linear(
                                    MediaQuery.of(context).textScaleFactor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0,
                                  16.0,
                                  0.0,
                                  0.0,
                                ),
                                child: PinCodeTextField(
                                  autoDisposeControllers: false,
                                  appContext: context,
                                  length: 6,
                                  textStyle: context.appTheme.bodyLarge,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  enableActiveFill: false,
                                  autoFocus: true,
                                  enablePinAutofill: true,
                                  errorTextSpace: 16.0,
                                  showCursor: true,
                                  cursorColor: context.appTheme.primary,
                                  obscureText: false,
                                  hintCharacter: '-',
                                  keyboardType: TextInputType.number,
                                  pinTheme: PinTheme(
                                    fieldHeight:
                                        MediaQuery.of(context).size.width *
                                        0.118,
                                    fieldWidth:
                                        MediaQuery.of(context).size.width *
                                        0.119,
                                    borderWidth: 1.0,
                                    borderRadius: BorderRadius.circular(7.0),
                                    shape: PinCodeFieldShape.box,
                                    activeColor: context.appTheme.primaryText,
                                    inactiveColor: context.appTheme.alternate,
                                    selectedColor: context.appTheme.primary,
                                    activeFillColor:
                                        context.appTheme.primaryText,
                                    inactiveFillColor:
                                        context.appTheme.alternate,
                                    selectedFillColor: context.appTheme.primary,
                                  ),
                                  controller: pinCodeController,
                                  onChanged: (value) {
                                    code = value;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: pinCodeControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          24.0,
                          12.0,
                          24.0,
                          16.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ispressed
                                ? CircularProgressIndicator()
                                : FFButtonWidget(
                                  onPressed: () async {
                                    if (code.trim().length != 6) {
                                      _showToastMessage(
                                        "Enter a valid 6 digit code.",
                                      );
                                      return;
                                    }
                                    setState(() => ispressed = true);
                                    await registerUser(context);
                                    if (mounted) {
                                      setState(() => ispressed = false);
                                    }
                                  },
                                  text: 'Verify Code',
                                  options: FFButtonOptions(
                                    height: 52.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      44.0,
                                      0.0,
                                      44.0,
                                      0.0,
                                    ),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      0.0,
                                      0.0,
                                      0.0,
                                    ),
                                    color: context.appTheme.primary,
                                    textStyle: context.appTheme.titleMedium,
                                    elevation: 3.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12.0),
                                    hoverColor: context.appTheme.accent1,
                                    hoverBorderSide: BorderSide(
                                      color: context.appTheme.primary,
                                      width: 1.0,
                                    ),
                                    hoverTextColor:
                                        context.appTheme.primaryText,
                                    hoverElevation: 0.0,
                                  ),
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
        ),
      ),
    );
  }
}
