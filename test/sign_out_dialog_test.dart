import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/sign_out_dialog.dart';

void main() {
  testWidgets('SignOutDialog renders all elements and triggers callbacks',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool signedOut = false;
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
                      SignOutDialog.show(
                        ctx,
                        onSignOut: () => signedOut = true,
                        onCancel: () => cancelled = true,
                      );
                    },
                    child: const Text('Open Sign Out'),
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
    await tester.tap(find.text('Open Sign Out'));
    await tester.pumpAndSettle();

    // Verify dialog content
    expect(find.text('Sign out?'), findsOneWidget);
    expect(
      find.text('Are you sure you want to sign out of your account?'),
      findsOneWidget,
    );
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);

    // Tap Cancel
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(cancelled, isTrue);
    expect(signedOut, isFalse);
    expect(find.text('Sign out?'), findsNothing);

    // Open dialog again to test Sign Out
    await tester.tap(find.text('Open Sign Out'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign Out'));
    await tester.pumpAndSettle();

    expect(signedOut, isTrue);
    expect(find.text('Sign out?'), findsNothing);
  });
}
