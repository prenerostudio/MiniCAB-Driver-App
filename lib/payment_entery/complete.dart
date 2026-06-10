import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:new_minicab_driver/Acount%20Statements/acount_statements_widget.dart';
import 'package:new_minicab_driver/Data/api_service.dart';
import 'package:new_minicab_driver/home/home_view_controller.dart';
import 'package:new_minicab_driver/main.dart';
import 'package:new_minicab_driver/mapbox/mapbox_route_map.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class CompleteWidget extends StatefulWidget {
  const CompleteWidget({super.key, this.isfromfare});

  final bool? isfromfare;

  @override
  State<CompleteWidget> createState() => _CompleteWidgetState();
}

class _CompleteWidgetState extends State<CompleteWidget> {
  static const _ink = Color(0xFF101820);
  static const _muted = Color(0xFF69756F);
  static const _surface = Color(0xFFF4F7F5);
  static const _line = Color(0xFFE1E7E3);
  static const _gold = Color(0xFFE2A84F);
  static const _success = Color(0xFF1D8F5A);
  static const _danger = Color(0xFFE04444);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final JobController myController = Get.put(JobController());
  List<LatLng> _completionRoute = [];

  String totalFee = '0.0';
  String jounreryFare = '0.0';
  String parking = '0.0';
  String tolls = '0.0';
  String extra = '0.0';
  String did = '0.0';
  String waiting = '0.0';
  String time = '--';
  String jobid = '--';
  String pickupDate = '--';
  String pickupTime = '--';
  String pickUplocation = '--';
  String dropOflocation = '--';
  String jobAccptTime = '--';
  String jobStart = '--';
  String waytoPickup = '--';
  String arrivalTime = '--';
  String pobTime = '--';
  String dropOffTime = '--';
  String formattedTime = '';
  bool isrequest = false;

  @override
  void initState() {
    super.initState();
    fetchAndSaveFares();
  }

  Future<void> getCompleteViewData() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt('isRideStart', 3);
    time = sp.getString('timerValue') ?? '';
    totalFee = sp.getString('totalFee') ?? '';
    jounreryFare = sp.getString('journey_fare') ?? '';
    parking = sp.getString('car_parking') ?? '';
    tolls = sp.getString('tolls') ?? '';
    extra = sp.getString('extra') ?? '';
    waiting = sp.getString('waiting') ?? '';
    jobid = sp.getString('jobId') ?? '';
    pickupDate = sp.getString('pickDate') ?? '';
    pickupTime = sp.getString('pickTime') ?? '';
    pickUplocation = sp.getString('pickLocation') ?? '';
    dropOflocation = sp.getString('dropLocation') ?? '';
    jobAccptTime = sp.getString('jobAcceptedTime') ?? '';
    jobStart = sp.getString('jobStartTime') ?? '';
    waytoPickup = sp.getString('jobWayToPickupTime') ?? '';
    arrivalTime = sp.getString('jobArrivalNowTime') ?? '';
    pobTime = sp.getString('jobPOBTime') ?? '';
    dropOffTime = sp.getString('jobAtDropOffTime') ?? '';
    _completionRoute = _routeFromStorage(sp);
    if (_completionRoute.isEmpty) {
      _completionRoute = myController.decodedPoints.toList();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> fetchAndSaveFares() async {
    final sp = await SharedPreferences.getInstance();
    jobid = sp.getString('jobId') ?? '';
    if (mounted) {
      setState(() {});
    }

    try {
      final response = await http.post(
        Uri.parse(ApiService.driverFetchFares),
        body: {'job_id': jobid},
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final data = responseBody['data'];
        if (responseBody['status'] == true && data is List && data.isNotEmpty) {
          final fare = data.first as Map<String, dynamic>;
          final journeyFare = fare['journey_fare']?.toString() ?? '0';
          final carParking = fare['car_parking']?.toString() ?? '0';
          final waitFare = fare['waiting']?.toString() ?? '0';
          final tollFees = fare['tolls']?.toString() ?? '0';
          final extras = fare['extras']?.toString() ?? '0';
          final total =
              _parseAmount(journeyFare) +
              _parseAmount(carParking) +
              _parseAmount(waitFare) +
              _parseAmount(tollFees) +
              _parseAmount(extras);

          await saveData(
            journeyFare,
            carParking,
            extras,
            waitFare,
            tollFees,
            total.toStringAsFixed(2),
          );
        }
      }
    } catch (_) {
      // Fall back to locally saved fare data below.
    }

    await getCompleteViewData();
  }

  Future<void> saveData(
    String jfare,
    String carparking,
    String extra,
    String waiting,
    String tolls,
    String totalFee,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('journey_fare', jfare);
    await prefs.setString('car_parking', carparking);
    await prefs.setString('extra', extra);
    await prefs.setString('waiting', waiting);
    await prefs.setString('tolls', tolls);
    await prefs.setString('totalFee', totalFee);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> completeJob() async {
    if (isrequest) {
      return;
    }

    final sp = await SharedPreferences.getInstance();
    _getCurrentTime();

    if (mounted) {
      setState(() {
        isrequest = true;
      });
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final dId = prefs.getString('d_id');
      final cid = prefs.getString('c_id');
      final routeData =
          prefs.getStringList('user_route') ??
          _completionRoute
              .map((point) => '${point.latitude},${point.longitude}')
              .toList();
      final coordinatesString = routeData.join(',');

      final response = await http.post(
        Uri.parse(ApiService.driverCompleteJob),
        body: {
          'job_id': jobid,
          'd_id': dId.toString(),
          'c_id': cid ?? '',
          'journey_fare': jounreryFare,
          'car_parking': parking,
          'extra': extra,
          'waiting': waiting,
          'tolls': tolls,
          'job_accepted_time': jobAccptTime,
          'job_started_time': jobStart,
          'way_to_pickup_time': waytoPickup,
          'arrived_at_pickup_time': arrivalTime,
          'pob_time': pobTime,
          'dropoff_time': dropOffTime,
          'job_completed_time': formattedTime,
          'driver_route': coordinatesString,
        },
      );

      if (response.statusCode == 200) {
        myController.visiblecontainer.value = false;
        myController.jobPusherContainer.value = false;
        myController.listFromPusher.clear();
        myController.pendingDispatchJobs.clear();
        myController.clearNavigationRoute();
        await myController.rememberCompletedJobByIds(
          jobId: prefs.getString('jobId') ?? jobid,
          bookId: prefs.getString('bookingid') ?? '',
        );
        await _clearCompletedJobPrefs(sp);
        await sp.setInt('isRideStart', 0);

        if (!mounted) {
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => NavBarPage(
                  initialPage: 'AcountStatements',
                  page: AcountStatementsWidget(),
                ),
          ),
        );
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.reasonPhrase ?? 'Could not complete job.'),
            backgroundColor: context.appTheme.error,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not complete job. Please try again.'),
            backgroundColor: context.appTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isrequest = false;
        });
      }
    }
  }

  Future<void> _clearCompletedJobPrefs(SharedPreferences sp) async {
    await sp.remove('isWaitingTrue');
    await sp.remove('arrivalDone');
    await sp.remove('jobDispatched');
    await sp.remove('acceptedJobKeys');
    await sp.remove('jobId');
    await sp.remove('bookingid');
    await sp.remove('c_id');
    await sp.remove('jobAcceptedTime');
    await sp.remove('jobAtDropOffTime');
    await sp.remove('jobPOBTime');
    await sp.remove('jobArrivalNowTime');
    await sp.remove('jobWayToPickupTime');
    await sp.remove('jobStartTime');
    await sp.remove('jobFlowStage');
    await sp.remove('passengerBoardingStartedAt');
    await sp.remove('passengerBoardingSeconds');
    await sp.remove('timerValue');
    await sp.remove('user_route');
    await sp.remove('pickLocation');
    await sp.remove('dropLocation');
    await sp.remove('pickDate');
    await sp.remove('pickTime');
  }

  void _getCurrentTime() {
    final now = DateTime.now();
    final formatter = DateFormat('HH:mm a');
    if (mounted) {
      setState(() {
        formattedTime = formatter.format(now);
      });
    } else {
      formattedTime = formatter.format(now);
    }
  }

  double _parseAmount(String value) {
    return double.tryParse(value.replaceAll(',', '').trim()) ?? 0;
  }

  String _display(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? '--' : trimmed;
  }

  String _money(String value) {
    final amount = _parseAmount(value);
    return '${String.fromCharCode(163)}${amount.toStringAsFixed(2)}';
  }

  String get _totalPayable {
    return totalFee.trim().isEmpty || totalFee.trim() == '0'
        ? _money(jounreryFare)
        : _money(totalFee);
  }

  List<LatLng> _routeFromStorage(SharedPreferences prefs) {
    final routeData = prefs.getStringList('user_route') ?? const <String>[];
    return routeData
        .map((item) {
          final parts = item.split(',');
          if (parts.length < 2) {
            return null;
          }

          final latitude = double.tryParse(parts[0].trim());
          final longitude = double.tryParse(parts[1].trim());
          if (latitude == null || longitude == null) {
            return null;
          }

          return LatLng(latitude, longitude);
        })
        .whereType<LatLng>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: true,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: _surface,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 14),
                        _buildRouteSection(context),
                        const SizedBox(height: 12),
                        _buildFareSection(context),
                        const SizedBox(height: 12),
                        _buildTimelineSection(context),
                      ],
                    ),
                  ),
                ),
                _buildBottomAction(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _ink,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            blurRadius: 18,
            color: Color(0x1F000000),
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: _success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Job Complete',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.appTheme.titleLarge.override(
                        fontFamily: 'Open Sans',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Job ${_display(jobid)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.appTheme.bodySmall.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: const Color(0xFFB7C0BC),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildHeaderMetric(
                  context,
                  label: 'Client pays',
                  value: _totalPayable,
                  icon: Icons.payments_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildHeaderMetric(
                  context,
                  label: 'Pay by',
                  value: 'Cash',
                  icon: FontAwesomeIcons.moneyBill1Wave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderMetric(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF18252A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF253238)),
      ),
      child: Row(
        children: [
          Icon(icon, color: _gold, size: 20),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.appTheme.bodySmall.override(
                    fontFamily: 'Plus Jakarta Sans',
                    color: const Color(0xFFB7C0BC),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.appTheme.bodyMedium.override(
                    fontFamily: 'Open Sans',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Journey',
      icon: Icons.route_rounded,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCompactInfo(
                context,
                label: 'Pickup date',
                value: _display(pickupDate),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCompactInfo(
                context,
                label: 'Pickup time',
                value: _display(pickupTime),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildRouteMap(context),
        const SizedBox(height: 14),
        _buildLocationRow(
          context,
          label: 'Pickup',
          value: _display(pickUplocation),
          color: _success,
          icon: Icons.trip_origin_rounded,
        ),
        const SizedBox(height: 12),
        _buildLocationRow(
          context,
          label: 'Dropoff',
          value: _display(dropOflocation),
          color: _danger,
          icon: Icons.flag_rounded,
        ),
      ],
    );
  }

  Widget _buildRouteMap(BuildContext context) {
    if (_completionRoute.length < 2) {
      return Container(
        height: 170,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _line),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.route_rounded, color: _muted, size: 28),
            const SizedBox(height: 8),
            Text(
              'Route will appear when tracking data is available',
              textAlign: TextAlign.center,
              style: context.appTheme.bodySmall.override(
                fontFamily: 'Plus Jakarta Sans',
                color: _muted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 190,
        child: MapboxRouteMap(
          center: _completionRoute.first,
          route: _completionRoute,
          initialZoom: 12.5,
          routeColor: _success,
          fitRoute: true,
          markers: [
            MapboxRouteMarker(
              id: 'completed_route_start',
              point: _completionRoute.first,
              color: _success,
            ),
            MapboxRouteMarker(
              id: 'completed_route_end',
              point: _completionRoute.last,
              color: _danger,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFareSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Fare Details',
      icon: Icons.receipt_long_rounded,
      children: [
        _buildAmountRow(context, 'Journey fare', _money(jounreryFare)),
        _buildAmountRow(
          context,
          'Waiting (${_display(time)})',
          _money(waiting),
        ),
        _buildAmountRow(context, 'Parking', _money(parking)),
        _buildAmountRow(context, 'Tolls', _money(tolls)),
        _buildAmountRow(context, 'Extra', _money(extra)),
        const Divider(height: 24, color: _line),
        _buildAmountRow(context, 'Total', _totalPayable, isEmphasis: true),
      ],
    );
  }

  Widget _buildTimelineSection(BuildContext context) {
    final items = [
      ('Accepted', jobAccptTime, Icons.done_rounded),
      ('Started', jobStart, Icons.play_arrow_rounded),
      ('Way to pickup', waytoPickup, Icons.near_me_rounded),
      ('Arrival at pickup', arrivalTime, Icons.location_on_rounded),
      ('POB', pobTime, Icons.airline_seat_recline_normal_rounded),
      ('Dropoff', dropOffTime, Icons.flag_rounded),
    ];

    return _buildSection(
      context,
      title: 'Time Tracking',
      icon: Icons.schedule_rounded,
      children:
          items
              .map(
                (item) => _buildTimelineRow(
                  context,
                  label: item.$1,
                  value: _display(item.$2),
                  icon: item.$3,
                ),
              )
              .toList(),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            color: Color(0x0F000000),
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: _ink),
              const SizedBox(width: 8),
              Text(
                title,
                style: context.appTheme.bodyLarge.override(
                  fontFamily: 'Open Sans',
                  color: _ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCompactInfo(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.appTheme.bodySmall.override(
              fontFamily: 'Plus Jakarta Sans',
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.appTheme.bodyMedium.override(
              fontFamily: 'Open Sans',
              color: _ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.appTheme.bodySmall.override(
                  fontFamily: 'Plus Jakarta Sans',
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.appTheme.bodyMedium.override(
                  fontFamily: 'Plus Jakarta Sans',
                  color: _ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow(
    BuildContext context,
    String label,
    String value, {
    bool isEmphasis = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.appTheme.bodyMedium.override(
                fontFamily: 'Plus Jakarta Sans',
                color: isEmphasis ? _ink : _muted,
                fontSize: isEmphasis ? 15 : 13,
                fontWeight: isEmphasis ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: context.appTheme.bodyMedium.override(
              fontFamily: 'Open Sans',
              color: isEmphasis ? _success : _ink,
              fontSize: isEmphasis ? 18 : 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _line),
            ),
            child: Icon(icon, color: _ink, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.appTheme.bodyMedium.override(
                fontFamily: 'Plus Jakarta Sans',
                color: _ink,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: context.appTheme.bodyMedium.override(
              fontFamily: 'Open Sans',
              color: _muted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _line)),
      ),
      child:
          isrequest
              ? const SizedBox(
                height: 52,
                child: Center(child: CircularProgressIndicator()),
              )
              : FFButtonWidget(
                onPressed: completeJob,
                text: 'Complete Job',
                icon: const Icon(Icons.check_circle_rounded, size: 18),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 52,
                  padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 18, 0),
                  color: _ink,
                  textStyle: context.appTheme.titleSmall.override(
                    fontFamily: 'Open Sans',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  elevation: 0,
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
    );
  }
}
