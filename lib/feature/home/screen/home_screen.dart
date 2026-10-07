import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
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
                  // When no boarding pass is added yet (Initial state)
                  if (!hasBoardingPass) ...[
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
                  ] else ...[
                    // Once boarding pass is added, show Flight countdown card and Weather card
                    FlightWaveCard(
                      departureTime: journeyState.departureCountdown,
                      flightNumber: journeyState.flightNumber,
                      originCode:
                          (journeyState.originCode == 'LHR' ||
                              journeyState.originCode.isEmpty)
                          ? 'AMS'
                          : journeyState.originCode,
                      originCity: journeyState.originCity,
                      destinationCode:
                          (journeyState.destinationCode == 'JFK' ||
                              journeyState.destinationCode.isEmpty)
                          ? 'FRA'
                          : journeyState.destinationCode,
                      destinationCity: journeyState.destinationCity,
                      terminal: journeyState.terminal,
                      gate: journeyState.gate,
                      seat: journeyState.seat,
                      checkInTime: journeyState.checkInTime,
                      status: journeyState.status,
                    ),
                    SizedBox(height: 16.h),
                    CityWeatherCard(),
                    SizedBox(height: 16.h),
                  ],

                  const TitleRowClick(title: "Quick access tools"),
                  SizedBox(height: 12.h),

                  QuickAccessToolsWidget(
                    onBoardingPassTap: () {
                      if (hasBoardingPass) {
                        context.push(AppRouterName.boardingPassScreen);
                      } else {
                        context.push(AppRouterName.scanScreen);
                      }
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
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
