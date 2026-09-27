class ChangePasswordState {
  final bool currentPassword;
  final bool newPassword;
  final bool confirmNewPassword;

  ChangePasswordState({
    this.currentPassword = true,
    this.newPassword = true,
    this.confirmNewPassword = true,
  });

  ChangePasswordState copyWith({
    bool? currentPassword,
    bool? newPassword,
    bool? confirmNewPassword,
  }) {
    return ChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
    );
  }
}
