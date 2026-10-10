import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/home/model/flight_journey_state.dart';

export 'package:navyla_flight_app/feature/home/model/flight_journey_state.dart';

class FlightJourneyNotifier extends Notifier<FlightJourneyState> {
  @override
  FlightJourneyState build() {
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
    String? flightDate,
    String? departureCountdown,
    String? checkInTime,
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
      flightDate: flightDate ?? state.flightDate,
      departureCountdown: departureCountdown ?? state.departureCountdown,
      checkInTime: checkInTime ?? state.checkInTime,
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
