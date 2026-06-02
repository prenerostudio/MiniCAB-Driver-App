import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:new_minicab_driver/Data/api_service.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/resentJobs.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'jobshistory_model.dart';

export 'jobshistory_model.dart';

class JobshistoryWidget extends StatefulWidget {
  const JobshistoryWidget({super.key, required this.did});

  final String? did;

  @override
  State<JobshistoryWidget> createState() => _JobshistoryWidgetState();
}

class _JobshistoryWidgetState extends State<JobshistoryWidget>
    with TickerProviderStateMixin {
  late JobshistoryModel _model;
  Future<List<Booked>>? _historyFuture;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const _ink = Color(0xFF101820);
  static const _muted = Color(0xFF6E7A73);
  static const _surface = Color(0xFFF4F7F5);
  static const _line = Color(0xFFE1E7E3);
  static const _gold = Color(0xFFE2A84F);
  static const _success = Color(0xFF1D8F5A);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => JobshistoryModel());
    _model.tabBarController = _createTabController();
    _historyFuture = fetchBookings();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  TabController _createTabController() {
    final controller = TabController(vsync: this, length: 2, initialIndex: 0);
    controller.addListener(() {
      if (mounted && controller.indexIsChanging) {
        setState(() {});
      }
    });
    return controller;
  }

  TabController _ensureTabController() {
    return _model.tabBarController ??= _createTabController();
  }

  void _ensureHistoryFuture() {
    _historyFuture ??= fetchBookings();
  }

  Future<List<Booked>> fetchBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDriverId = prefs.getString('d_id');
    final driverId =
        widget.did != null && widget.did!.trim().isNotEmpty
            ? widget.did!.trim()
            : savedDriverId;

    final response = await http.post(
      Uri.parse(ApiService.driverJobHistory),
      body: {'d_id': driverId.toString()},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load job history');
    }

    final jsonResponse = jsonDecode(response.body);
    final data = jsonResponse['data'];
    if (data is! List) {
      return [];
    }

    return data.whereType<Map<String, dynamic>>().map(Booked.fromJson).toList();
  }

  Future<void> _refreshHistory() async {
    setState(() => _historyFuture = fetchBookings());
    await _historyFuture!;
  }

  @override
  Widget build(BuildContext context) {
    final tabController = _ensureTabController();
    _ensureHistoryFuture();

    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap:
          () =>
              _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: _surface,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildTabs(context, tabController),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _buildHistoryTab(context, weekOffset: 0),
                    _buildHistoryTab(context, weekOffset: -1),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 10, 14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _line),
            ),
            child: const Icon(Icons.history_rounded, color: _ink, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Job history',
                  style: context.appTheme.titleLarge.copyWith(
                    color: _ink,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Review completed journeys and payment details',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.appTheme.bodySmall.copyWith(
                    color: _muted,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            style: IconButton.styleFrom(
              foregroundColor: _muted,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context, TabController tabController) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _line),
        ),
        child: TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: _ink,
          unselectedLabelColor: _muted,
          labelStyle: context.appTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
          unselectedLabelStyle: context.appTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
          indicator: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10101820),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          tabs: const [Tab(text: 'This Week'), Tab(text: 'Last Week')],
        ),
      ),
    );
  }

  Widget _buildHistoryTab(BuildContext context, {required int weekOffset}) {
    return FutureBuilder<List<Booked>>(
      future: _historyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildStateMessage(
            context,
            icon: Icons.cloud_off_rounded,
            title: 'Could not load history',
            body: 'Pull down later or reopen this screen.',
          );
        }

        final jobs = _filterJobsForWeek(snapshot.data ?? [], weekOffset);
        if (jobs.isEmpty) {
          return _buildStateMessage(
            context,
            icon: Icons.history_toggle_off_rounded,
            title: 'No history available',
            body:
                weekOffset == 0
                    ? 'Jobs completed this week will appear here.'
                    : 'Jobs completed last week will appear here.',
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshHistory,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 28),
            itemCount: jobs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _buildJobCard(context, jobs[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildStateMessage(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String body,
  }) {
    return RefreshIndicator(
      onRefresh: _refreshHistory,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(28),
        children: [
          const SizedBox(height: 110),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _line),
                  ),
                  child: Icon(icon, color: _muted, size: 28),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.appTheme.titleSmall.copyWith(
                    color: _ink,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: context.appTheme.bodySmall.copyWith(
                    color: _muted,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Booked job) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _openJobDetails(job),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10101820),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatFare(job.fare),
                        style: context.appTheme.headlineSmall.copyWith(
                          color: _ink,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Job #${_value(job.jobId, fallback: '--')}',
                        style: context.appTheme.bodySmall.copyWith(
                          color: _muted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(context, job.status),
              ],
            ),
            const SizedBox(height: 12),
            _buildMetaRow(
              context,
              icon: Icons.schedule_rounded,
              text:
                  '${_value(job.bookDate, fallback: 'No date')} at ${_value(job.bookTime, fallback: '--:--')}',
            ),
            const SizedBox(height: 8),
            _buildMetaRow(
              context,
              icon: Icons.person_rounded,
              text: _passengerSummary(job),
            ),
            const SizedBox(height: 14),
            _buildRouteBlock(context, job),
            const SizedBox(height: 14),
            Row(
              children: [
                _buildAmountChip(context, 'Extra', job.extra),
                const SizedBox(width: 8),
                _buildAmountChip(context, 'Waiting', job.waiting),
                const SizedBox(width: 8),
                _buildAmountChip(context, 'Tolls', job.toll),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String? status) {
    final label = _value(status, fallback: 'Completed');
    final normalized = label.toLowerCase();
    final color =
        normalized.contains('complete') || normalized.contains('paid')
            ? _success
            : _gold;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Text(
        label,
        style: context.appTheme.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _buildMetaRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, color: _muted, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.appTheme.bodySmall.copyWith(
              color: _muted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRouteBlock(BuildContext context, Booked job) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRouteDot(context, 'A', _success),
            Container(width: 2, height: 34, color: _line),
            _buildRouteDot(context, 'B', context.appTheme.error),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRouteText(context, 'Pickup', job.pickup),
              const SizedBox(height: 12),
              _buildRouteText(context, 'Dropoff', job.destination),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteDot(BuildContext context, String label, Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.36)),
      ),
      child: Center(
        child: Text(
          label,
          style: context.appTheme.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildRouteText(BuildContext context, String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 58,
          child: Text(
            label,
            style: context.appTheme.bodySmall.copyWith(
              color: _muted,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),
        Expanded(
          child: Text(
            _value(value, fallback: 'Not available'),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.appTheme.bodyMedium.copyWith(
              color: _ink,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountChip(BuildContext context, String label, String? amount) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _line),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.appTheme.bodySmall.copyWith(
                color: _muted,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _formatFare(amount),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.appTheme.bodySmall.copyWith(
                color: _ink,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openJobDetails(Booked bookingData) {
    context.pushNamed(
      'JobHistoryDetails',
      queryParameters:
          {
            'did': serializeParam(_value(bookingData.jobId), ParamType.String),
            'pickup': serializeParam(
              _value(bookingData.pickup),
              ParamType.String,
            ),
            'dropoff': serializeParam(
              _value(bookingData.destination),
              ParamType.String,
            ),
            'bookId': serializeParam(
              _value(bookingData.bookId),
              ParamType.String,
            ),
            'date': serializeParam(
              _value(bookingData.bookDate),
              ParamType.String,
            ),
            'time': serializeParam(
              _value(bookingData.bookTime),
              ParamType.String,
            ),
            'passanger': serializeParam(
              _value(bookingData.passenger),
              ParamType.String,
            ),
            'cId': serializeParam(_value(bookingData.cId), ParamType.String),
            'cName': serializeParam(
              _value(bookingData.cName),
              ParamType.String,
            ),
            'cNotes': serializeParam(
              _value(bookingData.note),
              ParamType.String,
            ),
            'cNumber': serializeParam(
              _value(bookingData.cPhone),
              ParamType.String,
            ),
            'fare': serializeParam(_value(bookingData.fare), ParamType.String),
            'extra': serializeParam(
              _value(bookingData.extra),
              ParamType.String,
            ),
            'stopTime': serializeParam(
              _value(bookingData.waiting),
              ParamType.String,
            ),
            'toll': serializeParam(_value(bookingData.toll), ParamType.String),
            'jobaccept': serializeParam(
              _value(bookingData.jobAccptTime),
              ParamType.String,
            ),
            'jobstart': serializeParam(
              _value(bookingData.jobStart),
              ParamType.String,
            ),
            'waytopickup': serializeParam(
              _value(bookingData.waytoPickup),
              ParamType.String,
            ),
            'arrivalNow': serializeParam(
              _value(bookingData.arrivalTime),
              ParamType.String,
            ),
            'pob': serializeParam(
              _value(bookingData.pobTime),
              ParamType.String,
            ),
            'ridePath': serializeParam(
              _value(bookingData.jobRoutes),
              ParamType.String,
            ),
            'dropOfftime': serializeParam(
              _value(bookingData.dropOffTime),
              ParamType.String,
            ),
            'completime': serializeParam(
              _value(bookingData.completetime),
              ParamType.String,
            ),
          }.withoutNulls,
    );
  }

  List<Booked> _filterJobsForWeek(List<Booked> jobs, int weekOffset) {
    final parsedDates = jobs.map((job) => _parseDate(job.bookDate)).toList();
    if (parsedDates.every((date) => date == null)) {
      return jobs;
    }

    final now = DateTime.now();
    final thisWeekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - DateTime.monday));
    final targetStart = thisWeekStart.add(Duration(days: 7 * weekOffset));
    final targetEnd = targetStart.add(const Duration(days: 7));

    final filtered = <Booked>[];
    for (var i = 0; i < jobs.length; i++) {
      final date = parsedDates[i];
      if (date == null) {
        if (weekOffset == 0) {
          filtered.add(jobs[i]);
        }
        continue;
      }

      final day = DateTime(date.year, date.month, date.day);
      if (!day.isBefore(targetStart) && day.isBefore(targetEnd)) {
        filtered.add(jobs[i]);
      }
    }
    return filtered;
  }

  DateTime? _parseDate(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    final direct = DateTime.tryParse(trimmed);
    if (direct != null) {
      return direct;
    }

    final parts = trimmed.split(RegExp(r'[-/]'));
    if (parts.length != 3) {
      return null;
    }

    final first = int.tryParse(parts[0]);
    final second = int.tryParse(parts[1]);
    final third = int.tryParse(parts[2]);
    if (first == null || second == null || third == null) {
      return null;
    }

    if (parts[0].length == 4) {
      return DateTime(first, second, third);
    }
    return DateTime(third, second, first);
  }

  String _passengerSummary(Booked job) {
    final pieces = [
      if (_value(job.cName).isNotEmpty) _value(job.cName),
      if (_value(job.passenger).isNotEmpty) '${_value(job.passenger)} pax',
      if (_value(job.luggage).isNotEmpty) '${_value(job.luggage)} bags',
      if (_value(job.journeyType).isNotEmpty) _value(job.journeyType),
    ];
    return pieces.isEmpty
        ? 'Passenger details unavailable'
        : pieces.join(' • ');
  }

  String _formatFare(String? amount) {
    final raw = _value(amount);
    if (raw.isEmpty) {
      return '£0';
    }
    if (raw.contains('£')) {
      return raw;
    }

    final numeric = double.tryParse(raw.replaceAll(RegExp(r'[^0-9.\-]'), ''));
    if (numeric == null) {
      return '£$raw';
    }

    final hasPennies = numeric.truncateToDouble() != numeric;
    return '£${numeric.toStringAsFixed(hasPennies ? 2 : 0)}';
  }

  String _value(String? value, {String fallback = ''}) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty || trimmed.toLowerCase() == 'null') {
      return fallback;
    }
    return trimmed;
  }
}
