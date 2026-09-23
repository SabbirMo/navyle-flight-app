import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/auth/verify_otp/model/verify_otp_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtpNotifier extends Notifier<VerifyOtpState> {
  Timer? _timer;
  static const int totalSeconds = 60;
  late final PinInputController pinController = PinInputController();

  @override
  VerifyOtpState build() {
    ref.onDispose(() {
      _timer?.cancel();
      pinController.dispose();
    });

    // Start 1 minute (60s) timer freshly whenever entering the screen
    _startTimer(totalSeconds, updateStateImmediately: false);

    return const VerifyOtpState(remainingSeconds: totalSeconds);
  }

  void _startTimer(int seconds, {bool updateStateImmediately = true}) {
    _timer?.cancel();

    if (updateStateImmediately) {
      state = state.copyWith(
        remainingSeconds: seconds,
        isResendActive: false,
        clearError: true,
      );
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 1) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        _timer?.cancel();
        state = state.copyWith(remainingSeconds: 0, isResendActive: true);
      }
    });
  }

  void onPinChanged(String pin) {
    state = state.copyWith(otp: pin, clearError: true);
    if (pinController.hasError) {
      pinController.clearError();
    }
  }

  void onOtpChanged(String otp) => onPinChanged(otp);

  Future<void> verifyCode({
    VoidCallback? onSuccess,
    void Function(String message)? onError,
  }) async {
    final code = pinController.text.isNotEmpty ? pinController.text : state.otp;

    if (code.length < 4) {
      pinController.triggerError();
      const errorMsg = 'Please enter a 4-digit code';
      state = state.copyWith(errorMessage: errorMsg);
      onError?.call(errorMsg);
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    await Future.delayed(const Duration(milliseconds: 400));

    // Test verification: '1234' is the valid code.
    // Any other code will trigger wrong OTP error shake & red borders.
    if (code == '1234') {
      state = state.copyWith(isLoading: false, clearError: true);
      onSuccess?.call();
    } else {
      pinController.triggerError();
      const errorMsg = 'Wrong OTP code. Please try again.';
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
      );
      onError?.call(errorMsg);
    }
  }

  void resendOtp() {
    if (!state.isResendActive) return;
    pinController.clear();
    state = state.copyWith(otp: '', clearError: true);
    _startTimer(totalSeconds);
  }

  void resetTimer([int seconds = totalSeconds]) {
    pinController.clear();
    state = state.copyWith(otp: '', clearError: true);
    _startTimer(seconds);
  }
}

final verifyOtpNotifierProvider =
    NotifierProvider.autoDispose<VerifyOtpNotifier, VerifyOtpState>(
      VerifyOtpNotifier.new,
    );
