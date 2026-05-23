import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:new_minicab_driver/theme/app_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'signup_model.dart';
import 'package:new_minicab_driver/Data/api_service.dart';
export 'signup_model.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({super.key});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  static const _logoAsset = 'assets/driver-app-icon.jpg';
  static const _registerEndpoint = ApiService.driverAuthenticationRegister;
  static const _zonesEndpoint = ApiService.driverZones;
  static const _vehiclesEndpoint = ApiService.driverActivityFetchVehicles;
  static const _ink = Color(0xFF101820);
  static const _green = Color(0xFF0E7C66);
  static const _gold = Color(0xFFE2A84F);
  static const _mist = Color(0xFFF4F7F5);

  static const _shiftOptions = [
    'Day Shift',
    'Afternoon Shift',
    'Evening Shift',
    'Night Shift',
  ];

  late SignupModel _model;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tflController = TextEditingController();
  final _carMakeController = TextEditingController();
  final _carModelController = TextEditingController();

  final _fullNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _tflFocusNode = FocusNode();
  final _carMakeFocusNode = FocusNode();
  final _carModelFocusNode = FocusNode();

  List<String> _postCodeOptions = [];
  List<String> _vehicleTypeOptions = [];

  String _phoneNumber = '';
  String? _postCode;
  String? _shiftTiming;
  String? _vehicleType;

  bool _acceptedTerms = false;
  bool _passwordVisible = false;
  bool _isSubmitting = false;
  bool _loadingPostCodes = true;
  bool _loadingVehicleTypes = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignupModel());
    _loadDropdowns();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _tflController.dispose();
    _carMakeController.dispose();
    _carModelController.dispose();

    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _tflFocusNode.dispose();
    _carMakeFocusNode.dispose();
    _carModelFocusNode.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadDropdowns() async {
    await Future.wait([_loadPostCodes(), _loadVehicleTypes()]);
  }

  Future<void> _loadPostCodes() async {
    setState(() => _loadingPostCodes = true);
    try {
      final options = await _fetchDropdownOptions(_zonesEndpoint, [
        'post_code',
        'postcode',
        'zone_name',
        'name',
        'starting_point',
      ]);

      if (!mounted) {
        return;
      }

      setState(() => _postCodeOptions = options);
    } catch (_) {
      _showToastMessage('Could not load post codes. Pull down and try again.');
    } finally {
      if (mounted) {
        setState(() => _loadingPostCodes = false);
      }
    }
  }

  Future<void> _loadVehicleTypes() async {
    setState(() => _loadingVehicleTypes = true);
    try {
      final options = await _fetchDropdownOptions(_vehiclesEndpoint, [
        'vehicle_type',
        'vt_name',
        'v_name',
        'name',
        'title',
      ]);

      if (!mounted) {
        return;
      }

      setState(() => _vehicleTypeOptions = options);
    } catch (_) {
      _showToastMessage(
        'Could not load vehicle types. Pull down and try again.',
      );
    } finally {
      if (mounted) {
        setState(() => _loadingVehicleTypes = false);
      }
    }
  }

  Future<List<String>> _fetchDropdownOptions(
    String endpoint,
    List<String> keys,
  ) async {
    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode != 200) {
      throw Exception('Dropdown request failed');
    }

    final decoded = json.decode(response.body);
    final dynamic data = decoded is Map ? decoded['data'] : decoded;
    final items = data is List ? data : <dynamic>[];
    final values = <String>[];

    for (final item in items) {
      if (item is String) {
        values.add(item);
        continue;
      }

      if (item is Map) {
        for (final key in keys) {
          final value = item[key];
          if (value != null && value.toString().trim().isNotEmpty) {
            values.add(value.toString().trim());
            break;
          }
        }
      }
    }

    return values.toSet().toList()..sort();
  }

  Future<void> _registerUser() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptedTerms) {
      _showToastMessage('Please accept the driver terms to continue.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_registerEndpoint),
      );
      request.fields.addAll({
        'full_name': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone':
            _phoneNumber.trim().isEmpty
                ? _phoneController.text.trim()
                : _phoneNumber.trim(),
        'password': _passwordController.text,
        'post_code': _postCode ?? '',
        'tfl_num': _tflController.text.trim(),
        'shift_timing': _shiftTiming ?? '',
        'vehicle_type': _vehicleType ?? '',
        'car_make': _carMakeController.text.trim(),
        'model': _carModelController.text.trim(),
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decoded = _decodeResponse(responseBody);

      if (response.statusCode == 200 && _isSuccess(decoded['status'])) {
        await _saveRegistrationHints(decoded);

        if (!mounted) {
          return;
        }

        _showToastMessage(
          _responseMessage(decoded, 'Registration successful. Please sign in.'),
        );
        context.goNamed('Login');
        return;
      }

      _showToastMessage(
        _responseMessage(decoded, 'Registration failed. Please try again.'),
      );
    } catch (error) {
      _showToastMessage('Registration failed. Please check your connection.');
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

  Future<void> _saveRegistrationHints(Map<String, dynamic> response) async {
    final data = response['data'];
    final prefs = await SharedPreferences.getInstance();

    final driverId =
        data is Map
            ? data['d_id'] ?? data['driver_id'] ?? data['id']
            : response['d_id'] ?? response['driver_id'] ?? response['id'];
    if (driverId != null && driverId.toString().trim().isNotEmpty) {
      await prefs.setString('d_id', driverId.toString());
    }
  }

  void _showToastMessage(String message) {
    Fluttertoast.showToast(msg: message, textColor: Colors.white);
  }

  Future<void> _refreshDropdowns() async {
    await Future.wait([_loadPostCodes(), _loadVehicleTypes()]);
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
        key: _scaffoldKey,
        backgroundColor: _mist,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshDropdowns,
            color: _green,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TopBar(onBack: () => context.goNamed('Welcome')),
                      const SizedBox(height: 16),
                      const _SignupHeader(),
                      const SizedBox(height: 24),
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
                                _buildTextField(
                                  controller: _fullNameController,
                                  focusNode: _fullNameFocusNode,
                                  label: 'Full name',
                                  icon: Icons.badge_rounded,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  validator:
                                      (value) =>
                                          _required(value, 'Enter full name'),
                                ),
                                const SizedBox(height: 14),
                                _buildTextField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  label: 'Email address',
                                  icon: Icons.alternate_email_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: _emailValidator,
                                ),
                                const SizedBox(height: 14),
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
                                      return 'Enter phone number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),
                                _buildTextField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  label: 'Password',
                                  icon: Icons.lock_rounded,
                                  obscureText: !_passwordVisible,
                                  textInputAction: TextInputAction.next,
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter password';
                                    }

                                    if (value.length < 8) {
                                      return 'Password must be at least 8 characters';
                                    }

                                    return null;
                                  },
                                ),
                                const SizedBox(height: 14),
                                _buildDropdown(
                                  value:
                                      _postCodeOptions.contains(_postCode)
                                          ? _postCode
                                          : null,
                                  label: 'Post code',
                                  icon: Icons.location_on_rounded,
                                  items: _postCodeOptions,
                                  isLoading: _loadingPostCodes,
                                  onChanged:
                                      (value) =>
                                          setState(() => _postCode = value),
                                  onRetry: _loadPostCodes,
                                ),
                                const SizedBox(height: 14),
                                _buildTextField(
                                  controller: _tflController,
                                  focusNode: _tflFocusNode,
                                  label: 'TFL number',
                                  icon: Icons.confirmation_number_rounded,
                                  textInputAction: TextInputAction.next,
                                  validator:
                                      (value) =>
                                          _required(value, 'Enter TFL number'),
                                ),
                                const SizedBox(height: 14),
                                _buildDropdown(
                                  value: _shiftTiming,
                                  label: 'Shift timing',
                                  icon: Icons.schedule_rounded,
                                  items: _shiftOptions,
                                  onChanged:
                                      (value) =>
                                          setState(() => _shiftTiming = value),
                                ),
                                const SizedBox(height: 14),
                                _buildDropdown(
                                  value:
                                      _vehicleTypeOptions.contains(_vehicleType)
                                          ? _vehicleType
                                          : null,
                                  label: 'Vehicle type',
                                  icon: Icons.local_taxi_rounded,
                                  items: _vehicleTypeOptions,
                                  isLoading: _loadingVehicleTypes,
                                  onChanged:
                                      (value) =>
                                          setState(() => _vehicleType = value),
                                  onRetry: _loadVehicleTypes,
                                ),
                                const SizedBox(height: 14),
                                _buildTextField(
                                  controller: _carMakeController,
                                  focusNode: _carMakeFocusNode,
                                  label: 'Car make',
                                  icon: Icons.directions_car_filled_rounded,
                                  textInputAction: TextInputAction.next,
                                  validator:
                                      (value) =>
                                          _required(value, 'Enter car make'),
                                ),
                                const SizedBox(height: 14),
                                _buildTextField(
                                  controller: _carModelController,
                                  focusNode: _carModelFocusNode,
                                  label: 'Model',
                                  icon: Icons.taxi_alert_rounded,
                                  textInputAction: TextInputAction.done,
                                  validator:
                                      (value) =>
                                          _required(value, 'Enter car model'),
                                  onFieldSubmitted: (_) => _registerUser(),
                                ),
                                const SizedBox(height: 16),
                                _TermsRow(
                                  value: _acceptedTerms,
                                  onChanged:
                                      (value) => setState(
                                        () => _acceptedTerms = value ?? false,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        _isSubmitting ? null : _registerUser,
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
                                              Icons.person_add_alt_1_rounded,
                                              size: 20,
                                            ),
                                    label: Text(
                                      _isSubmitting
                                          ? 'Creating account'
                                          : 'Create driver account',
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
                            'Already approved?',
                            style: context.appTheme.bodyMedium
                                .copyWith(color: const Color(0xFF59655F)),
                          ),
                          TextButton(
                            onPressed: () => context.goNamed('Login'),
                            child: const Text('Sign in'),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      decoration: _inputDecoration(
        label: label,
        icon: icon,
      ).copyWith(suffixIcon: suffixIcon),
      style: context.appTheme.bodyMedium,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isLoading = false,
    VoidCallback? onRetry,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: _inputDecoration(label: label, icon: icon).copyWith(
        suffixIcon:
            isLoading
                ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                : items.isEmpty && onRetry != null
                ? IconButton(
                  tooltip: 'Reload',
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                )
                : null,
      ),
      hint: Text(isLoading ? 'Loading $label' : 'Select $label'),
      items:
          items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
      onChanged: isLoading ? null : onChanged,
      validator: (selected) {
        if (selected == null || selected.isEmpty) {
          return 'Select $label';
        }
        return null;
      },
    );
  }

  String? _required(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Enter email address';
    }

    if (!RegExp(
      kTextValidatorEmailRegex,
      caseSensitive: false,
    ).hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
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
          foregroundColor: _SignupWidgetState._ink,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _SignupHeader extends StatelessWidget {
  const _SignupHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 112,
              height: 112,
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
                  _SignupWidgetState._logoAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: _SignupWidgetState._gold,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: _SignupWidgetState._ink,
                size: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          'Join the driver network',
          textAlign: TextAlign.center,
          style: context.appTheme.displaySmall.copyWith(
            color: _SignupWidgetState._ink,
            fontWeight: FontWeight.w700,
            fontSize: 31,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create your profile so dispatch can match you with the right work.',
          textAlign: TextAlign.center,
          style: context.appTheme.bodyMedium.copyWith(color: const Color(0xFF59655F), height: 1.45),
        ),
      ],
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: _SignupWidgetState._green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'I confirm these driver details are accurate and agree to the driver terms.',
            style: context.appTheme.bodySmall.copyWith(color: const Color(0xFF59655F), height: 1.4),
          ),
        ),
      ],
    );
  }
}
