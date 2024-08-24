import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'edit_profile_model.dart';
export 'edit_profile_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Model/myProfile.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({Key? key}) : super(key: key);

  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late EditProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController dnameController = TextEditingController();
  TextEditingController demailController = TextEditingController();
  TextEditingController dphoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController licenceController = TextEditingController();
  TextEditingController licenceExpController = TextEditingController();
  TextEditingController pcoLicenceController = TextEditingController();
  TextEditingController pcoExpController = TextEditingController();
  TextEditingController skypeAcountController = TextEditingController();
  TextEditingController dRemarksController = TextEditingController();
  // String? dropDownValue2;
  // FormFieldController<String>? dropDownValueController2;

  @override
  void initState() {
    super.initState();
    getPreferencesData();
    _model = createModel(context, () => EditProfileModel());

    _model.yourNameController ??= TextEditingController();
    _model.yourNameFocusNode ??= FocusNode();

    _model.emailController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.phoneNumberController1 ??= TextEditingController();
    _model.phoneNumberFocusNode1 ??= FocusNode();

    _model.phoneNumberController2 ??= TextEditingController();
    _model.phoneNumberFocusNode2 ??= FocusNode();

    _model.postalCodeController ??= TextEditingController();
    _model.postalCodeFocusNode ??= FocusNode();

    _model.vatController ??= TextEditingController();
    _model.vatFocusNode ??= FocusNode();

    _model.companyNameController ??= TextEditingController();
    _model.companyNameFocusNode ??= FocusNode();

    _model.addressController1 ??= TextEditingController();
    _model.addressFocusNode1 ??= FocusNode();

    _model.addressController2 ??= TextEditingController();
    _model.addressFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    dnameController.dispose();
    demailController.dispose();
    dphoneController.dispose();
    addressController.dispose();
    licenceController.dispose();
    licenceExpController.dispose();
    pcoLicenceController.dispose();
    pcoExpController.dispose();
    skypeAcountController.dispose();
    dRemarksController.dispose();
    super.dispose();
  }

  String? Gender;
  String? lang;
  String? dId;
  String? dName;
  String? dEmail;
  String? dAddress;
  String? dPassword;
  String? dPhone;
  String? dPic;
  String? dGender;
  String? dLanguage;
  String? dLicence;
  String? dLicenceExp;
  String? pcoLicence;
  String? pcoExp;
  String? skypeAcount;
  String? dRemarks;
  String? postalCode;
  String? gender;
  String? language;
  String? authority;
  File? selectedImage;

  Future<void> getPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    dId = prefs.getString('d_id');
    dName = prefs.getString('d_name');
    dEmail = prefs.getString('d_email');
    dAddress = prefs.getString('d_address');
    dPassword = prefs.getString('d_password');
    dPhone = prefs.getString('d_phone');
    dPic = prefs.getString('d_pic');
    dGender = prefs.getString('d_gender');
    dLanguage = prefs.getString('d_language');
    dLicence = prefs.getString('d_licence');
    dLicenceExp = prefs.getString('d_licence_exp');
    pcoLicence = prefs.getString('pco_licence');
    pcoExp = prefs.getString('pco_exp');
    skypeAcount = prefs.getString('skype_acount');
    dRemarks = prefs.getString('d_remarks');
    postalCode = prefs.getString('d_post_code');
    gender = prefs.getString('d_gender');
    language = prefs.getString('d_language');
    authority = prefs.getString('licence_authority');
    print(dName);
    dnameController.text = dName ?? '';
    demailController.text = dEmail ?? '';
    dphoneController.text = dPhone ?? '';
    licenceController.text = dLicence ?? '';
    licenceExpController.text = dLicenceExp ?? '';
    pcoLicenceController.text = pcoLicence ?? '';
    pcoExpController.text = pcoExp ?? '';
    skypeAcountController.text = skypeAcount ?? '';
    dRemarksController.text = dRemarks ?? '';
    addressController.text = dAddress ?? '';
    licenceController.text = postalCode ?? '';
    _model.dropDownValueController1!.value = gender ?? '';
    _model.dropDownValueController2!.value = language ?? '';
    _model.dropDownValueController3!.value = authority ?? '';
    print('The address is ${_model.dropDownValueController3!.value}');

    // dRemarksController.text = dRemarks ?? '';
    setState(() {});
  }

  void _showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
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

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            actions: [],
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.00, 0.00),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.safePop();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 24.0,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.00, 0.00),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Update Profile',
                              style: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 22.0,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              expandedTitleScale: 1.0,
            ),
            elevation: 0.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 50.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Form(
                    key: _model.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 20.0, 0.0, 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _pickImage(ImageSource.gallery);
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE0E3E7),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.3,
                                      height: MediaQuery.sizeOf(context).width *
                                          0.3,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: selectedImage != null
                                          ? Image.file(
                                              selectedImage!,
                                              fit: BoxFit.cover,
                                            )
                                          : dPic != null
                                              ? Image.network(
                                                  'https://minicaboffice.com/img/drivers/$dPic',
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.asset(
                                                      'assets/images/user.png',
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                )
                                              : Image.asset(
                                                  'assets/images/user.png',
                                                  fit: BoxFit.cover,
                                                ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 20.0, 16.0),
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  // Restore the previous text
                                  dnameController.text =
                                      dEmail!; // You can use your specific condition here
                                  dnameController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: dnameController.text.length),
                                  );
                                }
                              },
                              controller: dnameController,
                              textCapitalization: TextCapitalization.words,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE0E3E7),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF4B39EF),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 24.0, 0.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context).labelMedium,
                              validator: _model.yourNameControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 20.0, 16.0),
                            child: TextFormField(
                              onChanged: (value) {
                                // Check if the field is empty
                                if (value.isEmpty) {
                                  // Restore the previous text
                                  demailController.text =
                                      dEmail!; // You can use your specific condition here
                                  demailController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: demailController.text.length),
                                  );
                                }
                              },
                              controller: demailController,
                              focusNode: _model.emailFocusNode,
                              textCapitalization: TextCapitalization.words,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE0E3E7),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 24.0, 0.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context).labelMedium,
                              validator: _model.emailControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 20.0, 16.0),
                            child: TextFormField(
                              controller: dphoneController,
                              focusNode: _model.phoneNumberFocusNode1,
                              textCapitalization: TextCapitalization.words,
                              obscureText: false,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Phone ',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE0E3E7),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 24.0, 0.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context).labelMedium,
                              validator: _model.phoneNumberController1Validator
                                  .asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 20.0, 16.0),
                            child: TextFormField(
                              controller: addressController,
                              textCapitalization: TextCapitalization.words,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Address',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE0E3E7),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF4B39EF),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 24.0, 0.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context).labelMedium,
                              validator: _model.yourNameControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.00, 0.00),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 0.0, 0.0, 16.0),
                              child: FlutterFlowDropDown<String>(
                                controller: _model.dropDownValueController1 ??=
                                    FormFieldController<String>(null),
                                options: ['Male', 'Female', 'Other'],
                                onChanged: (val) {
                                  setState(() {
                                    _model.dropDownValue1 =
                                        val; // Assuming you want to update some state in your model
                                    Gender = val;
                                    print(Gender);
                                  });
                                },
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                height: 50.0,
                                textStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                hintText: 'Select Gender',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                elevation: 2.0,
                                borderColor: Color(0x6AD6D6D6),
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.00, 0.00),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20.0, 0.0, 0.0, 16.0),
                              child: FlutterFlowDropDown<String>(
                                controller: _model.dropDownValueController2 ??=
                                    FormFieldController<String>(null),
                                options: [
                                  'English',
                                  'Urdu',
                                  'French',
                                  'Spanish',
                                  'German',
                                  'Portuguese',
                                  'Arabic',
                                  'Russian',
                                  'Japanese',
                                  'Italian',
                                  'Bengali',
                                  'Hindi',
                                  'Korean',
                                  'Greek',
                                  'Turkish',
                                  'Indonesian',
                                  'Danish',
                                  'Gujarati',
                                  'Finnish',
                                  'Dutch',
                                  'Tamil',
                                  'Hungarian',
                                  'Romanian',
                                  'Czech',
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    _model.dropDownValue2 =
                                        val; // Assuming you want to update some state in your model
                                    lang = val;
                                    print(
                                        lang); // Save the selected value in the lang variable
                                  });
                                },
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                height: 50.0,
                                textStyle:
                                    FlutterFlowTheme.of(context).labelMedium,
                                hintText: 'Select Language',
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 24.0,
                                ),
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                elevation: 2.0,
                                borderColor: Color(0x6AD6D6D6),
                                borderWidth: 2.0,
                                borderRadius: 8.0,
                                margin: EdgeInsetsDirectional.fromSTEB(
                                    16.0, 4.0, 16.0, 4.0),
                                hidesUnderline: true,
                                isSearchable: false,
                                isMultiSelect: false,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 0.0, 20.0, 16.0),
                            child: TextFormField(
                              controller: licenceController,
                              focusNode: _model.phoneNumberFocusNode2,
                              textCapitalization: TextCapitalization.words,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Postal Code',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE0E3E7),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).primary,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 24.0, 0.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context).labelMedium,
                              validator: _model.phoneNumberController2Validator
                                  .asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 20.0, 8.0, 0.0),
                            child: FlutterFlowDropDown<String>(
                              controller: _model.dropDownValueController3 ??=
                                  FormFieldController<String>(null),
                              options: [
                                'Ireland',
                                'London',
                                'The North East',
                                'North West',
                                'Yorkshire',
                                'East Midlands',
                                'West Midlands',
                                'South East',
                                'East of England',
                                'South West'
                              ],
                              onChanged: (val) {
                                setState(() {
                                  _model.dropDownValue3 = val;
                                  language = val;
                                  // print("Selected value: $dropDownValue2");
                                });
                              },
                              width: MediaQuery.sizeOf(context).width * 0.9,
                              height: 50.0,
                              textStyle:
                                  FlutterFlowTheme.of(context).labelMedium,
                              hintText: 'Select Authority',
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              elevation: 2.0,
                              borderColor: Color(0x6AD6D6D6),
                              borderWidth: 2.0,
                              borderRadius: 8.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 4.0, 16.0, 4.0),
                              hidesUnderline: true,
                              isSearchable: false,
                              isMultiSelect: false,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.00, 0.05),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 45.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? dId = prefs.getString('d_id');
                                  // print('objectssssssssssssssssssssss $dPic');
                                  if (selectedImage == null && dPic!.isEmpty) {
                                    _showToastMessage(
                                        'Please select an image.');
                                    return;
                                  }
                                  if (dnameController.text.isEmpty ||
                                      demailController.text.isEmpty) {
                                    _showToastMessage(
                                        'Please fill in all fields.');
                                    return;
                                  }
                                  if (_model.dropDownValue2 == null) {
                                    _showToastMessage(
                                        'Please select an Authority.');
                                    return;
                                  }

                                  try {
                                    var request = http.MultipartRequest(
                                      'POST',
                                      Uri.parse(
                                          'https://minicaboffice.com/api/driver/update-profile.php'),
                                    );
                                    request.fields.addAll({
                                      'd_id': dId.toString(),
                                      'dname': dnameController.text,
                                      'd_address': addressController.text,
                                      'demail': demailController.text,
                                      'dgender': '${Gender.toString()}',
                                      'dlang': '${lang.toString()}',
                                      'post_code': licenceController.text,
                                      'license_authority':
                                          '${_model.dropDownValue2}'
                                    });
                                    print(request.fields);

                                    if (selectedImage != null) {
                                      // If selectedImage is not null, upload it
                                      request.files.add(
                                        await http.MultipartFile.fromPath(
                                            'd_img', selectedImage!.path),
                                      );
                                    } else if (dPic != null &&
                                        dPic!.isNotEmpty) {
                                      // If dPic is not null and not empty, download the image and upload it
                                      var imageUrl =
                                          'https://minicaboffice.com/img/drivers/$dPic';
                                      var response =
                                          await http.get(Uri.parse(imageUrl));
                                      if (response.statusCode == 200) {
                                        request.files.add(
                                          http.MultipartFile.fromBytes(
                                            'd_img',
                                            response.bodyBytes,
                                            filename: dPic!.split('/').last,
                                          ),
                                        );
                                      } else {
                                        print('Failed to load image from URL.');
                                      }
                                    }

                                    // request.files.add(
                                    //   await http.MultipartFile.fromPath(
                                    //       'd_img',selectedImage!.path ),
                                    // );
                                    final response = await request.send();
                                    if (response.statusCode == 200) {
                                      print(await response.stream
                                          .bytesToString());
                                      _showToastMessage(
                                          'Profile updated successfully');
                                      context.pushNamed('Dashboard');
                                    } else {
                                      print(response.reasonPhrase);
                                      _showToastMessage(
                                          'Profile update failed. Please check your internet connection.');
                                    }
                                  } catch (error) {
                                    print('Error: $error');
                                    _showToastMessage('Please $error');
                                  }
                                },
                                text: 'Update Profile',
                                options: FFButtonOptions(
                                  width: 270.0,
                                  height: 50.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                  elevation: 2.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
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
      ),
    );
  }
}
