import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'login_model.dart';
import 'package:new_minicab_driver/Data/api_service.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key, this.isFromHome});

  final bool? isFromHome;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  static const _logoAsset = 'assets/driver-app-icon.jpg';
  static const _signinEndpoint = ApiService.driverAuthenticationSignin;
  static const _ink = Color(0xFF101820);
  static const _green = Color(0xFF0E7C66);
  static const _gold = Color(0xFFE2A84F);
  static const _mist = Color(0xFFF4F7F5);

  late LoginModel _model;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  String _phoneNumber = '';
  bool _passwordVisible = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final request = http.MultipartRequest('POST', Uri.parse(_signinEndpoint));
      request.fields.addAll({
        'd_phone':
            _phoneNumber.trim().isEmpty
                ? _phoneController.text.trim()
                : _phoneNumber.trim(),
        'd_password': _passwordController.text,
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decoded = _decodeResponse(responseBody);

      if (response.statusCode == 200 && _isSuccess(decoded['status'])) {
        await _saveLoginSession(decoded);

        if (!mounted) {
          return;
        }

        _showToastMessage(_responseMessage(decoded, 'Login successful.'));
        context.goNamed('Home');
        return;
      }

      _showToastMessage(
        _responseMessage(decoded, 'Login failed. Please check your details.'),
      );
    } catch (error) {
      _showToastMessage('Login failed. Please check your connection.');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Map<String, dynamic> _decodeResponse(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return <String, dynamic>{};
    }

    final decoded = json.decode(responseBody);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return <String, dynamic>{'data': decoded};
  }

  bool _isSuccess(dynamic value) {
    final normalized = value?.toString().toLowerCase().trim();
    return value == true ||
        value == 1 ||
        normalized == 'true' ||
        normalized == '1' ||
        normalized == 'success';
  }

  String _responseMessage(Map<String, dynamic> response, String fallback) {
    final message = response['message'] ?? response['error'];
    if (message == null) {
      return fallback;
    }

    final text = message.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  Future<void> _saveLoginSession(Map<String, dynamic> response) async {
    final prefs = await SharedPreferences.getInstance();
    final data = response['data'];
    final user = data is Map ? data['user'] : response['user'];

    final userData = <String, dynamic>{};
    if (user is Map) {
      userData.addAll(Map<String, dynamic>.from(user));
    } else if (data is Map) {
      userData.addAll(Map<String, dynamic>.from(data));
    }

    final token =
        data is Map
            ? data['token'] ?? data['loginToken'] ?? response['token']
            : response['token'];
    if (token != null && token.toString().trim().isNotEmpty) {
      await prefs.setString('loginToken', token.toString());
    }

    for (final entry in userData.entries) {
      if (entry.value != null) {
        await prefs.setString(entry.key, entry.value.toString());
      }
    }

    final driverId =
        userData['d_id'] ??
        userData['driver_id'] ??
        userData['id'] ??
        response['d_id'];
    if (driverId != null && driverId.toString().trim().isNotEmpty) {
      await prefs.setString('d_id', driverId.toString());
    }

    await prefs.setBool('isLogin', true);
    await prefs.setInt('isRideStart', prefs.getInt('isRideStart') ?? 0);
  }

  void _showToastMessage(String message) {
    Fluttertoast.showToast(msg: message, textColor: Colors.white);
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TopBar(onBack: () => context.goNamed('Welcome')),
                      const SizedBox(height: 16),
                      const _LogoMark(),
                      const SizedBox(height: 26),
                      Text(
                        'Welcome back',
                        textAlign: TextAlign.center,
                        style: context.appTheme.displaySmall.copyWith(
                          color: _ink,
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to manage jobs, availability, and earnings.',
                        textAlign: TextAlign.center,
                        style: context.appTheme.bodyMedium.copyWith(
                          color: const Color(0xFF59655F),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 28),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE1E7E3)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 24,
                              offset: Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                IntlPhoneField(
                                  controller: _phoneController,
                                  focusNode: _phoneFocusNode,
                                  initialCountryCode: 'GB',
                                  disableLengthCheck: true,
                                  decoration: _inputDecoration(
                                    label: 'Phone number',
                                    icon: Icons.phone_rounded,
                                  ),
                                  style:
                                      context.appTheme.bodyMedium,
                                  keyboardType: TextInputType.phone,
                                  onChanged:
                                      (phone) =>
                                          _phoneNumber = phone.completeNumber,
                                  validator: (phone) {
                                    final value =
                                        phone?.number.trim() ??
                                        _phoneController.text.trim();
                                    if (value.isEmpty) {
                                      return 'Enter your phone number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),
                                TextFormField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  obscureText: !_passwordVisible,
                                  textInputAction: TextInputAction.done,
                                  decoration: _inputDecoration(
                                    label: 'Password',
                                    icon: Icons.lock_rounded,
                                  ).copyWith(
                                    suffixIcon: IconButton(
                                      tooltip:
                                          _passwordVisible
                                              ? 'Hide password'
                                              : 'Show password',
                                      onPressed:
                                          () => setState(
                                            () =>
                                                _passwordVisible =
                                                    !_passwordVisible,
                                          ),
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter your password';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) => _loginUser(),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        _isSubmitting ? null : _loginUser,
                                    icon:
                                        _isSubmitting
                                            ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                            : const Icon(
                                              Icons.login_rounded,
                                              size: 20,
                                            ),
                                    label: Text(
                                      _isSubmitting ? 'Signing in' : 'Sign in',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _green,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: _green
                                          .withValues(alpha: 0.58),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New to MiniCab Driver?',
                            style: context.appTheme.bodyMedium
                                .copyWith(color: const Color(0xFF59655F)),
                          ),
                          TextButton(
                            onPressed: () => context.goNamed('Signup'),
                            child: const Text('Create account'),
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

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _green),
      filled: true,
      fillColor: const Color(0xFFF9FBFA),
      labelStyle: const TextStyle(color: Color(0xFF59655F)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFDDE5E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _green, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE65454)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE65454), width: 1.4),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton.filledTonal(
        tooltip: 'Back',
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back_rounded),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _LoginWidgetState._ink,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 118,
            height: 118,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8E4)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18000000),
                  blurRadius: 22,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                _LoginWidgetState._logoAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _LoginWidgetState._gold,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(
              Icons.local_taxi_rounded,
              color: _LoginWidgetState._ink,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
