import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:new_minicab_driver/flutter_flow/flutter_flow_util.dart';
import 'package:new_minicab_driver/home/home_view_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vibration/vibration.dart';
import '../Model/jobDetails.dart';
import '../components/upcommingjob_Accepted_widget.dart';
import '../components/upcommingjob_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';

class Alarts {
  late BuildContext _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  String? pickup;
  double? pickupLat;
  double? pickupLng;
  int? switchValue1;
  bool visiblecontainer = false;

  final JobController myController = Get.put(JobController());

  Future<List<Job>> jobDetailsFuture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? dId = prefs.getString('d_id');
    print(dId);
    final response = await http.post(
      Uri.parse('https://minicaboffice.com/api/driver/upcoming-jobs.php'),
      body: {
        'd_id': dId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);

      print(parsedResponse);

      if (parsedResponse['data'] is List) {
        if (parsedResponse.containsKey('data')) {
          pickup = parsedResponse['data'][0]['pickup'];
        }
        return (parsedResponse['data'] as List)
            .map((item) => Job.fromJson(item))
            .toList();
      }
    }
    throw Exception('App Check Now');
  }

  final unfocusNode = FocusNode();

  void showOverlay(BuildContext context) {
    OverlayEntry? overlayEntry;
    bool isOverlayClosed = false;

    void closeOverlay() {
      if (!isOverlayClosed) {
        overlayEntry!.remove();
        isOverlayClosed = true;
        FlutterRingtonePlayer().stop();
        Vibration.cancel();
      }
    }

    void closeOverlay2() {
      overlayEntry!.remove();
      isOverlayClosed = true;
      FlutterRingtonePlayer().stop();
      Vibration.cancel();
    }

    // Timer(Duration(seconds: 20), closeOverlay);

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (unfocusNode.canRequestFocus) {
                FocusScope.of(context).requestFocus(unfocusNode);
              } else {
                FocusScope.of(context).unfocus();
              }
            },
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: closeOverlay, // Close overlay when tapped outside
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: AnimatedGradientBorder(
                        borderSize: 8,
                        glowSize: 0,
                        gradientColors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          FlutterFlowTheme.of(context).primary
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            boxShadow: [
                              const BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x33000000),
                                offset: Offset(0.0, 2.0),
                              )
                            ],
                          ),
                          child: FutureBuilder<List<Job>>(
                            future: jobDetailsFuture(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Job>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center();
                              } else if (snapshot.hasError) {
                                return const Center();
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center();
                              } else {
                                final jobDetails = snapshot.data;
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: jobDetails!.length,
                                  itemBuilder: (context, index) {
                                    final jobItem = jobDetails[index];
                                    return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '£${jobItem.journeyFare}',
                                                      textAlign: TextAlign.end,
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displaySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Outfit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 32,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                    ),
                                                    Text(
                                                      '(Estimated maximum value)',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Montserrat',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                    ),
                                                  ].divide(const SizedBox(
                                                      height: 4)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.business,
                                                  color: Color(0xFF5B68F5),
                                                  size: 45,
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Opacity(
                                                      opacity: 0.5,
                                                      child: SizedBox(
                                                        height: 50,
                                                        child: VerticalDivider(
                                                          thickness: 2,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              10, 0, 0, 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            'Time',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 16,
                                                                ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(0,
                                                                    15, 0, 0),
                                                            child: Text(
                                                              'Date',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              80, 0, 0, 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            '${jobItem.pickTime}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 16,
                                                                ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(0,
                                                                    15, 0, 0),
                                                            child: Text(
                                                              '${jobItem.pickDate}',
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ].divide(
                                                  const SizedBox(width: 16)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFF5B68F5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                            color: const Color(
                                                                0xFF5B68F5),
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'A',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 5,
                                                        left: 25,
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Container(
                                                              width: 4,
                                                              height: 80,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color(
                                                                    0xFFE5E7EB),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 25,
                                                            ),
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0.0),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Container(
                                                        width: 30,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xFF5B68F5),
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: const Color(
                                                                0xFF5B68F5),
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'B',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Open Sans',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryBackground,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 20),
                                                // Added SizedBox for spacing
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10,
                                                                      top: 10,
                                                                      bottom:
                                                                          20),
                                                              child: Text(
                                                                '${jobItem.pickup}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Readex Pro',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 3,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 40),
                                                        child: Row(
                                                          children: [
                                                            const FaIcon(
                                                              FontAwesomeIcons
                                                                  .bong,
                                                              color: Color(
                                                                  0xFF5B68F5),
                                                              size: 18,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8),
                                                              child: Text(
                                                                '${(double.parse(jobItem.journeyDistance) * 0.621371).toStringAsFixed(2)} Miles ${jobItem.journeyType}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Open Sans',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10,
                                                                      top: 10,
                                                                      bottom:
                                                                          20),
                                                              child: Text(
                                                                '${jobItem.destination}',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Readex Pro',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryText,
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 3,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  closeOverlay();
                                                  //  myController.visiblecontainer.value = true;
                                                  rejectJob(
                                                      '${jobItem.jobId}',
                                                      '${jobItem.bookId}',
                                                      closeOverlay);
                                                },
                                                text: 'cancel',
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  size: 15,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 50,
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          24, 0, 24, 0),
                                                  iconPadding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 0),
                                                  color: Colors.red,
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .titleSmall
                                                      .override(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                  elevation: 3,
                                                  borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              FFButtonWidget(
                                                onPressed: () async {
                                                  // SharedPreferences prefs = await SharedPreferences.getInstance();
                                                  // prefs.setBool('visiblecontainer', true);
                                                  // Navigator.pop(context);
                                                  // Call acceptJob function
                                                  myController.visiblecontainer
                                                      .value = true;
                                                  await acceptJob(
                                                          '${jobItem.jobId}',
                                                          closeOverlay,
                                                          context)
                                                      .then((s) {
                                                    overlayEntry!.remove();
                                                    // isOverlayClosed = true;
                                                    FlutterRingtonePlayer()
                                                        .stop();
                                                    Vibration.cancel();
                                                  });
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> NavBarPage(page:HomeWidget(),))
                                                  // Navigate to NavBarPage with index 0

                                                  // );
                                                },
                                                text: 'Accept',
                                                icon: const Icon(
                                                  Icons.east,
                                                  size: 15,
                                                ),
                                                options: FFButtonOptions(
                                                  height: 50,
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          24, 0, 24, 0),
                                                  iconPadding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 0, 0, 0),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Open Sans',
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                  elevation: 3,
                                                  borderSide: const BorderSide(
                                                    color: Colors.transparent,
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]
                                        // .divide(SizedBox(height: 4))
                                        // .addToEnd(SizedBox(height: 12)),
                                        );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  Future<void> startRingtoneAndVibrateLoop() async {
    FlutterRingtonePlayer().play(
      // fromAsset: "assets\audios\ring.mp3",
      android: AndroidSounds.alarm,
      ios: IosSounds.alarm,
      looping: true,
      volume: 1.0,
    );

    try {
      int totalDuration = 20000;
      int vibrationDuration = 3000;
      int pauseDuration = 3000;
      int numIterations = totalDuration ~/ (vibrationDuration + pauseDuration);
      for (int i = 0; i < numIterations; i++) {
        await Vibration.vibrate(duration: vibrationDuration);

        await Future.delayed(Duration(milliseconds: pauseDuration));
      }
    } catch (e) {
      print("Failed to vibrate: $e");
    }

    Timer(const Duration(seconds: 20), () {
      FlutterRingtonePlayer().stop();
      Vibration.cancel();
    });
  }

  Future<void> acceptJob(
      String jobId, Function closeOverlay, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String? dId = prefs.getString('d_id');
      var fields = {
        'job_id': jobId.toString(),
        'd_id': dId.toString(),
      };
      var uri =
          Uri.parse('https://www.minicaboffice.com/api/driver/accept-job.php');

      var response = await http.post(
        uri,
        body: fields,
      );

      if (response.statusCode == 200) {
        // Navigator.pop(context);
        print('Job accepted successfully');

        myController.visiblecontainer.value = true;
        print('object0');
        // closeOverlay();
      } else {
        print('Failed to accept job. Status Code: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }
  }

  Future<void> rejectJob(
      String jobId, String bookId, Function closeOverlay) async {
    try {
      var url =
          Uri.parse('https://minicaboffice.com/api/driver/cancel-booking.php');
      var response = await http.post(
        url,
        body: {
          'book_id': bookId.toString(),
          'job_id': jobId.toString(),
        },
      );
      if (response.statusCode == 200) {
        closeOverlay();
        print(response.body);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
