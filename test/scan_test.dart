import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/scan/screen/scan_screen.dart';

void main() {
  testWidgets('ScanScreen renders title, subtitle, camera card and option cards', (
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
              home: ScanScreen(),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Load your ticket'), findsOneWidget);
    expect(
      find.text(
        'Upload your digital pass or scan a printed one\nto begin your stress-free journey.',
      ),
      findsOneWidget,
    );

    // Verify Camera Card
    expect(find.text('Scan camera'), findsOneWidget);
    expect(find.text('Real-time AR extraction'), findsOneWidget);

    // Verify Action Option Cards
    expect(find.text('Gallery'), findsOneWidget);
    expect(find.text('Manual entry'), findsOneWidget);
  });
}
