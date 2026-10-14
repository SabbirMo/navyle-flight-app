import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
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
    return Consumer(
      builder: (context, ref, child) {
        final currentIndex = ref.watch(navbarNotifierProvider);
        final isMoreActive = currentIndex == 4;

        return PopScope(
          canPop: !isMoreActive,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (!isMoreActive) return;
            if (_navigatorKey.currentState?.canPop() ?? false) {
              _navigatorKey.currentState?.pop();
            } else {
              ref.read(navbarNotifierProvider.notifier).setIndex(0);
            }
          },
          child: child!,
        );
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

class MoreContentScreen extends ConsumerWidget {
  const MoreContentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isDark ? AppColors.darkBlack : null,
        centerTitle: true,
        leadingWidth: 54.w,
        leading: Center(
          child: GestureDetector(
            key: const Key('more_back_button'),
            onTap: () {
              ref.read(navbarNotifierProvider.notifier).setIndex(0);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: EdgeInsets.only(left: 16.w),
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.lightGray.withValues(alpha: 0.2)
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? AppColors.white : AppColors.blackShadow,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ),
        title: Image.asset(
          isDark ? ImageAssets.navylaWhite : ImageAssets.navyla,
          width: 100.w,
          height: 30.h,
        ),
        actions: [
          GestureDetector(
            onTap: () => context.push(AppRouterName.settingScreen),
            child: Container(
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.12)
                    : AppColors.primaryFeed.withValues(alpha: 0.12),
              ),
              child: Icon(
                Icons.settings_outlined,
                color: isDark ? AppColors.white : AppColors.lightBlueGray,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? null : AppColors.splashGradient,
        ),
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
                    isDark ? AppColors.white : AppColors.black,
                  ).copyWith(fontSize: 20.sp, fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(height: 4.h),
              Center(
                child: Text(
                  "Optional services for your trip",
                  style: StyleManager.interRegular14(
                    isDark ? AppColors.grayD3D3D3 : AppColors.grayColor,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "WHAT DO YOU NEED?",
                style: StyleManager.interSemiBold14(
                  isDark
                      ? AppColors.white.withValues(alpha: 0.6)
                      : AppColors.lightBlueGray,
                ),
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
