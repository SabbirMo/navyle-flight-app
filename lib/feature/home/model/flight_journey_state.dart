class FlightJourneyState {
  final bool hasActiveFlight;
  final String flightNumber;
  final String originCode;
  final String originCity;
  final String destinationCode;
  final String destinationCity;
  final String departureCountdown;
  final String checkInTime;
  final String terminal;
  final String gate;
  final String seat;
  final String status;
  final String weatherCity;
  final String weatherTemperature;
  final String weatherCondition;
  final String weatherLocalTime;
  final String weatherDate;

  const FlightJourneyState({
    this.hasActiveFlight = false,
    this.flightNumber = 'BA 0215',
    this.originCode = 'AMS',
    this.originCity = 'Amsterdam',
    this.destinationCode = 'FRA',
    this.destinationCity = 'Frankfurt',
    this.departureCountdown = '04:42:15',
    this.checkInTime = '8:00am',
    this.terminal = 'T5',
    this.gate = 'B24',
    this.seat = '14A',
    this.status = 'On Time',
    this.weatherCity = 'New York',
    this.weatherTemperature = '24°C',
    this.weatherCondition = 'Partly cloudy',
    this.weatherLocalTime = '3:18 AM',
    this.weatherDate = 'Tue, Apr 23',
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
    String? weatherCity,
    String? weatherTemperature,
    String? weatherCondition,
    String? weatherLocalTime,
    String? weatherDate,
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
      weatherCity: weatherCity ?? this.weatherCity,
      weatherTemperature: weatherTemperature ?? this.weatherTemperature,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      weatherLocalTime: weatherLocalTime ?? this.weatherLocalTime,
      weatherDate: weatherDate ?? this.weatherDate,
    );
  }
}
