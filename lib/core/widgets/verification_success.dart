import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

enum VerificationType { onlyVerify, updatePassword }

typedef VerificationSuccessType = VerificationType;

class VerificationSuccess extends StatefulWidget {
  final String userName;
  final String? email;
  final VoidCallback? onContinue;
  final VerificationType type;

  const VerificationSuccess({
    super.key,
    this.userName = AppString.defaultVerifiedUser,
    this.email,
    this.onContinue,
    this.type = VerificationType.onlyVerify,
  });

  @override
  State<VerificationSuccess> createState() => _VerificationSuccessState();
}

class _VerificationSuccessState extends State<VerificationSuccess>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _entranceController;
  late final AnimationController _lottieController;
  late final Animation<double> _pulseScale;
  late final Animation<double> _entranceScale;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Subtle breathing pulse for the outer concentric rings
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _pulseScale = Tween<double>(begin: 0.98, end: 1.025).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Entrance animation for content pop-in
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _entranceScale = Tween<double>(begin: 0.45, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    // Lottie animation controller
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _entranceController.forward();
    _lottieController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _entranceController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  void _replayAnimation() {
    _lottieController.reset();
    _lottieController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Resolve display name fallback
    final displayName = widget.userName.trim().isNotEmpty
        ? widget.userName
        : AppString.defaultVerifiedUser;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.blackShadow : Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background: Faint flight boarding pass watermark at the top fading to pure white
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 360.h,
            child: IgnorePointer(
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.black87, Colors.transparent],
                    stops: [0.0, 0.55, 1.0],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstIn,
                child: Opacity(
                  opacity: isDark ? 0.1 : 0.40,
                  child: Image.asset(
                    ImageAssets.authBg,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ),

          // Main Responsive Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            SizedBox(height: 48.h),

                            // Hero Visual: Concentric Rings & Lottie Checkmark Squircle
                            ScaleTransition(
                              scale: _entranceScale,
                              child: GestureDetector(
                                onTap: _replayAnimation,
                                child: _buildHeroSuccessGraphic(),
                              ),
                            ),

                            SizedBox(
                              height:
                                  widget.type == VerificationType.updatePassword
                                  ? 28.h
                                  : 32.h,
                            ),

                            if (widget.type ==
                                VerificationType.updatePassword) ...[
                              // Title: Password updated
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Text(
                                  AppString.passwordUpdated,
                                  textAlign: TextAlign.center,
                                  style: StyleManager.poppinsBold28(
                                    isDark ? AppColors.white : AppColors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),

                              // Subtitle
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                  ),
                                  child: Text(
                                    AppString.passwordUpdatedDesc,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.lightGray,
                                      height: 1.48,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              // Descriptive Text
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 24.w,
                                  ),
                                  child: Text(
                                    AppString.verificationSuccessDesc,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.lightGray,
                                      height: 1.48,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 36.h),

                              // Verified Email User Card
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: _buildVerifiedUserCard(displayName),
                              ),
                            ],

                            const Spacer(),

                            // Bottom Button (Back to login or Continue)
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: CustomButton(
                                text:
                                    widget.type ==
                                        VerificationType.updatePassword
                                    ? AppString.backToLogin
                                    : AppString.continueText,
                                onTap:
                                    widget.onContinue ??
                                    () =>
                                        widget.type ==
                                            VerificationType.updatePassword
                                        ? _handleBackToLogin(context)
                                        : _handleContinue(context),
                              ),
                            ),

                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Hero graphic: Outer & middle concentric circular rings, ambient glow, and green squircle with Lottie checkmark
  Widget _buildHeroSuccessGraphic() {
    return AnimatedBuilder(
      animation: _pulseScale,
      builder: (context, child) {
        return SizedBox(
          width: 240.w,
          height: 240.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Concentric Ring
              Transform.scale(
                scale: _pulseScale.value,
                child: Container(
                  width: 232.w,
                  height: 232.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.14),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              // Middle Concentric Ring
              Transform.scale(
                scale: 1.0 + (_pulseScale.value - 1.0) * 0.5,
                child: Container(
                  width: 172.w,
                  height: 172.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.26),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              // Ambient Radial Glow
              Container(
                width: 115.w,
                height: 115.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.22),
                      blurRadius: 36,
                      spreadRadius: 6,
                    ),
                  ],
                ),
              ),

              // Center Vibrant Green Squircle with Lottie Checkmark
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.38),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: SizedBox(
                    width: 70.w,
                    height: 70.w,
                    child: Lottie.asset(
                      ImageAssets.verifiedCheckLottie,
                      controller: _lottieController,
                      repeat: false,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Verified Email Card with user details and orange check badge
  Widget _buildVerifiedUserCard(String displayName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.textFieldBgColor : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark ? AppColors.lightBlueGray : const Color(0xFFF1F3F5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar Circle
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: isDark ? AppColors.white : null,
              border: Border.all(
                color: isDark
                    ? AppColors.white
                    : AppColors.grayColor.withValues(alpha: 0.1),
              ),
            ),
            child: Icon(Icons.person_rounded, color: AppColors.grayColor),
          ),
          SizedBox(width: 14.w),

          // User info: VERIFIED EMAIL label and Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppString.verifiedEmail,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightGray,
                    letterSpacing: 0.9,
                  ),
                ),
                Text(
                  displayName,
                  style: StyleManager.interSemiBold14(
                    isDark ? AppColors.white : AppColors.black,
                  ),
                ),
              ],
            ),
          ),

          // Orange Verified Checkmark Badge
          Container(
            width: 22.w,
            height: 22.w,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: isDark ? AppColors.blackShadow : Colors.white,
              size: 18.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// Default navigation on clicking Continue
  void _handleContinue(BuildContext context) {
    context.pushReplacement(AppRouterName.loginScreen);
  }

  /// Default navigation on clicking Back to login
  void _handleBackToLogin(BuildContext context) {
    context.go(AppRouterName.loginScreen);
  }
}
