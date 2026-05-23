import 'package:flutter/material.dart';

const _brandColor = Color(0xFF101820);
const _accentColor = Color(0xFFEACB6C);
const _successColor = Color(0xFF249689);
const _warningColor = Color(0xFFC96F46);
const _errorColor = Color(0xFFE65454);

ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final background = isDark ? const Color(0xFF111418) : Colors.white;
  final surface = isDark ? const Color(0xFF171B20) : Colors.white;
  final onSurface = isDark ? Colors.white : const Color(0xFF12151C);
  final secondaryText =
      isDark ? const Color(0xFFB2BBC2) : const Color(0xFF57636C);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: _brandColor,
    brightness: brightness,
  ).copyWith(
    primary: _brandColor,
    onPrimary: Colors.white,
    secondary: _accentColor,
    onSecondary: _brandColor,
    tertiary: const Color(0xFF39D2C0),
    error: _errorColor,
    surface: surface,
    onSurface: onSurface,
  );

  final textTheme = _textTheme(onSurface, secondaryText);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    fontFamily: 'OpenSans',
    textTheme: textTheme,
    primaryColor: _brandColor,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.headlineMedium,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF22282F) : const Color(0xFFF6F7F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF303741) : const Color(0xFFE0E3E7),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF303741) : const Color(0xFFE0E3E7),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _brandColor, width: 1.4),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _brandColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    scrollbarTheme: const ScrollbarThemeData(),
  );
}

TextTheme _textTheme(Color primaryText, Color secondaryText) => TextTheme(
  displayLarge: _textStyle(primaryText, 60),
  displayMedium: _textStyle(primaryText, 45),
  displaySmall: _textStyle(primaryText, 32, weight: FontWeight.w600),
  headlineLarge: _textStyle(primaryText, 32),
  headlineMedium: _textStyle(primaryText, 22, weight: FontWeight.w600),
  headlineSmall: _textStyle(primaryText, 20, weight: FontWeight.w600),
  titleLarge: _textStyle(primaryText, 22, weight: FontWeight.w600),
  titleMedium: _textStyle(Colors.white, 18, weight: FontWeight.w600),
  titleSmall: _textStyle(Colors.white, 16, weight: FontWeight.w600),
  labelLarge: _textStyle(secondaryText, 16, weight: FontWeight.w500),
  labelMedium: _textStyle(secondaryText, 14, weight: FontWeight.w500),
  labelSmall: _textStyle(secondaryText, 12, weight: FontWeight.w500),
  bodyLarge: _textStyle(primaryText, 16),
  bodyMedium: _textStyle(primaryText, 14),
  bodySmall: _textStyle(primaryText, 12),
);

TextStyle _textStyle(
  Color color,
  double size, {
  FontWeight weight = FontWeight.normal,
}) => TextStyle(
  color: color,
  fontSize: size,
  fontWeight: weight,
  letterSpacing: 0,
);

extension AppThemeContext on BuildContext {
  AppTheme get appTheme => AppTheme._(this);
}

class AppTheme {
  const AppTheme._(this.context);

  final BuildContext context;

  ThemeData get _theme => Theme.of(context);
  ColorScheme get _colors => _theme.colorScheme;
  TextTheme get _text => _theme.textTheme;
  bool get _isDark => _theme.brightness == Brightness.dark;

  Color get primary => _colors.primary;
  Color get secondary => _colors.secondary;
  Color get tertiary => _colors.tertiary;
  Color get alternate =>
      _isDark ? const Color(0xFF262D34) : const Color(0xFFE0E3E7);
  Color get primaryText => _colors.onSurface;
  Color get secondaryText =>
      _isDark ? const Color(0xFFB2BBC2) : const Color(0xFF57636C);
  Color get primaryBackground => _theme.scaffoldBackgroundColor;
  Color get secondaryBackground => _colors.surface;
  Color get accent1 => const Color(0x33101820);
  Color get accent2 => const Color(0x33EACB6C);
  Color get accent3 => const Color(0x3339D2C0);
  Color get accent4 =>
      _isDark ? const Color(0xB314181B) : const Color(0xB3FFFFFF);
  Color get success => _successColor;
  Color get warning => _warningColor;
  Color get error => _colors.error;
  Color get info => Colors.white;
  Color get primaryBtnText => Colors.white;
  Color get lineColor =>
      _isDark ? const Color(0xFF22282F) : const Color(0xFFE0E3E7);
  Color get inputbackground =>
      _isDark ? const Color(0xFF373737) : const Color(0x26B6B6DE);

  TextStyle get displayLarge =>
      _text.displayLarge ?? _textStyle(primaryText, 60);
  TextStyle get displayMedium =>
      _text.displayMedium ?? _textStyle(primaryText, 45);
  TextStyle get displaySmall =>
      _text.displaySmall ?? _textStyle(primaryText, 32);
  TextStyle get headlineLarge =>
      _text.headlineLarge ?? _textStyle(primaryText, 32);
  TextStyle get headlineMedium =>
      _text.headlineMedium ?? _textStyle(primaryText, 22);
  TextStyle get headlineSmall =>
      _text.headlineSmall ?? _textStyle(primaryText, 20);
  TextStyle get titleLarge => _text.titleLarge ?? _textStyle(primaryText, 22);
  TextStyle get titleMedium => _text.titleMedium ?? _textStyle(info, 18);
  TextStyle get titleSmall => _text.titleSmall ?? _textStyle(info, 16);
  TextStyle get labelLarge => _text.labelLarge ?? _textStyle(secondaryText, 16);
  TextStyle get labelMedium =>
      _text.labelMedium ?? _textStyle(secondaryText, 14);
  TextStyle get labelSmall => _text.labelSmall ?? _textStyle(secondaryText, 12);
  TextStyle get bodyLarge => _text.bodyLarge ?? _textStyle(primaryText, 16);
  TextStyle get bodyMedium => _text.bodyMedium ?? _textStyle(primaryText, 14);
  TextStyle get bodySmall => _text.bodySmall ?? _textStyle(primaryText, 12);
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) => copyWith(
    fontFamily: fontFamily,
    color: color,
    fontSize: fontSize,
    letterSpacing: letterSpacing,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    decoration: decoration,
    height: lineHeight,
  );
}
