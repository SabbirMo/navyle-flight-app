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
    );
  }
}
