import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/widgets/verification_success.dart';
import 'package:navyla_flight_app/feature/ai_chat/screen/ai_chat_screen.dart';
import 'package:navyla_flight_app/feature/auth/auth_selection/screen/auth_selection_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/screen/create_account_screen.dart';
import 'package:navyla_flight_app/feature/auth/forgot/screen/forgot_password_screen.dart';
import 'package:navyla_flight_app/feature/auth/new_password/screen/new_password_screen.dart';
import 'package:navyla_flight_app/feature/auth/login_account/screen/login_screen.dart';
import 'package:navyla_flight_app/feature/auth/verify_otp/model/otp_type.dart';
import 'package:navyla_flight_app/feature/auth/verify_otp/screen/verify_otp_screen.dart';
import 'package:navyla_flight_app/feature/boarding_pass/screen/boarding_pass_screen.dart';
import 'package:navyla_flight_app/feature/feed/model/feed_post_model.dart';
import 'package:navyla_flight_app/feature/feed/screen/post_live_update_screen.dart';
import 'package:navyla_flight_app/feature/manage_plan/screen/manage_plan_screen.dart';
import 'package:navyla_flight_app/feature/more/model/more_model.dart';
import 'package:navyla_flight_app/feature/more/screen/more_details_screen.dart';
import 'package:navyla_flight_app/feature/more/screen/partner_website_screen.dart';
import 'package:navyla_flight_app/feature/navbar/screen/navbar_screen.dart';
import 'package:navyla_flight_app/feature/navigate_airport/screen/live_navigation_screen.dart';
import 'package:navyla_flight_app/feature/navigate_airport/screen/navigate_airport_route.dart';
import 'package:navyla_flight_app/feature/notification/screen/notification_screen.dart';
import 'package:navyla_flight_app/feature/onboarding/screen/onboarding_screen.dart';
import 'package:navyla_flight_app/feature/scan/screen/review_scan_screen.dart';
import 'package:navyla_flight_app/feature/scan/screen/scan_camera_screen.dart';
import 'package:navyla_flight_app/feature/scan/screen/scan_screen.dart';
import 'package:navyla_flight_app/feature/scan/verify_details/screen/verify_details_screen.dart';
import 'package:navyla_flight_app/feature/setting/change_password/screen/change_password.dart';
import 'package:navyla_flight_app/feature/setting/profile_details/screen/profile_details_screen.dart';
import 'package:navyla_flight_app/feature/setting/setting/screen/setting_screen.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/privacy_policy_screen.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/termsof_service_screen.dart';
import 'package:navyla_flight_app/feature/setting/smart_watch/screen/smart_watch_screen.dart';
import 'package:navyla_flight_app/feature/splash/splash_screen.dart';
import 'package:navyla_flight_app/feature/subscription/screen/subscription_screen.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

final appPages = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: AppRouterName.splashScreen,
    routes: [
      GoRoute(
        path: AppRouterName.splashScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const SplashScreen()),
      ),
      GoRoute(
        path: AppRouterName.onBoardingScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const OnboardingScreen()),
      ),

      //auth
      GoRoute(
        path: AppRouterName.authSelectionScreen,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const AuthSelectionScreen(),
        ),
      ),
      GoRoute(
        path: AppRouterName.createAccountScreen,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const CreateAccountScreen(),
        ),
      ),
      GoRoute(
        path: AppRouterName.verifyOtpScreen,
        pageBuilder: (context, state) {
          final otpType = state.extra is OtpType
              ? state.extra as OtpType
              : OtpType.create;
          return CupertinoPage(
            key: state.pageKey,
            child: VerifyOtpScreen(otpType: otpType),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.verificationSuccessScreen,
        pageBuilder: (context, state) {
          String userName = AppString.defaultVerifiedUser;
          VerificationType type = VerificationType.onlyVerify;

          if (state.extra is VerificationType) {
            type = state.extra as VerificationType;
          } else if (state.extra is String) {
            userName = state.extra as String;
          } else if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            if (map['userName'] is String) userName = map['userName'] as String;
            if (map['type'] is VerificationType) {
              type = map['type'] as VerificationType;
            }
          }

          return CupertinoPage(
            key: state.pageKey,
            child: VerificationSuccess(userName: userName, type: type),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.loginScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const LoginScreen()),
      ),
      GoRoute(
        path: AppRouterName.forgotPasswordScreen,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: AppRouterName.newPasswordScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const NewPasswordScreen()),
      ),

      //Home
      GoRoute(
        path: AppRouterName.homeScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const NavbarScreen()),
      ),
      GoRoute(
        path: AppRouterName.navbarScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const NavbarScreen()),
      ),

      //Feed
      GoRoute(
        path: AppRouterName.postLiveUpdateScreen,
        pageBuilder: (context, state) {
          final postToEdit = state.extra is FeedPostModel
              ? state.extra as FeedPostModel
              : null;
          return CupertinoPage(
            key: state.pageKey,
            child: PostLiveUpdateScreen(postToEdit: postToEdit),
          );
        },
      ),

      //AI chat
      GoRoute(
        path: AppRouterName.aiChatScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const AIChatScreen()),
      ),

      //setting
      GoRoute(
        path: AppRouterName.settingScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const SettingScreen()),
      ),

      //profile Details
      GoRoute(
        path: AppRouterName.profileDetailsScreen,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const ProfileDetailsScreen(),
        ),
      ),

      //change password
      GoRoute(
        path: AppRouterName.changePassword,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const ChangePassword()),
      ),

      //manage plan
      GoRoute(
        path: AppRouterName.managePlanScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const ManagePlanScreen()),
      ),

      //smart watch
      GoRoute(
        path: AppRouterName.smartWatchScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const SmartWatchScreen()),
      ),

      //Terms of service
      GoRoute(
        path: AppRouterName.termsOfServiceScreen,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const TermsofServiceScreen(),
        ),
      ),

      //Privacy policy
      GoRoute(
        path: AppRouterName.privacyPolicyScreen,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const PrivacyPolicyScreen(),
        ),
      ),

      //Subscription
      GoRoute(
        path: AppRouterName.subscriptionScreen,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const SubscriptionScreen(),
        ),
      ),

      //notification
      GoRoute(
        path: AppRouterName.notificationScreen,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const NotificationScreen(),
        ),
      ),

      //scan
      GoRoute(
        path: AppRouterName.scanScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const ScanScreen()),
      ),

      //scan camera
      GoRoute(
        path: AppRouterName.scanCameraScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const ScanCameraScreen()),
      ),

      //review scan
      GoRoute(
        path: AppRouterName.reviewScanScreen,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: ReviewScanScreen(imagePath: state.extra as String?),
        ),
      ),

      //verify details
      GoRoute(
        path: AppRouterName.verifyDetailsScreen,
        pageBuilder: (context, state) {
          final extra = state.extra;
          bool isManual = false;
          Map<String, String>? initialData;
          if (extra is Map) {
            isManual = extra['isManual'] == true;
            if (extra['data'] is Map<String, String>) {
              initialData = extra['data'] as Map<String, String>;
            }
          }
          return CupertinoPage(
            key: state.pageKey,
            child: VerifyDetailsScreen(
              isManual: isManual,
              initialData: initialData,
            ),
          );
        },
      ),

      //Navigate airport route
      GoRoute(
        path: AppRouterName.navigateAirportRoute,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const NavigateAirportRoute(),
        ),
      ),
      GoRoute(
        path: AppRouterName.liveNavigationScreen,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const LiveNavigationScreen(),
        ),
      ),

      //Boarding Pass
      GoRoute(
        path: AppRouterName.boardingPassScreen,
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const BoardingPassScreen(),
        ),
      ),

      //More Details Screen
      GoRoute(
        path: AppRouterName.moreDetailsScreen,
        pageBuilder: (context, state) {
          final data = state.extra is MoreModel
              ? state.extra as MoreModel
              : moreItem.first;
          return CupertinoPage(
            key: state.pageKey,
            child: MoreDetailsScreen(data: data),
          );
        },
      ),

      //Partner Website Screen
      GoRoute(
        path: AppRouterName.partnerWebsiteScreen,
        pageBuilder: (context, state) {
          final data = state.extra is MoreModel
              ? state.extra as MoreModel
              : null;
          return CupertinoPage(
            key: state.pageKey,
            child: PartnerWebsiteScreen(data: data),
          );
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text("Page Not Found: ${state.error}"))),
  ),
);
