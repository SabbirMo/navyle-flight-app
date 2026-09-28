import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/notification/provider/notification_notifier.dart';
import 'package:navyla_flight_app/feature/notification/screen/notification_screen.dart';

void main() {
  testWidgets('NotificationScreen renders sections and notification cards', (
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
              home: NotificationScreen(),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('NOTIFICATIONS'), findsOneWidget);

    // Verify Section Headers
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('YESTERDAY'), findsOneWidget);

    // Verify Card Titles
    expect(find.text('GATE'), findsOneWidget);
    expect(find.text('Post Verified'), findsOneWidget);
    expect(find.text('Security'), findsNWidgets(2));

    // Verify Timestamps
    expect(find.text('2 MINS AGO'), findsOneWidget);
    expect(find.text('15 MINS AGO'), findsOneWidget);
    expect(find.text('1 HOUR AGO'), findsOneWidget);
    expect(find.text('YESTERDAY, 4:20 PM'), findsOneWidget);
  });

  testWidgets('NotificationNotifier marks item as read on tap', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final items = container.read(notificationNotifierProvider);
    expect(items[0].isUnread, true);

    container.read(notificationNotifierProvider.notifier).markAsRead('1');

    final updatedItems = container.read(notificationNotifierProvider);
    expect(updatedItems[0].isUnread, false);
    expect(updatedItems[0].isHighlighted, false);
  });
}
