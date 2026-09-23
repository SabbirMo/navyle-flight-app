class ForgotPasswordState {
  final bool isLoading;
  final String? errorMessage;
  final bool isCodeSent;

  const ForgotPasswordState({
    this.isLoading = false,
    this.errorMessage,
    this.isCodeSent = false,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isCodeSent,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isCodeSent: isCodeSent ?? this.isCodeSent,
    );
  }
}
