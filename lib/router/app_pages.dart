import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/feature/splash/splash_screen.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

final appPages = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: AppRouterName.splashScreen,
    routes: [
      GoRoute(
        path: AppRouterName.splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
    ],
  ),
);
