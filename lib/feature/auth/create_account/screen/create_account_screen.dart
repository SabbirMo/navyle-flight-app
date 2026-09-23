import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/utils/app_validator.dart';
import 'package:navyla_flight_app/core/widgets/auth_footer.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/core/widgets/custom_input_field.dart';
import 'package:navyla_flight_app/core/widgets/start_animation.dart';
import 'package:navyla_flight_app/feature/auth/auth_selection/widget/auth_common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/model/create_account_state.dart';
import 'package:navyla_flight_app/feature/auth/create_account/provider/create_account_notifer.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen>
    with TickerProviderStateMixin {
  late final StartAnimations _animations = StartAnimations(this);
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    ref
        .read(createAccountNotifierProvider.notifier)
        .onPasswordChanged(_passwordController.text);
  }

  @override
  void reassemble() {
    super.reassemble();
    _animations.reassemble();
  }

  @override
  void dispose() {
    _animations.dispose();
    _passwordController.removeListener(_onPasswordChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createAccountNotifierProvider);
    final notifier = ref.read(createAccountNotifierProvider.notifier);

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
                              AppString.createYourAccount,
                              textAlign: TextAlign.center,
                              style: StyleManager.poppinsBold28(
                                AppColors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          // Subtitle
                          _animations.taglineTransition(
                            child: Text(
                              AppString.createAccountSubtitle,
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

                    // White Form Card (expands down to the bottom)
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
                            24.h,
                            20.w,
                            MediaQuery.of(context).padding.bottom + 24.h,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // First name & Last name Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomInputField(
                                        validator: AppValidator.validateName,
                                        label: AppString.firstName,
                                        controller: _firstNameController,
                                        hintText: AppString.jhonHint,
                                        prefixIcon:
                                            Icons.person_outline_rounded,
                                      ),
                                    ),
                                    SizedBox(width: 14.w),
                                    Expanded(
                                      child: CustomInputField(
                                        label: AppString.lastName,
                                        validator: AppValidator.validateName,
                                        controller: _lastNameController,
                                        hintText: AppString.doeHint,
                                        prefixIcon:
                                            Icons.person_outline_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),

                                // Email Address Field
                                CustomInputField(
                                  label: AppString.emailAddress,
                                  validator: AppValidator.validateEmail,
                                  controller: _emailController,
                                  hintText: AppString.emailHint,
                                  prefixIcon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 16.h),

                                // Password Field
                                CustomInputField(
                                  label: AppString.password,
                                  validator: AppValidator.validatePassword,
                                  controller: _passwordController,
                                  hintText: AppString.passwordHint,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: !state.password,
                                  onChanged: notifier.onPasswordChanged,
                                  suffixIcon: GestureDetector(
                                    onTap: () => notifier.onPasswordToggle(),
                                    child: Icon(
                                      state.password
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 18.sp,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),

                                // Password Strength Indicator
                                Padding(
                                  padding: EdgeInsets.only(left: 4.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        AppString.passwordStrength,
                                        style: StyleManager.interRegular13(
                                          AppColors.grayColor,
                                        ),
                                      ),
                                      AnimatedDefaultTextStyle(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        style: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700,
                                          color: state.passwordStrength.color,
                                        ),
                                        child: Text(
                                          state.passwordStrength.label,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.h),

                                // Terms of Service & Privacy Policy Checkbox
                                _buildTermsCheckbox(state, notifier),
                                SizedBox(height: 24.h),

                                // Create Account Button
                                // _buildCreateAccountButton(),
                                CustomButton(
                                  text: "Create Account",
                                  height: 46.h,
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.push(
                                        AppRouterName.verifyOtpScreen,
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: 18.h),

                                // Already have an account? Log in
                                AuthFooter(
                                  text: AppString.alreadyHaveAccount,
                                  loginText: AppString.logIn,
                                  onTap: () =>
                                      context.push(AppRouterName.loginScreen),
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

  /// Terms and Privacy Policy Checkbox Row
  Widget _buildTermsCheckbox(
    CreateAccountState state,
    CreateAccountNotifer notifier,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => notifier.onTermsAndConditionToggle(),
          child: Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              color: state.termsAndCondition
                  ? AppColors.primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: state.termsAndCondition
                    ? AppColors.primaryColor
                    : const Color(0xFFD1D5DB),
                width: 1.5,
              ),
            ),
            child: state.termsAndCondition
                ? Icon(Icons.check, size: 13.sp, color: Colors.white)
                : null,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 11.5.sp,
                color: const Color(0xFF6B7280),
              ),
              children: [
                const TextSpan(text: AppString.agreeToThe),
                TextSpan(
                  text: AppString.termsOfService,
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
                const TextSpan(text: AppString.and),
                TextSpan(
                  text: AppString.privacyPolicy,
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
