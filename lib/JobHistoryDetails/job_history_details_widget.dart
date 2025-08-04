import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_minicab_driver/JobHistoryDetails/contact_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/customer_details_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'job_history_details_model.dart';
export 'job_history_details_model.dart';

class JobHistoryDetailsWidget extends StatefulWidget {
  JobHistoryDetailsWidget({
    super.key,
    required this.did,
    required this.pickup,
    required this.dropoff,
    required this.bookId,
    required this.date,
    required this.time,
    required this.passanger,
    required this.cId,
    required this.cName,
    required this.cNotes,
    required this.cNumber,
    required this.fare,
    this.jobId,
    this.pickUpdate,
    this.pickUpTime,
    this.ridePath,
    this.pickUpAdress,
    this.dropoffAdress,
    this.journy,
    this.stopTime,
    this.parking,
    this.toll,
    this.extra,
    this.jobaccept,
    this.jobstart,
    this.waytopickup,
    this.arrivalNow,
    this.pob,
    this.dropOfftime,
    this.completime,
  });

  final String? did;
  final String? jobId;
  final String? pickUpdate;
  final String? pickUpTime;
  final String? pickUpAdress;
  final String? dropoffAdress;
  final String? journy;
  final String? stopTime;
  final String? parking;
  final String? toll;
  final String? extra;
  final String? pickup;
  final String? dropoff;
  final String? bookId;
  final String? date;
  final String? time;
  final String? passanger;
  final String? cId;
  final String? cName;
  final String? cNotes;
  final String? cNumber;
  final String? fare;
  final String? jobaccept;
  final String? ridePath;
  final String? jobstart;
  final String? waytopickup;
  final String? arrivalNow;
  final String? pob;
  final String? dropOfftime;
  final String? completime;
  @override
  State<JobHistoryDetailsWidget> createState() =>
      _JobHistoryDetailsWidgetState();
}

class _JobHistoryDetailsWidgetState extends State<JobHistoryDetailsWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late JobHistoryDetailsModel _model;
  GoogleMapController? mapController;
  List<LatLng> routePoints = [];

  Future<void> loadRouteFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String rawData = widget.ridePath ?? '';

    // Remove spaces and split by comma
    List<String> routeData = rawData.replaceAll(" ", "").split(",");
    print('the saved routes minLat ${routeData}');

    if (routeData.isEmpty) return;

    List<LatLng> points = [];

    for (int i = 0; i < routeData.length; i += 2) {
      double lat = double.parse(routeData[i]);
      double lng = double.parse(routeData[i + 1]);
      points.add(LatLng(lat, lng));
    }

    setState(() {
      routePoints = points;
    });

    if (routePoints.isNotEmpty && mapController != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(_getLatLngBounds(routePoints), 50),
      );
    }
  }

  //   Future<void> loadRouteFromStorage() async {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String rawData = widget.ridePath ?? '';

  //     List<String>? routeData2 = prefs.getStringList('user_route');

  // // Remove spaces and split by comma
  //     List<String> routeData = rawData.replaceAll(" ", "").split(",");
  //     // print('the saved routes minLat 1 ${widget.ridePath}');
  //     print('the saved routes minLat ${routeData}');
  //     print('the saved routes minLat2 ${routeData2}');

  //     // print(routeData);
  //     if (routeData == null) return;

  //     List<LatLng> points = routeData.map((point) {
  //       List<String> latLng = point.split(',');
  //       return LatLng(double.parse(latLng[0]), double.parse(latLng[1]));
  //     }).toList();

  //     setState(() {
  //       routePoints = points;
  //     });

  //     if (routePoints.isNotEmpty && mapController != null) {
  //       mapController?.animateCamera(
  //         CameraUpdate.newLatLngBounds(
  //           _getLatLngBounds(routePoints),
  //           50,
  //         ),
  //       );
  //     }
  //   }

  LatLngBounds _getLatLngBounds(List<LatLng> points) {
    double minLat = points
        .map((p) => p.latitude)
        .reduce((a, b) => a < b ? a : b);
    double minLng = points
        .map((p) => p.longitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLat = points
        .map((p) => p.latitude)
        .reduce((a, b) => a > b ? a : b);
    double maxLng = points
        .map((p) => p.longitude)
        .reduce((a, b) => a > b ? a : b);

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => JobHistoryDetailsModel());
    loadRouteFromStorage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateFormat("yyyy-MM-dd").parse(widget.date ?? '');

    // Final format
    String formattedDate = DateFormat("d MMM h:mm a").format(date);
    return GestureDetector(
      onTap:
          () =>
              _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      // height: 166,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        // border: Border.all(color: Color(0xFF1C1F28)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              10,
                              15,
                              10,
                              10,
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.safePop();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          0,
                                          8,
                                          0,
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Icon(
                                            Icons.chevron_left,
                                            // color:
                                            //     FlutterFlowTheme.of(context)
                                            //         .accent4,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          8,
                                          0,
                                          0,
                                          0,
                                        ),
                                        child: Text(
                                          'Back',
                                          style: FlutterFlowTheme.of(
                                            context,
                                          ).titleMedium.override(
                                            fontFamily: 'Open Sans',
                                            color:
                                                FlutterFlowTheme.of(
                                                  context,
                                                ).primaryText,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Row(
                          //   mainAxisSize: MainAxisSize.max,
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       '${widget.date}',
                          //       style: FlutterFlowTheme.of(context)
                          //           .titleLarge
                          //           .override(
                          //             fontFamily: 'Open Sans',
                          //             // color: FlutterFlowTheme.of(context)
                          //             //     .secondaryBackground,
                          //             fontSize: 20,
                          //             letterSpacing: 0,
                          //           ),
                          //     ),
                          //     Padding(
                          //       padding:
                          //           EdgeInsetsDirectional.fromSTEB(10, 0, 5, 0),
                          //       child: Icon(
                          //         Icons.access_time_filled_rounded,
                          //         color: Color(0xFF5B68F5),
                          //         size: 20,
                          //       ),
                          //     ),
                          //     Text(
                          //       '${widget.time}',
                          //       style: FlutterFlowTheme.of(context)
                          //           .titleLarge
                          //           .override(
                          //             fontFamily: 'Open Sans',
                          //             // color: FlutterFlowTheme.of(context)
                          //             //     .secondaryBackground,
                          //             fontSize: 20,
                          //             letterSpacing: 0,
                          //           ),
                          //     ),
                          //   ],
                          // ),
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.max,
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Text(
                          //         '${widget.cNumber}',
                          //         style: FlutterFlowTheme.of(context)
                          //             .titleLarge
                          //             .override(
                          //               fontFamily: 'Open Sans',
                          //               // color: FlutterFlowTheme.of(context)
                          //               //     .secondaryBackground,
                          //               fontSize: 20,
                          //               letterSpacing: 0,
                          //             ),
                          //       ),
                          //       SizedBox(
                          //         height: 25,
                          //         child: VerticalDivider(
                          //           width: 40,
                          //           thickness: 3,
                          //           color: Color(0xFF5B68F5),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: EdgeInsetsDirectional.fromSTEB(
                          //             20, 0, 5, 0),
                          //         child: FaIcon(
                          //           FontAwesomeIcons.userFriends,
                          //           color: Color(0xFF5B68F5),
                          //           size: 18,
                          //         ),
                          //       ),
                          //       Text(
                          //         '${widget.passanger}',
                          //         style: FlutterFlowTheme.of(context)
                          //             .titleLarge
                          //             .override(
                          //               fontFamily: 'Open Sans',
                          //               // color: FlutterFlowTheme.of(context)
                          //               //     .secondaryBackground,
                          //               fontSize: 20,
                          //               letterSpacing: 0,
                          //             ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Row(
                    //         mainAxisSize: MainAxisSize.max,
                    //         children: [
                    //           Icon(
                    //             Icons.person_sharp,
                    //             color: Color(0xFF5B68F5),
                    //             size: 26,
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsetsDirectional.fromSTEB(
                    //               8,
                    //               0,
                    //               0,
                    //               0,
                    //             ),
                    //             child: InkWell(
                    //               splashColor: Colors.transparent,
                    //               focusColor: Colors.transparent,
                    //               hoverColor: Colors.transparent,
                    //               highlightColor: Colors.transparent,
                    //               child: Text(
                    //                 '${widget.cName}',
                    //                 style: FlutterFlowTheme.of(
                    //                   context,
                    //                 ).titleMedium.override(
                    //                   fontFamily: 'Open Sans',
                    //                   color:
                    //                       FlutterFlowTheme.of(
                    //                         context,
                    //                       ).primaryText,
                    //                   letterSpacing: 0,
                    //                   fontWeight: FontWeight.w600,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Padding(
                    //         padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                    //         child: InkWell(
                    //           splashColor: Colors.transparent,
                    //           focusColor: Colors.transparent,
                    //           hoverColor: Colors.transparent,
                    //           highlightColor: Colors.transparent,
                    //           onTap: () async {
                    //             await showModalBottomSheet(
                    //               isScrollControlled: true,
                    //               backgroundColor: Colors.transparent,
                    //               enableDrag: false,
                    //               context: context,
                    //               builder: (context) {
                    //                 return GestureDetector(
                    //                   onTap:
                    //                       () =>
                    //                           _model.unfocusNode.canRequestFocus
                    //                               ? FocusScope.of(
                    //                                 context,
                    //                               ).requestFocus(
                    //                                 _model.unfocusNode,
                    //                               )
                    //                               : FocusScope.of(
                    //                                 context,
                    //                               ).unfocus(),
                    //                   child: Padding(
                    //                     padding: MediaQuery.viewInsetsOf(
                    //                       context,
                    //                     ),
                    //                     child: CustomerDetailsWidget(
                    //                       cNumber: '${widget.cNumber}',
                    //                       cname: '${widget.cName}',
                    //                       cemail: '${widget.cNotes}',
                    //                     ),
                    //                   ),
                    //                 );
                    //               },
                    //             ).then((value) => safeSetState(() {}));
                    //           },
                    //           child: Icon(
                    //             Icons.keyboard_control_rounded,
                    //             color: FlutterFlowTheme.of(context).primaryText,
                    //             size: 30,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Opacity(
                    //   opacity: 0.3,
                    //   child: SizedBox(
                    //     width: 280,
                    //     child: Divider(
                    //       height: 30,
                    //       thickness: 1,
                    //       color: FlutterFlowTheme.of(context).secondaryText,
                    //     ),
                    //   ),
                    // ),
                    // Stack(
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                    //       child: Container(
                    //         width: MediaQuery.sizeOf(context).width,
                    //         height: 98,
                    //         decoration: BoxDecoration(
                    //           color:
                    //               FlutterFlowTheme.of(
                    //                 context,
                    //               ).secondaryBackground,
                    //         ),
                    //         child: Row(
                    //           mainAxisSize: MainAxisSize.max,
                    //           children: [
                    //             Opacity(
                    //               opacity: 0.6,
                    //               child: Padding(
                    //                 padding: EdgeInsetsDirectional.fromSTEB(
                    //                   10,
                    //                   0,
                    //                   0,
                    //                   0,
                    //                 ),
                    //                 child: Container(
                    //                   width: 30,
                    //                   height: 30,
                    //                   decoration: BoxDecoration(
                    //                     color:
                    //                         FlutterFlowTheme.of(
                    //                           context,
                    //                         ).secondaryBackground,
                    //                     borderRadius: BorderRadius.circular(50),
                    //                     border: Border.all(
                    //                       color:
                    //                           FlutterFlowTheme.of(
                    //                             context,
                    //                           ).secondaryText,
                    //                       width: 2,
                    //                     ),
                    //                   ),
                    //                   alignment: AlignmentDirectional(0, 0),
                    //                   child: Text(
                    //                     'B',
                    //                     style: FlutterFlowTheme.of(
                    //                       context,
                    //                     ).bodyMedium.override(
                    //                       fontFamily: 'Open Sans',
                    //                       fontSize: 16,
                    //                       letterSpacing: 0,
                    //                       fontWeight: FontWeight.w600,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             Expanded(
                    //               child: Padding(
                    //                 padding: EdgeInsetsDirectional.fromSTEB(
                    //                   10,
                    //                   15,
                    //                   0,
                    //                   0,
                    //                 ),
                    //                 child: Text(
                    //                   '${widget.dropoff}',
                    //                   textAlign: TextAlign.start,
                    //                   style: FlutterFlowTheme.of(
                    //                     context,
                    //                   ).titleMedium.override(
                    //                     fontFamily: 'Open Sans',
                    //                     color:
                    //                         FlutterFlowTheme.of(
                    //                           context,
                    //                         ).primaryText,
                    //                     fontSize: 15,
                    //                     letterSpacing: 0,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                   maxLines: 1,
                    //                   overflow: TextOverflow.ellipsis,
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     Container(
                    //       width: MediaQuery.sizeOf(context).width,
                    //       height: 49,
                    //       decoration: BoxDecoration(color: Color(0xFF5B68F5)),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.max,
                    //         children: [
                    //           Opacity(
                    //             opacity: 0.6,
                    //             child: Padding(
                    //               padding: EdgeInsetsDirectional.fromSTEB(
                    //                 10,
                    //                 0,
                    //                 0,
                    //                 0,
                    //               ),
                    //               child: Container(
                    //                 width: 30,
                    //                 height: 30,
                    //                 decoration: BoxDecoration(
                    //                   // color:
                    //                   //     FlutterFlowTheme.of(context).info,
                    //                   borderRadius: BorderRadius.circular(50),
                    //                   border: Border.all(
                    //                     // color:
                    //                     //     FlutterFlowTheme.of(context).info,
                    //                     width: 2,
                    //                   ),
                    //                 ),
                    //                 alignment: AlignmentDirectional(0, 0),
                    //                 child: Text(
                    //                   'A',
                    //                   style: FlutterFlowTheme.of(
                    //                     context,
                    //                   ).bodyMedium.override(
                    //                     fontFamily: 'Open Sans',
                    //                     color:
                    //                         FlutterFlowTheme.of(
                    //                           context,
                    //                         ).secondaryText,
                    //                     fontSize: 16,
                    //                     letterSpacing: 0,
                    //                     fontWeight: FontWeight.w600,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsetsDirectional.fromSTEB(
                    //               10,
                    //               0,
                    //               0,
                    //               0,
                    //             ),
                    //             child: Text(
                    //               '${widget.pickup}',
                    //               style: FlutterFlowTheme.of(
                    //                 context,
                    //               ).titleMedium.override(
                    //                 fontFamily: 'Open Sans',
                    //                 fontSize: 15,
                    //                 letterSpacing: 0,
                    //                 fontWeight: FontWeight.w600,
                    //               ),
                    //               maxLines: 1,
                    //               overflow: TextOverflow.ellipsis,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Opacity(
                    //   opacity: 0.3,
                    //   child: SizedBox(
                    //     width: 280,
                    //     child: Divider(
                    //       thickness: 1,
                    //       color: FlutterFlowTheme.of(context).secondaryText,
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Trip details',
                            style: FlutterFlowTheme.of(
                              context,
                            ).displaySmall.override(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    // Text('the routepoints are ${routePoints.first}'),
                    Container(
                      height: 200,
                      child: GoogleMap(
                        mapType:
                            MapType
                                .satellite, // Keep this as 'normal' (not satellite etc.)
                        tiltGesturesEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target:
                              routePoints.isNotEmpty
                                  ? routePoints.first
                                  : LatLng(0, 0),
                          zoom: 14,
                        ),
                        polylines: {
                          if (routePoints.isNotEmpty)
                            Polyline(
                              polylineId: PolylineId('ride_route'),
                              points: routePoints,
                              color: Colors.blue,
                              width: 5,
                            ),
                        },
                        markers: {
                          if (routePoints.isNotEmpty) ...{
                            Marker(
                              markerId: MarkerId('start_point'),
                              position: routePoints.first,
                              infoWindow: InfoWindow(title: 'Start Point'),
                            ),
                            Marker(
                              markerId: MarkerId('end_point'),
                              position: routePoints.last,
                              infoWindow: InfoWindow(title: 'End Point'),
                            ),
                          },
                        },
                        zoomControlsEnabled:
                            true, // Allow zoom controls on the map
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                          if (routePoints.isNotEmpty) {
                            mapController?.animateCamera(
                              CameraUpdate.newLatLngBounds(
                                _getLatLngBounds(routePoints),
                                50,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/user.png',
                                width: 40.0,
                                height: 40.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              "Green ride with ${widget.cName}" ?? '',
                              style: FlutterFlowTheme.of(
                                context,
                              ).displaySmall.override(
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                letterSpacing: 0,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                formattedDate ?? '',
                                style: FlutterFlowTheme.of(
                                  context,
                                ).displaySmall.override(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  letterSpacing: 0,
                                  color: Colors.grey,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "£${widget.fare}" ?? '',
                                style: FlutterFlowTheme.of(
                                  context,
                                ).displaySmall.override(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  color: Colors.grey,
                                  letterSpacing: 0,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.circle,
                              color: Colors.black,
                              size: 18,
                            ),
                            title: Text(
                              "${widget.pickup}" ?? '',
                              style: FlutterFlowTheme.of(
                                context,
                              ).displaySmall.override(
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                                letterSpacing: 0,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.square,
                              color: Colors.black,
                              size: 18,
                            ),
                            title: Text(
                              "${widget.dropoff}" ?? '',
                              style: FlutterFlowTheme.of(
                                context,
                              ).displaySmall.override(
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                                letterSpacing: 0,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                "Help" ?? '',
                                style: FlutterFlowTheme.of(
                                  context,
                                ).displaySmall.override(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  letterSpacing: 0,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ContactScreen(
                                        name: widget.cName ?? '',
                                      ),
                                ),
                              );
                            },
                            leading: Icon(
                              Icons.key,
                              color: Colors.black,
                              size: 18,
                            ),
                            title: Text(
                              "Find Lost Items",
                              style: FlutterFlowTheme.of(
                                context,
                              ).displaySmall.override(
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                                letterSpacing: 0,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "We can help you to get in touch with your driver",
                              style: FlutterFlowTheme.of(
                                context,
                              ).displaySmall.override(
                                color: Colors.grey,
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                letterSpacing: 0,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ContactScreen(
                                        name: widget.cName ?? '',
                                      ),
                                ),
                              );
                            },
                            leading: Icon(
                              Icons.note,
                              color: Colors.black,
                              size: 18,
                            ),
                            title: Text(
                              "Report safety issue",
                              style: FlutterFlowTheme.of(
                                context,
                              ).displaySmall.override(
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                                letterSpacing: 0,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "Let us know if you have safety related issue",
                              style: FlutterFlowTheme.of(
                                context,
                              ).displaySmall.override(
                                color: Colors.grey,
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                letterSpacing: 0,
                                // fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                    ),

                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     children: [
                    //       Text(
                    //         'Job Details',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).displaySmall.override(
                    //           fontFamily: 'Montserrat',
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Job id',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '${widget.bookId}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Pick-up date',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '${widget.date}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Pick-up time',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '${widget.time}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     children: [
                    //       Text(
                    //         'Fare Details',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).displaySmall.override(
                    //           fontFamily: 'Montserrat',
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Journey',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '£${widget.fare}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Extra',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '£${widget.extra}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Toll',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '£${widget.toll}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Waiting',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '£${widget.stopTime}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Time tracking',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Job Accepted',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '${widget.jobaccept}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Job Started',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '${widget.jobstart}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Way to pickup',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '${widget.waytopickup}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Arrival at pickup',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '${widget.arrivalNow}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'POB',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '${widget.pob}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Dropoff',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '${widget.dropOfftime}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Completed At',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           fontSize: 16,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //       Text(
                    //         '${widget.completime}',
                    //         style: FlutterFlowTheme.of(
                    //           context,
                    //         ).headlineSmall.override(
                    //           fontFamily: 'Open Sans',
                    //           color: FlutterFlowTheme.of(context).secondaryText,
                    //           fontSize: 18,
                    //           letterSpacing: 0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Column(
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(
                    //         15,
                    //         20,
                    //         15,
                    //         0,
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.max,
                    //         children: [
                    //           Text(
                    //             'Client notes',
                    //             style: FlutterFlowTheme.of(
                    //               context,
                    //             ).displaySmall.override(
                    //               fontFamily: 'Montserrat',
                    //               fontSize: 18,
                    //               letterSpacing: 0,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(
                    //         15,
                    //         15,
                    //         15,
                    //         0,
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.max,
                    //         children: [
                    //           Expanded(
                    //             child: Text(
                    //               '${widget.cNotes == '' ? '**NO WR OR EXTRA DROPS ARE ALLOWED - ONLY AtoB JOURNEYS **' : widget.cNotes}',
                    //               style: FlutterFlowTheme.of(
                    //                 context,
                    //               ).bodyMedium.override(
                    //                 fontFamily: 'Open Sans',
                    //                 color:
                    //                     FlutterFlowTheme.of(
                    //                       context,
                    //                     ).secondaryText,
                    //                 letterSpacing: 0,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(
                    //         15,
                    //         20,
                    //         15,
                    //         0,
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.max,
                    //         children: [
                    //           Text(
                    //             'Account instractions',
                    //             style: FlutterFlowTheme.of(
                    //               context,
                    //             ).displaySmall.override(
                    //               fontFamily: 'Montserrat',
                    //               fontSize: 18,
                    //               letterSpacing: 0,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(
                    //         15,
                    //         15,
                    //         15,
                    //         0,
                    //       ),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.max,
                    //         children: [
                    //           Expanded(
                    //             child: Text(
                    //               '**DO NOT MAKE ANY EXTRA STOP\nOFFS** ADDITIONAL PASSENGER NOT AUTHORISED YOU WILL NOT BE PAID FOR THEM**\nAtoB journeys ONLY *NO MULTISTOPS* or Wait & Returns',
                    //               textAlign: TextAlign.justify,
                    //               style: FlutterFlowTheme.of(
                    //                 context,
                    //               ).bodyMedium.override(
                    //                 fontFamily: 'Open Sans',
                    //                 color:
                    //                     FlutterFlowTheme.of(
                    //                       context,
                    //                     ).secondaryText,
                    //                 letterSpacing: 0,
                    //                 fontWeight: FontWeight.w500,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
