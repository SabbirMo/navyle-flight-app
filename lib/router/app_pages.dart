import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/widgets/verification_success.dart';
import 'package:navyla_flight_app/feature/auth/auth_selection/screen/auth_selection_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/screen/create_account_screen.dart';
import 'package:navyla_flight_app/feature/auth/forgot/screen/forgot_password_screen.dart';
import 'package:navyla_flight_app/feature/auth/new_password/screen/new_password_screen.dart';
import 'package:navyla_flight_app/feature/auth/login_account/screen/login_screen.dart';
import 'package:navyla_flight_app/feature/auth/verify_otp/model/otp_type.dart';
import 'package:navyla_flight_app/feature/auth/verify_otp/screen/verify_otp_screen.dart';
import 'package:navyla_flight_app/feature/feed/model/feed_post_model.dart';
import 'package:navyla_flight_app/feature/feed/screen/post_live_update_screen.dart';
import 'package:navyla_flight_app/feature/navbar/screen/navbar_screen.dart';
import 'package:navyla_flight_app/feature/onboarding/screen/onboarding_screen.dart';
import 'package:navyla_flight_app/feature/splash/splash_screen.dart';
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
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text("Page Not Found: ${state.error}"))),
  ),
);
