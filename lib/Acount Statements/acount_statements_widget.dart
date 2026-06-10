import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_minicab_driver/Acount%20Statements/accountStatementDetails.dart';
import 'package:new_minicab_driver/Data/api_service.dart';
import 'package:new_minicab_driver/main.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/invoiceDetails.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'acount_statements_model.dart';

export 'acount_statements_model.dart';

class AcountStatementsWidget extends StatefulWidget {
  const AcountStatementsWidget({super.key});

  @override
  State<AcountStatementsWidget> createState() => _AcountStatementsWidgetState();
}

class _AcountStatementsWidgetState extends State<AcountStatementsWidget>
    with TickerProviderStateMixin {
  static const _ink = Color(0xFF101820);
  static const _muted = Color(0xFF69756F);
  static const _surface = Color(0xFFF4F7F5);
  static const _line = Color(0xFFE1E7E3);
  static const _gold = Color(0xFFE2A84F);
  static const _success = Color(0xFF1D8F5A);
  static const _danger = Color(0xFFE04444);

  late AcountStatementsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;
  String? _loadError;
  List<Invoice> _lastJobInvoices = [];
  List<Invoice> _todayInvoices = [];
  List<Invoice> _weeklyInvoices = [];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AcountStatementsModel());
    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() {
      if (!_model.tabBarController!.indexIsChanging && mounted) {
        setState(() {});
      }
    });
    _loadStatements();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadStatements() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    final results = await Future.wait([
      _fetchInvoices(ApiService.driverEarningLastJob),
      _fetchInvoices(ApiService.driverEarningToday),
      _fetchInvoices(ApiService.driverEarningLastWeek),
    ]);

    if (!mounted) {
      return;
    }

    setState(() {
      _lastJobInvoices = results[0];
      _todayInvoices = results[1];
      _weeklyInvoices = results[2];
      _isLoading = false;
    });
  }

  Future<List<Invoice>> _fetchInvoices(String endpoint) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dId = prefs.getString('d_id');
      final response = await http
          .post(Uri.parse(endpoint), body: {'d_id': dId.toString()})
          .timeout(const Duration(seconds: 12));

      if (response.statusCode != 200) {
        return [];
      }

      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse is! Map<String, dynamic>) {
        return [];
      }

      final data =
          jsonResponse['data'] ??
          jsonResponse['invoice'] ??
          jsonResponse['invoices'] ??
          jsonResponse['jobs'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(Invoice.fromJson)
            .toList();
      }

      if (data is Map<String, dynamic>) {
        return [Invoice.fromJson(data)];
      }

      if (jsonResponse.containsKey('job_id') ||
          jsonResponse.containsKey('invoice_id') ||
          jsonResponse.containsKey('book_id')) {
        return [Invoice.fromJson(jsonResponse)];
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  int get _selectedTab => _model.tabBarController?.index ?? 0;

  String get _selectedLabel {
    switch (_selectedTab) {
      case 1:
        return 'Today';
      case 2:
        return 'Last 7 days';
      default:
        return 'Last job';
    }
  }

  List<Invoice> get _selectedInvoices {
    switch (_selectedTab) {
      case 1:
        return _todayInvoices;
      case 2:
        return _weeklyInvoices;
      default:
        return _lastJobInvoices;
    }
  }

  double get _selectedEarnings {
    return _selectedInvoices.fold<double>(
      0,
      (total, invoice) => total + _invoiceTotal(invoice),
    );
  }

  double get _weeklyEarnings {
    return _weeklyInvoices.fold<double>(
      0,
      (total, invoice) => total + _invoiceTotal(invoice),
    );
  }

  double get _todayEarnings {
    return _todayInvoices.fold<double>(
      0,
      (total, invoice) => total + _invoiceTotal(invoice),
    );
  }

  double _invoiceTotal(Invoice invoice) {
    final totalPay = _parseAmount(invoice.totalPay);
    if (totalPay > 0) {
      return totalPay;
    }

    return _parseAmount(invoice.journeyFare) +
        _parseAmount(invoice.carParking) +
        _parseAmount(invoice.waiting) +
        _parseAmount(invoice.tolls) +
        _parseAmount(invoice.extra);
  }

  double _parseAmount(String? value) {
    if (value == null) {
      return 0;
    }

    return double.tryParse(
          value
              .replaceAll(String.fromCharCode(163), '')
              .replaceAll(',', '')
              .trim(),
        ) ??
        0;
  }

  String _money(num value) {
    return '${String.fromCharCode(163)}${value.toStringAsFixed(2)}';
  }

  String _value(String? value, {String fallback = '--'}) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') {
      return fallback;
    }
    return trimmed;
  }

  void _openInvoiceDetails(Invoice invoice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AccountStatementDetails(
              totalFee: _money(_invoiceTotal(invoice)),
              jounreryFare: _value(invoice.journeyFare, fallback: '0'),
              parking: _value(invoice.carParking, fallback: '0'),
              tolls: _value(invoice.tolls, fallback: '0'),
              did: _value(invoice.dId, fallback: '0'),
              waiting: _value(invoice.waiting, fallback: '0'),
              time: _value(invoice.pickTime),
              jobid: _value(invoice.jobId),
              pickupDate: _value(invoice.pickDate),
              pickUplocation: _value(invoice.pickup),
              dropOflocation: _value(invoice.destination),
              pickupTime: _value(invoice.pickTime),
              extra: _value(invoice.extra, fallback: '0'),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () =>
              _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: true,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: _surface,
          body: SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: RefreshIndicator(
                    color: _ink,
                    onRefresh: _loadStatements,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                      children: [
                        _buildSummaryCard(context),
                        const SizedBox(height: 14),
                        _buildTabs(context),
                        const SizedBox(height: 12),
                        _buildStatementBody(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavBarPage(initialPage: 'Dashboard'),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back_rounded, color: _ink),
          ),
          Expanded(
            child: Text(
              'Account Statement',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.appTheme.titleLarge.override(
                fontFamily: 'Open Sans',
                color: _ink,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          IconButton(
            onPressed: _loadStatements,
            icon: const Icon(Icons.refresh_rounded, color: _ink),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
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
                  color: _gold,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: _ink,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Earnings',
                      style: context.appTheme.bodySmall.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: const Color(0xFFB7C0BC),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _selectedLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.appTheme.bodyMedium.override(
                        fontFamily: 'Open Sans',
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _money(_selectedEarnings),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.appTheme.titleLarge.override(
                  fontFamily: 'Open Sans',
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryMetric(
                  context,
                  label: 'Jobs',
                  value: _selectedInvoices.length.toString(),
                  icon: Icons.local_taxi_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryMetric(
                  context,
                  label: 'Today',
                  value: _money(_todayEarnings),
                  icon: Icons.today_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryMetric(
                  context,
                  label: 'Week',
                  value: _money(_weeklyEarnings),
                  icon: Icons.calendar_month_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF18252A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF253238)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _gold, size: 17),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.appTheme.bodySmall.override(
              fontFamily: 'Plus Jakarta Sans',
              color: const Color(0xFFB7C0BC),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.appTheme.bodyMedium.override(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
      ),
      child: TabBar(
        controller: _model.tabBarController,
        indicator: BoxDecoration(
          color: _ink,
          borderRadius: BorderRadius.circular(6),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: _muted,
        labelStyle: context.appTheme.bodySmall.override(
          fontFamily: 'Open Sans',
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
        unselectedLabelStyle: context.appTheme.bodySmall.override(
          fontFamily: 'Open Sans',
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        onTap: (_) => setState(() {}),
        tabs: const [
          Tab(text: 'Last job'),
          Tab(text: 'Today'),
          Tab(text: 'Weekly'),
        ],
      ),
    );
  }

  Widget _buildStatementBody(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.42,
        child: const Center(child: CircularProgressIndicator(color: _ink)),
      );
    }

    if (_loadError != null) {
      return _buildEmptyState(
        context,
        icon: Icons.cloud_off_rounded,
        title: 'Statement unavailable',
        message: _loadError!,
      );
    }

    final invoices = _selectedInvoices;
    if (invoices.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.receipt_long_rounded,
        title: 'No jobs found',
        message: 'There are no completed jobs for $_selectedLabel.',
      );
    }

    return Column(
      children:
          invoices
              .map(
                (invoice) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildInvoiceCard(context, invoice),
                ),
              )
              .toList(),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _line),
      ),
      child: Column(
        children: [
          Icon(icon, color: _muted, size: 34),
          const SizedBox(height: 12),
          Text(
            title,
            style: context.appTheme.bodyLarge.override(
              fontFamily: 'Open Sans',
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.appTheme.bodySmall.override(
              fontFamily: 'Plus Jakarta Sans',
              color: _muted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceCard(BuildContext context, Invoice invoice) {
    final total = _invoiceTotal(invoice);
    final paymentType = _value(invoice.paymentType, fallback: 'Cash');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _openInvoiceDetails(invoice),
        child: Ink(
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking ${_value(invoice.bookId)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.appTheme.bodyMedium.override(
                            fontFamily: 'Open Sans',
                            color: _ink,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_value(invoice.pickDate)} at ${_value(invoice.pickTime)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.appTheme.bodySmall.override(
                            fontFamily: 'Plus Jakarta Sans',
                            color: _muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF6F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _money(total),
                      style: context.appTheme.bodyMedium.override(
                        fontFamily: 'Open Sans',
                        color: _success,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildLocationLine(
                context,
                icon: Icons.trip_origin_rounded,
                color: _success,
                text: _value(invoice.pickup),
              ),
              const SizedBox(height: 9),
              _buildLocationLine(
                context,
                icon: Icons.flag_rounded,
                color: _danger,
                text: _value(invoice.destination),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  _buildChip(
                    context,
                    icon: Icons.payments_rounded,
                    label: paymentType,
                  ),
                  const SizedBox(width: 8),
                  _buildChip(
                    context,
                    icon: Icons.confirmation_number_rounded,
                    label: 'Job ${_value(invoice.jobId)}',
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded, color: _muted),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationLine(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.appTheme.bodySmall.override(
              fontFamily: 'Plus Jakarta Sans',
              color: _ink,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _muted, size: 13),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
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
            ),
          ],
        ),
      ),
    );
  }
}
