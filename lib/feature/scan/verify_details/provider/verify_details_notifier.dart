import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/scan/verify_details/model/verify_details_state.dart';
import 'package:navyla_flight_app/feature/ticket/model/saved_ticket_model.dart';
import 'package:navyla_flight_app/feature/ticket/provider/saved_tickets_provider.dart';

export 'package:navyla_flight_app/feature/scan/verify_details/model/verify_details_state.dart';

class VerifyDetailsNotifier extends Notifier<VerifyDetailsState> {
  @override
  VerifyDetailsState build() {
    return const VerifyDetailsState();
  }

  void initialize({bool isManual = false, Map<String, String>? initialData}) {
    final data = initialData ?? {};
    if (isManual) {
      state = const VerifyDetailsState(
        isManual: true,
        hasAttemptedSubmit: false,
      );
    } else {
      state = VerifyDetailsState(
        isManual: false,
        name: data['name'] ?? 'ALEX RIVERS',
        flightNumber: data['flightNumber'] ?? 'BA 0215',
        from: data['from'] ?? 'AMS',
        to: data['to'] ?? 'FRA',
        date: data['date'] ?? '24/09/26',
        seat: data['seat'] ?? '14A',
        terminal: data['terminal'] ?? '5',
        gate: data['gate'] ?? 'B24',
        hasAttemptedSubmit: false,
      );
    }
  }

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updateFlightNumber(String value) {
    state = state.copyWith(flightNumber: value);
  }

  void updateFrom(String value) {
    state = state.copyWith(from: value);
  }

  void updateTo(String value) {
    state = state.copyWith(to: value);
  }

  void updateDate(String value) {
    state = state.copyWith(date: value);
  }

  void updateSeat(String value) {
    state = state.copyWith(seat: value);
  }

  void updateTerminal(String value) {
    state = state.copyWith(terminal: value);
  }

  void updateGate(String value) {
    state = state.copyWith(gate: value);
  }

  bool submit() {
    state = state.copyWith(hasAttemptedSubmit: true);
    if (!state.isValid) {
      return false;
    }

    final finalFlightNum = state.flightNumber.trim();
    final from = state.from.trim();
    final to = state.to.trim();
    final date = state.date.trim();
    final seat = state.seat.trim();
    final gate = state.gate.trim();
    final terminal = state.terminal.trim();
    final passengerName = state.name.trim();

    // 1. Update Flight Journey
    ref
        .read(flightJourneyNotifierProvider.notifier)
        .addBoardingPass(
          flightNumber: finalFlightNum,
          originCode: from,
          originCity: from,
          destinationCode: to,
          destinationCity: to,
          seat: seat,
          gate: gate,
          terminal: terminal,
          flightDate: date,
        );

    // 2. Update Saved Tickets list
    final newSavedTicket = SavedTicketModel(
      id: 'ticket_${DateTime.now().millisecondsSinceEpoch}',
      airlineName: 'BRITISH AIRWAYS',
      flightClass: 'ECONOMY',
      flightNumber: finalFlightNum,
      originCode: from,
      originCity: from,
      destinationCode: to,
      destinationCity: to,
      displayDate: date,
      date: date,
      departureTime: '11:15 AM',
      boardingTime: '10:30 AM',
      passengerName: passengerName,
      terminal: terminal,
      gate: gate,
      seat: seat,
      luggage: '02',
      primaryColor: const Color(0xFF0453BC),
      secondaryColor: const Color(0xFF024699),
      badgeColor: const Color(0xFF0066FF),
      badgeType: 'flight',
    );
    ref.read(savedTicketsProvider.notifier).addTicket(newSavedTicket);

    return true;
  }
}

final verifyDetailsNotifierProvider =
    NotifierProvider<VerifyDetailsNotifier, VerifyDetailsState>(
      VerifyDetailsNotifier.new,
    );
