import 'dart:async';

import 'package:flutter/material.dart';
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
  String _distanceText(Job job) {
    final distance = double.tryParse(job.journeyDistance);
    final journeyType =
        job.journeyType.trim().isEmpty ? '' : ' ${job.journeyType}';

    if (distance == null) {
      final rawDistance = job.journeyDistance.trim();
      return rawDistance.isEmpty
          ? journeyType.trim()
          : '$rawDistance$journeyType';
    }

    return '${(distance * 0.621371).toStringAsFixed(2)} Miles$journeyType';
  }

  Future<bool> acceptJob(Job job) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final previouslyStickyJob =
        myController.listFromPusher.isNotEmpty
            ? myController.listFromPusher.first
            : null;
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
        print('Job accepted successfully');
        final currentRideState = prefs.getInt('isRideStart') ?? 0;
        await prefs.setBool('jobDispatched', true);
        if (currentRideState == 0) {
          await prefs.setInt('isRideStart', 0);
          await prefs.setString('jobFlowStage', 'accepted');
        }
        await prefs.setString('jobId', job.jobId);
        await prefs.setString('bookingid', job.bookId);
        await prefs.setString('c_id', job.cId);
        await prefs.setString('d_id_for_job', job.dId);
        await prefs.setString('journey_fare', job.journeyFare);
        await prefs.setString('booking_fee', job.bookingFee);
        await prefs.setString('car_parking', job.carParking);
        await prefs.setString('extra', job.extra);
        await prefs.setString('waiting', job.waiting);
        await prefs.setString('tolls', job.tolls);
        await prefs.setString('pickDate', job.pickDate);
        await prefs.setString('pickTime', job.pickTime);
        await prefs.setString('pickLocation', job.pickup);
        await prefs.setString('dropLocation', job.destination);
        await prefs.setString('totalFee', job.totalFee ?? '');
        await prefs.setString('job_note', job.jobNote);
        await prefs.setString('job_status', job.jobStatus);
        await prefs.setString('date_job_add', job.dateJobAdd);
        await prefs.setString('c_name', job.cName);
        await prefs.setString('c_email', job.cEmail);
        await prefs.setString('c_phone', job.cPhone);
        await prefs.setString('c_address', job.cAddress);
        await prefs.setString('d_name', job.dName);
        await prefs.setString('d_email', job.dEmail);
        await prefs.setString('d_phone', job.dPhone);
        await prefs.setString('b_type_id', job.bTypeId);
        await prefs.setString('address', job.address);
        await prefs.setString('postal_code', job.postalCode);
        await prefs.setString('passenger', job.passenger);
        await prefs.setString('journey_type', job.journeyType);
        await prefs.setString('v_id', job.vId);
        await prefs.setString('luggage', job.luggage);
        await prefs.setString('child_seat', job.childSeat);
        await prefs.setString('flight_number', job.flightNumber);
        await prefs.setString('delay_time', job.delayTime);
        await prefs.setString('note', job.note);
        await prefs.setString('journey_distance', job.journeyDistance);
        await prefs.setString('booking_status', job.bookingStatus);
        await prefs.setString('bid_status', job.bidStatus);
        await prefs.setString('bid_note', job.bidNote);
        await prefs.setString('book_add_date', job.bookAddDate);

        await myController.rememberAcceptedJob(job);
        myController.pendingDispatchJobs.clear();
        myController.jobPusherContainer.value = false;
        myController.isJobDetailDone.value = false;
        myController.clearNavigationRoute();

        print('object0');
        await myController.jobDetails();
        if (myController.listFromPusher.isEmpty) {
          final fallbackJob =
              myController.earliestAcceptedJob([
                if (previouslyStickyJob != null) previouslyStickyJob,
                job,
              ]) ??
              job;
          myController.listFromPusher
            ..clear()
            ..add(fallbackJob);
          myController.visiblecontainer.value = true;
        }

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

  Future<void> _refreshMapboxRoute(double destinationLat, double desLng) async {
    try {
      final originLat =
          myController.currentLocation?.latitude ?? myController.latitude.value;
      final originLng =
          myController.currentLocation?.longitude ??
          myController.longitude.value;
      if (originLat == 0.0 || originLng == 0.0) {
        return;
      }
      await myController.getdistanceandtime(
        destinationLat,
        desLng,
        originLat: originLat,
        originLng: originLng,
      );
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('route update failed: $e');
    }
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
        _refreshMapboxRoute(
          locations.first.latitude,
          locations.first.longitude,
        );
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> rejectJob(String jobId, String bookId) async {
    final navigator = Navigator.of(context);
    SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      var url = Uri.parse(ApiService.driverCancelBooking);
      var response = await http.post(
        url,
        body: {'book_id': bookId.toString(), 'job_id': jobId.toString()},
      );
      if (response.statusCode == 200) {
        final rejectedJobId = jobId.trim();
        final rejectedBookId = bookId.trim();
        await myController.rememberRejectedJobByIds(
          jobId: rejectedJobId,
          bookId: rejectedBookId,
        );
        myController.pendingDispatchJobs.removeWhere((pendingJob) {
          final sameJobId =
              rejectedJobId.isNotEmpty &&
              pendingJob.jobId.trim() == rejectedJobId;
          final sameBookId =
              rejectedBookId.isNotEmpty &&
              pendingJob.bookId.trim() == rejectedBookId;
          return sameJobId || sameBookId;
        });
        myController.jobPusherContainer.value =
            myController.pendingDispatchJobs.isNotEmpty;

        final storedJobId = (sp.getString('jobId') ?? '').trim();
        final storedBookId = (sp.getString('bookingid') ?? '').trim();
        final rejectedAcceptedJob =
            (storedJobId.isNotEmpty && storedJobId == rejectedJobId) ||
            (storedBookId.isNotEmpty && storedBookId == rejectedBookId);
        if (rejectedAcceptedJob) {
          await sp.remove('jobDispatched');
        }
        if (widget.isfromUi != true && navigator.canPop()) {
          navigator.pop();
        }
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
    if (widget.st.isEmpty) {
      return const SizedBox.shrink();
    }

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
                                      _distanceText(jobItem),
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
                          FlutterRingtonePlayer().stop();
                          Vibration.cancel();
                          final navigator = Navigator.of(context);
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
                            if (navigator.canPop()) {
                              navigator.pop();
                            }
                            await navigator.push(
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
