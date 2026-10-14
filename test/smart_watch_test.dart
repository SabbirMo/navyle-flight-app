import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:navyla_flight_app/core/services/app_preference_service.dart';
import 'package:navyla_flight_app/feature/setting/setting/screen/setting_screen.dart';
import 'package:navyla_flight_app/feature/setting/smart_watch/model/smart_watch_state.dart';
import 'package:navyla_flight_app/feature/setting/smart_watch/screen/smart_watch_screen.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppPreferenceService.init();
  });

  Widget buildTestableSmartWatchScreen({
    TargetPlatform platform = TargetPlatform.android,
    SmartWatchSyncState? initialState,
  }) {
    return ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            theme: ThemeData(platform: platform),
            home: SmartWatchScreen(initialState: initialState),
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
      'SmartWatchScreen initial setup on Android shows connection/setup (Open Wear OS) then Install NAVYLA then Ready/Done',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Initial visit: setup is NOT completed
    expect(AppPreferenceService.isSmartWatchSetupCompleted, isFalse);

    await tester.pumpWidget(
      buildTestableSmartWatchScreen(platform: TargetPlatform.android),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // 1. Initial State: Connection/Setup (notPaired)
    expect(find.text('Android • Wear OS'), findsOneWidget);
    expect(find.text('No compatible smartwatch connected'), findsOneWidget);
    expect(
      find.text(
          'Connect a Wear OS smartwatch in the Wear OS app on your phone to sync boarding passes and flight alerts with NAVYLA.'),
      findsOneWidget,
    );
    expect(find.text('Open Wear OS App'), findsOneWidget);
    expect(find.text('Done'), findsNothing);

    // Tap "Open Wear OS App" -> moves to step 2 (appNotInstalled)
    final openButtonFinder = find.text('Open Wear OS App');
    await tester.ensureVisible(openButtonFinder);
    await tester.tap(openButtonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 2. Open/Install State: appNotInstalled
    expect(find.text("NAVYLA isn't installed"), findsOneWidget);
    expect(find.text('Wear OS watch detected'), findsOneWidget);
    expect(find.text('Install NAVYLA'), findsOneWidget);
    expect(find.text('Done'), findsNothing);

    // Tap "Install NAVYLA" -> moves to step 3 (ready) and persists setup completion
    final installButtonFinder = find.text('Install NAVYLA');
    await tester.ensureVisible(installButtonFinder);
    await tester.tap(installButtonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // 3. Completed State: ready / Done
    expect(find.text('Smartwatch Ready'), findsOneWidget);
    expect(
      find.text('NAVYLA is installed and ready on your Wear OS smartwatch.'),
      findsOneWidget,
    );
    expect(find.text('Active & Connected'), findsOneWidget);
    expect(find.text('Available on Watch'), findsOneWidget);
    expect(find.text('Enabled'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    // Setup completion is persisted
    expect(AppPreferenceService.isSmartWatchSetupCompleted, isTrue);
  });

  testWidgets(
      'SmartWatchScreen on subsequent visit opens directly to Ready/Done state when setup is completed',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Prerequisite: Setup was completed on a previous visit
    await AppPreferenceService.setSmartWatchSetupCompleted(true);

    await tester.pumpWidget(
      buildTestableSmartWatchScreen(platform: TargetPlatform.android),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Subsequent visit opens directly to Ready state with Done button
    expect(find.text('Android • Wear OS'), findsOneWidget);
    expect(find.text('Smartwatch Ready'), findsOneWidget);
    expect(find.text('Active & Connected'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Open Wear OS App'), findsNothing);
    expect(find.text('Install NAVYLA'), findsNothing);
  });

  testWidgets(
      'SmartWatchScreen initial setup on iOS shows connection/setup (Open Apple Watch App) then Install then Ready/Done',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    expect(AppPreferenceService.isSmartWatchSetupCompleted, isFalse);

    await tester.pumpWidget(
      buildTestableSmartWatchScreen(platform: TargetPlatform.iOS),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // Initial state: notPaired
    expect(find.text('iPhone • Apple Watch'), findsOneWidget);
    expect(find.text('No Apple Watch Paired'), findsOneWidget);
    expect(find.text('Open Apple Watch App'), findsOneWidget);
    expect(find.text('Done'), findsNothing);

    // Tap "Open Apple Watch App" -> step 2
    final openButtonFinder = find.text('Open Apple Watch App');
    await tester.ensureVisible(openButtonFinder);
    await tester.tap(openButtonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("NAVYLA isn't installed"), findsOneWidget);
    expect(find.text('Apple Watch detected'), findsOneWidget);
    expect(find.text('Install NAVYLA'), findsOneWidget);

    // Tap "Install NAVYLA" -> step 3 (Ready)
    final installButtonFinder = find.text('Install NAVYLA');
    await tester.ensureVisible(installButtonFinder);
    await tester.tap(installButtonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Apple Watch Ready'), findsOneWidget);
    expect(find.text('Active & Connected'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
    expect(AppPreferenceService.isSmartWatchSetupCompleted, isTrue);
  });

  testWidgets(
      'Resetting Smartwatch Setup via Help dialog resets back to initial setup state',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Start with completed setup
    await AppPreferenceService.setSmartWatchSetupCompleted(true);

    await tester.pumpWidget(
      buildTestableSmartWatchScreen(platform: TargetPlatform.android),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Smartwatch Ready'), findsOneWidget);

    // Tap "?" help button
    await tester.tap(find.text('?'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Tap "Reset Smartwatch Setup"
    expect(find.text('Reset Smartwatch Setup'), findsOneWidget);
    await tester.tap(find.text('Reset Smartwatch Setup'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify it reset to initial setup state
    expect(AppPreferenceService.isSmartWatchSetupCompleted, isFalse);
    expect(find.text('No compatible smartwatch connected'), findsOneWidget);
    expect(find.text('Open Wear OS App'), findsOneWidget);
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
