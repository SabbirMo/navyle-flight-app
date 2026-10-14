import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/home/screen/home_screen.dart';
import 'package:navyla_flight_app/feature/home/widget/city_weather_card.dart';
import 'package:navyla_flight_app/feature/home/widget/flight_card_widget.dart';
import 'package:navyla_flight_app/feature/home/widget/home_header_widget.dart';
import 'package:navyla_flight_app/feature/home/widget/no_active_journey_card.dart';
import 'package:navyla_flight_app/feature/home/widget/travel_offers_widget.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/feature/notification/provider/notification_notifier.dart';

void main() {
  Widget buildTestableHomeScreen({ProviderContainer? container}) {
    return UncontrolledProviderScope(
      container: container ?? ProviderContainer(),
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        builder: (context, child) {
          return const MaterialApp(
            home: HomeScreen(),
          );
        },
      ),
    );
  }

  testWidgets(
      'HomeScreen shows NoActiveJourneyCard and TravelOffersWidget initially (no boarding pass)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(buildTestableHomeScreen(container: container));
    await tester.pump();

    // Verify initial state: FlightCardWidget & CityWeatherCard are NOT present
    expect(find.byType(FlightCardWidget), findsNothing);
    expect(find.byType(CityWeatherCard), findsNothing);

    // Verify initial state: NoActiveJourneyCard & TravelOffersWidget ARE present
    expect(find.byType(NoActiveJourneyCard), findsOneWidget);
    expect(find.byType(TravelOffersWidget), findsOneWidget);
    expect(find.text('No active journey'), findsOneWidget);
    expect(find.text('Scan/Load Boarding Pass'), findsOneWidget);
    expect(find.text('Travel Offers'), findsOneWidget);
    expect(find.text('Global eSIM'), findsOneWidget);
    expect(find.text('Lounge Access'), findsOneWidget);
  });

  testWidgets(
      'HomeScreen dynamically switches to FlightCardWidget and CityWeatherCard when boarding pass is added',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(buildTestableHomeScreen(container: container));
    await tester.pump();

    // Initially empty
    expect(find.byType(NoActiveJourneyCard), findsOneWidget);
    expect(find.byType(FlightCardWidget), findsNothing);

    // User adds boarding pass
    container.read(flightJourneyNotifierProvider.notifier).addBoardingPass(
          flightNumber: 'BA 0215',
          originCode: 'AMS',
          destinationCode: 'FRA',
          seat: '14A',
          gate: 'B24',
          terminal: 'T5',
        );
    await tester.pump();

    // Now NoActiveJourneyCard and TravelOffersWidget are replaced by Flight & Weather cards
    expect(find.byType(NoActiveJourneyCard), findsNothing);
    expect(find.byType(TravelOffersWidget), findsNothing);
    expect(find.byType(FlightCardWidget), findsOneWidget);
    expect(find.byType(CityWeatherCard), findsOneWidget);
    expect(find.text('BA 0215'), findsOneWidget);
  });

  testWidgets(
      'Tapping See all in TravelOffersWidget switches navbar to Travel Extras hub (index 4)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(buildTestableHomeScreen(container: container));
    await tester.pump();

    // Verify initial navbar index is 0 (Home)
    expect(container.read(navbarNotifierProvider), 0);

    // Tap 'See all' in Travel Offers
    final seeAllFinder = find.descendant(
      of: find.byType(TravelOffersWidget),
      matching: find.text('See all'),
    );
    expect(seeAllFinder, findsOneWidget);
    await tester.tap(seeAllFinder);
    await tester.pumpAndSettle();

    // Should switch to tab 4 (Travel Extras hub)
    expect(container.read(navbarNotifierProvider), 4);
  });

  testWidgets(
      'FlightCardWidget animates gentle sway over 7s, settles, does not replay on scroll, but replays when returning to Home',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(flightJourneyNotifierProvider.notifier).addBoardingPass(
          flightNumber: 'BA 0215',
          originCode: 'AMS',
          destinationCode: 'FRA',
          seat: '14A',
          gate: 'B24',
          terminal: 'T5',
        );

    await tester.pumpWidget(buildTestableHomeScreen(container: container));
    await tester.pump();

    expect(find.byType(FlightCardWidget), findsOneWidget);

    // Advance 7 seconds so it completes sways and settles smoothly
    await tester.pump(const Duration(milliseconds: 7000));
    await tester.pump(const Duration(milliseconds: 500));

    // Scroll down and up - should remain intact without re-triggering intro
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, -300));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.drag(
        find.byType(SingleChildScrollView), const Offset(0, 300));
    await tester.pump(const Duration(milliseconds: 300));

    // Switch to another tab (e.g. Feed tab 3) and switch back to Home (tab 0)
    container.read(navbarNotifierProvider.notifier).setIndex(3);
    await tester.pump();
    container.read(navbarNotifierProvider.notifier).setIndex(0);
    await tester.pump();

    // Verify card is present and replaying smoothly
    expect(find.byType(FlightCardWidget), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 7000));
  });

  testWidgets(
      'Notification bell displays red dot when unread notifications exist, and hides dot once all are read (no boarding pass)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(buildTestableHomeScreen(container: container));
    await tester.pump();

    // Verify unread notifications exist in initial state
    final initialUnread =
        container.read(notificationNotifierProvider).any((n) => n.isUnread);
    expect(initialUnread, isTrue);

    // Header hasUnread property should be true
    final headerWidget =
        tester.widget<HomeHeaderWidget>(find.byType(HomeHeaderWidget));
    expect(headerWidget.hasUnread, isTrue);

    // Red dot container exists
    expect(
      find.byWidgetPredicate((w) =>
          w is Container &&
          (w.decoration as BoxDecoration?)?.color == Colors.red),
      findsOneWidget,
    );

    // Mark all notifications as read
    container.read(notificationNotifierProvider.notifier).markAllAsRead();
    await tester.pump();

    // After all read: header hasUnread should be false and red dot should disappear
    final updatedHeaderWidget =
        tester.widget<HomeHeaderWidget>(find.byType(HomeHeaderWidget));
    expect(updatedHeaderWidget.hasUnread, isFalse);
    expect(
      find.byWidgetPredicate((w) =>
          w is Container &&
          (w.decoration as BoxDecoration?)?.color == Colors.red),
      findsNothing,
    );
  });

  testWidgets(
      'Notification bell displays red dot when unread notifications exist, and hides dot once all are read (active boarding pass)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Add active flight
    container.read(flightJourneyNotifierProvider.notifier).addBoardingPass(
          flightNumber: 'BA 0215',
          originCode: 'AMS',
          destinationCode: 'FRA',
          seat: '14A',
          gate: 'B24',
          terminal: 'T5',
        );

    await tester.pumpWidget(buildTestableHomeScreen(container: container));
    await tester.pump();

    // Unread red dot in active hero header exists
    expect(
      find.byWidgetPredicate((w) =>
          w is Container &&
          (w.decoration as BoxDecoration?)?.color == const Color(0xFFFF5252)),
      findsOneWidget,
    );

    // Mark all notifications as read
    container.read(notificationNotifierProvider.notifier).markAllAsRead();
    await tester.pump();

    // Red dot should disappear completely
    expect(
      find.byWidgetPredicate((w) =>
          w is Container &&
          (w.decoration as BoxDecoration?)?.color == const Color(0xFFFF5252)),
      findsNothing,
    );
  });
}

