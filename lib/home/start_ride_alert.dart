// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:glowy_borders/glowy_borders.dart';
// import 'package:mini_cab/Model/jobDetails.dart';
// import 'package:mini_cab/components/notes_widget.dart';
// import 'package:mini_cab/flutter_flow/flutter_flow_theme.dart';
// import 'package:mini_cab/flutter_flow/flutter_flow_util.dart';
// import 'package:mini_cab/flutter_flow/flutter_flow_widgets.dart';
// import 'package:mini_cab/home/home_view_controller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vibration/vibration.dart';
// import 'package:http/http.dart' as http;

// class StartRideAlert extends StatefulWidget {
//   List<Job> st;
//   StartRideAlert({super.key, required this.st});

//   @override
//   State<StartRideAlert> createState() => _StartRideAlerttState();
// }

// class _StartRideAlerttState extends State<StartRideAlert> {
//   final JobController myController = Get.put(JobController());
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
//         child: SingleChildScrollView(
//           child: Container(
//             color: FlutterFlowTheme.of(context).primaryBackground,
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Column(
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               '£${widget.st[0].journeyFare}',
//                               textAlign: TextAlign.end,
//                               style: FlutterFlowTheme.of(context)
//                                   .displaySmall
//                                   .override(
//                                     fontFamily: 'Outfit',
//                                     color: FlutterFlowTheme.of(context)
//                                         .primaryText,
//                                     fontSize: 32,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                             ),
//                             Text(
//                               '(Estimated maximum value)',
//                               style: FlutterFlowTheme.of(context)
//                                   .labelMedium
//                                   .override(
//                                     fontFamily: 'Montserrat',
//                                     color: FlutterFlowTheme.of(context)
//                                         .primaryText,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                             ),
//                           ].divide(const SizedBox(height: 4)),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(0),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.business,
//                           color: Color(0xFF5B68F5),
//                           size: 45,
//                         ),
//                         Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Opacity(
//                               opacity: 0.5,
//                               child: SizedBox(
//                                 height: 50,
//                                 child: VerticalDivider(
//                                   thickness: 2,
//                                   color: FlutterFlowTheme.of(context)
//                                       .secondaryText,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsetsDirectional.fromSTEB(
//                                   10, 0, 0, 0),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Text(
//                                     'Time',
//                                     style: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .override(
//                                           fontFamily: 'Roboto',
//                                           fontSize: 16,
//                                         ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsetsDirectional.fromSTEB(
//                                             0, 15, 0, 0),
//                                     child: Text(
//                                       'Date',
//                                       style: FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .override(
//                                             fontFamily: 'Roboto',
//                                             fontSize: 16,
//                                           ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsetsDirectional.fromSTEB(
//                                   80, 0, 0, 0),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Text(
//                                     '${widget.st[0]!.pickTime}',
//                                     style: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .override(
//                                           fontFamily: 'Roboto',
//                                           fontSize: 16,
//                                         ),
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsetsDirectional.fromSTEB(
//                                             0, 15, 0, 0),
//                                     child: Text(
//                                       '${widget.st[0]!.pickDate}',
//                                       style: FlutterFlowTheme.of(context)
//                                           .bodyMedium
//                                           .override(
//                                             fontFamily: 'Roboto',
//                                             fontSize: 16,
//                                           ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ].divide(const SizedBox(width: 16)),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Column(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Align(
//                               alignment: Alignment.center,
//                               child: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF5B68F5),
//                                   borderRadius: BorderRadius.circular(50),
//                                   shape: BoxShape.rectangle,
//                                   border: Border.all(
//                                     color: const Color(0xFF5B68F5),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     'A',
//                                     style: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .override(
//                                           fontFamily: 'Open Sans',
//                                           color: FlutterFlowTheme.of(context)
//                                               .secondaryBackground,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w300,
//                                         ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(
//                                 top: 5,
//                                 left: 25,
//                               ),
//                               child: Stack(
//                                 children: [
//                                   Align(
//                                     alignment: Alignment.center,
//                                     child: Container(
//                                       width: 4,
//                                       height: 80,
//                                       decoration: const BoxDecoration(
//                                         color: Color(0xFFE5E7EB),
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(
//                                       top: 25,
//                                     ),
//                                     child: Container(
//                                       width: 30,
//                                       height: 30,
//                                       decoration: const BoxDecoration(
//                                         color: Color.fromRGBO(0, 0, 0, 0.0),
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 5),
//                               child: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF5B68F5),
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: const Color(0xFF5B68F5),
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     'B',
//                                     style: FlutterFlowTheme.of(context)
//                                         .bodyMedium
//                                         .override(
//                                           fontFamily: 'Open Sans',
//                                           color: FlutterFlowTheme.of(context)
//                                               .secondaryBackground,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w300,
//                                         ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 20), // Added SizedBox for spacing
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Flexible(
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 10, top: 10, bottom: 20),
//                                       child: Text(
//                                         '${widget.st[0]!.pickup}',
//                                         style: FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .override(
//                                               fontFamily: 'Readex Pro',
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .secondaryText,
//                                               fontSize: 15,
//                                             ),
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 3,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 40),
//                                 child: Row(
//                                   children: [
//                                     const FaIcon(
//                                       FontAwesomeIcons.bong,
//                                       color: Color(0xFF5B68F5),
//                                       size: 18,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 8),
//                                       child: Text(
//                                         '${(double.parse(widget.st[0]!.journeyDistance) * 0.621371).toStringAsFixed(2)} Miles ${widget.st[0]!.journeyType}',
//                                         style: FlutterFlowTheme.of(context)
//                                             .bodyMedium
//                                             .override(
//                                               fontFamily: 'Open Sans',
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .secondaryText,
//                                               fontSize: 16,
//                                             ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   Flexible(
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 10, top: 10, bottom: 20),
//                                       child: Text(
//                                         '${widget.st[0]!.destination}',
//                                         style: FlutterFlowTheme.of(context)
//                                             .labelMedium
//                                             .override(
//                                               fontFamily: 'Readex Pro',
//                                               color:
//                                                   FlutterFlowTheme.of(context)
//                                                       .secondaryText,
//                                               fontSize: 15,
//                                             ),
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 3,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       FFButtonWidget(
//                         onPressed: () async {
//                           SharedPreferences sp =
//                               await SharedPreferences.getInstance();

//                           // print(
//                           //     'st ${initialLabelIndex == 1}');
//                           if (myController.initialLabelIndex.value == 1) {
//                             await sp.setBool('show', false);
//                             await sp.setBool('isRideStart', true);
//                             await showModalBottomSheet(
//                               isScrollControlled: true,
//                               backgroundColor: Colors.transparent,
//                               enableDrag: false,
//                               context: context,
//                               builder: (context) {
//                                 return Padding(
//                                   padding: MediaQuery.viewInsetsOf(context),
//                                   child: NotesWidget(
//                                     dId: '${widget.st[0].dId}',
//                                     jobId: '${widget.st[0].jobId}',
//                                     pickTime: '${widget.st[0].pickTime}',
//                                     pickDate: '${widget.st[0].pickDate}',
//                                     passenger: '${widget.st[0].passenger}',
//                                     pickup: '${widget.st[0].pickup}',
//                                     dropoff: '${widget.st[0].destination}',
//                                     luggage: '${widget.st[0].luggage}',
//                                     cName: '${widget.st[0].cName}',
//                                     cnumber: '${widget.st[0].cPhone}',
//                                     cemail: '${widget.st[0].cEmail}',
//                                     note: '${widget.st[0].note}',
//                                     fare: '${widget.st[0].journeyFare}',
//                                     distance: '${widget.st[0].journeyDistance}',
//                                   ),
//                                 );
//                               },
//                             ).then((value) => safeSetState(() {}));
//                           } else {
//                             Fluttertoast.showToast(
//                               msg: "Please be online before starting the ride.",
//                               textColor: Colors.white,
//                               fontSize: 16.0,
//                             );
//                           }
//                         },
//                         text: 'Start Now',
//                         icon: const Icon(
//                           Icons.east,
//                           size: 15,
//                         ),
//                         options: FFButtonOptions(
//                           height: 50,
//                           padding: const EdgeInsetsDirectional.fromSTEB(
//                               24, 0, 24, 0),
//                           iconPadding:
//                               const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                           color: FlutterFlowTheme.of(context).primary,
//                           textStyle: FlutterFlowTheme.of(context)
//                               .titleSmall
//                               .override(
//                                   fontFamily: 'Open Sans',
//                                   color: Colors.white,
//                                   fontSize: 10),
//                           elevation: 3,
//                           borderSide: const BorderSide(
//                             color: Colors.transparent,
//                             width: 1,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ]
//                     .divide(const SizedBox(height: 4))
//                     .addToEnd(const SizedBox(height: 12)),
//               ),
//             ),
//           ),
//         ));
//   }
// }
