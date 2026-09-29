import 'package:navyla_flight_app/feature/navigate_airport/model/airport_route_model.dart';

class NavigateAirportState {
  final String selectedChipId;
  final String searchQuery;
  final TerminalRouteInfo terminalInfo;
  final AirportPointOfInterest? selectedPoi;
  final bool isNavigating;
  final bool isSearchExpanded;
  final List<AirportPointOfInterest> points;
  final List<RouteCategoryChip> chips;

  const NavigateAirportState({
    this.selectedChipId = 'ask_navyla',
    this.searchQuery = '',
    this.terminalInfo = const TerminalRouteInfo(),
    this.selectedPoi,
    this.isNavigating = false,
    this.isSearchExpanded = false,
    this.points = AirportPointOfInterest.defaultPoints,
    this.chips = RouteCategoryChip.defaultChips,
  });

  List<AirportPointOfInterest> get filteredPoints {
    if (searchQuery.trim().isEmpty) {
      return points;
    }
    final q = searchQuery.toLowerCase().trim();
    return points.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q) ||
          p.subtitle.toLowerCase().contains(q);
    }).toList();
  }

  NavigateAirportState copyWith({
    String? selectedChipId,
    String? searchQuery,
    TerminalRouteInfo? terminalInfo,
    AirportPointOfInterest? selectedPoi,
    bool? isNavigating,
    bool? isSearchExpanded,
    List<AirportPointOfInterest>? points,
    List<RouteCategoryChip>? chips,
  }) {
    return NavigateAirportState(
      selectedChipId: selectedChipId ?? this.selectedChipId,
      searchQuery: searchQuery ?? this.searchQuery,
      terminalInfo: terminalInfo ?? this.terminalInfo,
      selectedPoi: selectedPoi ?? this.selectedPoi,
      isNavigating: isNavigating ?? this.isNavigating,
      isSearchExpanded: isSearchExpanded ?? this.isSearchExpanded,
      points: points ?? this.points,
      chips: chips ?? this.chips,
    );
  }
}
