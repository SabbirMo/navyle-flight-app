import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/core/utils/password_strength.dart';
import 'package:navyla_flight_app/feature/auth/create_account/model/create_account_state.dart';

class CreateAccountNotifer extends Notifier<CreateAccountState> {
  @override
  CreateAccountState build() => CreateAccountState();

  void onPasswordToggle() {
    state = state.copyWith(password: !state.password);
  }

  void onTermsAndConditionToggle() {
    state = state.copyWith(termsAndCondition: !state.termsAndCondition);
  }

  void onPasswordChanged(String password) {
    final strength = PasswordStrength.calculate(password);
    state = state.copyWith(passwordStrength: strength);
  }
}

final createAccountNotifierProvider =
    NotifierProvider<CreateAccountNotifer, CreateAccountState>(
      CreateAccountNotifer.new,
    );
