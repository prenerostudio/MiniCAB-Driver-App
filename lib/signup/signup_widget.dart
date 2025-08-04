import 'package:new_minicab_driver/login/login_widget.dart';
import 'package:new_minicab_driver/otp/otp_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'signup_model.dart';
export 'signup_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({Key? key}) : super(key: key);

  @override
  _SignupWidgetState createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  // late SignupModel _model;
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  String? enteredPhoneNumber;
  String? varifyId = "";
  // bool isLoading = false;
  bool? checkboxValue;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    // _model = createModel(context, () => SignupModel());
    checkLocationPermissionAndNavigate(context);

    textController1 ??= TextEditingController();
    textFieldFocusNode ??= FocusNode();
    passwordController ??= TextEditingController();
    passwordFocusNode ??= FocusNode();
    phoneNumberController ??= TextEditingController();
    phoneNumberFocusNode ??= FocusNode();
  }

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordController;
  bool passwordVisibility = true;
  String? Function(BuildContext, String?)? passwordControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for PhoneNumber widget.
  FocusNode? phoneNumberFocusNode;
  TextEditingController? phoneNumberController;
  String? Function(BuildContext, String?)? phoneNumberControllerValidator;
  // State field(s) for DropDown widget.

  void _verifyPhoneNumber() async {
    print('the phone number is: +${countryCode}${phoneController.text}');
    setState(() {});
    isLoading = true;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+${countryCode}${phoneController.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval or instant verification
          await _auth.signInWithCredential(credential);
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => HomeScreen()),
          // );
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading = false;
          setState(() {});
          Fluttertoast.showToast(msg: e.message.toString(), fontSize: 16.0);
          print('Failed to verify phone number: ${e.message}');
          // Handle error
        },
        codeSent: (String verificationId, int? resendToken) {
          print('verificationId to verify phone number: ${verificationId}');
          print('resendToken to verify phone number: ${resendToken}');
          isLoading = false;
          setState(() {});
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => OtpWidget(
                    dropDownValue2: dropDownValue2,
                    name: nameController.text,
                    phoneNumber: "+${countryCode}${phoneController.text}",
                    varifyId: verificationId,
                    email: emailAddressController.text,
                    password: PasswordController.text,
                    licenseAuth: phoneNumberController.text,
                  ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle auto retrieval timeout
        },
      );
    } catch (e) {
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: e.toString(), fontSize: 16.0);
    }
  }

  Future<void> saveDataIdInSharedPreferences(String dataId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('d_id', dataId);
    print('Data ID saved in SharedPreferences: $dataId');
  }

  Future<void> registerUser(BuildContext context) async {
    isLoading = true;
    if (!mounted) return; // Check if the widget is still mounted
    setState(() {});

    try {
      print('the picked number +${countryCode}${phoneController.text}');
      print('${passwordController.text}');
      final response = await http.post(
        Uri.parse('https://www.minicaboffice.com/api/driver/register.php'),
        body: {
          'd_name':
              nameController.text ?? '', // Use default values or handle nulls
          'd_email': emailAddressController.text ?? '',

          'd_phone': "${enteredPhoneNumber}" ?? '',
          // 'd_phone': "+${countryCode}${phoneController.text}" ?? '',
          'd_password': PasswordController.text.toString() ?? '',
          'licence_authority': dropDownValue2 ?? '',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          int dataId = responseData['data'];
          print('The else condition is ${dataId}');
          await saveDataIdInSharedPreferences(dataId.toString());
          if (!mounted) return; // Check if the widget is still mounted

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginWidget()),
          );
          _showToastMessage(responseData['message']);
        } else {
          print('The else condition is ${responseData['message']}');
          isLoading = false;
          if (!mounted) return; // Check if the widget is still mounted
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginWidget()),
          );
          _showToastMessage(responseData['message']);
        }
      } else {
        isLoading = false;
        _showToastMessage("Check your internet connection. Please try again.");
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('The register exception ${e}');
      _showToastMessage(e.toString());
      isLoading = false;
    }
  }

  // @override
  // void dispose() {
  //   _model.dispose();

  //   super.dispose();
  // }

  void _showToastMessage(String message) {
    Fluttertoast.showToast(msg: message, textColor: Colors.white);
  }

  Future<void> checkLocationPermissionAndNavigate(BuildContext context) async {
    final permissionStatus = await Permission.location.request();
    final currentStatus = await Permission.location.status;
    print(currentStatus);
    if (permissionStatus.isDenied) {
      openAppSettings();
    } else {}
  }

  String countryCode = '';
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
      // onTap: () => _model.unfocusNode.canRequestFocus
      //     ? FocusScope.of(context).requestFocus(_model.unfocusNode)
      //     : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 50.0, 20.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/app_launcher_icon.png',
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Become a driver',
                            style: FlutterFlowTheme.of(context).headlineLarge,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        0.0,
                        25.0,
                        0.0,
                        0.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        child: Form(
                          key: formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0,
                                  0.0,
                                  8.0,
                                  15.0,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: nameController,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Full Name',
                                      labelStyle: FlutterFlowTheme.of(
                                        context,
                                      ).labelMedium.override(
                                        fontFamily: 'Open Sans',
                                        fontSize: 16,
                                      ),
                                      hintText: 'Enter full name...',
                                      hintStyle:
                                          FlutterFlowTheme.of(
                                            context,
                                          ).labelMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).alternate,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).primary,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).error,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).error,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                    keyboardType: TextInputType.name,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0,
                                  0.0,
                                  8.0,
                                  0.0,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: emailAddressController,
                                    focusNode: textFieldFocusNode,
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'Email Address',
                                      labelStyle: FlutterFlowTheme.of(
                                        context,
                                      ).labelMedium.override(
                                        fontFamily: 'Open Sans',
                                        fontSize: 16,
                                      ),
                                      hintText: 'Enter email address',
                                      hintStyle:
                                          FlutterFlowTheme.of(
                                            context,
                                          ).labelMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).alternate,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).primary,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).error,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).error,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: textController1Validator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  8,
                                  20,
                                  8,
                                  0,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: PasswordController,
                                    focusNode: passwordFocusNode,
                                    autofocus: true,
                                    autofillHints: [AutofillHints.password],
                                    obscureText: passwordVisibility,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: FlutterFlowTheme.of(
                                        context,
                                      ).labelMedium.override(
                                        fontFamily: 'Open Sans',
                                        fontSize: 14,
                                      ),
                                      hintText: 'Enter Password',
                                      hintStyle:
                                          FlutterFlowTheme.of(
                                            context,
                                          ).labelMedium,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).alternate,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).primary,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).error,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).error,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      suffixIcon: InkWell(
                                        onTap:
                                            () => setState(
                                              () =>
                                                  passwordVisibility =
                                                      !passwordVisibility,
                                            ),
                                        focusNode: FocusNode(
                                          skipTraversal: true,
                                        ),
                                        child: Icon(
                                          passwordVisibility
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: passwordControllerValidator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0,
                                        20.0,
                                        8.0,
                                        0.0,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        child: IntlPhoneField(
                                          controller: phoneController,
                                          focusNode: phoneNumberFocusNode,
                                          autofocus: true,
                                          obscureText: false,
                                          initialCountryCode: 'GB',
                                          onChanged: (phone) {
                                            enteredPhoneNumber =
                                                phone.completeNumber ?? '';
                                            print(enteredPhoneNumber);
                                          },
                                          onCountryChanged: (country) {
                                            setState(() {});
                                            countryCode = country.dialCode;
                                            print(
                                              'Country changed to: ' +
                                                  country.dialCode,
                                            );
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Mobile number',
                                            labelStyle: FlutterFlowTheme.of(
                                              context,
                                            ).labelMedium.override(
                                              fontFamily: 'Open Sans',
                                              fontSize: 14,
                                            ),
                                            hintText: 'Enter Mobile Number',
                                            hintStyle:
                                                FlutterFlowTheme.of(
                                                  context,
                                                ).labelMedium,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).alternate,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).primary,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).error,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).error,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                          ),
                                          keyboardType: TextInputType.phone,
                                          style:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0,
                                  20.0,
                                  8.0,
                                  0.0,
                                ),
                                child: FlutterFlowDropDown<String>(
                                  controller:
                                      dropDownValueController2 ??=
                                          FormFieldController<String>(null),
                                  options: [
                                    'London',
                                    'The North East',
                                    'North West',
                                    'Yorkshire',
                                    'East Midlands',
                                    'West Midlands',
                                    'South East',
                                    'East of England',
                                    'South West',
                                  ],
                                  onChanged: (val) {
                                    setState(() {
                                      dropDownValue2 = val;
                                      print("Selected value: $dropDownValue2");
                                    });
                                  },
                                  width: MediaQuery.sizeOf(context).width,
                                  textStyle:
                                      FlutterFlowTheme.of(context).bodyMedium,
                                  hintText: 'Select Authority',
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color:
                                        FlutterFlowTheme.of(
                                          context,
                                        ).secondaryText,
                                    size: 24.0,
                                  ),
                                  fillColor:
                                      FlutterFlowTheme.of(
                                        context,
                                      ).primaryBackground,
                                  elevation: 2.0,
                                  borderColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  borderWidth: 2.0,
                                  borderRadius: 8.0,
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0,
                                    4.0,
                                    16.0,
                                    4.0,
                                  ),
                                  hidesUnderline: true,
                                  isSearchable: false,
                                  isMultiSelect: false,
                                ),
                              ),
                              // Generated code for this Row Widget...
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  15,
                                  0,
                                  0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Theme(
                                      data: ThemeData(
                                        checkboxTheme: CheckboxThemeData(
                                          visualDensity: VisualDensity.compact,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        unselectedWidgetColor:
                                            FlutterFlowTheme.of(
                                              context,
                                            ).secondaryText,
                                      ),
                                      child: Checkbox(
                                        value: checkboxValue ??= false,
                                        onChanged: (newValue) async {
                                          setState(
                                            () => checkboxValue = newValue!,
                                          );
                                        },
                                        activeColor:
                                            FlutterFlowTheme.of(
                                              context,
                                            ).primary,
                                        checkColor:
                                            FlutterFlowTheme.of(context).info,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          8,
                                          0,
                                          0,
                                          0,
                                        ),
                                        child: Text(
                                          'By signing up, you agree to our Terms and Conditions and confirm that you have read and understood the Privacy Policy for Drivers applicable for your country of operation.',
                                          textAlign: TextAlign.justify,
                                          style: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.override(
                                            fontFamily: 'Open Sans',
                                            color:
                                                FlutterFlowTheme.of(
                                                  context,
                                                ).secondaryText,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      30.0,
                                      0.0,
                                      0.0,
                                    ),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        if (nameController.text.isEmpty) {
                                          _showToastMessage(
                                            'Please enter full name',
                                          );
                                          return;
                                        }
                                        if (!emailAddressController.text
                                            .contains("@")) {
                                          _showToastMessage(
                                            'Please enter a valid email address with "@"',
                                          );
                                          return;
                                        }
                                        if (phoneController.text.isEmpty ||
                                            emailAddressController
                                                .text
                                                .isEmpty) {
                                          _showToastMessage(
                                            'Please enter a phone number and an email address',
                                          );
                                          return;
                                        }

                                        if (PasswordController.text.length <
                                            8) {
                                          _showToastMessage(
                                            'Password must be at least 8 characters long',
                                          );
                                          return;
                                        }

                                        if (dropDownValue2 == null ||
                                            dropDownValue2!.isEmpty) {
                                          _showToastMessage(
                                            'Please select a value for licensing Authority',
                                          );
                                          return;
                                        }

                                        if (checkboxValue != true) {
                                          _showToastMessage(
                                            'Please fill the checkbox',
                                          );
                                          return;
                                        }
                                        try {
                                          registerUser(context);
                                        } catch (e) {}
                                      },
                                      text: 'Sign up as a Driver',
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        height: 52.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          44.0,
                                          0.0,
                                          44.0,
                                          0.0,
                                        ),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                              0.0,
                                              0.0,
                                              0.0,
                                              0.0,
                                            ),
                                        color:
                                            FlutterFlowTheme.of(
                                              context,
                                            ).primary,
                                        textStyle:
                                            FlutterFlowTheme.of(
                                              context,
                                            ).titleMedium,
                                        elevation: 3.0,
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                        hoverColor:
                                            FlutterFlowTheme.of(
                                              context,
                                            ).accent1,
                                        hoverBorderSide: BorderSide(
                                          color:
                                              FlutterFlowTheme.of(
                                                context,
                                              ).primary,
                                          width: 1.0,
                                        ),
                                        hoverTextColor:
                                            FlutterFlowTheme.of(
                                              context,
                                            ).primaryText,
                                        hoverElevation: 0.0,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        0.0,
                        24.0,
                        0.0,
                        64.0,
                      ),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed('Login');
                        },
                        child: RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account?',
                                style: TextStyle(),
                              ),
                              TextSpan(
                                text: ' Log In!',
                                style: FlutterFlowTheme.of(
                                  context,
                                ).bodyLarge.override(
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                            style: FlutterFlowTheme.of(context).labelLarge,
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
      ),
    );
  }

  bool isLoading = false;
}
