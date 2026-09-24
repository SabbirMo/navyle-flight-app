import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/core/widgets/title_row_click.dart';
import 'package:navyla_flight_app/feature/home/widget/city_weather_card.dart';
import 'package:navyla_flight_app/feature/home/widget/flight_card_widget.dart';
import 'package:navyla_flight_app/feature/home/widget/home_header_widget.dart';
import 'package:navyla_flight_app/feature/home/widget/quick_access_tools_widget.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
            TitleRowClick(
              title: "NAVYLA Feed",
              isEnable: true,
              onTap: () {
                ref.read(navbarNotifierProvider.notifier).setIndex(3);
              },
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
