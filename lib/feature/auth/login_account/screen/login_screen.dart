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
import 'package:navyla_flight_app/core/widgets/main_image_size.dart';
import 'package:navyla_flight_app/core/widgets/start_animation.dart';
import 'package:navyla_flight_app/feature/auth/auth_selection/widget/auth_common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/auth/login_account/provider/login_notifier.dart';
import 'package:navyla_flight_app/feature/auth/login_account/widget/remember_me_switch.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/core/services/app_preference_service.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  late final StartAnimations _animations = StartAnimations(this);
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void reassemble() {
    super.reassemble();
    _animations.reassemble();
  }

  @override
  void dispose() {
    _animations.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(LoginNotifier notifier) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      notifier.setLoading(true);
      await Future.delayed(const Duration(milliseconds: 600));
      notifier.setLoading(false);
      await AppPreferenceService.setLoggedIn(true);
      if (mounted) {
        ref.read(navbarNotifierProvider.notifier).reset();
        context.go(AppRouterName.homeScreen);
      }
    }
  }

  void _onForgotPassword() {
    context.push(AppRouterName.forgotPasswordScreen);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginNotifierProvider);
    final notifier = ref.read(loginNotifierProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AuthCommonScreen(
      bottomSafeArea: false,
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
                          SizedBox(height: 30.h),
                          // App Logo
                          _animations.buttonTransition(child: MainImageSize()),
                          SizedBox(height: 16.h),
                          // Title: Welcome Back
                          _animations.taglineTransition(
                            child: Text(
                              AppString.welcomeBack,
                              textAlign: TextAlign.center,
                              style: StyleManager.poppinsBold28(
                                isDark ? AppColors.white : AppColors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          // Subtitle
                          _animations.taglineTransition(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Text(
                                AppString.loginSubtitle,
                                textAlign: TextAlign.center,
                                style: StyleManager.interMedium12(
                                  isDark
                                      ? AppColors.grayD3D3D3
                                      : AppColors.grayColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
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
                                : AppColors.lightBgColor.withValues(
                                    alpha: 0.85,
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
                                ),
                                SizedBox(height: 18.h),

                                // Password Field
                                CustomInputField(
                                  label: AppString.password,
                                  isRequired: false,
                                  validator: AppValidator.validatePassword,
                                  controller: _passwordController,
                                  hintText: AppString.enterYourPassword,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: state.obscurePassword,
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
                                SizedBox(height: 16.h),

                                // Remember Me & Forgot Password Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Remember Me Switch & Text
                                    Flexible(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          RememberMeSwitch(
                                            value: state.rememberMe,
                                            onChanged:
                                                notifier.toggleRememberMe,
                                          ),
                                          SizedBox(width: 8.w),
                                          Flexible(
                                            child: GestureDetector(
                                              onTap: () =>
                                                  notifier.toggleRememberMe(),
                                              child: Text(
                                                AppString.rememberMe,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    StyleManager.interMedium12(
                                                      const Color(0xFF6B7280),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8.w),

                                    // Forgot Password Link
                                    GestureDetector(
                                      onTap: _onForgotPassword,
                                      behavior: HitTestBehavior.opaque,
                                      child: Text(
                                        AppString.forgotPassword,
                                        style: StyleManager.interMedium12(
                                          AppColors.errorRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 28.h),

                                // Login Button
                                CustomButton(
                                  text: AppString.logIn,
                                  isLoading: state.isLoading,
                                  onTap: () => _handleLogin(notifier),
                                ),
                                SizedBox(height: 22.h),

                                // Footer: New to NAVYLA? Create account
                                AuthFooter(
                                  text: AppString.newToNavyla,
                                  loginText: AppString.createAccount,
                                  onTap: () => context.push(
                                    AppRouterName.createAccountScreen,
                                  ),
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
