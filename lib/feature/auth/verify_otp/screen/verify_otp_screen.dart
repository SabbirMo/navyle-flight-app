import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/core/widgets/start_animation.dart';
import 'package:navyla_flight_app/feature/auth/auth_selection/widget/auth_common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/auth/verify_otp/model/verify_otp_state.dart';
import 'package:navyla_flight_app/feature/auth/verify_otp/provider/verify_otp_notifer.dart';
import 'package:navyla_flight_app/feature/auth/verify_otp/widget/circular_countdown_timer.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen>
    with TickerProviderStateMixin {
  late final StartAnimations _animations = StartAnimations(this);

  @override
  void reassemble() {
    super.reassemble();
    _animations.reassemble();
  }

  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  void _handleSuccess() {
    FocusScope.of(context).unfocus();
    context.push(AppRouterName.verificationSuccessScreen);
  }

  void _showError(String message) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verifyOtpNotifierProvider);
    final notifier = ref.read(verifyOtpNotifierProvider.notifier);

    return AuthCommonScreen(
      bottomSafeArea: false,
      resizeToAvoidBottomInset: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Top Header Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),
                          // Back Button
                          _animations.taglineTransition(
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: CustomBackButton(),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          // App Logo
                          _animations.buttonTransition(
                            child: Image.asset(
                              ImageAssets.appLogo,
                              width: 52.w,
                              height: 52.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Title
                          _animations.taglineTransition(
                            child: Text(
                              AppString.checkYourEmail,
                              textAlign: TextAlign.center,
                              style: StyleManager.poppinsBold24(
                                AppColors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          // Subtitle
                          _animations.taglineTransition(
                            child: Text(
                              AppString.otpSubtitle,
                              textAlign: TextAlign.center,
                              style: StyleManager.interMedium13(
                                AppColors.grayColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),

                    // White Form Card
                    Expanded(
                      child: _animations.buttonTransition(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.lightBgColor.withValues(
                              alpha: 0.8,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(28.r),
                              topRight: Radius.circular(28.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.blackShadow.withValues(
                                  alpha: 0.06,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, -3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.fromLTRB(
                            20.w,
                            32.h,
                            20.w,
                            MediaQuery.of(context).padding.bottom + 24.h,
                          ),
                          child: Column(
                            children: [
                              // 4-Digit Pin Code Input (using MaterialPinField from pin_code_fields)
                              MaterialPinField(
                                length: 4,
                                pinController: notifier.pinController,
                                autoFocus: false,
                                keyboardType: TextInputType.number,
                                clearErrorOnInput: true,
                                errorText: state.errorMessage,
                                errorBuilder: (errorText) {
                                  if (errorText == null || errorText.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.error_outline_rounded,
                                          color: AppColors.errorRed,
                                          size: 16.sp,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          errorText,
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.errorRed,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                onTapOutside: (_) =>
                                    FocusScope.of(context).unfocus(),
                                theme: MaterialPinTheme(
                                  shape: MaterialPinShape.outlined,
                                  cellSize: Size(64.w, 64.h),
                                  spacing: 14.w,
                                  borderRadius: BorderRadius.circular(14.r),
                                  borderWidth: 1.5,
                                  focusedBorderWidth: 1.8,
                                  borderColor: const Color(0xFFE5E7EB),
                                  focusedBorderColor:
                                      AppColors.buttonGradientStart,
                                  filledBorderColor:
                                      AppColors.buttonGradientStart,
                                  fillColor: Colors.white,
                                  focusedFillColor: Colors.white,
                                  filledFillColor: Colors.white,
                                  showCursor: true,
                                  cursorColor: AppColors.buttonGradientStart,
                                  cursorWidth: 2.0,
                                  // Error theme for wrong OTP indication
                                  errorColor: AppColors.errorRed,
                                  errorBorderColor: AppColors.errorRed,
                                  errorFillColor: const Color(0xFFFEF2F2),
                                  errorBorderWidth: 1.8,
                                  errorTextStyle: GoogleFonts.inter(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.errorRed,
                                  ),
                                  hintCharacter: '-',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                  textStyle: GoogleFonts.inter(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                onChanged: notifier.onPinChanged,
                                onCompleted: (pin) {
                                  notifier.verifyCode(
                                    onSuccess: _handleSuccess,
                                    onError: _showError,
                                  );
                                },
                              ),
                              SizedBox(height: 50.h),
                              // Circular Countdown Timer
                              CircularCountdownTimer(
                                remainingSeconds: state.remainingSeconds,
                                totalSeconds: 60,
                              ),
                              SizedBox(height: 20.h),

                              // Didn't receive the code? Resend
                              _buildResendRow(state, notifier),
                              // Verify OTP Button
                              SizedBox(height: 30.h),
                              CustomButton(
                                text: AppString.verifyOtp,
                                isLoading: state.isLoading,
                                onTap: () {
                                  notifier.verifyCode(
                                    onSuccess: _handleSuccess,
                                    onError: _showError,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Resend Code Row
  Widget _buildResendRow(VerifyOtpState state, VerifyOtpNotifier notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppString.didntReceiveCode,
          style: StyleManager.interMedium13(const Color(0xFF6B7280)),
        ),
        GestureDetector(
          onTap: state.isResendActive ? () => notifier.resendOtp() : null,
          child: Text(
            AppString.resend,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: state.isResendActive
                  ? AppColors.primaryColor
                  : const Color(0xFF9CA3AF),
            ),
          ),
        ),
      ],
    );
  }
}
