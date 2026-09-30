import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/home/screen/home_screen.dart';
import 'package:navyla_flight_app/feature/home/widget/city_weather_card.dart';
import 'package:navyla_flight_app/feature/home/widget/flight_card_widget.dart';
import 'package:navyla_flight_app/feature/home/widget/no_active_journey_card.dart';
import 'package:navyla_flight_app/feature/home/widget/travel_offers_widget.dart';

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

    // Verify initial state: FlightWaveCard & CityWeatherCard are NOT present
    expect(find.byType(FlightWaveCard), findsNothing);
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
      'HomeScreen dynamically switches to FlightWaveCard and CityWeatherCard when boarding pass is added',
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
    expect(find.byType(FlightWaveCard), findsNothing);

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
    expect(find.byType(FlightWaveCard), findsOneWidget);
    expect(find.byType(CityWeatherCard), findsOneWidget);
    expect(find.text('BA 0215'), findsOneWidget);
  });
}
