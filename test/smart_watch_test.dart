import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/setting/setting/screen/setting_screen.dart';
import 'package:navyla_flight_app/feature/setting/smart_watch/screen/smart_watch_screen.dart';

void main() {
  Widget buildTestableSmartWatchScreen({
    TargetPlatform platform = TargetPlatform.android,
  }) {
    return ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            theme: ThemeData(platform: platform),
            home: const SmartWatchScreen(),
          );
        },
      ),
    );
  }

  Widget buildTestableSettingScreen({
    TargetPlatform platform = TargetPlatform.android,
  }) {
    return ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            theme: ThemeData(platform: platform),
            home: const SettingScreen(),
          );
        },
      ),
    );
  }

  testWidgets(
      'SmartWatchScreen on Android opens Wear OS and simulated ready state directly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildTestableSmartWatchScreen(platform: TargetPlatform.android),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Verifies Wear OS platform is selected directly
    expect(find.text('Android • Wear OS'), findsOneWidget);
    expect(find.text('iPhone • Apple Watch'), findsNothing);

    // Verifies it opens in the ready state directly (not notPaired or appNotInstalled)
    expect(find.text('Smartwatch Ready'), findsOneWidget);
    expect(
      find.text('NAVYLA is installed and ready on your Wear OS smartwatch.'),
      findsOneWidget,
    );
    expect(find.text('Active & Connected'), findsOneWidget);
    expect(find.text('Available on Watch'), findsOneWidget);
    expect(find.text('Enabled'), findsOneWidget);

    // Verifies action button is "Done" rather than cycling through fake advance steps
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Open Wear OS App'), findsNothing);
    expect(find.text('Install NAVYLA'), findsNothing);
  });

  testWidgets(
      'SmartWatchScreen on iOS opens Apple Watch and simulated ready state directly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      buildTestableSmartWatchScreen(platform: TargetPlatform.iOS),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Verifies Apple Watch platform is selected directly
    expect(find.text('iPhone • Apple Watch'), findsOneWidget);
    expect(find.text('Android • Wear OS'), findsNothing);

    // Verifies it opens in the ready state directly
    expect(find.text('Apple Watch Ready'), findsOneWidget);
    expect(
      find.text('NAVYLA is installed and ready to sync on your Apple Watch.'),
      findsOneWidget,
    );
    expect(find.text('Active & Connected'), findsOneWidget);
    expect(find.text('Available on Apple Watch'), findsOneWidget);
    expect(find.text('Enabled'), findsOneWidget);

    // Verifies action button is "Done"
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Open Apple Watch App'), findsNothing);
    expect(find.text('Install NAVYLA'), findsNothing);
  });

  testWidgets(
      'SettingScreen aligns smartwatch subtitle with device platform',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Android
    await tester.pumpWidget(
      buildTestableSettingScreen(platform: TargetPlatform.android),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Wear OS'), findsOneWidget);
    expect(find.text('Apple Watch'), findsNothing);

    // iOS
    await tester.pumpWidget(
      buildTestableSettingScreen(platform: TargetPlatform.iOS),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Apple Watch'), findsOneWidget);
  });
}
