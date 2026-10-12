import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/manage_plan/screen/manage_plan_screen.dart';

void main() {
  Widget buildTestableManagePlanScreen({TargetPlatform platform = TargetPlatform.android}) {
    return ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            theme: ThemeData(platform: platform),
            home: const ManagePlanScreen(),
          );
        },
      ),
    );
  }

  testWidgets('ManagePlanScreen on Android aligns wording with Google Play and shows store-managed auto-renewal',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestableManagePlanScreen(platform: TargetPlatform.android));
    await tester.pumpAndSettle();

    // Verify Billing Card says Google Play
    expect(find.text('Managed by Google Play'), findsOneWidget);

    // Verify Manage Subscription subtitle says Google Play (not App Store)
    expect(find.text('Open Google Play subscription settings'), findsOneWidget);
    expect(find.text('Open App Store subscription settings'), findsNothing);

    // Verify Auto-renewal is store-managed by Google Play, not an in-app switch
    expect(find.text('Auto-renewal'), findsOneWidget);
    expect(find.text('Renews automatically via Google Play'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);

    // Verify Notice Card says Google Play
    expect(
      find.text('Subscription management and billing are handled by Google Play, not directly by NAVYLA.'),
      findsOneWidget,
    );
  });

  testWidgets('ManagePlanScreen on iOS aligns wording with App Store and shows Restore Purchases',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestableManagePlanScreen(platform: TargetPlatform.iOS));
    await tester.pumpAndSettle();

    // Verify Billing Card says App Store
    expect(find.text('Managed by App Store'), findsOneWidget);

    // Verify Manage Subscription subtitle says App Store
    expect(find.text('Open App Store subscription settings'), findsOneWidget);
    expect(find.text('Open Google Play subscription settings'), findsNothing);

    // Verify Restore Purchases option exists on iOS
    expect(find.text('Restore Purchases'), findsOneWidget);

    // Verify Auto-renewal is store-managed by App Store
    expect(find.text('Auto-renewal'), findsOneWidget);
    expect(find.text('Renews automatically via App Store'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);

    // Verify Notice Card says Apple App Store
    expect(
      find.text('Subscription management and billing are handled by Apple App Store, not directly by NAVYLA.'),
      findsOneWidget,
    );
  });
}
