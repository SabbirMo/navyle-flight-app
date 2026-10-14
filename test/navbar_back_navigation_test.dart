import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/feature/navbar/screen/navbar_screen.dart';

void main() {
  testWidgets(
    'System back on Ticket, Feed, and More tabs returns to Home (0)',
    (WidgetTester tester) async {
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
              return const MaterialApp(home: NavbarScreen());
            },
          ),
        ),
      );

      await tester.pump();
      final container = ProviderScope.containerOf(
        tester.element(find.byType(NavbarScreen)),
      );

      // Initial tab is Home (0)
      expect(container.read(navbarNotifierProvider), 0);

      // 1. Switch to Ticket tab (1)
      container.read(navbarNotifierProvider.notifier).setIndex(1);
      await tester.pump();
      expect(container.read(navbarNotifierProvider), 1);

      // Press System Back
      final didPop1 = await tester.binding.handlePopRoute();
      expect(didPop1, isTrue);
      await tester.pump();
      // Should return to Home (0)
      expect(container.read(navbarNotifierProvider), 0);

      // 2. Switch to Feed tab (3)
      container.read(navbarNotifierProvider.notifier).setIndex(3);
      await tester.pump();
      expect(container.read(navbarNotifierProvider), 3);

      // Press System Back
      final didPop2 = await tester.binding.handlePopRoute();
      expect(didPop2, isTrue);
      await tester.pump();
      // Should return to Home (0)
      expect(container.read(navbarNotifierProvider), 0);

      // 3. Switch to More tab (4)
      container.read(navbarNotifierProvider.notifier).setIndex(4);
      await tester.pump();
      expect(container.read(navbarNotifierProvider), 4);

      // Press System Back
      final didPop3 = await tester.binding.handlePopRoute();
      expect(didPop3, isTrue);
      await tester.pump();
      // Should return to Home (0)
      expect(container.read(navbarNotifierProvider), 0);
    },
  );

  testWidgets(
    'More tab pops secondary screen first, then on next back returns to Home',
    (WidgetTester tester) async {
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
              return const MaterialApp(home: NavbarScreen());
            },
          ),
        ),
      );

      await tester.pump();
      final container = ProviderScope.containerOf(
        tester.element(find.byType(NavbarScreen)),
      );

      // Switch to More tab (4)
      container.read(navbarNotifierProvider.notifier).setIndex(4);
      await tester.pump();
      expect(container.read(navbarNotifierProvider), 4);

      // Tap on first travel extra item (Hotels)
      expect(find.text('Hotels'), findsOneWidget);
      await tester.tap(find.text('Hotels'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Verify secondary screen (MoreDetailsScreen) is showing
      expect(find.text('Offers from NAVYLA partners'), findsOneWidget);

      // Press System Back while on secondary screen
      final didPopSub = await tester.binding.handlePopRoute();
      expect(didPopSub, isTrue);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      // Secondary screen popped, back on More main screen, still on More tab (4)
      expect(container.read(navbarNotifierProvider), 4);
      expect(find.text('Offers from NAVYLA partners'), findsNothing);
      expect(find.text('Travel Extras'), findsOneWidget);

      // Now press System Back on More main screen
      final didPopToHome = await tester.binding.handlePopRoute();
      expect(didPopToHome, isTrue);
      await tester.pump();

      // Returns to Home (0)
      expect(container.read(navbarNotifierProvider), 0);
    },
  );

  testWidgets(
    'Tapping UI back button on Feed, More, and Ticket navigates to Home',
    (WidgetTester tester) async {
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
              return const MaterialApp(home: NavbarScreen());
            },
          ),
        ),
      );

      await tester.pump();
      final container = ProviderScope.containerOf(
        tester.element(find.byType(NavbarScreen)),
      );

      // 1. Feed Screen back button
      container.read(navbarNotifierProvider.notifier).setIndex(3);
      await tester.pump();
      expect(container.read(navbarNotifierProvider), 3);
      expect(find.byKey(const Key('feed_back_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('feed_back_button')));
      await tester.pump();
      expect(container.read(navbarNotifierProvider), 0);

      // 2. More Screen back button
      container.read(navbarNotifierProvider.notifier).setIndex(4);
      await tester.pump();
      expect(container.read(navbarNotifierProvider), 4);
      expect(find.byKey(const Key('more_back_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('more_back_button')));
      await tester.pump();
      expect(container.read(navbarNotifierProvider), 0);

      // 3. Ticket Screen back button
      container.read(navbarNotifierProvider.notifier).setIndex(1);
      await tester.pump();
      expect(container.read(navbarNotifierProvider), 1);
      expect(find.byKey(const Key('add_pass_back_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('add_pass_back_button')));
      await tester.pump();
      expect(container.read(navbarNotifierProvider), 0);
    },
  );
}
