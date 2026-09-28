import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/feature/navbar/screen/navbar_screen.dart';
import 'package:navyla_flight_app/feature/navbar/widget/custom_bottom_navbar.dart';

void main() {
  testWidgets('NavbarScreen hides bottom navigation bar when index is scan (2)', (
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
              home: NavbarScreen(),
            );
          },
        ),
      ),
    );

    await tester.pump();

    // Verify initial screen has bottom navbar
    expect(find.byType(CustomBottomNavBar), findsOneWidget);

    // Switch state to scan tab (2)
    final container = ProviderScope.containerOf(
      tester.element(find.byType(NavbarScreen)),
    );
    container.read(navbarNotifierProvider.notifier).setIndex(2);
    await tester.pump();

    // Verify CustomBottomNavBar is hidden when scan screen is active
    expect(find.byType(CustomBottomNavBar), findsNothing);

    // Switch back to home
    container.read(navbarNotifierProvider.notifier).setIndex(0);
    await tester.pump();

    // Verify CustomBottomNavBar is visible again
    expect(find.byType(CustomBottomNavBar), findsOneWidget);
  });
}
