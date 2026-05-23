import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_minicab_driver/theme/app_theme.dart';

void main() {
  test('builds the app-owned light and dark themes', () {
    final lightTheme = buildAppTheme(Brightness.light);
    final darkTheme = buildAppTheme(Brightness.dark);

    expect(lightTheme.brightness, Brightness.light);
    expect(darkTheme.brightness, Brightness.dark);
    expect(lightTheme.colorScheme.primary, const Color(0xFF101820));
  });
}
