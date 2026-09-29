import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/navigate_airport/model/airport_route_model.dart';
import 'package:navyla_flight_app/feature/navigate_airport/provider/navigate_airport_state.dart';

export 'package:navyla_flight_app/feature/navigate_airport/provider/navigate_airport_state.dart';

class NavigateAirportNotifier extends Notifier<NavigateAirportState> {
  @override
  NavigateAirportState build() {
    return NavigateAirportState(
      selectedPoi: AirportPointOfInterest.defaultPoints.isNotEmpty
          ? AirportPointOfInterest.defaultPoints.first
          : null,
    );
  }

  void selectChip(String chipId) {
    state = state.copyWith(selectedChipId: chipId);
  }

  void updateSearch(String query) {
    state = state.copyWith(
      searchQuery: query,
      isSearchExpanded: query.trim().isNotEmpty,
    );
  }

  void setSearchExpanded(bool expanded) {
    state = state.copyWith(isSearchExpanded: expanded);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '', isSearchExpanded: false);
  }

  void selectPoi(AirportPointOfInterest poi) {
    state = state.copyWith(
      selectedPoi: poi,
      isSearchExpanded: false,
      searchQuery: poi.name,
    );
  }

  void toggleBookmark() {
    final currentStatus = state.terminalInfo.isBookmarked;
    state = state.copyWith(
      terminalInfo: state.terminalInfo.copyWith(isBookmarked: !currentStatus),
    );
  }

  void toggleNavigation() {
    state = state.copyWith(isNavigating: !state.isNavigating);
  }

  void setNavigating(bool navigating) {
    state = state.copyWith(isNavigating: navigating);
  }
}

final navigateAirportNotifierProvider =
    NotifierProvider<NavigateAirportNotifier, NavigateAirportState>(
  NavigateAirportNotifier.new,
);
