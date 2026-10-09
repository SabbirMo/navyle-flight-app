import 'package:flutter/material.dart';

class AirportHubItem {
  final String code;
  final String name;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final String subtitle;

  const AirportHubItem({
    required this.code,
    required this.name,
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
    required this.subtitle,
  });
}

class ExploreNearbyState {
  final String selectedRegion;
  final String searchQuery;
  final bool isLocationEnabled;
  final String selectedHubCode;
  final String? manualAirportCode;
  final String? detectedLocationAirportCode;
  final List<AirportHubItem> allHubs;

  const ExploreNearbyState({
    this.selectedRegion = 'All Hubs',
    this.searchQuery = '',
    this.isLocationEnabled = false,
    this.selectedHubCode = 'AMS',
    this.manualAirportCode,
    this.detectedLocationAirportCode,
    this.allHubs = const [
      AirportHubItem(
        code: 'AMS',
        name: 'Amsterdam Schiphol',
        badge: 'Hub',
        badgeColor: Color(0xFFEFF6FF),
        badgeTextColor: Color(0xFF2563EB),
        subtitle: 'Amsterdam, Netherlands • Departure 1, 2, 3',
      ),
      AirportHubItem(
        code: 'LHR',
        name: 'London Heathrow',
        badge: 'Last Visited',
        badgeColor: Color(0xFFEFF6FF),
        badgeTextColor: Color(0xFF2563EB),
        subtitle: 'London, UK • T2, T3, T4, T5',
      ),
      AirportHubItem(
        code: 'FRA',
        name: 'Frankfurt Airport',
        badge: 'Upcoming Trip',
        badgeColor: Color(0xFFFEF3C7),
        badgeTextColor: Color(0xFFD97706),
        subtitle: 'Frankfurt, Germany • Terminal 1, 2',
      ),
      AirportHubItem(
        code: 'BRU',
        name: 'Brussels Airport',
        subtitle: 'Zaventem, Belgium • Main & Gates A, B',
      ),
      AirportHubItem(
        code: 'JFK',
        name: 'JFK International',
        subtitle: 'New York, USA • Terminals 1, 4, 5, 7, 8',
      ),
      AirportHubItem(
        code: 'DXB',
        name: 'Dubai International',
        subtitle: 'Dubai, UAE • Concourse A, B, C & T3',
      ),
    ],
  });

  /// Resolves which airport context should currently be active:
  /// 1. Manual selection by passenger (highest priority once picked)
  /// 2. Active journey airport (from active boarding pass)
  /// 3. Reliably detected from user's location
  /// 4. Otherwise null (No active journey + no detected airport -> Show Select/Search Airport)
  String? getEffectiveAirportCode({
    required bool hasActiveFlight,
    String? journeyOriginCode,
  }) {
    if (manualAirportCode != null && manualAirportCode!.isNotEmpty) {
      return manualAirportCode;
    }
    if (hasActiveFlight &&
        journeyOriginCode != null &&
        journeyOriginCode.isNotEmpty) {
      return journeyOriginCode;
    }
    if (isLocationEnabled &&
        detectedLocationAirportCode != null &&
        detectedLocationAirportCode!.isNotEmpty) {
      return detectedLocationAirportCode;
    }
    return null;
  }

  List<AirportHubItem> get filteredHubs {
    if (searchQuery.trim().isEmpty) {
      return allHubs;
    }
    final q = searchQuery.toLowerCase();
    final list =
        allHubs.where((h) {
          return h.name.toLowerCase().contains(q) ||
              h.code.toLowerCase().contains(q) ||
              h.subtitle.toLowerCase().contains(q);
        }).toList();
    return list.isNotEmpty ? list : allHubs;
  }

  AirportHubItem get selectedHub {
    return allHubs.firstWhere(
      (h) => h.code == selectedHubCode,
      orElse: () => allHubs.first,
    );
  }

  ExploreNearbyState copyWith({
    String? selectedRegion,
    String? searchQuery,
    bool? isLocationEnabled,
    String? selectedHubCode,
    String? Function()? manualAirportCode,
    String? Function()? detectedLocationAirportCode,
    List<AirportHubItem>? allHubs,
  }) {
    return ExploreNearbyState(
      selectedRegion: selectedRegion ?? this.selectedRegion,
      searchQuery: searchQuery ?? this.searchQuery,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      selectedHubCode: selectedHubCode ?? this.selectedHubCode,
      manualAirportCode: manualAirportCode != null
          ? manualAirportCode()
          : this.manualAirportCode,
      detectedLocationAirportCode: detectedLocationAirportCode != null
          ? detectedLocationAirportCode()
          : this.detectedLocationAirportCode,
      allHubs: allHubs ?? this.allHubs,
    );
  }
}
