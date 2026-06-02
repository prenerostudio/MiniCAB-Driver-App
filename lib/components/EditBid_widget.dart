import 'package:fluttertoast/fluttertoast.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'EditBid_model.dart';
import 'package:new_minicab_driver/Data/api_service.dart';
export 'edit_bid_model.dart';

class EditBidWidget extends StatefulWidget {
  const EditBidWidget({super.key, required this.dId, required this.bidId});

  final String? dId;
  final String? bidId;

  @override
  State<EditBidWidget> createState() => _EditBidWidgetState();
}

class _EditBidWidgetState extends State<EditBidWidget> {
  late EditBidModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  TextEditingController bidingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditBidModel());

    _model.bidingController ??= TextEditingController();
    _model.bidingFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
      child: Container(
        width: double.infinity,
        height: 400,
        decoration: BoxDecoration(
          color: context.appTheme.secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x25090F13),
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Container(
                      width: 60,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.appTheme.primaryBackground,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Bid',
                            style: context.appTheme.headlineSmall.override(
                              fontFamily: 'Outfit',
                              color: context.appTheme.primary,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                            child: Text(
                              'Please enter a bid amount.',
                              style: context.appTheme.labelMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                      child: FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30,
                        borderWidth: 1,
                        buttonSize: 44,
                        icon: Icon(
                          Icons.close,
                          color: context.appTheme.secondaryText,
                          size: 24,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24,
                thickness: 2,
                color: context.appTheme.primaryBackground,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: bidingController,
                          focusNode: _model.bidingFocusNode,
                          autofocus: true,
                          autofillHints: [AutofillHints.name],
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: '£00.00',
                            labelStyle:
                                context.appTheme.labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    context.appTheme.secondaryText,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: context.appTheme.primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: context.appTheme.error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: context.appTheme.error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor:
                                context.appTheme.secondaryBackground,
                            contentPadding: EdgeInsets.all(24),
                          ),
                          style: context.appTheme.bodyMedium,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.number,
                          validator: _model.bidingControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          try {
                            print(widget.bidId);
                            if (bidingController.text.isEmpty) {
                              Fluttertoast.showToast(
                                msg: "Please enter a bid amount.",
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              return;
                            }
                            var request = http.MultipartRequest(
                              'POST',
                              Uri.parse(ApiService.driverEditBid),
                            );
                            request.fields.addAll({
                              'bid_id': '${widget.bidId}',
                              'bid_amount': bidingController.text,
                            });
                            print(request.fields);
                            http.StreamedResponse response =
                                await request.send();
                            if (response.statusCode == 200) {
                              print(await response.stream.bytesToString());
                              Navigator.pop(context);
                            } else {
                              print(response.reasonPhrase);
                            }
                          } catch (error) {
                            print('Error: $error');
                          }
                        },

                        text: 'Bid Now',
                        options: FFButtonOptions(
                          height: 40,
                          padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                            0,
                            0,
                            0,
                            0,
                          ),
                          color: context.appTheme.primary,
                          textStyle: context.appTheme.titleSmall.override(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
