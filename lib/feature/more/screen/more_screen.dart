import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/feature/more/model/more_model.dart';
import 'package:navyla_flight_app/feature/more/screen/more_details_screen.dart';
import 'package:navyla_flight_app/feature/more/screen/partner_website_screen.dart';
import 'package:navyla_flight_app/feature/more/widget/travel_extras_widget.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_navigatorKey.currentState?.canPop() ?? false) {
          _navigatorKey.currentState?.pop();
        }
      },
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          if (settings.name == AppRouterName.moreDetailsScreen) {
            final data = settings.arguments as MoreModel;
            return CupertinoPageRoute(
              builder: (_) => MoreDetailsScreen(data: data),
            );
          }
          if (settings.name == AppRouterName.partnerWebsiteScreen) {
            final data = settings.arguments as MoreModel?;
            return CupertinoPageRoute(
              builder: (_) => PartnerWebsiteScreen(data: data),
            );
          }
          return CupertinoPageRoute(builder: (_) => const MoreContentScreen());
        },
      ),
    );
  }
}

class MoreContentScreen extends StatelessWidget {
  const MoreContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Image.asset(ImageAssets.navyla, width: 100.w, height: 30.h),
        actions: [
          GestureDetector(
            onTap: () => context.push(AppRouterName.settingScreen),
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFeed.withValues(alpha: 0.12),
              ),
              child: Icon(
                Icons.settings_outlined,
                color: AppColors.lightBlueGray,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  "Travel Extras",
                  style: StyleManager.interSemiBold14(
                    AppColors.black,
                  ).copyWith(fontSize: 20.sp, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(height: 4.h),
              Center(
                child: Text(
                  "Optional services for your trip",
                  style: StyleManager.interRegular14(AppColors.grayColor),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "WHAT DO YOU NEED?",
                style: StyleManager.interSemiBold14(AppColors.lightBlueGray),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 4.h, bottom: 90.h),
                  itemCount: moreItem.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) => TravelExtraWidget(
                    data: moreItem[index],
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) =>
                              MoreDetailsScreen(data: moreItem[index]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
