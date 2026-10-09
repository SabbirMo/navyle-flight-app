class ChangePasswordState {
  final bool currentPassword;
  final bool newPassword;
  final bool confirmNewPassword;
  final bool hasMinLength;
  final bool hasSpecialChar;
  final bool hasUppercase;

  ChangePasswordState({
    this.currentPassword = true,
    this.newPassword = true,
    this.confirmNewPassword = true,
    this.hasMinLength = false,
    this.hasSpecialChar = false,
    this.hasUppercase = false,
  });

  bool get isPasswordValid => hasMinLength && hasSpecialChar && hasUppercase;

  ChangePasswordState copyWith({
    bool? currentPassword,
    bool? newPassword,
    bool? confirmNewPassword,
    bool? hasMinLength,
    bool? hasSpecialChar,
    bool? hasUppercase,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasSpecialChar: hasSpecialChar ?? this.hasSpecialChar,
      hasUppercase: hasUppercase ?? this.hasUppercase,
    );
  }
}
