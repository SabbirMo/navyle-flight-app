import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/feature/feed/widget/feed_sponsor_card_widget.dart';
import 'package:navyla_flight_app/feature/more/model/more_model.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

/// Displayed on the Feed screen under "My post" tab when the user has not posted any updates yet.
class FeedMyPostEmptyWidget extends StatelessWidget {
  final VoidCallback onCreatePostTap;

  const FeedMyPostEmptyWidget({super.key, required this.onCreatePostTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 80.h),
      child: Column(
        children: [
          // 1. My Post Illustration Image
          Image.asset(
            ImageAssets.myPossBoarding,
            height: 160.h,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10.h),

          // 2. MY ACTIVITY Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.feedOrange.withValues(alpha: 0.2),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 14.sp,
                  color: AppColors.feedOrange,
                ),
                SizedBox(width: 6.w),
                Text(
                  'MY ACTIVITY',
                  style: GoogleFonts.inter(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.feedOrange,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.h),

          // 3. Heading
          Text(
            'No posts yet',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.blackShadow,
            ),
          ),

          SizedBox(height: 8.h),

          // 4. Subtitle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              "You haven't shared any airport or terminal updates yet. Share real-time gate changes, security wait times, or tips to help fellow travelers.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.lightBlueGray,
                height: 1.45,
              ),
            ),
          ),

          SizedBox(height: 22.h),

          // 5. Create Your First Post Button
          GestureDetector(
            onTap: onCreatePostTap,
            child: Container(
              width: double.infinity,
              height: 42.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9E45), Color(0xFFFA7E23)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFA7E23).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Create Your First Post',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 18.h),

          // 6. Sponsored Stay Connected Worldwide (eSIM) Card
          FeedSponsorCardWidget(
            image: ImageAssets.myPostSponsor,
            title: AppString.stayConnectedWorldwide,
            description: AppString.stayConnectedWorldwideDesc,
            onTap: () {
              if (moreItem.length > 3) {
                context.push(
                  AppRouterName.moreDetailsScreen,
                  extra: moreItem[3],
                );
              }
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
