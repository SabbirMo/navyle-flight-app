import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/core/services/app_preference_service.dart';

class ThemeModeProvider extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return AppPreferenceService.themeMode;
  }

  void set(ThemeMode mode) {
    state = mode;
    AppPreferenceService.setThemeMode(mode);
  }

  void toggleTheme() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    AppPreferenceService.setThemeMode(next);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeProvider, ThemeMode>(
  ThemeModeProvider.new,
);
