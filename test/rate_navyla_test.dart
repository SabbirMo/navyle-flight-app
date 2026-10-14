import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/setting/rate_navyla/widget/rate_navyla_bottom_sheet.dart';

void main() {
  testWidgets('RateNavylaBottomSheet show and submit rating', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => Center(
                child: ElevatedButton(
                  onPressed: () => RateNavylaBottomSheet.show(ctx),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Open bottom sheet
    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Submit Rating'), findsOneWidget);

    // Tap submit rating
    await tester.ensureVisible(find.text('Submit Rating'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Submit Rating'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // SnackBar appears on click
    expect(find.text('Thank you for sharing your experience!'), findsOneWidget);

    // After 2 seconds, snackbar completes and sheet navigates back
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Submit Rating'), findsNothing);
  });
}
