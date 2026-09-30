import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/scan/verify_details/screen/verify_details_screen.dart';

void main() {
  testWidgets('VerifyDetailsScreen renders extracted data in default mode', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        builder: (context, child) {
          return const MaterialApp(
            home: VerifyDetailsScreen(),
          );
        },
      ),
    );

    await tester.pumpAndSettle();

    // Verify Header Back button with VERIFY DETAILS title
    expect(find.byType(CustomBackButton), findsOneWidget);
    expect(find.text('VERIFY DETAILS'), findsOneWidget);

    // Verify Success Banner
    expect(find.text('EXTRACTED SUCCESSFUL'), findsOneWidget);
    expect(find.text('Please review the details below.'), findsOneWidget);

    // Verify Pre-filled Card text
    expect(find.text('NAME'), findsOneWidget);
    expect(find.text('ALEX RIVERS'), findsOneWidget);

    expect(find.text('FLIGHT NUMBER'), findsOneWidget);
    expect(find.text('BA 0215'), findsOneWidget);

    expect(find.text('FROM'), findsOneWidget);
    expect(find.text('LHR'), findsOneWidget);
    expect(find.text('TO'), findsOneWidget);
    expect(find.text('JFK'), findsOneWidget);

    expect(find.text('DATE'), findsOneWidget);
    expect(find.text('24/09/26'), findsOneWidget);
    expect(find.text('SEAT'), findsOneWidget);
    expect(find.text('14A'), findsOneWidget);

    expect(find.text('TERMINAL'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('GATE'), findsOneWidget);
    expect(find.text('B24'), findsOneWidget);

    // Verify AI Disclaimer Banner
    expect(
      find.text(
        'NAVYLA uses AI to extract this information. Incorrect data may affect your real-time alerts.',
      ),
      findsOneWidget,
    );

    // Verify Confirm Button
    expect(find.byType(CustomButton), findsOneWidget);
    expect(find.text('Confirm & Create Pass'), findsOneWidget);
  });

  testWidgets(
      'VerifyDetailsScreen opens with empty text fields in manual mode and allows typing',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        builder: (context, child) {
          return const MaterialApp(
            home: VerifyDetailsScreen(isManual: true),
          );
        },
      ),
    );

    await tester.pumpAndSettle();

    // Verify manual mode banner
    expect(find.text('ENTER FLIGHT DETAILS'), findsOneWidget);
    expect(
        find.text('Please type in your flight details below.'), findsOneWidget);

    // In manual mode, prefilled texts like ALEX RIVERS should NOT exist
    expect(find.text('ALEX RIVERS'), findsNothing);
    expect(find.text('BA 0215'), findsNothing);

    // All TextFields should be present (8 fields: name, flight, from, to, date, seat, terminal, gate)
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(8));

    // Type into the first textfield (Name)
    await tester.enterText(textFields.at(0), 'JOHN DOE');
    await tester.pump();
    expect(find.text('JOHN DOE'), findsOneWidget);

    // Type into second textfield (Flight Number)
    await tester.enterText(textFields.at(1), 'EK 0202');
    await tester.pump();
    expect(find.text('EK 0202'), findsOneWidget);
  });

  testWidgets('Tapping DATE field opens DatePickerDialog',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        builder: (context, child) {
          return const MaterialApp(
            home: VerifyDetailsScreen(),
          );
        },
      ),
    );

    await tester.pumpAndSettle();

    // Tap DATE label or card
    await tester.tap(find.text('DATE'));
    await tester.pumpAndSettle();

    // Verify DatePickerDialog is displayed
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });
}
