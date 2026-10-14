import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/navigate_airport/screen/navigate_airport_route.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/route_category_chips.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/route_floating_controls.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/route_top_header.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/terminal_bottom_sheet.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('NavigateAirportRoute renders all UI elements from design', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(flightJourneyNotifierProvider.notifier).addBoardingPass(
          flightNumber: 'BA 0215',
          originCode: 'LHR',
          originCity: 'London Heathrow',
          destinationCode: 'JFK',
          terminal: 'Main Terminal 5',
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          builder: (context, child) {
            return const MaterialApp(
              home: NavigateAirportRoute(),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Title in header
    expect(find.text('NAVIGATE YOUR ROUTE'), findsOneWidget);

    // Verify Search bar
    expect(find.text('Search terminal'), findsOneWidget);

    // Verify Chips
    expect(find.byType(RouteCategoryChips), findsOneWidget);
    expect(find.text('Ask NAVYLA'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Ticket'), findsOneWidget);

    // Scroll chips to verify 'Feed' chip is present
    await tester.drag(find.byType(RouteCategoryChips), const Offset(-150, 0));
    await tester.pumpAndSettle();
    expect(find.text('Feed'), findsOneWidget);

    // Verify Top Header and Floating Controls
    expect(find.byType(RouteTopHeader), findsOneWidget);
    expect(find.byType(RouteFloatingControls), findsOneWidget);

    // Verify Bottom Sheet elements
    expect(find.byType(TerminalBottomSheet), findsOneWidget);
    expect(find.text('Main Terminal 5'), findsOneWidget);
    expect(find.text('30° • 41 AQI'), findsOneWidget);
    expect(find.text('London Heathrow'), findsOneWidget);

    // Test bookmark toggle
    final bookmarkIcon = find.byIcon(Icons.bookmark_outline_rounded);
    expect(bookmarkIcon, findsOneWidget);
    await tester.tap(bookmarkIcon);
    await tester.pumpAndSettle();

    // Verify bookmark icon changes to filled
    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
  });
}
