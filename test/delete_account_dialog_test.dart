import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/delete_account_dialog.dart';

void main() {
  testWidgets('DeleteAccountDialog renders all elements and triggers callbacks',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool deleted = false;
    bool cancelled = false;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) => Center(
                  child: ElevatedButton(
                    onPressed: () {
                      DeleteAccountDialog.show(
                        ctx,
                        onDelete: () => deleted = true,
                        onCancel: () => cancelled = true,
                      );
                    },
                    child: const Text('Open Dialog'),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    // Open dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // Verify dialog content
    expect(find.text('Delete account?'), findsOneWidget);
    expect(
      find.text(
          'This permanently deletes your profile and history. This cannot be undone.'),
      findsOneWidget,
    );
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    // Tap Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(cancelled, isTrue);
    expect(deleted, isFalse);
    expect(find.text('Delete account?'), findsNothing);

    // Open dialog again to test Delete
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(deleted, isTrue);
    expect(find.text('Delete account?'), findsNothing);
  });
}
