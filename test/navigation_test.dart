import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/feature/auth/login_account/screen/login_screen.dart';
import 'package:navyla_flight_app/feature/home/screen/home_screen.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

void main() {
  testWidgets('HomeScreen builds without crash', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) => const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('HomeScreen builds in dark mode without crash', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) => MaterialApp(
          theme: ThemeData.dark(),
          home: const HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('LoginScreen navigates to HomeScreen when login tapped', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: AppRouterName.loginScreen,
      routes: [
        GoRoute(
          path: AppRouterName.loginScreen,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRouterName.homeScreen,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(540, 1200),
          minTextAdapt: true,
          builder: (context, child) => MaterialApp.router(
            routerConfig: router,
          ),
        ),
      ),
    );
    // Enter email and password
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;

    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, '12345678');
    await tester.pump(const Duration(milliseconds: 300));

    // Tap Login button
    final loginButton = find.text('Login');
    expect(loginButton, findsOneWidget);
    await tester.ensureVisible(loginButton);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(loginButton);
    await tester.pump();

    // Wait for the simulated delay (600ms)
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 100));

    // Verify HomeScreen is now displayed
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
