import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/scan/screen/scan_camera_screen.dart';
import 'package:navyla_flight_app/feature/scan/widget/scanner_corner_overlay.dart';

void main() {
  testWidgets('ScanCameraScreen renders all UI elements accurately', (
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
              home: ScanCameraScreen(),
            );
          },
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));

    // Verify Header Back button
    expect(find.byType(CustomBackButton), findsOneWidget);

    // Verify Title & Subtitle
    expect(find.text('SCAN PASS'), findsOneWidget);
    expect(find.text('Align the boarding pass'), findsOneWidget);
    expect(
      find.text(
        'Keep it within the frame and avoid glare for better extraction.',
      ),
      findsOneWidget,
    );

    // Verify Scanner Corners Overlay
    expect(find.byType(ScannerCornerOverlay), findsOneWidget);

    // Verify Bottom Action buttons
    expect(find.text('GALLERY'), findsOneWidget);
    expect(find.text('MANUAL'), findsOneWidget);
  });
}
