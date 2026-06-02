import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/jobDetails.dart';
import 'package:new_minicab_driver/Data/api_service.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'upcommingjob_model.dart';

export 'upcommingjob_model.dart';

class UpcommingjobWidget extends StatefulWidget {
  const UpcommingjobWidget({super.key, required this.dId});

  final String? dId;

  @override
  State<UpcommingjobWidget> createState() => _UpcommingjobWidgetState();
}

class _UpcommingjobWidgetState extends State<UpcommingjobWidget>
    with TickerProviderStateMixin {
  late UpcommingjobModel _model;
  late Future<List<Job>> _upcomingJobsFuture;
  late Future<List<Job>> _nextWeekJobsFuture;

  static const _ink = Color(0xFF101820);
  static const _muted = Color(0xFF6E7A73);
  static const _surface = Color(0xFFF4F7F5);
  static const _line = Color(0xFFE1E7E3);
  static const _gold = Color(0xFFE2A84F);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UpcommingjobModel());
    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    _loadJobs();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  void _loadJobs() {
    _upcomingJobsFuture = _fetchJobs(ApiService.driverAcceptedJobs);
    _nextWeekJobsFuture = _fetchJobs(ApiService.driverUpcomingNextWeek);
  }

  Future<List<Job>> _fetchJobs(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final savedDriverId = prefs.getString('d_id');
    final driverId =
        widget.dId != null && widget.dId!.trim().isNotEmpty
            ? widget.dId!.trim()
            : savedDriverId;

    final response = await http.post(
      Uri.parse(endpoint),
      body: {'d_id': driverId.toString()},
    );

    if (response.statusCode != 200) {
      throw Exception('Could not load jobs');
    }

    final parsedResponse = json.decode(response.body);
    final data = parsedResponse['data'];
    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map((item) => Job.fromJson(item))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if ((details.primaryDelta ?? 0) > 20) {
          Navigator.pop(context);
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.55,
        maxChildSize: 0.98,
        builder: (context, scrollController) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x24101820),
                  blurRadius: 28,
                  offset: Offset(0, -12),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSheetHeader(context),
                _buildTabs(context),
                Expanded(
                  child: TabBarView(
                    controller: _model.tabBarController,
                    children: [
                      _buildJobList(
                        context,
                        future: _upcomingJobsFuture,
                        scrollController: scrollController,
                        emptyTitle: 'No upcoming jobs',
                        emptyBody: 'Accepted work will appear here.',
                      ),
                      _buildJobList(
                        context,
                        future: _nextWeekJobsFuture,
                        scrollController: scrollController,
                        emptyTitle: 'Nothing next week',
                        emptyBody: 'Future bookings will appear here.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSheetHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 10, 12),
      child: Column(
        children: [
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD7DED9),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.event_available_rounded,
                  color: _ink,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming jobs',
                      style: context.appTheme.titleMedium.copyWith(
                        color: _ink,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Review scheduled pickups and route details',
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
                tooltip: 'Close',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  foregroundColor: _muted,
                  backgroundColor: _surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _line),
        ),
        child: TabBar(
          controller: _model.tabBarController,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: _ink,
          unselectedLabelColor: _muted,
          labelStyle: context.appTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
          unselectedLabelStyle: context.appTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14101820),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Next Week')],
        ),
      ),
    );
  }

  Widget _buildJobList(
    BuildContext context, {
    required Future<List<Job>> future,
    required ScrollController scrollController,
    required String emptyTitle,
    required String emptyBody,
  }) {
    return FutureBuilder<List<Job>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildStateMessage(
            context,
            icon: Icons.cloud_off_rounded,
            title: 'Could not load jobs',
            body: 'Pull down later or reopen this panel.',
          );
        }

        final jobs = snapshot.data ?? const <Job>[];
        if (jobs.isEmpty) {
          return _buildStateMessage(
            context,
            icon: Icons.event_busy_rounded,
            title: emptyTitle,
            body: emptyBody,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(_loadJobs);
            await Future.wait([_upcomingJobsFuture, _nextWeekJobsFuture]);
          },
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 28),
            itemCount: jobs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder:
                (context, index) => _buildJobCard(context, jobs[index]),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: _muted, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.appTheme.titleSmall.copyWith(
                color: _ink,
                fontWeight: FontWeight.w800,
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
    );
  }

  Widget _buildJobCard(BuildContext context, Job job) {
    final distanceText = _formatDistance(job.journeyDistance);
    final details = [
      if (distanceText.isNotEmpty) distanceText,
      if (job.journeyType.isNotEmpty) job.journeyType,
      if (job.passenger.isNotEmpty) '${job.passenger} pax',
      if (job.luggage.isNotEmpty) '${job.luggage} bags',
    ].join(' • ');

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatFare(job.journeyFare),
                      style: context.appTheme.headlineSmall.copyWith(
                        color: _ink,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Estimated maximum value',
                      style: context.appTheme.bodySmall.copyWith(
                        color: _muted,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDateBadge(context, job),
            ],
          ),
          const SizedBox(height: 14),
          _buildMetaRow(
            context,
            icon: Icons.schedule_rounded,
            text: '${job.pickDate} at ${job.pickTime}',
          ),
          if (details.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildMetaRow(context, icon: FontAwesomeIcons.route, text: details),
          ],
          const SizedBox(height: 14),
          _buildRouteBlock(context, job),
          if (job.note.isNotEmpty || job.flightNumber.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildNotes(context, job),
          ],
        ],
      ),
    );
  }

  Widget _buildDateBadge(BuildContext context, Job job) {
    final dateText = job.pickDate.trim().isEmpty ? '--' : job.pickDate.trim();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            job.pickTime.trim().isEmpty ? '--:--' : job.pickTime.trim(),
            style: context.appTheme.bodyMedium.copyWith(
              color: _ink,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            dateText,
            style: context.appTheme.bodySmall.copyWith(
              color: _muted,
              letterSpacing: 0,
            ),
          ),
        ],
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

  Widget _buildRouteBlock(BuildContext context, Job job) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _buildRouteDot(context, 'A', context.appTheme.success),
            Container(width: 2, height: 34, color: _line),
            _buildRouteDot(context, 'B', context.appTheme.error),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
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
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        label,
        style: context.appTheme.bodySmall.copyWith(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _buildRouteText(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 54,
          child: Text(
            label,
            style: context.appTheme.bodySmall.copyWith(
              color: _muted,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.trim().isEmpty ? 'Not provided' : value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.appTheme.bodyMedium.copyWith(
              color: _ink,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotes(BuildContext context, Job job) {
    final values = [
      if (job.flightNumber.isNotEmpty) 'Flight ${job.flightNumber}',
      if (job.note.isNotEmpty) job.note,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAEE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF2DDA4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.sticky_note_2_rounded, color: _gold, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              values.join(' • '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.appTheme.bodySmall.copyWith(
                color: _ink,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFare(String fare) {
    final trimmed = fare.trim();
    if (trimmed.isEmpty) {
      return '£0';
    }
    return trimmed.startsWith('£') ? trimmed : '£$trimmed';
  }

  String _formatDistance(String distance) {
    final parsed = double.tryParse(distance);
    if (parsed == null) {
      return distance.trim();
    }
    return '${(parsed * 0.621371).toStringAsFixed(2)} miles';
  }
}
