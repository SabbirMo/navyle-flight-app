import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/utils/app_validator.dart';
import 'package:navyla_flight_app/core/widgets/auth_footer.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/core/widgets/custom_input_field.dart';
import 'package:navyla_flight_app/core/widgets/start_animation.dart';
import 'package:navyla_flight_app/feature/auth/auth_selection/widget/auth_common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/auth/forgot/provider/forgot_password_notifier.dart';
import 'package:navyla_flight_app/feature/auth/forgot/widget/forgot_password_illustration.dart';
import 'package:navyla_flight_app/feature/auth/verify_otp/model/otp_type.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  late final StartAnimations _animations = StartAnimations(this);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void reassemble() {
    super.reassemble();
    _animations.reassemble();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animations.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetCode(ForgotPasswordNotifier notifier) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      final success = await notifier.sendResetCode(
        _emailController.text.trim(),
      );
      if (success && mounted) {
        context.push(AppRouterName.verifyOtpScreen, extra: OtpType.forgot);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordNotifierProvider);
    final notifier = ref.read(forgotPasswordNotifierProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AuthCommonScreen(
      bottomSafeArea: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                          SizedBox(height: 8.h),
                          // Back Button
                          _animations.taglineTransition(
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: CustomBackButton(),
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // Floating Key & Question badge
                          _animations.buttonTransition(
                            child: const ForgotPasswordIllustration(),
                          ),
                          SizedBox(height: 22.h),

                          // Title: Forgot password?
                          _animations.taglineTransition(
                            child: Text(
                              AppString.forgotPassword,
                              textAlign: TextAlign.center,
                              style: StyleManager.poppinsBold28(
                                isDark ? AppColors.white : AppColors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),

                          // Subtitle: Don't worry, it happens...
                          _animations.taglineTransition(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                AppString.forgotPasswordSubtitle,
                                textAlign: TextAlign.center,
                                style: StyleManager.interMedium12(
                                  isDark
                                      ? AppColors.grayD3D3D3
                                      : AppColors.grayColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 28.h),
                        ],
                      ),
                    ),

                    // White Form Card
                    Expanded(
                      child: _animations.buttonTransition(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.blackShadow
                                : const Color(0xFFFFFBF8),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(28.r),
                              topRight: Radius.circular(28.r),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.blackShadow.withValues(
                                  alpha: 0.05,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, -3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.fromLTRB(
                            20.w,
                            28.h,
                            20.w,
                            MediaQuery.of(context).padding.bottom + 24.h,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Email Address Field
                                CustomInputField(
                                  label: AppString.emailAddress,
                                  isRequired: false,
                                  validator: AppValidator.validateEmail,
                                  controller: _emailController,
                                  hintText: AppString.emailHint,
                                  prefixIcon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) =>
                                      _handleSendResetCode(notifier),
                                ),
                                SizedBox(height: 24.h),

                                // Send reset code Button
                                CustomButton(
                                  text: AppString.sendResetCode,
                                  isLoading: state.isLoading,
                                  boxShadow: true,
                                  onTap: () => _handleSendResetCode(notifier),
                                ),
                                SizedBox(height: 24.h),

                                // Footer: Remembered? Log in
                                AuthFooter(
                                  text: AppString.remembered,
                                  loginText: AppString.logIn,
                                  onTap: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    } else {
                                      context.push(AppRouterName.loginScreen);
                                    }
                                  },
                                ),
                              ],
                            ),
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
}
