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
  final List<AirportHubItem> allHubs;

  const ExploreNearbyState({
    this.selectedRegion = 'All Hubs',
    this.searchQuery = '',
    this.isLocationEnabled = false,
    this.selectedHubCode = 'LHR',
    this.allHubs = const [
      AirportHubItem(
        code: 'LHR',
        name: 'London Heathrow',
        badge: 'Last Visited',
        badgeColor: Color(0xFFEFF6FF),
        badgeTextColor: Color(0xFF2563EB),
        subtitle: 'London, UK • T2, T3, T4, T5',
      ),
      AirportHubItem(
        code: 'BRU',
        name: 'Brussels Airport',
        badge: 'Upcoming Trip',
        badgeColor: Color(0xFFFEF3C7),
        badgeTextColor: Color(0xFFD97706),
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
    List<AirportHubItem>? allHubs,
  }) {
    return ExploreNearbyState(
      selectedRegion: selectedRegion ?? this.selectedRegion,
      searchQuery: searchQuery ?? this.searchQuery,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      selectedHubCode: selectedHubCode ?? this.selectedHubCode,
      allHubs: allHubs ?? this.allHubs,
    );
  }
}
