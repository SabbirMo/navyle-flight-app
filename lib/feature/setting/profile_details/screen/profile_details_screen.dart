import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/core/widgets/custom_input_field.dart';
import 'package:navyla_flight_app/core/widgets/title_row_click.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/setting/profile_details/provider/profile_details_notifier.dart';

class ProfileDetailsScreen extends ConsumerStatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  ConsumerState<ProfileDetailsScreen> createState() =>
      _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends ConsumerState<ProfileDetailsScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileDetailsProvider);
    final notifier = ref.read(profileDetailsProvider.notifier);

    return Scaffold(
      body: CommonScreen(
        child: Column(
          children: [
            const CustomBackButton(title: "PROFILE DETAILS"),
            SizedBox(height: 24.h),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with Camera Badge (Centered)
                    Center(
                      child: SizedBox(
                        width: 116.w,
                        height: 116.w,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: GestureDetector(
                                onTap: () => notifier.pickImageFromGallery(),
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  width: 108.w,
                                  height: 108.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(34.r),
                                    border: Border.all(
                                      color: AppColors.white,
                                      width: 3.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.blackShadow.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 18,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                    image: state.imageFile != null
                                        ? DecorationImage(
                                            image: FileImage(state.imageFile!),
                                            fit: BoxFit.cover,
                                          )
                                        : const DecorationImage(
                                            image: AssetImage(
                                              ImageAssets.profile,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 2.w,
                              bottom: 2.w,
                              child: GestureDetector(
                                onTap: () => notifier.pickImageFromGallery(),
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  width: 32.w,
                                  height: 32.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.white,
                                      width: 3.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryColor
                                            .withValues(alpha: 0.35),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 15.sp,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // First name & Last name
                    Row(
                      children: [
                        Expanded(
                          child: CustomInputField(
                            label: AppString.firstName,
                            isRequired: false,
                            controller: _firstNameController,
                            hintText: "Radu",
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomInputField(
                            label: AppString.lastName,
                            isRequired: false,
                            controller: _lastNameController,
                            hintText: "lulian",
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Email address
                    CustomInputField(
                      label: AppString.emailAddress,
                      isRequired: false,
                      controller: _emailController,
                      hintText: "your.email@example.com",
                      prefixIcon: Icons.mail_outline_rounded,
                      obscureText: state.isPasswordVisible,
                      suffixIcon: IconButton(
                        onPressed: () {
                          notifier.togglePasswordVisibility();
                        },
                        icon: Icon(
                          state.isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 18.sp,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Password row
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: TitleRowClick(
                        title: "Password",
                        isEnable: true,
                        subTitle: "Change password",
                        onTap: () {
                          // Handle change password
                        },
                      ),
                    ),

                    SizedBox(height: 34.h),

                    // Save Changes Button
                    CustomButton(
                      text: "Save changes",
                      height: 44.h,
                      boxShadow: true,
                      onTap: () {
                        // Handle save changes
                      },
                    ),
                    SizedBox(height: 24.h),
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
