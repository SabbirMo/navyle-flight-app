import 'package:flutter/material.dart';

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
  });

  Color get effectivePrimaryColor {
    if (primaryColor != const Color(0xFF4C1D95) &&
        primaryColor != const Color(0xFFBE185D) &&
        primaryColor != const Color(0xFF0453BC)) {
      return primaryColor;
    }
    final upper = airlineName.toUpperCase();
    if (upper.contains('LUFTHANSA')) {
      return const Color(0xFFFFFFFF);
    }
    if (upper.contains('WIZZ')) {
      return const Color(0xFFEDE8FF);
    }
    return const Color(0xFF0453BC);
  }

  Color get effectiveSecondaryColor {
    if (secondaryColor != const Color(0xFF3B0764) &&
        secondaryColor != const Color(0xFF831843) &&
        secondaryColor != const Color(0xFF024699)) {
      return secondaryColor;
    }
    final upper = airlineName.toUpperCase();
    if (upper.contains('LUFTHANSA')) {
      return const Color(0xFFFFFFFF);
    }
    if (upper.contains('WIZZ')) {
      return const Color(0xFFE5DEFF);
    }
    return const Color(0xFF024699);
  }

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
