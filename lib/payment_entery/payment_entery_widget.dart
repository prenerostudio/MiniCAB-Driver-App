import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:new_minicab_driver/Data/api_service.dart';
import 'package:new_minicab_driver/payment_entery/complete.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/jobDetails.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'payment_entery_model.dart';

export 'payment_entery_model.dart';

class PaymentEnteryWidget extends StatefulWidget {
  const PaymentEnteryWidget({
    super.key,
    required this.jobid,
    required this.did,
    required this.fare,
  });

  final String? jobid;
  final String? fare;
  final String? did;

  @override
  State<PaymentEnteryWidget> createState() => _PaymentEnteryWidgetState();
}

class _PaymentEnteryWidgetState extends State<PaymentEnteryWidget> {
  late PaymentEnteryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final extraWaitingController = TextEditingController(text: '0');
  final parkingController = TextEditingController(text: '0');
  final tollsController = TextEditingController(text: '0');
  final watingController = TextEditingController(text: '0');

  static const _ink = Color(0xFF101820);
  static const _muted = Color(0xFF6E7A73);
  static const _surface = Color(0xFFF4F7F5);
  static const _line = Color(0xFFE1E7E3);
  static const _gold = Color(0xFFE2A84F);
  static const _success = Color(0xFF1D8F5A);

  String? _carParking;
  String? _waiting;
  String? _tolls;
  String? _extra;

  String extra = '0';
  String parking = '0';
  String waiting = '0';
  String tolls = '0';

  int isExcapted = 0;
  bool _isLoadingFareData = true;
  bool _isSubmittingFares = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentEnteryModel());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _wireFareListeners();
    _loadInitialFareData();
    pushercallbg();
  }

  @override
  void dispose() {
    extraWaitingController.dispose();
    parkingController.dispose();
    tollsController.dispose();
    watingController.dispose();
    _model.dispose();
    super.dispose();
  }

  void _wireFareListeners() {
    extraWaitingController.addListener(_refreshTotals);
    parkingController.addListener(_refreshTotals);
    tollsController.addListener(_refreshTotals);
    watingController.addListener(_refreshTotals);
  }

  void _refreshTotals() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadInitialFareData() async {
    try {
      await getFares();
      await jobDetailsFuture();
    } finally {
      if (mounted) {
        setState(() => _isLoadingFareData = false);
      }
    }
  }

  Future<List<Job>> jobDetailsFuture() async {
    final prefs = await SharedPreferences.getInstance();
    final dId = prefs.getString('d_id');
    debugPrint('Driver id for payment fares: $dId');

    final response = await http.post(
      Uri.parse(ApiService.driverUpcomingJobs),
      body: {'d_id': dId.toString()},
    );

    if (response.statusCode != 200) {
      return [];
    }

    final parsedResponse = json.decode(response.body);
    final data = parsedResponse['data'];
    if (data is! List) {
      return [];
    }

    if (data.isNotEmpty && data.first is Map<String, dynamic>) {
      final firstJob = data.first as Map<String, dynamic>;
      _carParking = firstJob['car_parking']?.toString();
      _waiting = firstJob['waiting']?.toString();
      _tolls = firstJob['tolls']?.toString();
      _extra = firstJob['extra']?.toString();
      _applyFetchedFareValues();
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map((item) => Job.fromJson(item))
        .toList();
  }

  void _applyFetchedFareValues() {
    _setControllerValue(extraWaitingController, _extra);
    _setControllerValue(parkingController, _carParking);
    _setControllerValue(tollsController, _tolls);
    _setControllerValue(watingController, _waiting);

    if (mounted) {
      setState(() {});
    }
  }

  void _setControllerValue(TextEditingController controller, String? value) {
    final normalised = _normaliseFare(value);
    if (controller.text != normalised) {
      controller.text = normalised;
    }
  }

  Future<void> pushercallbg() async {
    try {
      final pusher = PusherClient(
        'ef80ba163503f394d9c3',
        PusherOptions(
          host: ApiService.driverCheckFareStatus,
          cluster: 'ap2',
          encrypted: false,
        ),
      );
      pusher.connect();

      final channel = pusher.subscribe('jobs-channel');
      channel.bind('fare-approved', (event) {
        final payload = event?.data;
        if (payload == null) {
          return;
        }

        final jsonMap = json.decode(payload);
        debugPrint('Fare approval message: ${jsonMap['message']}');
        if (jsonMap['message'] != 'Fares have been approved by controller.') {
          return;
        }

        final details = jsonMap['details'];
        if (details is! Map<String, dynamic>) {
          return;
        }

        final approvedExtra = details['extras'].toString();
        final approvedParking = details['car_parking'].toString();
        final approvedTolls = details['tolls'].toString();
        final approvedWaiting = details['waiting'].toString();

        extraWaitingController.text = approvedExtra;
        parkingController.text = approvedParking;
        tollsController.text = approvedTolls;
        watingController.text = approvedWaiting;

        saveData(
          details['journey_fare'].toString(),
          approvedParking,
          approvedExtra,
          approvedWaiting,
          approvedTolls,
          jsonMap['total_fee'].toString(),
        );

        if (mounted) {
          setState(() => isExcapted = 2);
        }
      });
    } catch (e) {
      debugPrint('Pusher fare approval exception: $e');
    }
  }

  Future<void> saveData(
    String jfare,
    String carparking,
    String extraFare,
    String waitingFare,
    String tollFare,
    String totalFee,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('journey_fare', jfare);
    await prefs.setString('car_parking', carparking);
    await prefs.setString('extra', extraFare);
    await prefs.setString('waiting', waitingFare);
    await prefs.setString('tolls', tollFare);
    await prefs.setString('totalFee', totalFee);

    if (mounted) {
      setState(() {
        extra = extraFare;
        parking = carparking;
        waiting = waitingFare;
        tolls = tollFare;
      });
    }
  }

  Future<void> getFares() async {
    final sp = await SharedPreferences.getInstance();
    final savedExtra = sp.getString('extra') ?? '0';
    final savedParking = sp.getString('car_parking') ?? '0';
    final savedTolls = sp.getString('tolls') ?? '0';
    final savedWaiting = sp.getString('waiting') ?? '0';

    extraWaitingController.text = savedExtra;
    parkingController.text = savedParking;
    tollsController.text = savedTolls;
    watingController.text = savedWaiting;

    if (mounted) {
      setState(() {
        extra = savedExtra;
        parking = savedParking;
        tolls = savedTolls;
        waiting = savedWaiting;
      });
    }
  }

  Future<void> addFares() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dId = prefs.getString('d_id');
      debugPrint('Submitting fares for job ${widget.jobid}, driver $dId');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverAddFares),
      );
      request.fields.addAll({
        'job_id': '${widget.jobid}',
        'd_id': dId.toString(),
        'extra': extraWaitingController.text,
        'car_parking': parkingController.text,
        'tolls': tollsController.text,
        'journey_fare': '${widget.fare}',
        'waiting': watingController.text,
      });

      final response = await request.send();
      if (response.statusCode == 200) {
        debugPrint(await response.stream.bytesToString());
        if (mounted) {
          setState(() => isExcapted = 1);
        }
      } else {
        debugPrint('Failed to add fares: ${response.reasonPhrase}');
      }
    } catch (error) {
      debugPrint('Add fares error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 16),
                          _buildPaymentSummary(context),
                          const SizedBox(height: 12),
                          _buildChargePanel(context),
                          const SizedBox(height: 12),
                          _buildFareBreakdown(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _buildBottomAction(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _line),
          ),
          child: const Icon(Icons.payments_rounded, color: _ink, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment',
                style: context.appTheme.titleLarge.copyWith(
                  color: _ink,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Review cash collection and job charges',
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
    );
  }

  Widget _buildPaymentSummary(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pay by cash',
                      style: context.appTheme.bodyMedium.copyWith(
                        color: _muted,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatMoney(_currentTotal),
                      style: context.appTheme.headlineMedium.copyWith(
                        color: _ink,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Client pays total amount',
                      style: context.appTheme.bodySmall.copyWith(
                        color: _muted,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusPill(context),
            ],
          ),
          if (_isLoadingFareData) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                minHeight: 5,
                backgroundColor: _surface,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusPill(BuildContext context) {
    final hasChanges = !_savedValuesMatch;
    final Color color;
    final IconData icon;
    final String label;

    if (isExcapted == 2) {
      color = _success;
      icon = Icons.verified_rounded;
      label = 'Approved';
    } else if (isExcapted == 1 || hasChanges) {
      color = _gold;
      icon = Icons.pending_actions_rounded;
      label = isExcapted == 1 ? 'Waiting' : 'Approval';
    } else {
      color = _success;
      icon = Icons.check_circle_rounded;
      label = 'Ready';
    }

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
          Icon(icon, color: color, size: 17),
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

  Widget _buildChargePanel(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional charges',
            style: context.appTheme.titleSmall.copyWith(
              color: _ink,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Update only the charges that apply to this journey.',
            style: context.appTheme.bodySmall.copyWith(
              color: _muted,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 14),
          _buildChargeInput(
            context,
            controller: extraWaitingController,
            icon: Icons.add_card_rounded,
            label: 'Extra',
          ),
          const SizedBox(height: 10),
          _buildChargeInput(
            context,
            controller: watingController,
            icon: Icons.timer_rounded,
            label: 'Waiting',
          ),
          const SizedBox(height: 10),
          _buildChargeInput(
            context,
            controller: parkingController,
            icon: Icons.local_parking_rounded,
            label: 'Parking',
          ),
          const SizedBox(height: 10),
          _buildChargeInput(
            context,
            controller: tollsController,
            icon: Icons.toll_rounded,
            label: 'Tolls',
          ),
        ],
      ),
    );
  }

  Widget _buildChargeInput(
    BuildContext context, {
    required TextEditingController controller,
    required IconData icon,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      style: context.appTheme.bodyMedium.copyWith(
        color: _ink,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: context.appTheme.bodySmall.copyWith(
          color: _muted,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        prefixIcon: Icon(icon, color: _muted, size: 20),
        prefixText: '£ ',
        prefixStyle: context.appTheme.bodyMedium.copyWith(
          color: _ink,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        filled: true,
        fillColor: _surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _ink, width: 1.4),
        ),
      ),
    );
  }

  Widget _buildFareBreakdown(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
      ),
      child: Column(
        children: [
          _buildBreakdownRow(
            context,
            label: 'Journey fare',
            amount: _baseFare,
            isStrong: true,
          ),
          const Divider(height: 22, color: _line),
          _buildBreakdownRow(
            context,
            label: 'Extra',
            amount: _amountFromText(extraWaitingController.text),
          ),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            context,
            label: 'Waiting',
            amount: _amountFromText(watingController.text),
          ),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            context,
            label: 'Parking',
            amount: _amountFromText(parkingController.text),
          ),
          const SizedBox(height: 8),
          _buildBreakdownRow(
            context,
            label: 'Tolls',
            amount: _amountFromText(tollsController.text),
          ),
          const Divider(height: 22, color: _line),
          _buildBreakdownRow(
            context,
            label: 'Total cash due',
            amount: _currentTotal,
            isStrong: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(
    BuildContext context, {
    required String label,
    required double amount,
    bool isStrong = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.appTheme.bodyMedium.copyWith(
              color: isStrong ? _ink : _muted,
              fontWeight: isStrong ? FontWeight.w900 : FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ),
        Text(
          _formatMoney(amount),
          style: context.appTheme.bodyMedium.copyWith(
            color: _ink,
            fontWeight: isStrong ? FontWeight.w900 : FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    final canProceedDirectly = _savedValuesMatch;
    final buttonText =
        _isSubmittingFares
            ? 'Sending...'
            : canProceedDirectly
            ? 'Proceed to complete'
            : 'Send for approval';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _line)),
        boxShadow: [
          BoxShadow(
            color: Color(0x10101820),
            blurRadius: 18,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSubmittingFares ? null : _handleProceed,
              icon:
                  _isSubmittingFares
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Icon(
                        canProceedDirectly
                            ? Icons.check_circle_rounded
                            : Icons.verified_user_rounded,
                        size: 20,
                      ),
              label: Text(buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: _ink,
                foregroundColor: Colors.white,
                disabledBackgroundColor: _muted,
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: context.appTheme.titleSmall.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleProceed() async {
    FocusScope.of(context).unfocus();

    if (_savedValuesMatch) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompleteWidget(isfromfare: true),
        ),
      );
      return;
    }

    setState(() => _isSubmittingFares = true);
    await addFares();
    if (!mounted) {
      return;
    }
    setState(() => _isSubmittingFares = false);
    await _showFareApprovalDialog();
  }

  Future<void> _showFareApprovalDialog() {
    return showDialog<void>(
      context: context,
      builder:
          (dialogContext) => Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: _gold.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.pending_actions_rounded,
                          color: _gold,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Controller approval',
                          style: context.appTheme.titleMedium.copyWith(
                            color: _ink,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Your updated fares have been sent for controller approval.',
                    style: context.appTheme.bodyMedium.copyWith(
                      color: _muted,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => CompleteWidget(isfromfare: true),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _ink,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: context.appTheme.titleSmall.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  bool get _savedValuesMatch =>
      _normaliseFare(extra) == _normaliseFare(extraWaitingController.text) &&
      _normaliseFare(parking) == _normaliseFare(parkingController.text) &&
      _normaliseFare(tolls) == _normaliseFare(tollsController.text) &&
      _normaliseFare(waiting) == _normaliseFare(watingController.text);

  double get _baseFare => _amountFromText(widget.fare);

  double get _currentTotal =>
      _baseFare +
      _amountFromText(extraWaitingController.text) +
      _amountFromText(watingController.text) +
      _amountFromText(parkingController.text) +
      _amountFromText(tollsController.text);

  double _amountFromText(String? value) {
    final cleaned = (value ?? '').replaceAll(RegExp(r'[^0-9.\-]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  String _formatMoney(double value) {
    final hasPennies = value.truncateToDouble() != value;
    return '£${value.toStringAsFixed(hasPennies ? 2 : 0)}';
  }

  String _normaliseFare(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) {
      return '0';
    }

    final amount = _amountFromText(trimmed);
    if (amount == 0 && !trimmed.contains(RegExp(r'[1-9]'))) {
      return '0';
    }
    return amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2);
  }
}
