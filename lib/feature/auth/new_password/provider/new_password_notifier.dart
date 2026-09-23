import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/auth/new_password/model/new_password_state.dart';

class NewPasswordNotifier extends Notifier<NewPasswordState> {
  @override
  NewPasswordState build() {
    return const NewPasswordState();
  }

  void onPasswordChanged(String password) {
    final bool hasMinLength = password.length >= 8;
    final bool hasSpecialChar =
        RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\/`~]').hasMatch(password);
    final bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);

    state = state.copyWith(
      password: password,
      hasMinLength: hasMinLength,
      hasSpecialChar: hasSpecialChar,
      hasUppercase: hasUppercase,
    );
  }

  void onConfirmPasswordChanged(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      obscureConfirmPassword: !state.obscureConfirmPassword,
    );
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

  Future<bool> resetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    if (!state.isPasswordValid) {
      setError("Please fulfill all password requirements");
      return false;
    }
    if (password != confirmPassword) {
      setError("Passwords do not match");
      return false;
    }
    setLoading(true);
    clearError();
    try {
      // Simulate network request
      await Future.delayed(const Duration(milliseconds: 800));
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final newPasswordNotifierProvider =
    NotifierProvider.autoDispose<NewPasswordNotifier, NewPasswordState>(
  NewPasswordNotifier.new,
);
