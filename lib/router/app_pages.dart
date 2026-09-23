import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/widgets/verification_success.dart';
import 'package:navyla_flight_app/feature/auth/auth_selection/screen/auth_selection_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/screen/create_account_screen.dart';
import 'package:navyla_flight_app/feature/auth/login_account/screen/login_screen.dart';
import 'package:navyla_flight_app/feature/auth/verify_otp/screen/verify_otp_screen.dart';
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
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const VerifyOtpScreen()),
      ),
      GoRoute(
        path: AppRouterName.verificationSuccessScreen,
        pageBuilder: (context, state) {
          final userName = state.extra is String
              ? state.extra as String
              : AppString.defaultVerifiedUser;
          return CupertinoPage(
            key: state.pageKey,
            child: VerificationSuccess(userName: userName),
          );
        },
      ),
      GoRoute(
        path: AppRouterName.loginScreen,
        pageBuilder: (context, state) =>
            CupertinoPage(key: state.pageKey, child: const LoginScreen()),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text("Page Not Found: ${state.error}"))),
  ),
);
