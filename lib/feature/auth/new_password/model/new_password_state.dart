class NewPasswordState {
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String password;
  final String confirmPassword;
  final bool hasMinLength;
  final bool hasSpecialChar;
  final bool hasUppercase;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const NewPasswordState({
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.password = '',
    this.confirmPassword = '',
    this.hasMinLength = false,
    this.hasSpecialChar = false,
    this.hasUppercase = false,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  bool get isPasswordValid =>
      hasMinLength && hasSpecialChar && hasUppercase;

  NewPasswordState copyWith({
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    String? password,
    String? confirmPassword,
    bool? hasMinLength,
    bool? hasSpecialChar,
    bool? hasUppercase,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    bool clearError = false,
  }) {
    return NewPasswordState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasSpecialChar: hasSpecialChar ?? this.hasSpecialChar,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
