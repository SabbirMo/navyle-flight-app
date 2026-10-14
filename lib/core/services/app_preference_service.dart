import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:navyla_flight_app/feature/home/model/flight_journey_state.dart';
import 'package:navyla_flight_app/feature/ticket/model/saved_ticket_model.dart';

class AppPreferenceService {
  static const String _keyIsLoggedIn = 'app_is_logged_in';
  static const String _keyThemeMode = 'app_theme_mode';
  static const String _keySavedTickets = 'app_saved_tickets_json';
  static const String _keyFlightJourney = 'app_flight_journey_json';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ==========================================
  // Auth / Signed-in State
  // ==========================================
  static bool get isLoggedIn => _prefs?.getBool(_keyIsLoggedIn) ?? false;

  static Future<void> setLoggedIn(bool value) async {
    await _prefs?.setBool(_keyIsLoggedIn, value);
  }

  // ==========================================
  // Theme Mode
  // ==========================================
  static ThemeMode get themeMode {
    final modeStr = _prefs?.getString(_keyThemeMode);
    if (modeStr == 'dark') return ThemeMode.dark;
    if (modeStr == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    final modeStr = mode == ThemeMode.dark
        ? 'dark'
        : (mode == ThemeMode.light ? 'light' : 'system');
    await _prefs?.setString(_keyThemeMode, modeStr);
  }

  // ==========================================
  // Saved Tickets
  // ==========================================
  static List<SavedTicketModel> getSavedTickets() {
    final jsonStr = _prefs?.getString(_keySavedTickets);
    if (jsonStr == null || jsonStr.isEmpty) {
      // Normal user list starts empty
      return <SavedTicketModel>[];
    }
    try {
      final decoded = jsonDecode(jsonStr) as List<dynamic>;
      return decoded
          .map((item) => SavedTicketModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return <SavedTicketModel>[];
    }
  }

  static Future<void> setSavedTickets(List<SavedTicketModel> tickets) async {
    final jsonList = tickets.map((t) => t.toJson()).toList();
    await _prefs?.setString(_keySavedTickets, jsonEncode(jsonList));
  }

  // ==========================================
  // Flight Journey
  // ==========================================
  static FlightJourneyState? getFlightJourney() {
    final jsonStr = _prefs?.getString(_keyFlightJourney);
    if (jsonStr == null || jsonStr.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      return FlightJourneyState.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  static Future<void> setFlightJourney(FlightJourneyState state) async {
    await _prefs?.setString(_keyFlightJourney, jsonEncode(state.toJson()));
  }

  // ==========================================
  // Smartwatch Setup
  // ==========================================
  static const String _keySmartWatchSetupCompleted =
      'app_smartwatch_setup_completed';

  static bool get isSmartWatchSetupCompleted =>
      _prefs?.getBool(_keySmartWatchSetupCompleted) ?? false;

  static Future<void> setSmartWatchSetupCompleted(bool value) async {
    await _prefs?.setBool(_keySmartWatchSetupCompleted, value);
  }

  // ==========================================
  // Sign Out / Delete Account Clear
  // ==========================================
  static Future<void> clearUserSession() async {
    await _prefs?.setBool(_keyIsLoggedIn, false);
    await _prefs?.remove(_keySavedTickets);
    await _prefs?.remove(_keyFlightJourney);
    await _prefs?.remove(_keySmartWatchSetupCompleted);
  }
}
