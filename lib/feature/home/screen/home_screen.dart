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
import 'package:navyla_flight_app/feature/notification/provider/notification_notifier.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _activeScrollController = ScrollController();

  @override
  void dispose() {
    _activeScrollController.dispose();
    super.dispose();
  }

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
    final notifications = ref.watch(notificationNotifierProvider);
    final hasUnreadNotifications = notifications.any((n) => n.isUnread);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg = isDark ? AppColors.darkBlack : const Color(0xFFF8FAFC);

    // When boarding pass is added (Active flight state from user design)
    if (hasBoardingPass) {
      return Scaffold(
        backgroundColor: scaffoldBg,
        body: SingleChildScrollView(
          controller: _activeScrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Hero Section with darkBg / lightBg Airport Window Image
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // 1. Airport Window Background - Dynamically fills entire hero area
                  Positioned.fill(
                    child: Image.asset(
                      isDark ? ImageAssets.darkBg : ImageAssets.lightBg,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),

                  // 2. Bottom gradient overlay to blend into scaffold background seamlessly
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 220.h,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.45, 0.8, 1.0],
                          colors: [
                            scaffoldBg.withValues(alpha: 0.0),
                            scaffoldBg.withValues(alpha: 0.25),
                            scaffoldBg.withValues(alpha: 0.75),
                            scaffoldBg,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Hero content inside scrollable view (Header scrolls upward with page)
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          SizedBox(height: 6.h),
                          // 1. Top Header Bar (Alex + Logo + Notification) - scrolls up with content
                          _buildActiveHeroHeader(
                            context,
                            isDark,
                            hasUnreadNotifications,
                          ),
                          SizedBox(height: 12.h),

                          // 3. Weather / City / Local Time Strip
                          const CityWeatherCard(),
                          SizedBox(height: 16.h),

                          // 4. Flight Card
                          const FlightCardWidget(),

                          // Bottom clearance so background image and gradient extend gracefully past the card
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 6.h),

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
                    // Bottom clearance for floating CustomBottomNavBar
                    SizedBox(height: 110.h),
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Home Header inside scroll view so it scrolls upward naturally
            HomeHeaderWidget(
              userName: AppString.defaultUserName,
              hasUnread: hasBoardingPass && hasUnreadNotifications,
              onSettingsTap: () => context.push(AppRouterName.settingScreen),
              onNotificationTap: () =>
                  context.push(AppRouterName.notificationScreen),
            ),
            SizedBox(height: 12.h),
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
            SizedBox(height: 110.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveHeroHeader(
    BuildContext context,
    bool isDark,
    bool hasUnread,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.46),
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
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
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.85),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        ImageAssets.profile,
                        fit: BoxFit.cover,
                      ),
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
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      Text(
                        'Alex',
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
              ImageAssets.navylaWhite,
              height: 22.h,
              fit: BoxFit.contain,
            ),

            const Spacer(),

            // Notification Bell Icon button
            GestureDetector(
              onTap: () => context.push(AppRouterName.notificationScreen),
              child: Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SvgPicture.asset(
                        ImageAssets.notification,
                        width: 20.w,
                        height: 20.w,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      // Notification dot indicator (shown only when unread notifications remain)
                      if (hasUnread)
                        Positioned(
                          top: -1,
                          right: -1,
                          child: Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF5252),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
