import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/boarding_pass/model/boarding_pass_state.dart';

export 'package:navyla_flight_app/feature/boarding_pass/model/boarding_pass_state.dart';

class BoardingPassNotifier extends Notifier<BoardingPassState> {
  Timer? _countdownTimer;

  @override
  BoardingPassState build() {
    ref.onDispose(() {
      _countdownTimer?.cancel();
    });

    _startTimer();
    return const BoardingPassState();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isStressFreeModeActive) {
        return;
      }

      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        timer.cancel();
      }
    });
  }

  void toggleStressFreeMode() {
    final nextStatus = !state.isStressFreeModeActive;
    state = state.copyWith(isStressFreeModeActive: nextStatus);
    if (nextStatus) {
      _startTimer();
    } else {
      _countdownTimer?.cancel();
    }
  }

  void exitStressFreeMode() {
    _countdownTimer?.cancel();
    state = state.copyWith(isStressFreeModeActive: false);
  }

  void resetTimer({int seconds = 1122}) {
    state = state.copyWith(
      remainingSeconds: seconds,
      isStressFreeModeActive: true,
    );
    _startTimer();
  }
}

final boardingPassNotifierProvider =
    NotifierProvider.autoDispose<BoardingPassNotifier, BoardingPassState>(
  BoardingPassNotifier.new,
);
