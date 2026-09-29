import 'package:flutter/material.dart';

class AirportPointOfInterest {
  final String id;
  final String name;
  final String category;
  final String subtitle;
  final String walkingMinutes;
  final String distance;
  final IconData icon;

  const AirportPointOfInterest({
    required this.id,
    required this.name,
    required this.category,
    required this.subtitle,
    required this.walkingMinutes,
    required this.distance,
    required this.icon,
  });

  static const List<AirportPointOfInterest> defaultPoints = [
    AirportPointOfInterest(
      id: 'gate_b24',
      name: 'Gate B24',
      category: 'Gates',
      subtitle: 'Boarding Gate • 3 min walk',
      walkingMinutes: '3 mins',
      distance: '180m',
      icon: Icons.flight_takeoff_rounded,
    ),
    AirportPointOfInterest(
      id: 'starbucks',
      name: 'Starbucks',
      category: 'Food & Dining',
      subtitle: 'Coffee & Snacks • Dining Plaza',
      walkingMinutes: '2 mins',
      distance: '120m',
      icon: Icons.coffee_rounded,
    ),
    AirportPointOfInterest(
      id: 'duty_free',
      name: 'Duty Free Zone',
      category: 'Shopping',
      subtitle: 'Luxury & Travel Essentials',
      walkingMinutes: '4 mins',
      distance: '240m',
      icon: Icons.shopping_bag_outlined,
    ),
    AirportPointOfInterest(
      id: 'terminal_5_block_a',
      name: 'Terminal 5 - Block A',
      category: 'Terminal',
      subtitle: 'Check-in & Priority Baggage',
      walkingMinutes: '6 mins',
      distance: '380m',
      icon: Icons.business_outlined,
    ),
    AirportPointOfInterest(
      id: 'dining_plaza',
      name: 'Dining Plaza',
      category: 'Food & Dining',
      subtitle: 'Restaurants & Lounge Area',
      walkingMinutes: '2 mins',
      distance: '150m',
      icon: Icons.restaurant_outlined,
    ),
  ];
}

class RouteCategoryChip {
  final String id;
  final String label;
  final IconData icon;
  final bool isPrimary;

  const RouteCategoryChip({
    required this.id,
    required this.label,
    required this.icon,
    this.isPrimary = false,
  });

  static const List<RouteCategoryChip> defaultChips = [
    RouteCategoryChip(
      id: 'ask_navyla',
      label: 'Ask NAVYLA',
      icon: Icons.help_outline_rounded,
      isPrimary: true,
    ),
    RouteCategoryChip(
      id: 'home',
      label: 'Home',
      icon: Icons.home_outlined,
    ),
    RouteCategoryChip(
      id: 'ticket',
      label: 'Ticket',
      icon: Icons.confirmation_number_outlined,
    ),
    RouteCategoryChip(
      id: 'feed',
      label: 'Feed',
      icon: Icons.dynamic_feed_outlined,
    ),
  ];
}

class TerminalRouteInfo {
  final String terminalName;
  final String airportName;
  final String temperature;
  final String aqi;
  final bool isBookmarked;

  const TerminalRouteInfo({
    this.terminalName = 'Main Terminal 5',
    this.airportName = 'London Heathrow',
    this.temperature = '30°',
    this.aqi = '41 AQI',
    this.isBookmarked = false,
  });

  TerminalRouteInfo copyWith({
    String? terminalName,
    String? airportName,
    String? temperature,
    String? aqi,
    bool? isBookmarked,
  }) {
    return TerminalRouteInfo(
      terminalName: terminalName ?? this.terminalName,
      airportName: airportName ?? this.airportName,
      temperature: temperature ?? this.temperature,
      aqi: aqi ?? this.aqi,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
