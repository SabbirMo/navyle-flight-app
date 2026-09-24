import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/home/widget/city_weather_card.dart';

void main() {
  testWidgets('CityWeatherCard renders with default information', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) => const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: CityWeatherCard(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('New York'), findsOneWidget);
    expect(find.text('24°C'), findsOneWidget);
    expect(find.text('Partly cloudy'), findsOneWidget);
    expect(find.text('Local time'), findsOneWidget);
    expect(find.text('3:18 AM'), findsOneWidget);
    expect(find.text('Tue, Apr 23'), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(2));
  });
}
