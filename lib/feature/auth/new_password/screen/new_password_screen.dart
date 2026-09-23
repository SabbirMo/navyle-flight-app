import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/utils/app_validator.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/core/widgets/custom_input_field.dart';
import 'package:navyla_flight_app/core/widgets/start_animation.dart';
import 'package:navyla_flight_app/feature/auth/auth_selection/widget/auth_common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/auth/new_password/model/new_password_state.dart';
import 'package:navyla_flight_app/feature/auth/new_password/provider/new_password_notifier.dart';
import 'package:navyla_flight_app/feature/auth/new_password/widget/password_criteria_card.dart';
import 'package:navyla_flight_app/core/widgets/verification_success.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen>
    with TickerProviderStateMixin {
  late final StartAnimations _animations = StartAnimations(this);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void reassemble() {
    super.reassemble();
    _animations.reassemble();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animations.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword(NewPasswordNotifier notifier) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      final success = await notifier.resetPassword(
        password: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
      );
      if (success && mounted) {
        context.pushReplacement(
          AppRouterName.verificationSuccessScreen,
          extra: VerificationType.updatePassword,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newPasswordNotifierProvider);
    final notifier = ref.read(newPasswordNotifierProvider.notifier);

    ref.listen<NewPasswordState>(newPasswordNotifierProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    });

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
                          SizedBox(height: 8.h),
                          // Back Button
                          _animations.taglineTransition(
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: CustomBackButton(),
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // App Logo
                          _animations.buttonTransition(
                            child: Image.asset(
                              ImageAssets.appLogo,
                              width: 56.w,
                              height: 56.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Title: Secure your account
                          _animations.taglineTransition(
                            child: Text(
                              AppString.secureYourAccount,
                              textAlign: TextAlign.center,
                              style: StyleManager.poppinsBold28(
                                AppColors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),

                          // Subtitle: Create a strong new password...
                          _animations.taglineTransition(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                AppString.secureYourAccountSubtitle,
                                textAlign: TextAlign.center,
                                style: StyleManager.interMedium12(
                                  AppColors.grayColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),

                    // White Form Card
                    Expanded(
                      child: _animations.buttonTransition(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBF8),
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
                                // New Password Field
                                CustomInputField(
                                  label: AppString.newPassword,
                                  isRequired: false,
                                  validator: AppValidator.validatePassword,
                                  controller: _passwordController,
                                  hintText: AppString.enterYourPassword,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: state.obscurePassword,
                                  onChanged: notifier.onPasswordChanged,
                                  suffixIcon: GestureDetector(
                                    onTap: notifier.togglePasswordVisibility,
                                    behavior: HitTestBehavior.opaque,
                                    child: Icon(
                                      state.obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 18.sp,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 18.h),

                                // Confirm New Password Field
                                CustomInputField(
                                  label: AppString.confirmNewPassword,
                                  isRequired: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                  controller: _confirmPasswordController,
                                  hintText: AppString.enterYourPassword,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: state.obscureConfirmPassword,
                                  onChanged: notifier.onConfirmPasswordChanged,
                                  suffixIcon: GestureDetector(
                                    onTap: notifier
                                        .toggleConfirmPasswordVisibility,
                                    behavior: HitTestBehavior.opaque,
                                    child: Icon(
                                      state.obscureConfirmPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 18.sp,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),

                                // Password Criteria Box
                                PasswordCriteriaCard(
                                  hasMinLength: state.hasMinLength,
                                  hasSpecialChar: state.hasSpecialChar,
                                  hasUppercase: state.hasUppercase,
                                ),
                                SizedBox(height: 28.h),

                                // Update Password Button
                                CustomButton(
                                  text: AppString.updatePassword,
                                  isLoading: state.isLoading,
                                  onTap: () => _handleResetPassword(notifier),
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
