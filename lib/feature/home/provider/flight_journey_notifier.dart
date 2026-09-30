import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/home/model/flight_journey_state.dart';

export 'package:navyla_flight_app/feature/home/model/flight_journey_state.dart';

class FlightJourneyNotifier extends Notifier<FlightJourneyState> {
  @override
  FlightJourneyState build() {
    // When the user opens the app for the first time,
    // boarding pass is not added yet and weather is hidden.
    return const FlightJourneyState(hasActiveFlight: false);
  }

  void addBoardingPass({
    String? flightNumber,
    String? originCode,
    String? originCity,
    String? destinationCode,
    String? destinationCity,
    String? seat,
    String? gate,
    String? terminal,
    String? departureCountdown,
    String? checkInTime,
    String? weatherCity,
  }) {
    state = state.copyWith(
      hasActiveFlight: true,
      flightNumber: flightNumber ?? state.flightNumber,
      originCode: originCode ?? state.originCode,
      originCity: originCity ?? state.originCity,
      destinationCode: destinationCode ?? state.destinationCode,
      destinationCity: destinationCity ?? state.destinationCity,
      seat: seat ?? state.seat,
      gate: gate ?? state.gate,
      terminal: terminal ?? state.terminal,
      departureCountdown: departureCountdown ?? state.departureCountdown,
      checkInTime: checkInTime ?? state.checkInTime,
      weatherCity: weatherCity ?? state.weatherCity,
    );
  }

  void removeBoardingPass() {
    state = state.copyWith(hasActiveFlight: false);
  }

  void toggleFlightStatus() {
    state = state.copyWith(hasActiveFlight: !state.hasActiveFlight);
  }
}

final flightJourneyNotifierProvider =
    NotifierProvider<FlightJourneyNotifier, FlightJourneyState>(
  FlightJourneyNotifier.new,
);
