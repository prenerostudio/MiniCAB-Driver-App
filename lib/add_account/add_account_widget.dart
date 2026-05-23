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
import 'add_account_model.dart';
import 'package:new_minicab_driver/Data/api_service.dart';
export 'add_account_model.dart';

class AddAccountWidget extends StatefulWidget {
  const AddAccountWidget({super.key});

  @override
  State<AddAccountWidget> createState() => _AddAccountWidgetState();
}

class _AddAccountWidgetState extends State<AddAccountWidget> {
  late AddAccountModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController sortCodeController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddAccountModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

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
            'ADD ACCOUNT',
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: nameController,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Bank Name',
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
                              validator: _model.textControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: numberController,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Account Number',
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
                              validator: _model.textControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: sortCodeController,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Sort Code',
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
                              validator: _model.textControllerValidator
                                  .asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              10,
                              15,
                              10,
                              15,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      if (nameController.text.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Bank Name field is empty",
                                          fontSize: 16.0,
                                        );
                                        return;
                                      } else if (numberController
                                          .text
                                          .isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Account Number field is empty",
                                          fontSize: 16.0,
                                        );
                                        return;
                                      } else if (sortCodeController
                                          .text
                                          .isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Sortcode field is empty",
                                          fontSize: 16.0,
                                        );
                                        return;
                                      }

                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      String? cId = prefs.getString('c_id');
                                      try {
                                        var request = http.MultipartRequest(
                                          'POST',
                                          Uri.parse(
                                            ApiService.driverAddBankAccount,
                                          ),
                                        );
                                        request.fields.addAll({
                                          'c_id': cId.toString(),
                                          'bank_name': nameController.text,
                                          'account_number': '$numberController',
                                          'sort_code': sortCodeController.text,
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
