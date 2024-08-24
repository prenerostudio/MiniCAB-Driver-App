import 'package:get/get.dart';
import 'package:mini_cab/home/home_view_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/at_dropoff_widget.dart';
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

import 'dropoff_model.dart';
export 'dropoff_model.dart';

class DropoffWidget extends StatefulWidget {
  const DropoffWidget({
    super.key,
    required this.cId,
    required this.dId,
    required this.time,
    required this.date,
    required this.pickup,
    required this.dropoff,
    required this.cName,
    required this.cNumber,
    required this.passenger,
    required this.cNotes,
    required this.fare,
  });

  final String? cId;
  final String? dId;
  final String? time;
  final String? date;
  final String? pickup;
  final String? dropoff;
  final String? cName;
  final String? cNumber;
  final String? passenger;
  final String? cNotes;
  final String? fare;

  @override
  State<DropoffWidget> createState() => _DropoffWidgetState();
}

class _DropoffWidgetState extends State<DropoffWidget> {
  late DropoffModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DropoffModel());
  }

  double pickupLat = 0.0;
  double pickupLng = 0.0;
  late double currentLatitude;
  late double currentLongitude;

  String? did;
  String? jobid;
  String? pickup;
  String? dropoff;
  String? cName;
  String? fare;
  String? distance;
  String? note;
  String? pickTime;
  String? pickDate;
  String? passenger;
  String? luggage;
  String? cnumber;
  String? cemail;
  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  final JobController myController = Get.put(JobController());

  Future loadata() async {
    // myController.jobDetails();
    SharedPreferences sp = await SharedPreferences.getInstance();
    // isWaiting = sp.getBool('isWaitingTrue') ?? false;
    setState(() {});
    // widget.did = sp.getString('did');
    // widget.jobid = sp.getString('jobId');
    // widget.pickup = sp.getString('pickup');
    // widget.dropoff = sp.getString('destination');
    // widget.cName = sp.getString('cName');
    // widget.fare = sp.getString('journeyFare');
    // widget.distance = sp.getString('journeyDistance');
    // widget.note = sp.getString('note');
    // widget.pickTime = sp.getString('pickTime');
    // widget.pickDate = sp.getString('pickDate');
    // widget.passenger = sp.getString('passenger');
    // widget.luggage = sp.getString('laggage');
    // widget.cnumber = sp.getString('cPhone');
    // widget.cemail = sp.getString('cEmail');
    await myController.acceptedJobDetails().then((value) {
      if (value != null) {
        print("after job details $value");
        did = value.dId;
        jobid = value.jobId;
        pickup = value.pickup;
        dropoff = value.destination;
        cName = value.cName;
        fare = value.journeyFare;
        distance = value.journeyDistance;
        note = value.note;
        pickTime = value.pickTime;
        pickDate = value.pickDate;
        passenger = value.passenger;
        luggage = value.luggage;
        cnumber = value.cPhone;
        cemail = value.cEmail;
      } else {
        print("No job details found.");
        // Handle the null case, e.g., show an error message, redirect, etc.
      }
    });
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
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color(0xFF5B68F5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.person,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    size: 20,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                          child: Text(
                            '25 Hillersdon Avenue, \nEDGWARE',
                            style: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            'HA8 7SG',
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
            padding: EdgeInsetsDirectional.fromSTEB(0, 80, 0, 0),
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
                          child: AtDropoffWidget(
                            date: '',
                            time: '',
                            passenger: '',
                            cName: '',
                            cNumber: '',
                            pickup: '',
                            dropoff: '',
                            fare: '',
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                ),
                FFButtonWidget(
                  onPressed: () async {
                    context.pushNamed('correct');
                  },
                  text: 'AT DROP OFF',
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
