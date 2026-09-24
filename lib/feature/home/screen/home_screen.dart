import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/feature/home/widget/flight_card_widget.dart';
import 'package:navyla_flight_app/feature/home/widget/home_header_widget.dart';

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
            SizedBox(height: 90.h),
          ],
        ),
      ),
    );
  }
}
