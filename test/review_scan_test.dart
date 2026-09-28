import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/scan/screen/review_scan_screen.dart';
import 'package:navyla_flight_app/feature/scan/widget/scanner_corner_overlay.dart';

void main() {
  testWidgets('ReviewScanScreen renders all UI elements accurately', (
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
              home: ReviewScanScreen(),
            );
          },
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));

    // Verify Header Back button with Title
    expect(find.byType(CustomBackButton), findsOneWidget);
    expect(find.text('Review Scan'), findsOneWidget);

    // Verify Headings
    expect(find.text('Boarding Pass'), findsOneWidget);
    expect(find.text('Check your scan'), findsOneWidget);
    expect(
      find.text(
        'Make sure your boarding pass is clear and readable before we extract the details.',
      ),
      findsOneWidget,
    );

    // Verify Scanner Corners Overlay
    expect(find.byType(ScannerCornerOverlay), findsOneWidget);

    // Verify Question Card
    expect(find.text('Is this scan clear and complete?'), findsOneWidget);
    expect(
      find.text('If anything is blurry or missing, retake the photo.'),
      findsOneWidget,
    );

    // Verify Action Buttons
    expect(find.text('Use This Scan'), findsOneWidget);
    expect(find.text('Retake'), findsOneWidget);
  });
}
