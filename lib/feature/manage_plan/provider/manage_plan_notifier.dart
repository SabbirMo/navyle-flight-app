import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/manage_plan/model/manage_plan_state.dart';

class ManagePlanNotifier extends Notifier<ManagePlanState> {
  @override
  ManagePlanState build() => ManagePlanState();

  void toggleAutoRenew() {
    state = state.copyWith(isAutoRenew: !state.isAutoRenew);
  }

  void setAutoRenew(bool value) {
    state = state.copyWith(isAutoRenew: value);
  }
}

final managePlanNotifierProvider =
    NotifierProvider.autoDispose<ManagePlanNotifier, ManagePlanState>(
      ManagePlanNotifier.new,
    );
