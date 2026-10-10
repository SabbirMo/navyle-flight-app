import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/ticket/model/saved_ticket_model.dart';

class SavedTicketsState {
  final List<SavedTicketModel> tickets;
  final int selectedIndex;
  final bool isViewingAddPass;

  const SavedTicketsState({
    this.tickets = const [],
    this.selectedIndex = 0,
    this.isViewingAddPass = false,
  });

  SavedTicketModel? get currentTicket =>
      (tickets.isNotEmpty && selectedIndex >= 0 && selectedIndex < tickets.length)
          ? tickets[selectedIndex]
          : null;

  SavedTicketsState copyWith({
    List<SavedTicketModel>? tickets,
    int? selectedIndex,
    bool? isViewingAddPass,
  }) {
    return SavedTicketsState(
      tickets: tickets ?? this.tickets,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isViewingAddPass: isViewingAddPass ?? this.isViewingAddPass,
    );
  }
}

class SavedTicketsNotifier extends Notifier<SavedTicketsState> {
  @override
  SavedTicketsState build() {
    return SavedTicketsState(
      tickets: List.from(SavedTicketModel.defaultTickets),
      selectedIndex: 0,
      isViewingAddPass: false,
    );
  }

  void selectTicket(int index) {
    if (index >= 0 && index < state.tickets.length) {
      state = state.copyWith(selectedIndex: index, isViewingAddPass: false);
    }
  }

  void showAddPass() {
    state = state.copyWith(isViewingAddPass: true);
  }

  void hideAddPass() {
    state = state.copyWith(isViewingAddPass: false);
  }

  void addTicket(SavedTicketModel ticket) {
    final updated = List<SavedTicketModel>.from(state.tickets)..add(ticket);
    state = state.copyWith(
      tickets: updated,
      selectedIndex: updated.length - 1,
      isViewingAddPass: false,
    );
  }

  void removeTicket(int index) {
    if (index >= 0 && index < state.tickets.length) {
      final updated = List<SavedTicketModel>.from(state.tickets)..removeAt(index);
      final newIndex = updated.isEmpty
          ? 0
          : (state.selectedIndex >= updated.length
              ? updated.length - 1
              : state.selectedIndex);
      state = state.copyWith(
        tickets: updated,
        selectedIndex: newIndex,
        isViewingAddPass: updated.isEmpty,
      );
    }
  }

  void removeAll() {
    state = state.copyWith(tickets: [], selectedIndex: 0, isViewingAddPass: true);
  }
}

final savedTicketsProvider =
    NotifierProvider<SavedTicketsNotifier, SavedTicketsState>(
      SavedTicketsNotifier.new,
    );
