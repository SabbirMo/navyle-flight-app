class FlightJourneyState {
  final bool hasActiveFlight;
  final String? flightNumber;
  final String? originCode;
  final String? originCity;
  final String? destinationCode;
  final String? destinationCity;
  final String? departureCountdown;
  final String? checkInTime;
  final String? terminal;
  final String? gate;
  final String? seat;
  final String? status;
  final String? flightDate;
  final bool isStressFreeActive;

  const FlightJourneyState({
    this.hasActiveFlight = false,
    this.flightNumber,
    this.originCode,
    this.originCity,
    this.destinationCode,
    this.destinationCity,
    this.departureCountdown,
    this.checkInTime,
    this.terminal,
    this.gate,
    this.seat,
    this.status,
    this.flightDate,
    this.isStressFreeActive = true,
  });

  FlightJourneyState copyWith({
    bool? hasActiveFlight,
    String? flightNumber,
    String? originCode,
    String? originCity,
    String? destinationCode,
    String? destinationCity,
    String? departureCountdown,
    String? checkInTime,
    String? terminal,
    String? gate,
    String? seat,
    String? status,
    String? flightDate,
    bool? isStressFreeActive,
  }) {
    return FlightJourneyState(
      hasActiveFlight: hasActiveFlight ?? this.hasActiveFlight,
      flightNumber: flightNumber ?? this.flightNumber,
      originCode: originCode ?? this.originCode,
      originCity: originCity ?? this.originCity,
      destinationCode: destinationCode ?? this.destinationCode,
      destinationCity: destinationCity ?? this.destinationCity,
      departureCountdown: departureCountdown ?? this.departureCountdown,
      checkInTime: checkInTime ?? this.checkInTime,
      terminal: terminal ?? this.terminal,
      gate: gate ?? this.gate,
      seat: seat ?? this.seat,
      status: status ?? this.status,
      flightDate: flightDate ?? this.flightDate,
      isStressFreeActive: isStressFreeActive ?? this.isStressFreeActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasActiveFlight': hasActiveFlight,
      'flightNumber': flightNumber,
      'originCode': originCode,
      'originCity': originCity,
      'destinationCode': destinationCode,
      'destinationCity': destinationCity,
      'departureCountdown': departureCountdown,
      'checkInTime': checkInTime,
      'terminal': terminal,
      'gate': gate,
      'seat': seat,
      'status': status,
      'flightDate': flightDate,
      'isStressFreeActive': isStressFreeActive,
    };
  }

  factory FlightJourneyState.fromJson(Map<String, dynamic> json) {
    return FlightJourneyState(
      hasActiveFlight: json['hasActiveFlight'] as bool? ?? false,
      flightNumber: json['flightNumber'] as String?,
      originCode: json['originCode'] as String?,
      originCity: json['originCity'] as String?,
      destinationCode: json['destinationCode'] as String?,
      destinationCity: json['destinationCity'] as String?,
      departureCountdown: json['departureCountdown'] as String?,
      checkInTime: json['checkInTime'] as String?,
      terminal: json['terminal'] as String?,
      gate: json['gate'] as String?,
      seat: json['seat'] as String?,
      status: json['status'] as String?,
      flightDate: json['flightDate'] as String?,
      isStressFreeActive: json['isStressFreeActive'] as bool? ?? true,
    );
  }
}
