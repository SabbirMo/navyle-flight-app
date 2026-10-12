import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/core/services/app_preference_service.dart';
import 'package:navyla_flight_app/feature/home/model/flight_journey_state.dart';

export 'package:navyla_flight_app/feature/home/model/flight_journey_state.dart';

class FlightJourneyNotifier extends Notifier<FlightJourneyState> {
  @override
  FlightJourneyState build() {
    final persisted = AppPreferenceService.getFlightJourney();
    return persisted ?? const FlightJourneyState(hasActiveFlight: false);
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
    String? status,
    bool? isStressFreeActive,
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
      status: status ?? state.status ?? 'On Time',
      isStressFreeActive: isStressFreeActive ?? state.isStressFreeActive,
    );
    AppPreferenceService.setFlightJourney(state);
  }

  void removeBoardingPass() {
    state = state.copyWith(hasActiveFlight: false);
    AppPreferenceService.setFlightJourney(state);
  }

  void toggleFlightStatus() {
    state = state.copyWith(hasActiveFlight: !state.hasActiveFlight);
    AppPreferenceService.setFlightJourney(state);
  }

  void setStressFreeMode(bool value) {
    state = state.copyWith(isStressFreeActive: value);
    AppPreferenceService.setFlightJourney(state);
  }

  void toggleStressFreeMode() {
    state = state.copyWith(isStressFreeActive: !state.isStressFreeActive);
    AppPreferenceService.setFlightJourney(state);
  }
}

final flightJourneyNotifierProvider =
    NotifierProvider<FlightJourneyNotifier, FlightJourneyState>(
      FlightJourneyNotifier.new,
    );
