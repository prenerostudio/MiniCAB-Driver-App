import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
// import 'package:latlong2/latlong.dart';
import 'package:mini_cab/Model/jobDetails.dart';
import 'package:mini_cab/flutter_flow/flutter_flow_theme.dart';
import 'package:mini_cab/flutter_flow/flutter_flow_util.dart';
import 'package:mini_cab/flutter_flow/flutter_flow_widgets.dart';
import 'package:mini_cab/home/home_view_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/services.dart';
export 'home_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class HomeScreenAlert extends StatefulWidget {
  List<Job> st;

  HomeScreenAlert({
    super.key,
    required this.st,
  });

  @override
  State<HomeScreenAlert> createState() => _HomeScreenAlertState();
}

class _HomeScreenAlertState extends State<HomeScreenAlert> {
  Future acceptJob(
    String jobId,
  ) async {
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
        var jsonData = json.decode(response.body);
        // Navigator.pop(context);
        print('Job accepted successfully');
        Timer(Duration(seconds: 1), () {
          print('now timer start');
          myController.jobDetails();
        });
        myController.isJobDetailDone.value = false;
        print('object0');
        print('object ${jsonData['data'][0]['pickup']}');
        await getCoordinatesFromAddress(jsonData['data'][0]['pickup']);

        // myController.visiblecontainer.value = true;

        // closeOverlay();
      } else {
        print('Failed to accept job. Status Code: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }
  }

  Future _getPolyline(double destinationLat, double desLng) async {
    print('tapped');
    var origin =
        '${myController.currentLocation?.latitude},${myController.currentLocation?.longitude}'; // Replace with your source coordinates
    var destination =
        // '31.414050,73.0613070'; // Replace with your destination coordinates // Replace with your destination coordinates
        '${destinationLat},${desLng}';
    // var destination =
    // // '31.414050,73.0613070'; // Replace with your destination coordinates // Replace with your destination coordinates
    // '${31.3637197},${73.0553336}';
    try {
      final response = await http.post(Uri.parse(// can be get and post request
          // 'https://maps.googleapis.com/maps/api/directions/json?origin=31.4064054,73.0413076&destination=31.6404050,73.2413070&key=AIzaSyBBSmpcyEaIojvZznYVNpCU0Htvdabe__Y'));
          'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('routes') && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          if (route.containsKey('legs') && route['legs'].isNotEmpty) {
            final leg = route['legs'][0];

            if (leg.containsKey('distance')) {
              // distance.value = leg['distance']['text'];
              // time.value = leg['duration']['text'];

              final points = route['overview_polyline']['points'];
              print('the point of poly line $points');
              // Decode polyline points and add them to the map
              //         final json = jsonDecode(response.body);
              // final String encodedPolyline =
              //     json['routes'][0]['overview_polyline']['points'];
              // final List<LatLng> points = decodePolyline(encodedPolyline);
              decodedPoints = PolylinePoints()
                  .decodePolyline(points)
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList();

              if (mounted) {
                setState(() {
                  myController.polylines.add(
                    Polyline(
                      polylineId: PolylineId('poly'),
                      visible: true,
                      points: decodedPoints,
                      width: 4,
                      color: Colors.blue,
                    ),
                  );
                });
              }
            }
          }
        }
      } else {
        print('the point of poly line ');
      }
    } catch (e) {
      print('the point of poly line $e');
    }
  }

  final apiKey = 'AIzaSyCgDZ47OHpMIZZXiXHe1DHnq9eX5m_HoeA';

  List<LatLng> decodedPoints = <LatLng>[];

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  Future getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        myController.convertedLat.value = locations.first.latitude;
        myController.convertedLng.value = locations.first.longitude;
        print(
            'convert Latitude: ${myController.convertedLat.value}, convert longitude: ${myController.convertedLng.value}');
        _getPolyline(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> rejectJob(
    String jobId,
    String bookId,
  ) async {
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
        print(response.body);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // List<Job> st = [
  //   Job(
  //       jobId: '12',
  //       bookId: '123',
  //       cId: '2',
  //       dId: '23',
  //       jobNote: 'note',
  //       journeyFare: "journeyFare",
  //       bookingFee: "bookingFee",
  //       carParking: "carParking",
  //       waiting: "waiting",
  //       tolls: "tolls",
  //       extra: 'extra',
  //       jobStatus: 'jobStatus',
  //       dateJobAdd: 'dateJobAdd',
  //       cName: 'cName',
  //       cEmail: 'cEmail',
  //       cPhone: '2342323',
  //       cAddress: 'faisalabad',
  //       dName: 'dName',
  //       dEmail: 'dEmail',
  //       dPhone: '234324',
  //       bTypeId: '324',
  //       pickup: 'jhang road',
  //       destination: 'samundri',
  //       address: 'address',
  //       postalCode: 'postalCode',
  //       passenger: 'passenger',
  //       pickDate: '30-10-2025',
  //       pickTime: '06:00 PM',
  //       journeyType: 'journeyType',
  //       vId: 'vId',
  //       luggage: 'luggage',
  //       childSeat: 'childSeat',
  //       flightNumber: 'flightNumber',
  //       delayTime: 'delayTime',
  //       note: 'note',
  //       journeyDistance: '4',
  //       bookingStatus: 'bookingStatus',
  //       bidStatus: 'bidStatus',
  //       bidNote: ' bidNote',
  //       bookAddDate: '31-10-2025:')
  // ];
  final JobController myController = Get.put(JobController());
  @override
  Widget build(BuildContext context) {
    return Container(
      // backgroundColor: Colors.transparent,
      // insetPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Container(
          width: double.infinity,
          // height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              const BoxShadow(
                blurRadius: 4.0,
                color: Color(0x33000000),
                offset: Offset(0.0, 2.0),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.st!.length,
              itemBuilder: (context, index) {
                final jobItem = widget.st[index];
                return Column(mainAxisSize: MainAxisSize.max, children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '£${jobItem.journeyFare}',
                              textAlign: TextAlign.end,
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              '(Estimated maximum value)',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Montserrat',
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ].divide(const SizedBox(height: 4)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.business,
                          color: Color(0xFF5B68F5),
                          size: 45,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Opacity(
                              opacity: 0.5,
                              child: SizedBox(
                                height: 50,
                                child: VerticalDivider(
                                  thickness: 2,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Time',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                        ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    child: Text(
                                      'Date',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Roboto',
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  70, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '${jobItem.pickTime}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Roboto',
                                          fontSize: 16,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 5, 0, 0),
                                    child: Text(
                                      '${jobItem.pickDate}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Roboto',
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ].divide(const SizedBox(width: 16)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5B68F5),
                                  borderRadius: BorderRadius.circular(50),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: const Color(0xFF5B68F5),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'A',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 4,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE5E7EB),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                    ),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(0, 0, 0, 0.0),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5B68F5),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF5B68F5),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'B',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Open Sans',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 10, bottom: 10),
                                      child: Text(
                                        '${jobItem.pickup}',
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Row(
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.bong,
                                      color: Color(0xFF5B68F5),
                                      size: 18,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '${(double.parse(jobItem.journeyDistance) * 0.621371).toStringAsFixed(2)} Miles ${jobItem.journeyType}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Open Sans',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 15,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 0),
                                      child: Text(
                                        '${jobItem.destination}',
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 15,
                                            ),
                                        overflow: TextOverflow.ellipsis,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FFButtonWidget(
                        onPressed: () async {
                          // Navigator.pop(context);
                          FlutterRingtonePlayer().stop();
                          Vibration.cancel();
                          myController.visiblecontainer.value = true;

                          rejectJob(
                            '${jobItem.jobId}',
                            '${jobItem.bookId}',
                          );
                        },
                        text: 'cancel',
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 15,
                        ),
                        options: FFButtonOptions(
                          height: 50,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24, 0, 24, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: Colors.red,
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                  fontFamily: 'Open Sans',
                                  color: Colors.white,
                                  fontSize: 10),
                          elevation: 3,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          // await sp.setBool('show', true);
                          setState(() {});
                          myController.jobPusherContainer.value = false;
                          // Navigator.pop(context);
                          // myController.visiblecontainer.value = true;
                          myController.isJobDetailDone.value = true;
                          await acceptJob(jobItem.jobId).then((s) {});
                          // isOverlayClosed = true;
                          FlutterRingtonePlayer().stop();
                          Vibration.cancel();
                          // });

                          // );
                        },
                        text: 'Accept',
                        icon: const Icon(
                          Icons.east,
                          size: 15,
                        ),
                        options: FFButtonOptions(
                          height: 50,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24, 0, 24, 0),
                          iconPadding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Open Sans',
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                          elevation: 3,
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ]
                    // .divide(SizedBox(height: 4))
                    // .addToEnd(SizedBox(height: 12)),
                    );
              },
            ),
          )

          // FutureBuilder<List<Job>>(
          //   future: jobDetailsFuture(),
          //   builder: (BuildContext context,
          //       AsyncSnapshot<List<Job>> snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center();
          //     } else if (snapshot.hasError) {
          //       return const Center();
          //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //       return const Center();
          //     } else {
          //       final jobDetails = snapshot.data;
          //       return ListView.builder(
          //         padding: EdgeInsets.zero,
          //         shrinkWrap: true,
          //         scrollDirection: Axis.vertical,
          //         itemCount: jobDetails!.length,
          //         itemBuilder: (context, index) {
          //           final jobItem = jobDetails[index];
          //           return Column(
          //               mainAxisSize: MainAxisSize.max,
          //               children: [
          //                 Padding(
          //                   padding:
          //                       const EdgeInsetsDirectional.fromSTEB(
          //                           0, 0, 0, 8),
          //                   child: Row(
          //                     mainAxisSize: MainAxisSize.max,
          //                     mainAxisAlignment:
          //                         MainAxisAlignment.center,
          //                     children: [
          //                       Column(
          //                         mainAxisSize: MainAxisSize.max,
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.center,
          //                         crossAxisAlignment:
          //                             CrossAxisAlignment.center,
          //                         children: [
          //                           Text(
          //                             '£${jobItem.journeyFare}',
          //                             textAlign: TextAlign.end,
          //                             style: FlutterFlowTheme.of(
          //                                     context)
          //                                 .displaySmall
          //                                 .override(
          //                                   fontFamily: 'Outfit',
          //                                   color: FlutterFlowTheme.of(
          //                                           context)
          //                                       .primaryText,
          //                                   fontSize: 32,
          //                                   fontWeight: FontWeight.w600,
          //                                 ),
          //                           ),
          //                           Text(
          //                             '(Estimated maximum value)',
          //                             style: FlutterFlowTheme.of(
          //                                     context)
          //                                 .labelMedium
          //                                 .override(
          //                                   fontFamily: 'Montserrat',
          //                                   color: FlutterFlowTheme.of(
          //                                           context)
          //                                       .primaryText,
          //                                   fontSize: 14,
          //                                   fontWeight: FontWeight.w500,
          //                                 ),
          //                           ),
          //                         ].divide(const SizedBox(height: 4)),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.all(0),
          //                   child: Row(
          //                     mainAxisSize: MainAxisSize.max,
          //                     mainAxisAlignment:
          //                         MainAxisAlignment.spaceEvenly,
          //                     crossAxisAlignment:
          //                         CrossAxisAlignment.center,
          //                     children: [
          //                       const Icon(
          //                         Icons.business,
          //                         color: Color(0xFF5B68F5),
          //                         size: 45,
          //                       ),
          //                       Row(
          //                         mainAxisSize: MainAxisSize.max,
          //                         children: [
          //                           Opacity(
          //                             opacity: 0.5,
          //                             child: SizedBox(
          //                               height: 50,
          //                               child: VerticalDivider(
          //                                 thickness: 2,
          //                                 color: FlutterFlowTheme.of(
          //                                         context)
          //                                     .secondaryText,
          //                               ),
          //                             ),
          //                           ),
          //                           Padding(
          //                             padding:
          //                                 const EdgeInsetsDirectional
          //                                     .fromSTEB(10, 0, 0, 0),
          //                             child: Column(
          //                               mainAxisSize: MainAxisSize.max,
          //                               children: [
          //                                 Text(
          //                                   'Time',
          //                                   style: FlutterFlowTheme.of(
          //                                           context)
          //                                       .bodyMedium
          //                                       .override(
          //                                         fontFamily: 'Roboto',
          //                                         fontSize: 16,
          //                                       ),
          //                                 ),
          //                                 Padding(
          //                                   padding:
          //                                       const EdgeInsetsDirectional
          //                                           .fromSTEB(
          //                                           0, 15, 0, 0),
          //                                   child: Text(
          //                                     'Date',
          //                                     style:
          //                                         FlutterFlowTheme.of(
          //                                                 context)
          //                                             .bodyMedium
          //                                             .override(
          //                                               fontFamily:
          //                                                   'Roboto',
          //                                               fontSize: 16,
          //                                             ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                           Padding(
          //                             padding:
          //                                 const EdgeInsetsDirectional
          //                                     .fromSTEB(80, 0, 0, 0),
          //                             child: Column(
          //                               mainAxisSize: MainAxisSize.max,
          //                               children: [
          //                                 Text(
          //                                   '${jobItem.pickTime}',
          //                                   style: FlutterFlowTheme.of(
          //                                           context)
          //                                       .bodyMedium
          //                                       .override(
          //                                         fontFamily: 'Roboto',
          //                                         fontSize: 16,
          //                                       ),
          //                                 ),
          //                                 Padding(
          //                                   padding:
          //                                       const EdgeInsetsDirectional
          //                                           .fromSTEB(
          //                                           0, 15, 0, 0),
          //                                   child: Text(
          //                                     '${jobItem.pickDate}',
          //                                     style:
          //                                         FlutterFlowTheme.of(
          //                                                 context)
          //                                             .bodyMedium
          //                                             .override(
          //                                               fontFamily:
          //                                                   'Roboto',
          //                                               fontSize: 16,
          //                                             ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ].divide(const SizedBox(width: 16)),
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.all(12),
          //                   child: Row(
          //                     mainAxisSize: MainAxisSize.max,
          //                     mainAxisAlignment:
          //                         MainAxisAlignment.start,
          //                     children: [
          //                       Column(
          //                         mainAxisSize: MainAxisSize.max,
          //                         children: [
          //                           Align(
          //                             alignment: Alignment.center,
          //                             child: Container(
          //                               width: 30,
          //                               height: 30,
          //                               decoration: BoxDecoration(
          //                                 color:
          //                                     const Color(0xFF5B68F5),
          //                                 borderRadius:
          //                                     BorderRadius.circular(50),
          //                                 shape: BoxShape.rectangle,
          //                                 border: Border.all(
          //                                   color:
          //                                       const Color(0xFF5B68F5),
          //                                   width: 2,
          //                                 ),
          //                               ),
          //                               child: Center(
          //                                 child: Text(
          //                                   'A',
          //                                   style: FlutterFlowTheme.of(
          //                                           context)
          //                                       .bodyMedium
          //                                       .override(
          //                                         fontFamily:
          //                                             'Open Sans',
          //                                         color: FlutterFlowTheme
          //                                                 .of(context)
          //                                             .secondaryBackground,
          //                                         fontSize: 18,
          //                                         fontWeight:
          //                                             FontWeight.w300,
          //                                       ),
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                           Padding(
          //                             padding: const EdgeInsets.only(
          //                               top: 5,
          //                               left: 25,
          //                             ),
          //                             child: Stack(
          //                               children: [
          //                                 Align(
          //                                   alignment: Alignment.center,
          //                                   child: Container(
          //                                     width: 4,
          //                                     height: 80,
          //                                     decoration:
          //                                         const BoxDecoration(
          //                                       color:
          //                                           Color(0xFFE5E7EB),
          //                                     ),
          //                                   ),
          //                                 ),
          //                                 Padding(
          //                                   padding:
          //                                       const EdgeInsets.only(
          //                                     top: 25,
          //                                   ),
          //                                   child: Container(
          //                                     width: 30,
          //                                     height: 30,
          //                                     decoration:
          //                                         const BoxDecoration(
          //                                       color: Color.fromRGBO(
          //                                           0, 0, 0, 0.0),
          //                                       shape: BoxShape.circle,
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                           Padding(
          //                             padding:
          //                                 const EdgeInsets.only(top: 5),
          //                             child: Container(
          //                               width: 30,
          //                               height: 30,
          //                               decoration: BoxDecoration(
          //                                 color:
          //                                     const Color(0xFF5B68F5),
          //                                 shape: BoxShape.circle,
          //                                 border: Border.all(
          //                                   color:
          //                                       const Color(0xFF5B68F5),
          //                                   width: 2,
          //                                 ),
          //                               ),
          //                               child: Center(
          //                                 child: Text(
          //                                   'B',
          //                                   style: FlutterFlowTheme.of(
          //                                           context)
          //                                       .bodyMedium
          //                                       .override(
          //                                         fontFamily:
          //                                             'Open Sans',
          //                                         color: FlutterFlowTheme
          //                                                 .of(context)
          //                                             .secondaryBackground,
          //                                         fontSize: 18,
          //                                         fontWeight:
          //                                             FontWeight.w300,
          //                                       ),
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                       const SizedBox(width: 20),
          //                       // Added SizedBox for spacing
          //                       Expanded(
          //                         child: Column(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.start,
          //                           children: [
          //                             Row(
          //                               children: [
          //                                 Flexible(
          //                                   child: Padding(
          //                                     padding:
          //                                         const EdgeInsets.only(
          //                                             left: 10,
          //                                             top: 10,
          //                                             bottom: 20),
          //                                     child: Text(
          //                                       '${jobItem.pickup}',
          //                                       style:
          //                                           FlutterFlowTheme.of(
          //                                                   context)
          //                                               .labelMedium
          //                                               .override(
          //                                                 fontFamily:
          //                                                     'Readex Pro',
          //                                                 color: FlutterFlowTheme.of(
          //                                                         context)
          //                                                     .secondaryText,
          //                                                 fontSize: 15,
          //                                               ),
          //                                       overflow: TextOverflow
          //                                           .ellipsis,
          //                                       maxLines: 3,
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                             Padding(
          //                               padding: const EdgeInsets.only(
          //                                   bottom: 40),
          //                               child: Row(
          //                                 children: [
          //                                   const FaIcon(
          //                                     FontAwesomeIcons.bong,
          //                                     color: Color(0xFF5B68F5),
          //                                     size: 18,
          //                                   ),
          //                                   Padding(
          //                                     padding:
          //                                         const EdgeInsets.only(
          //                                             left: 8),
          //                                     child: Text(
          //                                       '${(double.parse(jobItem.journeyDistance) * 0.621371).toStringAsFixed(2)} Miles ${jobItem.journeyType}',
          //                                       overflow: TextOverflow
          //                                           .ellipsis,
          //                                       maxLines: 1,
          //                                       style:
          //                                           FlutterFlowTheme.of(
          //                                                   context)
          //                                               .bodyMedium
          //                                               .override(
          //                                                 fontFamily:
          //                                                     'Open Sans',
          //                                                 color: FlutterFlowTheme.of(
          //                                                         context)
          //                                                     .secondaryText,
          //                                                 fontSize: 16,
          //                                               ),
          //                                     ),
          //                                   ),
          //                                 ],
          //                               ),
          //                             ),
          //                             Row(
          //                               children: [
          //                                 Flexible(
          //                                   child: Padding(
          //                                     padding:
          //                                         const EdgeInsets.only(
          //                                             left: 10,
          //                                             top: 10,
          //                                             bottom: 20),
          //                                     child: Text(
          //                                       '${jobItem.destination}',
          //                                       style:
          //                                           FlutterFlowTheme.of(
          //                                                   context)
          //                                               .labelMedium
          //                                               .override(
          //                                                 fontFamily:
          //                                                     'Readex Pro',
          //                                                 color: FlutterFlowTheme.of(
          //                                                         context)
          //                                                     .secondaryText,
          //                                                 fontSize: 15,
          //                                               ),
          //                                       overflow: TextOverflow
          //                                           .ellipsis,
          //                                       maxLines: 3,
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 Row(
          //                   mainAxisAlignment:
          //                       MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     FFButtonWidget(
          //                       onPressed: () async {
          //                         // closeOverlay();
          //                         //  myController.visiblecontainer.value = true;
          //                         rejectJob(
          //                           '${jobItem.jobId}',
          //                           '${jobItem.bookId}',
          //                         );
          //                       },
          //                       text: 'cancel',
          //                       icon: const Icon(
          //                         Icons.delete_outline,
          //                         size: 15,
          //                       ),
          //                       options: FFButtonOptions(
          //                         height: 50,
          //                         padding: const EdgeInsetsDirectional
          //                             .fromSTEB(24, 0, 24, 0),
          //                         iconPadding:
          //                             const EdgeInsetsDirectional
          //                                 .fromSTEB(0, 0, 0, 0),
          //                         color: Colors.red,
          //                         textStyle:
          //                             FlutterFlowTheme.of(context)
          //                                 .titleSmall
          //                                 .override(
          //                                     fontFamily: 'Open Sans',
          //                                     color: Colors.white,
          //                                     fontSize: 10),
          //                         elevation: 3,
          //                         borderSide: const BorderSide(
          //                           color: Colors.transparent,
          //                           width: 1,
          //                         ),
          //                         borderRadius:
          //                             BorderRadius.circular(8),
          //                       ),
          //                     ),
          //                     FFButtonWidget(
          //                       onPressed: () async {
          //                         // SharedPreferences prefs = await SharedPreferences.getInstance();
          //                         // prefs.setBool('visiblecontainer', true);
          //                         // Navigator.pop(context);
          //                         // Call acceptJob function
          //                         myController.visiblecontainer.value =
          //                             true;
          //                         await acceptJob(jobItem.jobId)
          //                             .then((s) {
          //                           // isOverlayClosed = true;
          //                           FlutterRingtonePlayer.stop();
          //                           Vibration.cancel();
          //                         });
          //                         // Navigator.push(context, MaterialPageRoute(builder: (context)=> NavBarPage(page:HomeWidget(),))
          //                         // Navigate to NavBarPage with index 0

          //                         // );
          //                       },
          //                       text: 'Accept',
          //                       icon: const Icon(
          //                         Icons.east,
          //                         size: 15,
          //                       ),
          //                       options: FFButtonOptions(
          //                         height: 50,
          //                         padding: const EdgeInsetsDirectional
          //                             .fromSTEB(24, 0, 24, 0),
          //                         iconPadding:
          //                             const EdgeInsetsDirectional
          //                                 .fromSTEB(0, 0, 0, 0),
          //                         color: FlutterFlowTheme.of(context)
          //                             .primary,
          //                         textStyle:
          //                             FlutterFlowTheme.of(context)
          //                                 .titleSmall
          //                                 .override(
          //                                   fontFamily: 'Open Sans',
          //                                   color: Colors.white,
          //                                   fontSize: 10,
          //                                 ),
          //                         elevation: 3,
          //                         borderSide: const BorderSide(
          //                           color: Colors.transparent,
          //                           width: 1,
          //                         ),
          //                         borderRadius:
          //                             BorderRadius.circular(8),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ]
          //               // .divide(SizedBox(height: 4))
          //               // .addToEnd(SizedBox(height: 12)),
          //               );
          //         },
          //       );
          //     }
          //   },
          // ),
          ),
    );
  }
}
