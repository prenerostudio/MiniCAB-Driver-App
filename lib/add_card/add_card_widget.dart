import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'add_card_model.dart';
import 'package:new_minicab_driver/Data/api_service.dart';
export 'add_card_model.dart';

class AddcardWidget extends StatefulWidget {
  const AddcardWidget({super.key});

  @override
  State<AddcardWidget> createState() => _AddcardWidgetState();
}

class _AddcardWidgetState extends State<AddcardWidget> {
  late AddcardModel _model;
  TextEditingController usernameController = TextEditingController();
  TextEditingController NumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvcController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddcardModel());
  }

  @override
  void dispose() {
    _model.dispose();
    usernameController.dispose();
    NumberController.dispose();
    expiryController.dispose();
    cvcController.dispose();
    super.dispose();
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
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: context.appTheme.primary,
              size: 30,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'ADD NEW CARD',
            style: context.appTheme.headlineMedium.override(
              fontFamily: 'Open Sans',
              color: context.appTheme.primary,
              fontSize: 22,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'NO HIDDEN CHARGES. FULLY SECURE',
                        style: context.appTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 1,
                    decoration: BoxDecoration(
                      color: context.appTheme.primaryBackground,
                    ),
                    child: Form(
                      key: _model.formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextFormField(
                            controller: usernameController,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Card Holder Name',
                              labelStyle:
                                  context.appTheme.labelMedium,
                              hintStyle:
                                  context.appTheme.labelMedium,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      context.appTheme.secondaryText,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: context.appTheme.primary,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: context.appTheme.error,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: context.appTheme.error,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                15,
                                0,
                                15,
                                0,
                              ),
                            ),
                            style: context.appTheme.bodyMedium,
                            validator: _model.textController1Validator
                                .asValidator(context),
                          ),
                          TextFormField(
                            controller: NumberController,
                            autofocus: true,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Card Number',
                              labelStyle:
                                  context.appTheme.labelMedium,
                              hintStyle:
                                  context.appTheme.labelMedium,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      context.appTheme.secondaryText,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: context.appTheme.primary,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: context.appTheme.error,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: context.appTheme.error,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              contentPadding: EdgeInsetsDirectional.fromSTEB(
                                15,
                                0,
                                15,
                                0,
                              ),
                            ),
                            style: context.appTheme.bodyMedium,
                            validator: _model.textController2Validator
                                .asValidator(context),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: expiryController,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Expiry mm/yy',
                                    labelStyle:
                                        context.appTheme.labelMedium,
                                    hintStyle:
                                        context.appTheme.labelMedium,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            context.appTheme.secondaryText,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            context.appTheme.primary,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            context.appTheme.error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            context.appTheme.error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                          15,
                                          0,
                                          15,
                                          0,
                                        ),
                                  ),
                                  style:
                                      context.appTheme.bodyMedium,
                                  validator: _model.textController3Validator
                                      .asValidator(context),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: cvcController,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'CVV',
                                    labelStyle:
                                        context.appTheme.labelMedium,
                                    hintStyle:
                                        context.appTheme.labelMedium,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            context.appTheme.secondaryText,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            context.appTheme.primary,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            context.appTheme.error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            context.appTheme.error,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                          15,
                                          0,
                                          15,
                                          0,
                                        ),
                                  ),
                                  style:
                                      context.appTheme.bodyMedium,
                                  validator: _model.textController4Validator
                                      .asValidator(context),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              15,
                              0,
                              15,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      if (cvcController.text == null) {
                                    Fluttertoast.showToast(
                                      msg: "CVC field is empty",
                                      fontSize: 16.0,
                                    );
                                    return;
                                  }
                                      try {
                                        final prefs =
                                            await SharedPreferences.getInstance();
                                        String? cId = prefs.getString('c_id');
                                        var request = http.MultipartRequest(
                                          'POST',
                                          Uri.parse(ApiService.bookerAddCard),
                                        );
                                        request.fields.addAll({
                                          'c_id': cId.toString(),
                                          'card_name': usernameController.text,
                                          'card_num': NumberController.text,
                                          'expiry': expiryController.text,
                                          'cvv': cvcController.text,
                                        });
                                        print(request.fields);
                                        http.StreamedResponse response =
                                            await request.send();
                                        if (response.statusCode == 200) {
                                          print(
                                            await response.stream
                                                .bytesToString(),
                                          );
                                          context.pushNamed('Home');
                                        } else {
                                          print(response.reasonPhrase);
                                        }
                                      } catch (error) {
                                        print('Error: $error');
                                      }
                                    },
                                    text: 'DONE',
                                    options: FFButtonOptions(
                                      height: 50,
                                      padding: EdgeInsetsDirectional.fromSTEB(
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
                                      textStyle: context.appTheme.titleSmall.override(
                                        fontFamily: 'Open Sans',
                                        color:
                                            context.appTheme.info,
                                      ),
                                      elevation: 3,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(0),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
