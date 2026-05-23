import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_minicab_driver/Acount%20Statements/acount_statements_widget.dart';
import 'package:new_minicab_driver/Data/api_service.dart';
import 'package:new_minicab_driver/Model/myProfile.dart';
import 'package:new_minicab_driver/home/home_model.dart';
import 'package:new_minicab_driver/home/open_jobs.dart';
import 'package:new_minicab_driver/review/review_screen.dart';
import 'package:new_minicab_driver/sms_view/sms_view.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';
import 'package:new_minicab_driver/time_slot/time_slot_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '/flutter_flow/flutter_flow_util.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late final HomeModel _model;
  late final Future<List<Driver>> _profileFuture;

  String _dueBalance = '0.00';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeModel());
    _profileFuture = _loadProfile();
    _loadDueBalance();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadDueBalance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dId = prefs.getString('d_id');
      if (dId == null || dId.trim().isEmpty) return;

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiService.driverTotalDueBalance),
      )..fields.addAll({'d_id': dId});

      final response = await request.send();
      if (response.statusCode != 200) return;

      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody) as Map<String, dynamic>;
      final totalCommission =
          jsonResponse['data']?['total_commission']?.toString();

      if (!mounted || totalCommission == null) return;
      setState(() => _dueBalance = totalCommission);
    } catch (_) {}
  }

  Future<List<Driver>> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dId = prefs.getString('d_id');
      if (dId == null || dId.trim().isEmpty) return [];

      final response = await http.post(
        Uri.parse(ApiService.driverViewProfile),
        body: {'d_id': dId},
      );

      if (response.statusCode != 200) return [];

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonResponse['data'];
      if (data is! List) return [];

      return data
          .whereType<Map<String, dynamic>>()
          .map(Driver.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  void _pushNamed(String routeName) {
    context.pushNamed(routeName);
  }

  void _pushPage(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  Future<void> _callSupport() async {
    await launchUrl(Uri(scheme: 'tel', path: '+447552834179'));
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.clear();
    if (!mounted) return;
    context.pushNamed('Login');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final drawerWidth = width < 420 ? width * 0.86 : 360.0;

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        elevation: 24,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
        ),
        backgroundColor: context.appTheme.primaryBackground,
        child: SafeArea(
          child: Column(
            children: [
              FutureBuilder<List<Driver>>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  final driver =
                      snapshot.hasData && snapshot.data!.isNotEmpty
                          ? snapshot.data!.first
                          : null;
                  return _DrawerHeader(
                    driver: driver,
                    dueBalance: _dueBalance,
                    loading:
                        snapshot.connectionState == ConnectionState.waiting,
                    onTap: () => _pushNamed('Myprofile'),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: _ThemeSwitch(
                  value:
                      _model.switchValue2 ??
                      Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    setState(() => _model.switchValue2 = value);
                    setDarkModeSetting(
                      context,
                      value ? ThemeMode.dark : ThemeMode.light,
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  children: [
                    const _SectionLabel('Work'),
                    _DrawerTile(
                      icon: Icons.space_dashboard_outlined,
                      label: 'Dashboard',
                      onTap: () => _pushNamed('Dashboard'),
                    ),
                    _DrawerTile(
                      icon: Icons.local_taxi_outlined,
                      label: 'Open Jobs',
                      onTap: () => _pushPage(OpenJobsSection()),
                    ),
                    _DrawerTile(
                      icon: Icons.event_available_outlined,
                      label: 'Upcoming Jobs',
                      onTap: () => _pushNamed('Upcomming'),
                    ),
                    _DrawerTile(
                      icon: Icons.history_outlined,
                      label: 'Job History',
                      onTap: () => _pushNamed('jobshistory'),
                    ),
                    _DrawerTile(
                      icon: Icons.gavel_outlined,
                      label: 'Bids',
                      onTap: () => _pushNamed('BidHistoryFilter'),
                    ),
                    _DrawerTile(
                      icon: Icons.schedule_outlined,
                      label: 'Time Slots',
                      onTap: () => _pushPage(TimeSlotView()),
                    ),
                    const _SectionLabel('Account'),
                    _DrawerTile(
                      icon: Icons.account_circle_outlined,
                      label: 'My Account',
                      onTap: () => _pushNamed('Myprofile'),
                    ),
                    _DrawerTile(
                      icon: Icons.edit_document,
                      label: 'Documents',
                      onTap: () => _pushNamed('AllDocoments'),
                    ),
                    _DrawerTile(
                      icon: Icons.receipt_long_outlined,
                      label: 'Account Statement',
                      onTap: () => _pushPage(AcountStatementsWidget()),
                    ),
                    _DrawerTile(
                      icon: Icons.picture_as_pdf_outlined,
                      label: 'Reports',
                      onTap: () => _pushNamed('invoiecs'),
                    ),
                    const _SectionLabel('Help'),
                    _DrawerTile(
                      icon: Icons.star_border_rounded,
                      label: 'Reviews',
                      onTap: () => _pushPage(ReviewScreen()),
                    ),
                    _DrawerTile(
                      icon: Icons.chat_outlined,
                      label: 'Messages',
                      onTap: () => _pushPage(ChatScreen()),
                    ),
                    _DrawerTile(
                      icon: Icons.call_outlined,
                      label: 'Support',
                      onTap: _callSupport,
                    ),
                    const SizedBox(height: 12),
                    _DrawerTile(
                      icon: Icons.logout_rounded,
                      label: 'Log out',
                      destructive: true,
                      onTap: _logout,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    required this.driver,
    required this.dueBalance,
    required this.loading,
    required this.onTap,
  });

  final Driver? driver;
  final String dueBalance;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = driver?.dName?.trim();
    final phone = driver?.dPhone?.trim();
    final avatarUrl = ApiService.driverImageUrl(driver?.dPic);

    return Material(
      color: context.appTheme.primary,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Avatar(imageUrl: avatarUrl, loading: loading),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name == null || name.isEmpty ? 'Driver' : name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.appTheme.titleLarge.override(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phone == null || phone.isEmpty
                              ? 'MiniCab Driver'
                              : phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.appTheme.bodySmall.override(
                            color: Colors.white.withValues(alpha: 0.72),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEACB6C),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Color(0xFF101820),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due balance',
                            style: context.appTheme.labelSmall.override(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'GBP $dueBalance',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.appTheme.titleMedium.override(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.imageUrl, required this.loading});

  final String imageUrl;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: ClipOval(
        child:
            loading
                ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
                : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Image.asset(
                        'assets/images/user.png',
                        fit: BoxFit.cover,
                      ),
                ),
      ),
    );
  }
}

class _ThemeSwitch extends StatelessWidget {
  const _ThemeSwitch({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      decoration: BoxDecoration(
        color: context.appTheme.secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.appTheme.alternate),
      ),
      child: Row(
        children: [
          Icon(
            value ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            color: context.appTheme.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value ? 'Dark mode' : 'Light mode',
              style: context.appTheme.bodyMedium.override(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: context.appTheme.primary,
            activeTrackColor: context.appTheme.accent1,
            inactiveTrackColor: context.appTheme.alternate,
            inactiveThumbColor: context.appTheme.secondaryText,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 6),
      child: Text(
        label.toUpperCase(),
        style: context.appTheme.labelSmall.override(
          color: context.appTheme.secondaryText,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color =
        destructive ? context.appTheme.error : context.appTheme.primary;
    final textColor =
        destructive ? context.appTheme.error : context.appTheme.primaryText;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: destructive ? 0.1 : 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.appTheme.bodyMedium.override(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.appTheme.secondaryText,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
