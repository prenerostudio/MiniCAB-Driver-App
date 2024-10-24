import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_model.dart';
export 'login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginWidget extends StatefulWidget {
  bool? isFromHome;
  LoginWidget({super.key, this.isFromHome});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget>
    with TickerProviderStateMixin {
  late LoginModel _model;
  String? enteredPhoneNumber = '';
  String? varifyId = "";
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'textOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 100.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 400.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 100.ms,
          duration: 400.ms,
          begin: Offset(0, 40),
          end: Offset(0, 0),
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
          end: Offset(1, 1),
        ),
      ],
    ),
    'textOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 200.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 400.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 400.ms,
          begin: Offset(0, 40),
          end: Offset(0, 0),
        ),
        TiltEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 400.ms,
          begin: Offset(0.349, 0),
          end: Offset(0, 0),
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 400.ms,
          begin: Offset(0.9, 0.9),
          end: Offset(1, 1),
        ),
      ],
    ),
    'textFieldOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 300.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: Offset(0, 40),
          end: Offset(0, 0),
        ),
        TiltEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: Offset(0.349, 0),
          end: Offset(0, 0),
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: Offset(0.9, 0.9),
          end: Offset(1, 1),
        ),
      ],
    ),
    'textFieldOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 300.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: Offset(0, 40),
          end: Offset(0, 0),
        ),
        TiltEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: Offset(0.349, 0),
          end: Offset(0, 0),
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: Offset(0.9, 0.9),
          end: Offset(1, 1),
        ),
      ],
    ),
  };
  TextEditingController phoneController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());
    checkLocationPermissionAndNavigate(context);
    _model.phoneNumberController ??= TextEditingController();
    _model.phoneNumberFocusNode ??= FocusNode();

    _model.passwordController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> loginUser() async {
    if (PasswordController.text.length < 8) {
      _showToastMessage("Password must be at least 8 characters long.");
      return;
    }
    try {
      print('entire phopne +${countryCode}${phoneController.text}');
      final url =
          Uri.parse('https://www.minicaboffice.com/api/driver/signin.php');
      final request = http.MultipartRequest('POST', url);
      request.fields.addAll({
        'd_phone': '+${countryCode}${phoneController.text}',
        'd_password': '${PasswordController.text ?? ''}',
      });
      print(request.fields);
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        print('Response: $responseBody');
        if (jsonResponse['status'] == true) {
          if (jsonResponse.containsKey('data')) {
            final Map<String, dynamic> userData = jsonResponse['data']['user'];

            if (userData != null && userData.isNotEmpty) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('loginToken', jsonResponse['data']['token']);
              prefs.setBool('isLogin', true);
              userData.forEach((key, value) async {
                await prefs.setString(key, value?.toString() ?? '') ?? '';
                print('Saved $key: ${prefs.getString(key)}');
              });
            } else {
              print('Error: userData is null or empty');
            }
            context.pushNamed('Home');
            _showToastMessage("Login successful!");
          } else {}
        } else {
          _showToastMessage("Login failed. Please try again.");
          print(response.reasonPhrase);
        }
      } else {
        _showToastMessage("Login failed. Please try again.");
        print(response.reasonPhrase);
      }
    } catch (error) {
      _showToastMessage("Login failed. Please try again.");
      print('Error during login: $error');
    }
  }

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
    );
  }

  String countryCode = '';
  Future<void> checkLocationPermissionAndNavigate(BuildContext context) async {
    final permissionStatus = await Permission.location.request();
    final currentStatus = await Permission.location.status;
    print(currentStatus);
    if (permissionStatus.isDenied) {
      openAppSettings();
    } else {}
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
      child: WillPopScope(
        onWillPop: () async => false,
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
                Icons.arrow_back_rounded,
                color: FlutterFlowTheme.of(context).primary,
                size: 30,
              ),
              onPressed: () async {
                context.pushNamed('Welcome');
              },
            ),
            actions: [],
            centerTitle: false,
            elevation: 0,
          ),
          body: SafeArea(
            top: true,
            child: Align(
              alignment: AlignmentDirectional(0, -1),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxWidth: 770,
                ),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/app_launcher_icon.png',
                                    width: MediaQuery.sizeOf(context).width,
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.3,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Sign in as drivers',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineLarge,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                child: IntlPhoneField(
                                  controller: phoneController,
                                  focusNode: _model.phoneNumberFocusNode,
                                  obscureText: false,
                                  initialCountryCode: 'GB',
                                  onChanged: (phone) {
                                    setState(() {});
                                    enteredPhoneNumber =
                                        "${countryCode}${phone.completeNumber}" ??
                                            '';
                                    print("st code${enteredPhoneNumber}");
                                  },
                                  onCountryChanged: (country) {
                                    countryCode = country.dialCode;
                                    setState(() {});
                                    print('Country changedss to: ' +
                                        "${country.dialCode}");
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Mobile number',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          fontSize: 14,
                                        ),
                                    hintText: 'Enter Mobile Number',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                      ),
                                  keyboardType: TextInputType.phone,
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                ).animateOnPageLoad(animationsMap[
                                    'textFieldOnPageLoadAnimation1']!),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                child: TextFormField(
                                  controller: PasswordController,
                                  focusNode: _model.passwordFocusNode,
                                  obscureText: !_model.passwordVisibility,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          fontSize: 14,
                                        ),
                                    hintText: 'Enter Password',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () => setState(
                                        () => _model.passwordVisibility =
                                            !_model.passwordVisibility,
                                      ),
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Readex Pro',
                                      ),
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primary,
                                  validator: _model.passwordControllerValidator
                                      .asValidator(context),
                                ).animateOnPageLoad(animationsMap[
                                    'textFieldOnPageLoadAnimation2']!),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FFButtonWidget(
                              onPressed: () async {
                                loginUser();
                              },
                              text: 'Sign In',
                              options: FFButtonOptions(
                                height: 52,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    44, 0, 44, 0),
                                iconPadding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle:
                                    FlutterFlowTheme.of(context).titleMedium,
                                elevation: 3,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                hoverColor:
                                    FlutterFlowTheme.of(context).accent1,
                                hoverBorderSide: BorderSide(
                                  color: FlutterFlowTheme.of(context).primary,
                                  width: 1,
                                ),
                                hoverTextColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                hoverElevation: 0,
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
