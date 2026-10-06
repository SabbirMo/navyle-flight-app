import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/explore_nearby/model/explore_nearby_state.dart';

class ExploreNearbyNotifier extends Notifier<ExploreNearbyState> {
  @override
  ExploreNearbyState build() => const ExploreNearbyState();

  void selectRegion(String region) {
    state = state.copyWith(selectedRegion: region);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  void toggleLocation() {
    state = state.copyWith(isLocationEnabled: !state.isLocationEnabled);
  }

  void selectHubCode(String code) {
    state = state.copyWith(selectedHubCode: code);
  }
}

final exploreNearbyNotifierProvider =
    NotifierProvider.autoDispose<ExploreNearbyNotifier, ExploreNearbyState>(
      ExploreNearbyNotifier.new,
    );
