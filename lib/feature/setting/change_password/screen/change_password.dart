import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/utils/app_validator.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/core/widgets/custom_input_field.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/setting/change_password/provider/change_password_notifier.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordNotifierProvider);
    final notifier = ref.read(changePasswordNotifierProvider.notifier);

    return Scaffold(
      body: CommonScreen(
        child: Column(
          children: [
            CustomBackButton(title: "CHANGE PASSWORD", isBorder: true),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      CustomInputField(
                        controller: _currentPasswordController,
                        label: "Current Password",
                        isRequired: false,
                        validator: AppValidator.validatePassword,
                        hintText: AppString.enterYourPassword,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: state.currentPassword,
                        suffixIcon: GestureDetector(
                          onTap: () => notifier.toggleCurrentPassword(),
                          behavior: HitTestBehavior.opaque,
                          child: Icon(
                            state.currentPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      CustomInputField(
                        controller: _newPasswordController,
                        label: "New Password",
                        isRequired: false,
                        validator: AppValidator.validatePassword,
                        hintText: AppString.enterYourPassword,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: state.newPassword,
                        suffixIcon: GestureDetector(
                          onTap: () => notifier.toggleNewPassword(),
                          behavior: HitTestBehavior.opaque,
                          child: Icon(
                            state.newPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      CustomInputField(
                        controller: _confirmPasswordController,
                        label: "Confirm new Password",
                        isRequired: false,
                        validator: (value) =>
                            AppValidator.validateConfirmPassword(
                              value,
                              _newPasswordController.text,
                            ),
                        hintText: AppString.enterYourPassword,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: state.confirmNewPassword,
                        suffixIcon: GestureDetector(
                          onTap: () => notifier.toggleConfirmPassword(),
                          behavior: HitTestBehavior.opaque,
                          child: Icon(
                            state.confirmNewPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),

                      CustomButton(
                        text: "Update password",
                        boxShadow: true,
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Password changed successfully',
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                  backgroundColor: AppColors.primaryColor,
                                  duration: Duration(milliseconds: 2000),
                                ),
                              );
                              Future.delayed(
                                const Duration(milliseconds: 2000),
                                () {
                                  if (mounted) {
                                    context.pop();
                                  }
                                },
                              );
                            }
                          }
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
    );
  }
}
