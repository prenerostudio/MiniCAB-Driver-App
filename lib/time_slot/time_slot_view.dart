import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:new_minicab_driver/Data/api_service.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import 'package:new_minicab_driver/time_slot/time_slot_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeSlotView extends StatefulWidget {
  const TimeSlotView({super.key});

  @override
  State<TimeSlotView> createState() => _TimeSlotViewState();
}

class _TimeSlotViewState extends State<TimeSlotView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Future<List<TimeSlotModel>>? _availableSlotsFuture;
  Future<List<AcceptedTimeSlotModel>>? _acceptedSlotsFuture;

  static const _ink = Color(0xFF101820);
  static const _muted = Color(0xFF6E7A73);
  static const _surface = Color(0xFFF4F7F5);
  static const _line = Color(0xFFE1E7E3);
  static const _gold = Color(0xFFE2A84F);
  static const _success = Color(0xFF1D8F5A);

  bool _isAcceptingSlot = false;

  @override
  void initState() {
    super.initState();
    _tabController = _createTabController();
    _loadSlots();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  TabController _createTabController() {
    final controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      if (mounted && controller.indexIsChanging) {
        setState(() {});
      }
    });
    return controller;
  }

  TabController _ensureTabController() {
    return _tabController ??= _createTabController();
  }

  void _ensureSlotFutures() {
    _availableSlotsFuture ??= getTimerSlots();
    _acceptedSlotsFuture ??= acceptedTimeSlot();
  }

  void _loadSlots() {
    _availableSlotsFuture = getTimerSlots();
    _acceptedSlotsFuture = acceptedTimeSlot();
  }

  Future<void> _refreshSlots() async {
    setState(_loadSlots);
    await Future.wait([_availableSlotsFuture!, _acceptedSlotsFuture!]);
  }

  Future<List<TimeSlotModel>> getTimerSlots() async {
    final response = await http.post(
      Uri.parse(ApiService.driverFetchTimeSlots),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load time slots');
    }

    final jsonResponse = jsonDecode(response.body);
    final data = jsonResponse['data'];
    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map((item) => TimeSlotModel.fromJson(item))
        .toList();
  }

  Future<List<AcceptedTimeSlotModel>> acceptedTimeSlot() async {
    final prefs = await SharedPreferences.getInstance();
    final dId = prefs.getString('d_id');

    final response = await http.post(
      Uri.parse(ApiService.driverAcceptedTimeSlot),
      body: {'d_id': dId.toString()},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load time slots');
    }

    final jsonResponse = jsonDecode(response.body);
    final data = jsonResponse['data'];
    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map((item) => AcceptedTimeSlotModel.fromJson(item))
        .toList();
  }

  Future<void> acceptTimeSlot(String atId) async {
    setState(() => _isAcceptingSlot = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final dId = prefs.getString('d_id');
      final response = await http.post(
        Uri.parse(ApiService.driverAcceptTimeSlot),
        body: {'at_id': atId, 'd_id': dId.toString()},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to accept time slot');
      }

      final jsonResponse = jsonDecode(response.body);
      showToastMessage(jsonResponse['message']?.toString() ?? 'Slot accepted');
      await _refreshSlots();
    } catch (error) {
      showToastMessage('Could not accept this time slot');
      debugPrint('Accept time slot error: $error');
    } finally {
      if (mounted) {
        setState(() => _isAcceptingSlot = false);
      }
    }
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: _ink,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabController = _ensureTabController();
    _ensureSlotFutures();

    return Scaffold(
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
                  _buildAvailableSlots(context),
                  _buildAcceptedSlots(context),
                ],
              ),
            ),
          ],
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
            child: const Icon(Icons.schedule_rounded, color: _ink, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Time slots',
                  style: context.appTheme.titleLarge.copyWith(
                    color: _ink,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Accept dispatch windows and review your booked slots',
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
          tabs: const [Tab(text: 'Available'), Tab(text: 'Accepted')],
        ),
      ),
    );
  }

  Widget _buildAvailableSlots(BuildContext context) {
    return FutureBuilder<List<TimeSlotModel>>(
      future: _availableSlotsFuture,
      builder: (context, snapshot) {
        return _buildFutureBody<TimeSlotModel>(
          context,
          snapshot: snapshot,
          emptyTitle: 'No available slots',
          emptyBody: 'New dispatch windows will appear here.',
          itemBuilder:
              (context, slot) => _buildSlotCard(
                context,
                date: slot.date,
                startTime: slot.startTime,
                endTime: slot.endTime,
                status: slot.atStatus,
                action: _buildAcceptButton(context, slot),
              ),
        );
      },
    );
  }

  Widget _buildAcceptedSlots(BuildContext context) {
    return FutureBuilder<List<AcceptedTimeSlotModel>>(
      future: _acceptedSlotsFuture,
      builder: (context, snapshot) {
        return _buildFutureBody<AcceptedTimeSlotModel>(
          context,
          snapshot: snapshot,
          emptyTitle: 'No accepted slots',
          emptyBody: 'Accepted time slots will be listed here.',
          itemBuilder:
              (context, slot) => _buildSlotCard(
                context,
                date: slot.date,
                startTime: slot.startTime,
                endTime: slot.endTime,
                status: slot.atStatus,
                isAccepted: true,
              ),
        );
      },
    );
  }

  Widget _buildFutureBody<T>(
    BuildContext context, {
    required AsyncSnapshot<List<T>> snapshot,
    required String emptyTitle,
    required String emptyBody,
    required Widget Function(BuildContext context, T slot) itemBuilder,
  }) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return _buildStateMessage(
        context,
        icon: Icons.cloud_off_rounded,
        title: 'Could not load slots',
        body: 'Pull down later or reopen this screen.',
      );
    }

    final slots = snapshot.data ?? const [];
    if (slots.isEmpty) {
      return _buildStateMessage(
        context,
        icon: Icons.event_busy_rounded,
        title: emptyTitle,
        body: emptyBody,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshSlots,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 28),
        itemCount: slots.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) => itemBuilder(context, slots[index]),
      ),
    );
  }

  Widget _buildStateMessage(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String body,
  }) {
    return RefreshIndicator(
      onRefresh: _refreshSlots,
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

  Widget _buildSlotCard(
    BuildContext context, {
    required String date,
    required String startTime,
    required String endTime,
    required String status,
    Widget? action,
    bool isAccepted = false,
  }) {
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(date),
                      style: context.appTheme.titleMedium.copyWith(
                        color: _ink,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildMetaRow(
                      context,
                      icon: Icons.schedule_rounded,
                      text:
                          '${_formatTime(startTime)} - ${_formatTime(endTime)}',
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(context, status, isAccepted: isAccepted),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildTimeBlock(context, 'Start', _formatTime(startTime)),
              const SizedBox(width: 10),
              _buildTimeBlock(context, 'End', _formatTime(endTime)),
            ],
          ),
          if (action != null) ...[
            const SizedBox(height: 14),
            SizedBox(width: double.infinity, height: 46, child: action),
          ],
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
        const SizedBox(width: 7),
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

  Widget _buildStatusBadge(
    BuildContext context,
    String status, {
    required bool isAccepted,
  }) {
    final label = isAccepted ? 'Accepted' : _statusLabel(status);
    final color = isAccepted ? _success : _gold;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAccepted ? Icons.check_circle_rounded : Icons.pending_rounded,
            color: color,
            size: 17,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.appTheme.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeBlock(BuildContext context, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              style: context.appTheme.bodySmall.copyWith(
                color: _muted,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.appTheme.titleSmall.copyWith(
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

  Widget _buildAcceptButton(BuildContext context, TimeSlotModel slot) {
    return ElevatedButton.icon(
      onPressed:
          _isAcceptingSlot ? null : () async => acceptTimeSlot(slot.atId),
      icon:
          _isAcceptingSlot
              ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
              : const Icon(Icons.check_rounded, size: 20),
      label: Text(_isAcceptingSlot ? 'Accepting...' : 'Accept slot'),
      style: ElevatedButton.styleFrom(
        backgroundColor: _ink,
        foregroundColor: Colors.white,
        disabledBackgroundColor: _muted,
        disabledForegroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: context.appTheme.titleSmall.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }

  String _statusLabel(String status) {
    final normalized = status.trim();
    if (normalized.isEmpty || normalized == '0') {
      return 'Open';
    }
    if (normalized == '1') {
      return 'Accepted';
    }
    return normalized;
  }

  String _formatDate(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? 'Date unavailable' : trimmed;
  }

  String _formatTime(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? '--:--' : trimmed;
  }
}
