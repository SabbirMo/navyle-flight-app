import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/setting/change_password/model/change_password_state.dart';

class ChangePasswordNotifier extends Notifier<ChangePasswordState> {
  @override
  ChangePasswordState build() => ChangePasswordState();

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
