import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/feature/ticket/screen/ticket_screen.dart';
import 'package:navyla_flight_app/feature/ticket/widget/delete_ticket_bottom_sheet.dart';
import 'package:navyla_flight_app/feature/ticket/widget/ticket_boarding_pass.dart';

void main() {
  testWidgets('DeleteTicketBottomSheet renders correctly and triggers callbacks', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool deleted = false;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) => Center(
                  child: ElevatedButton(
                    onPressed: () {
                      DeleteTicketBottomSheet.show(
                        ctx,
                        flightNumber: 'BA 0215',
                        originCode: 'AMS',
                        destinationCode: 'FRA',
                        onDelete: () => deleted = true,
                      );
                    },
                    child: const Text('Open Sheet'),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    // Open sheet
    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    // Verify sheet contents
    expect(find.text('Delete Boarding Pass?'), findsOneWidget);
    expect(find.text('Delete Ticket'), findsOneWidget);
    expect(find.text('Keep Ticket'), findsOneWidget);

    // Tap Delete Ticket
    await tester.tap(find.text('Delete Ticket'));
    await tester.pumpAndSettle();

    expect(deleted, isTrue);
    expect(find.text('Delete Boarding Pass?'), findsNothing);
  });

  testWidgets('TicketScreen renders TicketBoardingPass aligned up when flight is active', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(flightJourneyNotifierProvider.notifier).addBoardingPass(
          flightNumber: 'BA 0215',
          originCode: 'LHR',
          originCity: 'LONDON, UK',
          destinationCode: 'JFK',
          destinationCity: 'NEW YORK, USA',
          terminal: 'T5',
          gate: 'B24',
          seat: '14A',
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          builder: (context, child) {
            return const MaterialApp(
              home: TicketScreen(),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('TICKET'), findsOneWidget);
    expect(find.byType(TicketBoardingPass), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

    // Verify tapping back button sets navbar index to 0
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(container.read(navbarNotifierProvider), 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('TicketScreen renders empty state when no flight is active', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: ScreenUtilInit(
          designSize: Size(360, 690),
          minTextAdapt: true,
          child: MaterialApp(
            home: TicketScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('TICKET'), findsOneWidget);
    expect(find.text('No Active Boarding Pass'), findsOneWidget);
    expect(find.byType(TicketBoardingPass), findsNothing);
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

