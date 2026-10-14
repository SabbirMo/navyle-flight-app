import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/explore_nearby/model/explore_nearby_state.dart';
import 'package:navyla_flight_app/feature/explore_nearby/screen/explore_hub_details_screen.dart';
import 'package:navyla_flight_app/feature/explore_nearby/screen/explore_nearby_screen.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/home/widget/quick_access_tools_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget(Widget child, {ProviderContainer? container}) {
    return UncontrolledProviderScope(
      container: container ?? ProviderContainer(),
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        builder: (context, _) => MaterialApp(home: child),
      ),
    );
  }

  testWidgets(
      'ExploreHubDetailsScreen renders EXPLORE YOUR AIRPORT heading with airport name, POIs and categories in discovery mode',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const testHub = AirportHubItem(
      code: 'AMS',
      name: 'Amsterdam Schiphol',
      subtitle: 'Amsterdam, Netherlands • Departure 1, 2, 3',
    );

    await tester.pumpWidget(
      buildTestableWidget(const ExploreHubDetailsScreen(hub: testHub)),
    );
    await tester.pump();

    // 1. Verify "EXPLORE YOUR AIRPORT" and airport name heading
    expect(find.text('EXPLORE YOUR AIRPORT'), findsOneWidget);
    expect(find.text('Amsterdam Schiphol (AMS)'), findsOneWidget);

    // 2. Verify discovery categories are present
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Food & Drinks'), findsOneWidget);
    expect(find.text('Duty Free'), findsOneWidget);
    expect(find.text('Restrooms'), findsOneWidget);

    // 3. Verify floating POI Card is present with details
    expect(find.text('NAVYLA Partner'), findsOneWidget);
    expect(find.text('Fast Track'), findsOneWidget);
    expect(find.text('Gordon Ramsay Plane\nFood'), findsOneWidget);
    expect(find.text('Take Me There'), findsOneWidget);
  });

  testWidgets(
      'ExploreNearbyScreen shows SELECT AIRPORT without active flight, and EXPLORE YOUR AIRPORT with active flight',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    // 1. Initial: No active flight -> SELECT AIRPORT
    await tester.pumpWidget(
      buildTestableWidget(const ExploreNearbyScreen(), container: container),
    );
    await tester.pump();

    expect(find.text('SELECT AIRPORT'), findsOneWidget);
    expect(find.text('EXPLORE YOUR AIRPORT'), findsNothing);

    // 2. Add active journey (AMS)
    container.read(flightJourneyNotifierProvider.notifier).addBoardingPass(
          flightNumber: 'KL 1234',
          originCode: 'AMS',
          originCity: 'Amsterdam',
          destinationCode: 'LHR',
        );

    await tester.pumpWidget(
      buildTestableWidget(const ExploreNearbyScreen(), container: container),
    );
    await tester.pump();

    // Now header updates to EXPLORE YOUR AIRPORT with airport name
    expect(find.text('EXPLORE YOUR AIRPORT'), findsOneWidget);
    expect(find.text('Amsterdam Schiphol'), findsOneWidget);
    expect(find.text('SELECT AIRPORT'), findsNothing);
  });

  testWidgets(
      'QuickAccessToolsWidget Explore Nearby opens ExploreHubDetailsScreen in discovery mode when journey is active',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Add active journey with AMS
    container.read(flightJourneyNotifierProvider.notifier).addBoardingPass(
          flightNumber: 'KL 1234',
          originCode: 'AMS',
          originCity: 'Amsterdam',
          destinationCode: 'LHR',
        );

    // Test router with QuickAccessToolsWidget as home
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => const Scaffold(
            body: SingleChildScrollView(
              child: QuickAccessToolsWidget(),
            ),
          ),
        ),
        GoRoute(
          path: AppRouterName.exploreHubDetailsScreen,
          builder: (context, state) {
            final hub = state.extra as AirportHubItem?;
            return ExploreHubDetailsScreen(hub: hub);
          },
        ),
        GoRoute(
          path: AppRouterName.exploreNearbyScreen,
          builder: (context, _) => const ExploreNearbyScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          builder: (context, _) => MaterialApp.router(
            routerConfig: router,
          ),
        ),
      ),
    );
    await tester.pump();

    // Scroll to and tap "Explore nearby" card
    final exploreFinder = find.text('Explore nearby');
    expect(exploreFinder, findsOneWidget);
    await tester.ensureVisible(exploreFinder);
    await tester.tap(exploreFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verifies it opens ExploreHubDetailsScreen in discovery mode (NOT NavigateAirportRoute)
    expect(find.byType(ExploreHubDetailsScreen), findsOneWidget);
    expect(find.text('EXPLORE YOUR AIRPORT'), findsOneWidget);
    expect(find.text('Amsterdam Schiphol (AMS)'), findsOneWidget);
    expect(find.text('Food & Drinks'), findsOneWidget);
  });
}
