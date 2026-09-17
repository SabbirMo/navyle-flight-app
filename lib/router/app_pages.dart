import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text("Page Not Found: ${state.error}"))),
  ),
);
