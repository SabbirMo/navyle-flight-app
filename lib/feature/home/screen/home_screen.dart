import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/core/widgets/title_row_click.dart';
import 'package:navyla_flight_app/feature/home/widget/city_weather_card.dart';
import 'package:navyla_flight_app/feature/home/widget/flight_card_widget.dart';
import 'package:navyla_flight_app/feature/home/widget/home_header_widget.dart';
import 'package:navyla_flight_app/feature/home/widget/quick_access_tools_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CommonScreen(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            HomeHeaderWidget(
              greeting: AppString.goodMorning,
              userName: AppString.defaultUserName,
              onSettingsTap: () {},
            ),
            SizedBox(height: 16.h),
            const FlightWaveCard(),
            SizedBox(height: 16.h),
            const CityWeatherCard(),
            SizedBox(height: 16.h),

            const TitleRowClick(title: "Quick access tools"),
            SizedBox(height: 12.h),

            const QuickAccessToolsWidget(),
            SizedBox(height: 16.h),
            const TitleRowClick(title: "NAVYLA Feed", isEnable: true),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
