class VerifyOtpState {
  final String otp;
  final int remainingSeconds;
  final bool isResendActive;
  final bool isLoading;
  final String? errorMessage;

  const VerifyOtpState({
    this.otp = '',
    this.remainingSeconds = 60,
    this.isResendActive = false,
    this.isLoading = false,
    this.errorMessage,
  });

  VerifyOtpState copyWith({
    String? otp,
    int? remainingSeconds,
    bool? isResendActive,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return VerifyOtpState(
      otp: otp ?? this.otp,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isResendActive: isResendActive ?? this.isResendActive,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
