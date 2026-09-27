import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
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
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordNotifierProvider);
    final notifier = ref.read(changePasswordNotifierProvider.notifier);
    return Scaffold(
      body: CommonScreen(
        child: Column(
          children: [
            CustomBackButton(title: "CHANGE PASSWORD"),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    CustomInputField(
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
                      label: "Confirm new Password",
                      isRequired: false,
                      validator: AppValidator.validatePassword,
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

                    CustomButton(text: "Update password", boxShadow: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
