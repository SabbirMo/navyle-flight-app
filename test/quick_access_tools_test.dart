import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/home/widget/quick_access_tools_widget.dart';

void main() {
  testWidgets('QuickAccessToolsWidget renders all 4 cards correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        builder: (context, child) {
          return const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: QuickAccessToolsWidget(),
              ),
            ),
          );
        },
      ),
    );

    // Verify all 4 titles render
    expect(find.text('Airport Navigation'), findsOneWidget);
    expect(find.text('Boarding pass'), findsOneWidget);
    expect(find.text('Explore nearby'), findsOneWidget);
    expect(find.text('Ask NAVYLA'), findsOneWidget);

    // Verify all 4 subtitles render
    expect(find.text('FIND YOUR WAY'), findsOneWidget);
    expect(find.text('VIEW YOUR PASS'), findsOneWidget);
    expect(find.text('SHOP, FOODS & MORE'), findsOneWidget);
    expect(find.text('YOUR AI ASSISTANT'), findsOneWidget);

    // Verify 4 chevrons render
    expect(find.byIcon(Icons.arrow_forward_ios_rounded), findsNWidgets(4));
  });
}
