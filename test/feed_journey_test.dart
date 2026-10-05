import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/feed/screen/feed_screen.dart';
import 'package:navyla_flight_app/feature/feed/widget/feed_card_widget.dart';
import 'package:navyla_flight_app/feature/feed/widget/feed_my_post_empty_widget.dart';
import 'package:navyla_flight_app/feature/feed/widget/feed_no_active_journey_widget.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';

void main() {
  Widget buildTestableFeedScreen({ProviderContainer? container}) {
    return UncontrolledProviderScope(
      container: container ?? ProviderContainer(),
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        builder: (context, child) {
          return const MaterialApp(
            home: FeedScreen(),
          );
        },
      ),
    );
  }

  testWidgets(
      'FeedScreen shows FeedNoActiveJourneyWidget when no boarding pass is active',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(buildTestableFeedScreen(container: container));
    await tester.pump();

    // Verify: FeedNoActiveJourneyWidget is visible
    expect(find.byType(FeedNoActiveJourneyWidget), findsOneWidget);
    expect(find.text('ACTIVE JOURNEY REQUIRED'), findsOneWidget);
    expect(find.text('No active journey'), findsOneWidget);
    expect(find.text('Scan / Load Boarding Pass'), findsOneWidget);
    expect(find.text('Enter flight number manually >'), findsOneWidget);
    expect(find.text('Clutter-free guarantee'), findsOneWidget);

    // Verify: Normal feed cards are NOT shown
    expect(find.byType(FeedCardWidget), findsNothing);
  });

  testWidgets(
      'FeedScreen switches to normal feed cards when boarding pass is added and back when removed',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(buildTestableFeedScreen(container: container));
    await tester.pump();

    // Initially: No active journey design
    expect(find.byType(FeedNoActiveJourneyWidget), findsOneWidget);
    expect(find.byType(FeedCardWidget), findsNothing);

    // Add boarding pass
    container.read(flightJourneyNotifierProvider.notifier).addBoardingPass(
          flightNumber: 'BA 0215',
          originCode: 'AMS',
          destinationCode: 'FRA',
          seat: '14A',
          gate: 'B24',
          terminal: 'T5',
        );
    await tester.pump();

    // Now: FeedNoActiveJourneyWidget is gone, normal FeedCardWidgets appear
    expect(find.byType(FeedNoActiveJourneyWidget), findsNothing);
    expect(find.byType(FeedCardWidget), findsWidgets);

    // Remove boarding pass
    container.read(flightJourneyNotifierProvider.notifier).removeBoardingPass();
    await tester.pump();

    // Reverts to No active journey design
    expect(find.byType(FeedNoActiveJourneyWidget), findsOneWidget);
    expect(find.byType(FeedCardWidget), findsNothing);
  });

  testWidgets(
      'FeedScreen shows FeedMyPostEmptyWidget when My post tab is selected and has no posts',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1179, 2556);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(buildTestableFeedScreen(container: container));
    await tester.pump();

    // Tap on "My post" tab
    await tester.tap(find.text('My post'));
    await tester.pumpAndSettle();

    // Verify: FeedMyPostEmptyWidget is shown
    expect(find.byType(FeedMyPostEmptyWidget), findsOneWidget);
    expect(find.text('MY ACTIVITY'), findsOneWidget);
    expect(find.text('No posts yet'), findsOneWidget);
    expect(find.text('Create Your First Post'), findsOneWidget);
  });
}
