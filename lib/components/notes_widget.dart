import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notes_model.dart';
export 'notes_model.dart';

class NotesWidget extends StatefulWidget {
  const NotesWidget({
    Key? key,
    required this.dId,
    required this.jobId,
    required this.pickup,
    required this.dropoff,
    required this.cName,
    required this.note,
    required this.fare,
    required this.distance,
    required this.pickTime,
    required this.pickDate,
    required this.cnumber,
    required this.luggage,
    required this.cemail,
    required this.passenger,
  }) : super(key: key);

  final String? dId;
  final String? note;
  final String? jobId;
  final String? pickup;
  final String? dropoff;
  final String? cName;
  final String? fare;
  final String? distance;
  final String? pickTime;
  final String? pickDate;
  final String? passenger;
  final String? cnumber;
  final String? luggage;
  final String? cemail;

  @override
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  late NotesModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    print(widget.cName);
    _model = createModel(context, () => NotesModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 24.0),
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.65,
        width: MediaQuery.sizeOf(context).width * 1.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 3.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 1.0),
            )
          ],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(4.0, 4.0, 4.0, 4.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Client notes',
                        style: FlutterFlowTheme.of(context).displaySmall.override(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          widget.note!,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Open Sans',
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Account insttractions',
                        style: FlutterFlowTheme.of(context).displaySmall.override(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          '**DO NOT MAKE ANY EXTRA STOP\nOFFS** ADDITIONAL PASSENGER NOT AUTHORISED YOU WILL NOT BE PAID FOR THEM**\nAtoB journeys ONLY *NO MULTISTOPS* or Wait & Returns',
                          textAlign: TextAlign.justify,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Open Sans',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 30, 15, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Passenger',
                        style: FlutterFlowTheme.of(context).displaySmall.override(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          widget.cName!,
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Open Sans',
                                color: FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 16,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(
                        'onWay',
                        queryParameters: {
                          'did': serializeParam(
                            '${widget.dId}',
                            ParamType.String,
                          ),
                          'jobid': serializeParam(
                            '${widget.jobId}',
                            ParamType.String,
                          ),
                          'pickup': serializeParam(
                            '${widget.pickup}',
                            ParamType.String,
                          ),
                          'dropoff': serializeParam(
                            '${widget.dropoff}',
                            ParamType.String,
                          ),
                          'cName': serializeParam(
                            '${widget.cName}',
                            ParamType.String,
                          ),
                          'cnumber': serializeParam(
                            '${widget.cnumber}',
                            ParamType.String,
                          ),
                          'cemail': serializeParam(
                            '${widget.cemail}',
                            ParamType.String,
                          ),
                          'luggage': serializeParam(
                            '${widget.luggage}',
                            ParamType.String,
                          ),
                          'note': serializeParam(
                            '${widget.note}',
                            ParamType.String,
                          ),
                          'fare': serializeParam(
                            '${widget.fare}',
                            ParamType.String,
                          ),
                          'distance': serializeParam(
                            '${widget.distance}',
                            ParamType.String,
                          ),
            
                          'pickTime': serializeParam(
                            '${widget.pickTime}',
                            ParamType.String,
                          ),
                          'pickDate': serializeParam(
                            '${widget.pickDate}',
                            ParamType.String,
                          ),
                          'passenger': serializeParam(
                            '${widget.passenger}',
                            ParamType.String,
                          ),
                        }.withoutNulls,
                      );
                    },
                    text: 'ACKNOWLEDGE',
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width,
                      height: 50,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'Open Sans',
                            color: Colors.white,
                            fontSize: 18,
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
        ),
      ),
    );
  }
}
