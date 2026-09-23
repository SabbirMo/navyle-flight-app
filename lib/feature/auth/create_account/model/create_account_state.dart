import 'package:navyla_flight_app/core/utils/password_strength.dart';

class CreateAccountState {
  final bool password;
  final bool termsAndCondition;
  final PasswordStrength passwordStrength;

  CreateAccountState({
    this.password = false,
    this.termsAndCondition = false,
    this.passwordStrength = PasswordStrength.none,
  });

  CreateAccountState copyWith({
    bool? password,
    bool? confirmPassword,
    bool? termsAndCondition,
    PasswordStrength? passwordStrength,
  }) {
    return CreateAccountState(
      password: password ?? this.password,
      termsAndCondition: termsAndCondition ?? this.termsAndCondition,
      passwordStrength: passwordStrength ?? this.passwordStrength,
    );
  }
}
