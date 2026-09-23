import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/auth/forgot/model/forgot_password_state.dart';

class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
  @override
  ForgotPasswordState build() {
    return const ForgotPasswordState();
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(errorMessage: error);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<bool> sendResetCode(String email) async {
    setLoading(true);
    clearError();
    try {
      // Simulate API call for sending reset code
      await Future.delayed(const Duration(milliseconds: 800));
      state = state.copyWith(isLoading: false, isCodeSent: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final forgotPasswordNotifierProvider =
    NotifierProvider.autoDispose<ForgotPasswordNotifier, ForgotPasswordState>(
  ForgotPasswordNotifier.new,
);
