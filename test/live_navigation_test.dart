import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/navigate_airport/screen/live_navigation_screen.dart';
import 'package:navyla_flight_app/feature/navigate_airport/screen/navigate_airport_route.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/live_nav_bottom_panel.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/live_nav_floating_buttons.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/live_nav_top_banner.dart';
import 'package:navyla_flight_app/router/app_pages.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

void main() {
  testWidgets('LiveNavigationScreen renders all elements from design', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          builder: (context, child) {
            return const MaterialApp(
              home: LiveNavigationScreen(),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify top direction banner
    expect(find.byType(LiveNavTopBanner), findsOneWidget);
    expect(find.text('Square RD'), findsOneWidget);
    expect(find.text('Continue straight'), findsOneWidget);
    expect(find.text('THEN'), findsOneWidget);

    // Verify map landmark texts
    expect(find.text('Kaderia Tower'), findsOneWidget);
    expect(find.text('Masjid-e-Gausul\nAzam'), findsOneWidget);
    expect(find.text('Bank Asia Limited'), findsOneWidget);
    expect(find.text('3 min slower'), findsOneWidget);

    // Verify floating action buttons
    expect(find.byType(LiveNavFloatingButtons), findsOneWidget);

    // Verify bottom panel
    expect(find.byType(LiveNavBottomPanel), findsOneWidget);
    expect(find.text('40'), findsOneWidget);
    expect(find.text('min'), findsOneWidget);
    expect(find.text('2.9 km • 9:35 AM'), findsOneWidget);
  });

  testWidgets('Clicking navigation CTA in NavigateAirportRoute navigates to LiveNavigationScreen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          builder: (context, child) {
            final router = container.read(appPages);
            router.go(AppRouterName.navigateAirportRoute);
            return MaterialApp.router(
              routerConfig: router,
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify we are on NavigateAirportRoute
    expect(find.byType(NavigateAirportRoute), findsOneWidget);

    // Find the CTA near_me button
    final ctaButton = find.byIcon(Icons.near_me_rounded);
    expect(ctaButton, findsOneWidget);

    // Tap CTA button
    await tester.tap(ctaButton);
    await tester.pumpAndSettle();

    // Verify we navigated to LiveNavigationScreen
    expect(find.byType(LiveNavigationScreen), findsOneWidget);
    expect(find.text('Square RD'), findsOneWidget);
  });
}
