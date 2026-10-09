import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/setting/change_password/model/change_password_state.dart';

class ChangePasswordNotifier extends Notifier<ChangePasswordState> {
  @override
  ChangePasswordState build() => ChangePasswordState();

  void onNewPasswordChanged(String password) {
    final bool hasMinLength = password.length >= 8;
    final bool hasSpecialChar = RegExp(
      r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\/`~]',
    ).hasMatch(password);
    final bool hasUppercase = RegExp(r'[A-Z]').hasMatch(password);

    state = state.copyWith(
      hasMinLength: hasMinLength,
      hasSpecialChar: hasSpecialChar,
      hasUppercase: hasUppercase,
    );
  }

  void toggleCurrentPassword() {
    state = state.copyWith(currentPassword: !state.currentPassword);
  }

  void toggleNewPassword() {
    state = state.copyWith(newPassword: !state.newPassword);
  }

  void toggleConfirmPassword() {
    state = state.copyWith(confirmNewPassword: !state.confirmNewPassword);
  }
}

final changePasswordNotifierProvider =
    NotifierProvider.autoDispose<ChangePasswordNotifier, ChangePasswordState>(
      ChangePasswordNotifier.new,
    );
