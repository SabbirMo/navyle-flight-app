import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/core/widgets/title_row_click.dart';
import 'package:navyla_flight_app/feature/feed/provider/feed_notifier.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/home/widget/city_weather_card.dart';
import 'package:navyla_flight_app/feature/home/widget/flight_card_widget.dart';
import 'package:navyla_flight_app/feature/home/widget/home_feed_card.dart';
import 'package:navyla_flight_app/feature/home/widget/home_header_widget.dart';
import 'package:navyla_flight_app/feature/home/widget/no_active_journey_card.dart';
import 'package:navyla_flight_app/feature/home/widget/quick_access_tools_widget.dart';
import 'package:navyla_flight_app/feature/home/widget/travel_offers_widget.dart';
import 'package:navyla_flight_app/feature/more/model/more_model.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final feedPosts = ref.watch(feedNotifierProvider).posts;
    final homePost = feedPosts.firstWhere(
      (p) => p.authorName.contains('Mark'),
      orElse: () =>
          feedPosts.isNotEmpty ? feedPosts.first : HomeFeedCard.defaultPost,
    );
    final journeyState = ref.watch(flightJourneyNotifierProvider);
    final hasBoardingPass = journeyState.hasActiveFlight;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // When boarding pass is added (Active flight state from user design)
    if (hasBoardingPass) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBlack : const Color(0xFFF8FAFC),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 1. Hero Section with darkBg / lightBg Airport Window Image
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Airport Window Background (darkBg.png for dark, lightBg.png for light)
                  SizedBox(
                    width: double.infinity,
                    height: 340.h,
                    child: Image.asset(
                      isDark ? ImageAssets.darkBg : ImageAssets.lightBg,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),

                  // Bottom gradient overlay to blend into scaffold background
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 80.h,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            (isDark
                                    ? AppColors.darkBlack
                                    : const Color(0xFFF8FAFC))
                                .withValues(alpha: 0.0),
                            (isDark
                                ? AppColors.darkBlack
                                : const Color(0xFFF8FAFC)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Hero content
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          _buildActiveHeroHeader(context, isDark),
                          SizedBox(height: 18.h),
                          // Weather / City / Local Time Strip
                          const CityWeatherCard(),
                          SizedBox(height: 36.h),
                          // Flight Card
                          FlightCardWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // 2. Bottom Section below Hero
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    const TitleRowClick(title: "Quick access tools"),
                    SizedBox(height: 12.h),

                    QuickAccessToolsWidget(
                      onBoardingPassTap: () {
                        ref.read(navbarNotifierProvider.notifier).setIndex(1);
                      },
                    ),
                    SizedBox(height: 16.h),

                    TitleRowClick(
                      title: "NAVYLA Feed",
                      subTitle: "See all",
                      isEnable: true,
                      onTap: () {
                        ref.read(navbarNotifierProvider.notifier).setIndex(3);
                      },
                    ),
                    SizedBox(height: 12.h),

                    HomeFeedCard(
                      post: homePost,
                      onTap: () {
                        ref.read(navbarNotifierProvider.notifier).setIndex(3);
                      },
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Initial state when user hasn't added a boarding pass yet
    return CommonScreen(
      child: Column(
        children: [
          HomeHeaderWidget(
            greeting: AppString.goodMorning,
            userName: AppString.defaultUserName,
            onSettingsTap: () => context.push(AppRouterName.settingScreen),
            onNotificationTap: () =>
                context.push(AppRouterName.notificationScreen),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  NoActiveJourneyCard(
                    onScanTap: () => context.push(AppRouterName.scanScreen),
                    onViewOfferTap: () => context.push(
                      AppRouterName.moreDetailsScreen,
                      extra: moreItem.first,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TravelOffersWidget(
                    onSeeAllTap: () =>
                        ref.read(navbarNotifierProvider.notifier).setIndex(4),
                    onEsimTap: () => context.push(
                      AppRouterName.moreDetailsScreen,
                      extra: moreItem.firstWhere(
                        (m) => m.id == 4,
                        orElse: () => moreItem.first,
                      ),
                    ),
                    onLoungeTap: () => context.push(
                      AppRouterName.moreDetailsScreen,
                      extra: moreItem.firstWhere(
                        (m) => m.id == 3,
                        orElse: () => moreItem.first,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  const TitleRowClick(title: "Quick access tools"),
                  SizedBox(height: 12.h),

                  QuickAccessToolsWidget(
                    onBoardingPassTap: () {
                      ref.read(navbarNotifierProvider.notifier).setIndex(1);
                    },
                  ),
                  SizedBox(height: 16.h),

                  if (hasBoardingPass) ...[
                    TitleRowClick(
                      title: "NAVYLA Feed",
                      subTitle: "See all",
                      isEnable: true,
                      onTap: () {
                        ref.read(navbarNotifierProvider.notifier).setIndex(3);
                      },
                    ),
                    SizedBox(height: 12.h),

                    HomeFeedCard(
                      post: homePost,
                      onTap: () {
                        ref.read(navbarNotifierProvider.notifier).setIndex(3);
                      },
                    ),
                    SizedBox(height: 16.h),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveHeroHeader(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          // User Avatar + "Hi, Alex"
          GestureDetector(
            onTap: () => context.push(AppRouterName.settingScreen),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.8),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(ImageAssets.profile, fit: BoxFit.cover),
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hi,',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppColors.darkGrayColor,
                      ),
                    ),
                    Text(
                      'Alex',
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.white : AppColors.black,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // NAVYLA Logo in center
          Image.asset(
            isDark ? ImageAssets.navylaWhite : ImageAssets.navyla,
            height: 24.h,
            fit: BoxFit.contain,
          ),

          const Spacer(),

          // Notification Bell Icon button
          GestureDetector(
            onTap: () => context.push(AppRouterName.notificationScreen),
            child: Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.white.withValues(alpha: 0.16)
                    : Colors.white.withValues(alpha: 0.8),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  ImageAssets.notification,
                  width: 20.w,
                  height: 20.w,
                  colorFilter: ColorFilter.mode(
                    isDark ? AppColors.white : AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
