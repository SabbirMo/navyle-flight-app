import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:navyla_flight_app/core/services/app_preference_service.dart';
import 'package:navyla_flight_app/core/theme/theme_mode_provder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Initial theme mode is ThemeMode.light on fresh start', () async {
    // Mock empty SharedPreferences (fresh install)
    SharedPreferences.setMockInitialValues({});
    await AppPreferenceService.init();

    // Verify preference defaults to light mode
    expect(AppPreferenceService.themeMode, ThemeMode.light);

    // Verify Riverpod provider initializes with light mode
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.light);
  });

  test('Setting theme mode toggles between light and dark without system mode', () async {
    SharedPreferences.setMockInitialValues({});
    await AppPreferenceService.init();

    final container = ProviderContainer();
    addTearDown(container.dispose);

    // 1. Initial is light
    expect(container.read(themeModeProvider), ThemeMode.light);

    // 2. Set to dark
    container.read(themeModeProvider.notifier).set(ThemeMode.dark);
    expect(container.read(themeModeProvider), ThemeMode.dark);
    expect(AppPreferenceService.themeMode, ThemeMode.dark);

    // 3. Set to light
    container.read(themeModeProvider.notifier).set(ThemeMode.light);
    expect(container.read(themeModeProvider), ThemeMode.light);
    expect(AppPreferenceService.themeMode, ThemeMode.light);
  });
}
