import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/notification/provider/notification_notifier.dart';
import 'package:navyla_flight_app/feature/notification/screen/notification_screen.dart';
import 'package:navyla_flight_app/feature/notification/widget/notification_card.dart';

void main() {
  Widget buildTestableNotificationScreen({ProviderContainer? container}) {
    return UncontrolledProviderScope(
      container: container ?? ProviderContainer(),
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        builder: (context, child) {
          return const MaterialApp(
            home: NotificationScreen(),
          );
        },
      ),
    );
  }

  testWidgets(
      'NotificationScreen shows unread cards and Mark all as read button, and updates state when tapped',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      buildTestableNotificationScreen(container: container),
    );
    await tester.pump();

    // Verify initial unread items exist
    expect(
      container.read(notificationNotifierProvider).any((n) => n.isUnread),
      isTrue,
    );

    // Header has the Mark all as read button (done_all_rounded icon)
    final markAllFinder = find.byIcon(Icons.done_all_rounded);
    expect(markAllFinder, findsOneWidget);

    // Tap Mark all as read
    await tester.tap(markAllFinder);
    await tester.pump();

    // Now all notifications are read
    expect(
      container.read(notificationNotifierProvider).any((n) => n.isUnread),
      isFalse,
    );

    // The Mark all as read icon button is now gone
    expect(find.byIcon(Icons.done_all_rounded), findsNothing);
  });

  testWidgets(
      'Tapping an individual unread NotificationCard marks it as read',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      buildTestableNotificationScreen(container: container),
    );
    await tester.pump();

    // Verify first item is unread
    final firstItem = container.read(notificationNotifierProvider).first;
    expect(firstItem.isUnread, isTrue);

    // Tap the first NotificationCard
    final firstCardFinder = find.byType(NotificationCard).first;
    await tester.tap(firstCardFinder);
    await tester.pump();

    // Verify first item is now read
    final updatedFirstItem =
        container.read(notificationNotifierProvider).firstWhere((n) => n.id == firstItem.id);
    expect(updatedFirstItem.isUnread, isFalse);
  });
}
