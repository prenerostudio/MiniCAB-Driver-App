import '/components/clientnotes_widget.dart';
import '/components/dropoff_widget.dart';
import '/components/waydetails_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'onway_model.dart';
export 'onway_model.dart';

class OnwayWidget extends StatefulWidget {
  const OnwayWidget({
    super.key,
    required this.pickup,
    required this.dropoff,
    required this.dId,
    required this.bookId,
    required this.date,
    required this.time,
    required this.passanger,
    required this.cId,
    required this.cName,
    required this.cNotes,
    required this.cNumber,
    required this.fare,
  });

  final String? pickup;
  final String? dropoff;
  final String? dId;
  final String? bookId;
  final String? date;
  final String? time;
  final String? passanger;
  final String? cId;
  final String? cName;
  final String? cNotes;
  final String? cNumber;
  final String? fare;

  @override
  State<OnwayWidget> createState() => _OnwayWidgetState();
}

class _OnwayWidgetState extends State<OnwayWidget> {
  late OnwayModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnwayModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 1,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Opacity(
            opacity: 0.6,
            child: SizedBox(
              width: 30,
              child: Divider(
                height: 20,
                thickness: 2,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.person,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 24,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                          child: Text(
                            '36, Bohun Grove, BARNET',
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            'EN4 8UA',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Opacity(
                      opacity: 0.4,
                      child: SizedBox(
                        width: 240,
                        child: Divider(
                          height: 20,
                          thickness: 2,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: ClientnotesWidget(
                            name: '',
                            notes: '',
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'VIEW NOTE',
                  icon: FaIcon(
                    FontAwesomeIcons.infoCircle,
                    size: 21,
                  ),
                  options: FFButtonOptions(
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    height: 45,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Open Sans',
                          color: Colors.white,
                        ),
                    elevation: 3,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlutterFlowIconButton(
                  borderColor: Color(0xFF5B68F5),
                  borderWidth: 1,
                  buttonSize: 48,
                  fillColor: Color(0xFF5B68F5),
                  icon: FaIcon(
                    FontAwesomeIcons.ellipsisH,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    size: 24,
                  ),
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: WaydetailsWidget(
                            time: '',
                            date: '',
                            passanger: '',
                            cName: '',
                            pickup: '',
                            dropoff: '',
                            cNote: '',
                            cnumber: '',
                            luggage: '',
                            cemail: '',
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                ),
                FFButtonWidget(
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: DropoffWidget(
                            cId: '',
                            dId: '',
                            time: '',
                            date: '',
                            pickup: '',
                            dropoff: '',
                            cName: '',
                            cNumber: '',
                            passenger: '',
                            cNotes: '',
                            fare: '',
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'ON WAY',
                  options: FFButtonOptions(
                    width: MediaQuery.sizeOf(context).width * 0.85,
                    height: 49,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Color(0xFF1C1F28),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Open Sans',
                          color: Colors.white,
                        ),
                    elevation: 3,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
