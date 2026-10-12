import 'package:flutter/material.dart';

class TicketPalettePreset {
  final Color primaryColor;
  final Color secondaryColor;
  final Color badgeColor;
  final String badgeType; // 'flight', 'compass', 'wizz'
  final Color planeIconColor;
  final Color airlineLogoColor;
  final Color economyBgColor;
  final Color economyTextColor;

  const TicketPalettePreset({
    required this.primaryColor,
    required this.secondaryColor,
    required this.badgeColor,
    required this.badgeType,
    required this.planeIconColor,
    required this.airlineLogoColor,
    required this.economyBgColor,
    required this.economyTextColor,
  });
}

class TicketColorPalette {
  static const List<TicketPalettePreset> presets = [
    // 1. Classic Navy & Amber (British Airways aesthetic)
    TicketPalettePreset(
      primaryColor: Color(0xFF0453BC),
      secondaryColor: Color(0xFF024699),
      badgeColor: Color(0xFF0066FF),
      badgeType: 'flight',
      planeIconColor: Color(0xFFFA7E23),
      airlineLogoColor: Color(0xFF2563EB),
      economyBgColor: Color(0xFF196CCB),
      economyTextColor: Colors.white,
    ),
    // 2. Alpine Pearl & Midnight Navy (Lufthansa aesthetic)
    TicketPalettePreset(
      primaryColor: Color(0xFFFFFFFF),
      secondaryColor: Color(0xFFFFFFFF),
      badgeColor: Color(0xFF5B21B6),
      badgeType: 'compass',
      planeIconColor: Color(0xFF0B1B3D),
      airlineLogoColor: Color(0xFF0B1B3D),
      economyBgColor: Color(0xFFCAD4F8),
      economyTextColor: Color(0xFF1E1B4B),
    ),
    // 3. Lilac Violet & Crimson Rose (Wizz Air aesthetic)
    TicketPalettePreset(
      primaryColor: Color(0xFFEDE8FF),
      secondaryColor: Color(0xFFE5DEFF),
      badgeColor: Color(0xFFE11D48),
      badgeType: 'wizz',
      planeIconColor: Color(0xFF8B5CF6),
      airlineLogoColor: Color(0xFF9A84F8),
      economyBgColor: Color(0xFFB4A5F8),
      economyTextColor: Colors.white,
    ),
    // 4. Emerald Spruce & Warm Gold
    TicketPalettePreset(
      primaryColor: Color(0xFF0F5148),
      secondaryColor: Color(0xFF0A3C35),
      badgeColor: Color(0xFF059669),
      badgeType: 'flight',
      planeIconColor: Color(0xFFF59E0B),
      airlineLogoColor: Color(0xFF10B981),
      economyBgColor: Color(0xFF136A5E),
      economyTextColor: Colors.white,
    ),
    // 5. Burgundy Velvet & Coral Rose
    TicketPalettePreset(
      primaryColor: Color(0xFF701A75),
      secondaryColor: Color(0xFF4A0E4E),
      badgeColor: Color(0xFFDB2777),
      badgeType: 'compass',
      planeIconColor: Color(0xFFF472B6),
      airlineLogoColor: Color(0xFFC026D3),
      economyBgColor: Color(0xFF86198F),
      economyTextColor: Colors.white,
    ),
    // 6. Deep Indigo Slate & Electric Cyan
    TicketPalettePreset(
      primaryColor: Color(0xFF1E1B4B),
      secondaryColor: Color(0xFF0F172A),
      badgeColor: Color(0xFF0284C7),
      badgeType: 'flight',
      planeIconColor: Color(0xFF06B6D4),
      airlineLogoColor: Color(0xFF38BDF8),
      economyBgColor: Color(0xFF2E2976),
      economyTextColor: Colors.white,
    ),
  ];

  static TicketPalettePreset getPresetForIndex(int index) {
    return presets[index % presets.length];
  }
}

class SavedTicketModel {
  final String id;
  final String airlineName;
  final String flightClass;
  final String flightNumber;
  final String originCode;
  final String originCity;
  final String destinationCode;
  final String destinationCity;
  final String displayDate;
  final String date;
  final String departureTime;
  final String boardingTime;
  final String passengerName;
  final String terminal;
  final String gate;
  final String seat;
  final String luggage;
  final Color primaryColor;
  final Color secondaryColor;
  final Color badgeColor;
  final String badgeType; // 'flight', 'compass', 'wizz'
  final Color? planeIconColor;
  final Color? airlineLogoColor;
  final Color? economyBgColor;
  final Color? economyTextColor;
  final String? originalScanPath;

  const SavedTicketModel({
    required this.id,
    required this.airlineName,
    required this.flightClass,
    required this.flightNumber,
    required this.originCode,
    required this.originCity,
    required this.destinationCode,
    required this.destinationCity,
    required this.displayDate,
    required this.date,
    required this.departureTime,
    required this.boardingTime,
    this.passengerName = 'ALEX RIVERS',
    this.terminal = 'T5',
    this.gate = 'B24',
    this.seat = '14A',
    this.luggage = '03',
    this.primaryColor = const Color(0xFF0453BC),
    this.secondaryColor = const Color(0xFF024699),
    this.badgeColor = const Color(0xFF0066FF),
    this.badgeType = 'flight',
    this.planeIconColor,
    this.airlineLogoColor,
    this.economyBgColor,
    this.economyTextColor,
    this.originalScanPath,
  });

  Color get effectivePrimaryColor => primaryColor;

  Color get effectiveSecondaryColor => secondaryColor;

  Color get effectivePlaneIconColor {
    if (planeIconColor != null) return planeIconColor!;
    final upper = airlineName.toUpperCase();
    if (upper.contains('LUFTHANSA')) {
      return const Color(0xFF0B1B3D);
    }
    if (upper.contains('WIZZ')) {
      return const Color(0xFF8B5CF6);
    }
    return const Color(0xFFFA7E23);
  }

  Color get effectiveAirlineLogoColor {
    if (airlineLogoColor != null) return airlineLogoColor!;
    final upper = airlineName.toUpperCase();
    if (upper.contains('LUFTHANSA')) {
      return const Color(0xFF0B1B3D);
    }
    if (upper.contains('WIZZ')) {
      return const Color(0xFF9A84F8);
    }
    return const Color(0xFF2563EB);
  }

  Color get effectiveEconomyBgColor {
    if (economyBgColor != null) return economyBgColor!;
    final upper = airlineName.toUpperCase();
    if (upper.contains('LUFTHANSA')) {
      return const Color(0xFFCAD4F8);
    }
    if (upper.contains('WIZZ')) {
      return const Color(0xFFB4A5F8);
    }
    return const Color(0xFF196CCB);
  }

  Color get effectiveEconomyTextColor {
    if (economyTextColor != null) return economyTextColor!;
    final upper = airlineName.toUpperCase();
    if (upper.contains('LUFTHANSA')) {
      return const Color(0xFF1E1B4B);
    }
    return Colors.white;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'airlineName': airlineName,
      'flightClass': flightClass,
      'flightNumber': flightNumber,
      'originCode': originCode,
      'originCity': originCity,
      'destinationCode': destinationCode,
      'destinationCity': destinationCity,
      'displayDate': displayDate,
      'date': date,
      'departureTime': departureTime,
      'boardingTime': boardingTime,
      'passengerName': passengerName,
      'terminal': terminal,
      'gate': gate,
      'seat': seat,
      'luggage': luggage,
      'primaryColor': primaryColor.toARGB32(),
      'secondaryColor': secondaryColor.toARGB32(),
      'badgeColor': badgeColor.toARGB32(),
      'badgeType': badgeType,
      'planeIconColor': planeIconColor?.toARGB32(),
      'airlineLogoColor': airlineLogoColor?.toARGB32(),
      'economyBgColor': economyBgColor?.toARGB32(),
      'economyTextColor': economyTextColor?.toARGB32(),
      'originalScanPath': originalScanPath,
    };
  }

  factory SavedTicketModel.fromJson(Map<String, dynamic> json) {
    return SavedTicketModel(
      id:
          json['id'] as String? ??
          'ticket_${DateTime.now().millisecondsSinceEpoch}',
      airlineName: json['airlineName'] as String? ?? 'BRITISH AIRWAYS',
      flightClass: json['flightClass'] as String? ?? 'ECONOMY',
      flightNumber: json['flightNumber'] as String? ?? 'BA 0215',
      originCode: json['originCode'] as String? ?? 'AMS',
      originCity: json['originCity'] as String? ?? 'AMSTERDAM, NL',
      destinationCode: json['destinationCode'] as String? ?? 'FRA',
      destinationCity: json['destinationCity'] as String? ?? 'FRANKFURT, DE',
      displayDate: json['displayDate'] as String? ?? '24 Oct',
      date: json['date'] as String? ?? '24 Oct, 26',
      departureTime: json['departureTime'] as String? ?? '11:15 AM',
      boardingTime: json['boardingTime'] as String? ?? '10:30 AM',
      passengerName: json['passengerName'] as String? ?? 'ALEX RIVERS',
      terminal: json['terminal'] as String? ?? 'T5',
      gate: json['gate'] as String? ?? 'B24',
      seat: json['seat'] as String? ?? '14A',
      luggage: json['luggage'] as String? ?? '03',
      primaryColor: json['primaryColor'] != null
          ? Color(json['primaryColor'] as int)
          : const Color(0xFF0453BC),
      secondaryColor: json['secondaryColor'] != null
          ? Color(json['secondaryColor'] as int)
          : const Color(0xFF024699),
      badgeColor: json['badgeColor'] != null
          ? Color(json['badgeColor'] as int)
          : const Color(0xFF0066FF),
      badgeType: json['badgeType'] as String? ?? 'flight',
      planeIconColor: json['planeIconColor'] != null
          ? Color(json['planeIconColor'] as int)
          : null,
      airlineLogoColor: json['airlineLogoColor'] != null
          ? Color(json['airlineLogoColor'] as int)
          : null,
      economyBgColor: json['economyBgColor'] != null
          ? Color(json['economyBgColor'] as int)
          : null,
      economyTextColor: json['economyTextColor'] != null
          ? Color(json['economyTextColor'] as int)
          : null,
      originalScanPath: json['originalScanPath'] as String?,
    );
  }

  static List<SavedTicketModel> defaultTickets = const [
    SavedTicketModel(
      id: 'ba_0215',
      airlineName: 'BRITISH AIRWAYS',
      flightClass: 'ECONOMY',
      flightNumber: 'BA 0215',
      originCode: 'AMS',
      originCity: 'AMSTERDAM, NL',
      destinationCode: 'FRA',
      destinationCity: 'FRANKFURT, DE',
      displayDate: '24 Oct',
      date: '24 Oct, 26',
      departureTime: '11:15 AM',
      boardingTime: '10:30 AM',
      passengerName: 'ALEX RIVERS',
      terminal: 'T5',
      gate: 'B24',
      seat: '14A',
      luggage: '03',
      primaryColor: Color(0xFF0453BC),
      secondaryColor: Color(0xFF024699),
      planeIconColor: Color(0xFFFA7E23),
      airlineLogoColor: Color(0xFF2563EB),
      economyBgColor: Color(0xFF196CCB),
      economyTextColor: Colors.white,
      badgeColor: Color(0xFF0066FF),
      badgeType: 'flight',
    ),
    SavedTicketModel(
      id: 'lh_2031',
      airlineName: 'LUFTHANSA',
      flightClass: 'ECONOMY',
      flightNumber: 'LH 2031',
      originCode: 'FRA',
      originCity: 'FRANKFURT, DE',
      destinationCode: 'MUC',
      destinationCity: 'MUNICH, DE',
      displayDate: '24 Oct',
      date: '24 Oct, 26',
      departureTime: '2:20 PM',
      boardingTime: '1:40 PM',
      passengerName: 'ALEX RIVERS',
      terminal: 'T1',
      gate: 'A16',
      seat: '08F',
      luggage: '01',
      primaryColor: Color(0xFFFFFFFF),
      secondaryColor: Color(0xFFFFFFFF),
      planeIconColor: Color(0xFF0B1B3D),
      airlineLogoColor: Color(0xFF0B1B3D),
      economyBgColor: Color(0xFFCAD4F8),
      economyTextColor: Color(0xFF1E1B4B),
      badgeColor: Color(0xFF5B21B6),
      badgeType: 'compass',
    ),
    SavedTicketModel(
      id: 'w6_3189',
      airlineName: 'WIZZ AIR',
      flightClass: 'ECONOMY',
      flightNumber: 'W6 3189',
      originCode: 'MUC',
      originCity: 'MUNICH, DE',
      destinationCode: 'OTP',
      destinationCity: 'BUCHAREST, RO',
      displayDate: '24 Oct',
      date: '24 Oct, 26',
      departureTime: '6:40 PM',
      boardingTime: '6:00 PM',
      passengerName: 'ALEX RIVERS',
      terminal: 'T2',
      gate: 'C04',
      seat: '22C',
      luggage: '02',
      primaryColor: Color(0xFFEDE8FF),
      secondaryColor: Color(0xFFE5DEFF),
      planeIconColor: Color(0xFF8B5CF6),
      airlineLogoColor: Color(0xFF9A84F8),
      economyBgColor: Color(0xFFB4A5F8),
      economyTextColor: Colors.white,
      badgeColor: Color(0xFFE11D48),
      badgeType: 'wizz',
    ),
  ];
}
