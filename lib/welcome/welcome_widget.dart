import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'welcome_model.dart';
export 'welcome_model.dart';

class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({super.key});

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  static const _logoAsset = 'assets/driver-app-icon.jpg';
  static const _ink = Color(0xFF101820);
  static const _green = Color(0xFF0E7C66);
  static const _gold = Color(0xFFE2A84F);
  static const _mist = Color(0xFFF4F7F5);

  late WelcomeModel _model;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WelcomeModel());
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('isLogin') ?? false;

    if (!mounted || !isLogin) {
      return;
    }

    context.goNamed('Home');
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
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: _mist,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 132,
                          height: 132,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8E4)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x18000000),
                                blurRadius: 24,
                                offset: Offset(0, 14),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(_logoAsset, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      const SizedBox(height: 34),
                      Text(
                        'MiniCab Driver',
                        textAlign: TextAlign.center,
                        style: context.appTheme.displaySmall.copyWith(
                          color: _ink,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'A calmer way to start your shift, manage bookings, and keep every ride moving.',
                        textAlign: TextAlign.center,
                        style: context.appTheme.bodyLarge.copyWith(
                          color: const Color(0xFF59655F),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 30),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE1E7E3)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: const [
                              _OnboardingPoint(
                                icon: Icons.route_rounded,
                                title: 'Clear dispatch',
                                subtitle:
                                    'See accepted and upcoming jobs at a glance.',
                              ),
                              SizedBox(height: 14),
                              _OnboardingPoint(
                                icon: Icons.payments_rounded,
                                title: 'Simple earnings',
                                subtitle:
                                    'Track fares, bids, and account statements.',
                              ),
                              SizedBox(height: 14),
                              _OnboardingPoint(
                                icon: Icons.verified_rounded,
                                title: 'Driver ready',
                                subtitle:
                                    'Keep profile and vehicle details in order.',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () => context.goNamed('Signup'),
                          icon: const Icon(Icons.person_add_alt_1_rounded),
                          label: const Text('Create driver account'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: context.appTheme.titleSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 54,
                        child: OutlinedButton.icon(
                          onPressed: () => context.goNamed('Login'),
                          icon: const Icon(Icons.login_rounded),
                          label: const Text('Sign in'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _ink,
                            side: const BorderSide(color: Color(0xFFD5DED9)),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: context.appTheme.titleSmall.copyWith(
                              color: _ink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _gold,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Secure driver access',
                            style: context.appTheme.bodySmall
                                .copyWith(color: const Color(0xFF59655F)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPoint extends StatelessWidget {
  const _OnboardingPoint({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _WelcomeWidgetState._mist,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _WelcomeWidgetState._green, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.appTheme.bodyLarge.copyWith(
                  color: _WelcomeWidgetState._ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: context.appTheme.bodySmall.copyWith(
                  color: const Color(0xFF59655F),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
