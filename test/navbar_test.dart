import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/feature/home/screen/home_screen.dart';
import 'package:navyla_flight_app/feature/navbar/screen/navbar_screen.dart';
import 'package:navyla_flight_app/feature/scan/screen/scan_screen.dart';
import 'package:navyla_flight_app/feature/ticket/screen/ticket_screen.dart';
import 'package:navyla_flight_app/feature/navbar/widget/custom_bottom_navbar.dart';

void main() {
  testWidgets('CustomBottomNavBar builds standalone without ProviderScope',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    int tappedIndex = -1;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: 0,
              onTap: (index) => tappedIndex = index,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppString.navHome), findsOneWidget);
    expect(find.text(AppString.navTicket), findsOneWidget);
    expect(find.text(AppString.navScan), findsOneWidget);
    expect(find.text(AppString.navFeed), findsOneWidget);
    expect(find.text(AppString.navMore), findsOneWidget);

    // Tap Ticket
    await tester.tap(find.text(AppString.navTicket));
    await tester.pumpAndSettle();
    expect(tappedIndex, 1);

    // Tap Scan
    await tester.tap(find.text(AppString.navScan));
    await tester.pumpAndSettle();
    expect(tappedIndex, 2);
  });

  testWidgets('NavbarScreen renders HomeScreen initially and switches tabs',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          builder: (context, child) => const MaterialApp(
            home: NavbarScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify HomeScreen is shown
    expect(find.byType(HomeScreen), findsOneWidget);

    // Tap Ticket tab
    await tester.tap(find.text(AppString.navTicket));
    await tester.pumpAndSettle();
    expect(find.byType(TicketScreen), findsOneWidget);

    // Tap Scan tab
    await tester.tap(find.text(AppString.navScan));
    await tester.pumpAndSettle();
    expect(find.byType(ScanScreen), findsOneWidget);
  });
}
