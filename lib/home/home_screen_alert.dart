import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:new_minicab_driver/Model/jobDetails.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import 'package:new_minicab_driver/flutter_flow/flutter_flow_util.dart';
import 'package:new_minicab_driver/flutter_flow/flutter_flow_widgets.dart';
import 'package:new_minicab_driver/home/home_view_controller.dart';
import 'package:new_minicab_driver/home/home_widget.dart';
import 'package:new_minicab_driver/main.dart';
// import 'package:latlong2/latlong.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;

export 'home_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:new_minicab_driver/Data/api_service.dart';

class HomeScreenAlert extends StatefulWidget {
  List<Job> st;
  double? height;
  bool? isfromUi;
  HomeScreenAlert({super.key, required this.st, this.height, this.isfromUi});

  @override
  State<HomeScreenAlert> createState() => _HomeScreenAlertState();
}

class _HomeScreenAlertState extends State<HomeScreenAlert> {
  Future<bool> acceptJob(Job job) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String? dId = prefs.getString('d_id');
      var fields = {
        'job_id': job.jobId.toString(),
        'book_id': job.bookId.toString(),
        'd_id': dId.toString(),
      };
      var uri = Uri.parse(ApiService.driverAcceptJob);

      var response = await http.post(uri, body: fields);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        print('Job accepted successfully');
        await prefs.setBool('jobDispatched', true);
        await prefs.setString('jobId', job.jobId);
        await prefs.setString('bookingid', job.bookId);

        myController.listFromPusher
          ..clear()
          ..add(job);
        myController.visiblecontainer.value = true;
        myController.jobPusherContainer.value = false;
        myController.isJobDetailDone.value = false;

        print('object0');
        final acceptedPickup =
            jsonData['data'] is List && jsonData['data'].isNotEmpty
                ? jsonData['data'][0]['pickup']?.toString()
                : null;
        await getCoordinatesFromAddress(acceptedPickup ?? job.pickup);

        return true;
      } else {
        print('Failed to accept job. Status Code: ${response.statusCode}');
        print('Reason: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }
    return false;
  }

  Future _getPolyline(double destinationLat, double desLng) async {
    print('tapped');
    var origin =
        '${myController.currentLocation?.latitude},${myController.currentLocation?.longitude}'; // Replace with your source coordinates
    var destination =
        // '31.414050,73.0613070'; // Replace with your destination coordinates // Replace with your destination coordinates
        '$destinationLat,$desLng';
    // var destination =
    // // '31.414050,73.0613070'; // Replace with your destination coordinates // Replace with your destination coordinates
    // '${31.3637197},${73.0553336}';
    try {
      final response = await http.post(
        Uri.parse(
          ApiService.googleDirectionsUrl(
            origin: origin,
            destination: destination,
            apiKey: apiKey,
          ),
        ),
      );
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
              decodedPoints =
                  PolylinePoints()
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
          'convert Latitude: ${myController.convertedLat.value}, convert longitude: ${myController.convertedLng.value}',
        );
        _getPolyline(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> rejectJob(String jobId, String bookId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      var url = Uri.parse(ApiService.driverCancelBooking);
      var response = await http.post(
        url,
        body: {'book_id': bookId.toString(), 'job_id': jobId.toString()},
      );
      if (response.statusCode == 200) {
        myController.jobPusherContainer.value = false;
        await sp.remove('jobDispatched');
        Navigator.pop(context);
        print(response.body);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  final JobController myController = Get.put(JobController());
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        color: context.appTheme.secondaryBackground,
        boxShadow: [
          const BoxShadow(
            blurRadius: 4.0,
            color: Color(0x33000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: widget.st.length,
            itemBuilder: (context, index) {
              final jobItem = widget.st[index];
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
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
                              style: context.appTheme.displaySmall.override(
                                fontFamily: 'Outfit',
                                color: context.appTheme.primaryText,
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '(Estimated maximum value)',
                              style: context.appTheme.labelMedium.override(
                                fontFamily: 'Montserrat',
                                color: context.appTheme.primaryText,
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
                                  color: context.appTheme.secondaryText,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                0,
                                0,
                                0,
                                0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Time',
                                    style: context.appTheme.bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          0,
                                          0,
                                          0,
                                        ),
                                    child: Text(
                                      'Date',
                                      style: context.appTheme.bodyMedium
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
                                70,
                                0,
                                0,
                                0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    jobItem.pickTime,
                                    style: context.appTheme.bodyMedium.override(
                                      fontFamily: 'Roboto',
                                      fontSize: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      5,
                                      0,
                                      0,
                                    ),
                                    child: Text(
                                      jobItem.pickDate,
                                      style: context.appTheme.bodyMedium
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
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
                                    style: context.appTheme.bodyMedium.override(
                                      fontFamily: 'Open Sans',
                                      color:
                                          context.appTheme.secondaryBackground,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
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
                                    padding: const EdgeInsets.only(top: 5),
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
                                    style: context.appTheme.bodyMedium.override(
                                      fontFamily: 'Open Sans',
                                      color:
                                          context.appTheme.secondaryBackground,
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
                                        left: 0,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        jobItem.pickup,
                                        style: context.appTheme.labelMedium
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  context
                                                      .appTheme
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
                                    SizedBox(width: 10),
                                    Text(
                                      '${(double.parse(jobItem.journeyDistance) * 0.621371).toStringAsFixed(2)} Miles ${jobItem.journeyType}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: context.appTheme.bodyMedium
                                          .override(
                                            fontFamily: 'Open Sans',
                                            color:
                                                context.appTheme.secondaryText,
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
                                        top: 10,
                                        bottom: 0,
                                      ),
                                      child: Text(
                                        jobItem.destination,
                                        style: context.appTheme.labelMedium
                                            .override(
                                              fontFamily: 'Readex Pro',
                                              color:
                                                  context
                                                      .appTheme
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
                          myController.visiblecontainer.value = false;

                          rejectJob(jobItem.jobId, jobItem.bookId);
                        },
                        text: 'cancel',
                        icon: const Icon(Icons.delete_outline, size: 15),
                        options: FFButtonOptions(
                          height: 50,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            24,
                            0,
                            24,
                            0,
                          ),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                            0,
                            0,
                            0,
                            0,
                          ),
                          color: Colors.red,
                          textStyle: context.appTheme.titleSmall.override(
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
                      FFButtonWidget(
                        onPressed: () async {
                          SharedPreferences sp =
                              await SharedPreferences.getInstance();
                          // await sp.setBool('show', true);
                          setState(() {});
                          myController.jobPusherContainer.value = false;
                          _getCurrentTime();
                          await sp.setString('jobAcceptedTime', formattedTime);
                          // myController.visiblecontainer.value = true;
                          myController.isJobDetailDone.value = true;
                          final accepted = await acceptJob(jobItem);
                          if (accepted) {
                            myController.visiblecontainer.value = true;
                            myController.jobPusherContainer.value = false;
                            myController.isJobDetailDone.value = false;
                          }
                          // isOverlayClosed = true;
                          FlutterRingtonePlayer().stop();
                          Vibration.cancel();
                          if (widget.isfromUi == true) {
                            // Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => NavBarPage(
                            //               initialPage: 'Home',
                            //               page: HomeWidget(),
                            //             )));
                          } else {
                            // Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => NavBarPage(
                                      initialPage: 'Home',
                                      page: HomeWidget(),
                                    ),
                              ),
                            );
                          }
                          // if (myController.isscreenHome.value == false) {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => NavBarPage(
                          //                 initialPage: 'Home',
                          //                 page: HomeWidget(),
                          //               )));
                          // }
                          // });

                          // );
                        },
                        text: 'Accept',
                        icon: const Icon(Icons.east, size: 15),
                        options: FFButtonOptions(
                          height: 50,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            24,
                            0,
                            24,
                            0,
                          ),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                            0,
                            0,
                            0,
                            0,
                          ),
                          color: context.appTheme.primary,
                          textStyle: context.appTheme.titleSmall.override(
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
                ],
                // .divide(SizedBox(height: 4))
                // .addToEnd(SizedBox(height: 12)),
              );
            },
          ),
        ),
      ),
    );
  }

  void _getCurrentTime() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm a');
    setState(() {
      formattedTime = formatter.format(now);
    });
  }

  String formattedTime = "";
}
