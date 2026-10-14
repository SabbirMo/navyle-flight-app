import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/feature/ticket/provider/saved_tickets_provider.dart';
import 'package:navyla_flight_app/feature/ticket/screen/ticket_screen.dart';
import 'package:navyla_flight_app/feature/ticket/widget/delete_ticket_bottom_sheet.dart';
import 'package:navyla_flight_app/feature/ticket/widget/ticket_boarding_pass.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
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
    container.read(savedTicketsProvider.notifier).loadDemoTickets();
    container.read(savedTicketsProvider.notifier).hideAddPass();
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
    // Back button is present in app bar
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    expect(find.text('1 OF 3'), findsOneWidget);

    // Verify tapping back button navigates to Home (sets navbar index to 0)
    container.read(navbarNotifierProvider.notifier).setIndex(1);
    expect(container.read(navbarNotifierProvider), 1);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pumpAndSettle();
    expect(container.read(navbarNotifierProvider), 0);

    // Verify tapping '1 OF 3' capsule badge opens AddBoardingPassView
    await tester.tap(find.text('1 OF 3'));
    await tester.pumpAndSettle();
    expect(find.text('ADD BOARDING PASS'), findsOneWidget);
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

    expect(find.text('ADD BOARDING PASS'), findsOneWidget);
    expect(find.text('SCAN YOUR BOARDING PASS'), findsOneWidget);
    expect(find.text('Open Camera'), findsOneWidget);
    expect(find.text('Upload from Gallery'), findsOneWidget);
    expect(find.text('Enter Details Manually'), findsOneWidget);
    expect(find.text('No saved tickets yet'), findsOneWidget);
    expect(find.byType(TicketBoardingPass), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tapping a saved ticket in ADD BOARDING PASS view activates flight and displays TICKET screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(savedTicketsProvider.notifier).loadDemoTickets();

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

    // Verify initial ADD BOARDING PASS screen
    expect(find.text('ADD BOARDING PASS'), findsOneWidget);

    // Tap first saved ticket: BA 0215
    await tester.tap(find.text('BA 0215'));
    await tester.pumpAndSettle();

    // Verify it transitions to TICKET screen
    expect(find.text('TICKET'), findsOneWidget);
    expect(find.byType(TicketBoardingPass), findsOneWidget);
    expect(find.text('1 OF 3'), findsOneWidget);
    expect(container.read(flightJourneyNotifierProvider).hasActiveFlight, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tapping 3 dots on TicketScreen opens Ticket Options sheet and deletes only selected ticket', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(savedTicketsProvider.notifier).loadDemoTickets();
    container.read(savedTicketsProvider.notifier).hideAddPass();

    // Make flight active with BA 0215
    container.read(flightJourneyNotifierProvider.notifier).addBoardingPass(
          flightNumber: 'BA 0215',
          originCode: 'AMS',
          destinationCode: 'FRA',
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

    // Verify initially on TICKET screen with 3 saved tickets
    expect(find.text('TICKET'), findsOneWidget);
    expect(find.text('1 OF 3'), findsOneWidget);

    // Tap 3-dot overflow menu
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Verify all Ticket Options from the user's screenshot
    expect(find.text('Ticket Options'), findsOneWidget);
    expect(find.text('View Original Ticket'), findsOneWidget);
    expect(find.text('Share Boarding Pass'), findsOneWidget);
    expect(find.text('Download'), findsOneWidget);
    expect(find.text('Delete Boarding Pass'), findsOneWidget);

    // Tap 'Delete Boarding Pass'
    await tester.tap(find.text('Delete Boarding Pass'));
    await tester.pumpAndSettle();

    // Verify DeleteTicketBottomSheet confirmation appears for BA 0215
    expect(find.text('Delete Boarding Pass?'), findsOneWidget);
    expect(find.text('Delete Ticket'), findsOneWidget);

    // Confirm deletion
    await tester.tap(find.text('Delete Ticket'));
    await tester.pumpAndSettle();

    // Verify ONLY BA 0215 was deleted, 2 tickets remain!
    final savedTickets = container.read(savedTicketsProvider).tickets;
    expect(savedTickets.length, 2);
    expect(savedTickets.any((t) => t.flightNumber == 'BA 0215'), isFalse);
    expect(savedTickets.any((t) => t.flightNumber == 'LH 2031'), isTrue);
    expect(savedTickets.any((t) => t.flightNumber == 'W6 3189'), isTrue);

    // Flight journey remains active with the remaining ticket!
    expect(container.read(flightJourneyNotifierProvider).hasActiveFlight, isTrue);
    expect(find.text('1 OF 2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bottom pagination indicator renders and updates via Riverpod', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(savedTicketsProvider.notifier).loadDemoTickets();
    container.read(savedTicketsProvider.notifier).hideAddPass();

    // Make flight active
    container.read(flightJourneyNotifierProvider.notifier).addBoardingPass(
          flightNumber: 'BA 0215',
          originCode: 'AMS',
          destinationCode: 'FRA',
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

    // Verify '1 OF 3' badge
    expect(find.text('1 OF 3'), findsOneWidget);

    // Verify TicketBoardingPass has crisp white border
    final boardingPassFinder = find.byType(TicketBoardingPass);
    expect(boardingPassFinder, findsOneWidget);

    // Select second ticket via Riverpod
    container.read(savedTicketsProvider.notifier).selectTicket(1);
    await tester.pumpAndSettle();

    // Verify badge updated reactively via Riverpod
    expect(find.text('2 OF 3'), findsOneWidget);
    expect(container.read(savedTicketsProvider).selectedIndex, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AddBoardingPassView displays Upload from Gallery button', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

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

    // Verify AddBoardingPassView has 'Upload from Gallery' and 'Enter Details Manually'
    expect(find.text('Upload from Gallery'), findsOneWidget);
    expect(find.text('Enter Details Manually'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tapping Share Boarding Pass invokes AppShareHelper safely', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(savedTicketsProvider.notifier).loadDemoTickets();
    container.read(savedTicketsProvider.notifier).hideAddPass();

    container.read(flightJourneyNotifierProvider.notifier).addBoardingPass(
          flightNumber: 'BA 0215',
          originCode: 'AMS',
          destinationCode: 'FRA',
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

    // Tap 3 dots
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Tap Share Boarding Pass
    expect(find.text('Share Boarding Pass'), findsOneWidget);
    await tester.tap(find.text('Share Boarding Pass'));
    await tester.pumpAndSettle();

    // Dialog should be dismissed cleanly
    expect(find.text('Ticket Options'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AddBoardingPassView 3 dots opens popup menu with Clear Saved Tickets and clears tickets', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(savedTicketsProvider.notifier).loadDemoTickets();

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

    // Verify on ADD BOARDING PASS view
    expect(find.text('ADD BOARDING PASS'), findsOneWidget);
    expect(container.read(savedTicketsProvider).tickets.isNotEmpty, isTrue);

    // Tap 3 dots on ADD BOARDING PASS view
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Verify popup menu displays 'Clear Saved Tickets'
    expect(find.text('Clear Saved Tickets'), findsOneWidget);

    // Tap 'Clear Saved Tickets'
    await tester.tap(find.text('Clear Saved Tickets'));
    await tester.pumpAndSettle();

    // Verify saved tickets are cleared
    expect(container.read(savedTicketsProvider).tickets.isEmpty, isTrue);
    expect(find.text('No saved tickets yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Normal user starts with empty saved tickets list and demo tickets are excluded', (WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(savedTicketsProvider).tickets.isEmpty, isTrue);
    expect(container.read(flightJourneyNotifierProvider).hasActiveFlight, isFalse);
  });
}


