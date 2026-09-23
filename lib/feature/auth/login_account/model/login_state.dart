class LoginState {
  final bool obscurePassword;
  final bool rememberMe;
  final bool isLoading;
  final String? errorMessage;

  const LoginState({
    this.obscurePassword = true,
    this.rememberMe = true,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? obscurePassword,
    bool? rememberMe,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
