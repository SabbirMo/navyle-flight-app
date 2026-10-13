import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/feature/feed/model/feed_post_model.dart';

/// A preview card for the NAVYLA Feed section on the Home Screen.
/// Matches the community live update card design:
/// - Author avatar (Mark Thompson)
/// - Author name & relative timestamp
/// - Category pill badge (e.g. ESCALATOR)
/// - Update description content
class HomeFeedCard extends StatelessWidget {
  final FeedPostModel? post;
  final VoidCallback? onTap;

  const HomeFeedCard({super.key, this.post, this.onTap});

  static FeedPostModel get defaultPost => FeedPostModel(
    id: 'home_preview_post',
    authorName: 'Mark Thompson',
    avatarUrl: null,
    timeAgo: '12 mins ago',
    category: 'ESCALATOR',
    content:
        'The lounge near B12 is currently closed for cleaning. Staff said it should reopen in 45 mins.',
    realCount: 8,
    spamCount: 1,
    isMyPost: false,
    createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
  );

  @override
  Widget build(BuildContext context) {
    final displayPost = post ?? defaultPost;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBluec : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isDark
                ? AppColors.lightBlueGray.withValues(alpha: 0.4)
                : const Color(0xFFEEF2F6),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightGray.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Avatar + Name/Time + Category Tag
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar (Circular)
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFF1F5F9),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(child: _buildAvatar(displayPost)),
                ),
                SizedBox(width: 12.w),

                // Author Name & Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayPost.authorName,
                        style: StyleManager.interSemiBold14(
                          isDark ? AppColors.white : AppColors.black,
                        ),
                      ),
                      Text(
                        displayPost.timeAgo,
                        style: StyleManager.interMedium12(
                          AppColors.lightGray,
                        ).copyWith(fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),

                // Pill Category Badge (e.g. ESCALATOR)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.lightBlueGray.withValues(alpha: 0.5)
                        : _getCategoryBgColor(displayPost.category),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    displayPost.category.toUpperCase(),
                    style:
                        StyleManager.interSemiBold12(
                          isDark
                              ? AppColors.white
                              : _getCategoryTextColor(displayPost.category),
                        ).copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                  ),
                ),
              ],
            ),

            // Content Text
            SizedBox(height: 8.h),
            Text(
              defaultPost.content,
              style: StyleManager.interRegular13(
                isDark ? AppColors.lightGray : AppColors.darkGrayColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(FeedPostModel post) {
    // If author is Mark Thompson or Alex Rivers, use the exact local asset
    if (post.authorName.contains('Mark') ||
        post.authorName.contains('Alex') ||
        post.avatarUrl == null ||
        post.avatarUrl!.isEmpty) {
      return Image.asset(
        ImageAssets.alexRivers,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildFallbackAvatar(post),
      );
    }

    return Image.network(
      post.avatarUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset(ImageAssets.alexRivers, fit: BoxFit.cover),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: const Color(0xFFF1F5F9),
          child: Center(
            child: SizedBox(
              width: 14.w,
              height: 14.w,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackAvatar(FeedPostModel post) {
    return Container(
      color: const Color(0xFFE2E8F0),
      child: Center(
        child: Text(
          post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : 'M',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Color _getCategoryBgColor(String category) {
    switch (category.toUpperCase()) {
      case 'ESCALATOR':
        return const Color(0xFFEBF3FE); // Soft icy blue from screenshot
      case 'SECURITY':
        return const Color(0xFFFFF1E6);
      case 'GATE':
      case 'GATES':
        return const Color(0xFFF3E8FF);
      case 'LIFT':
      case 'LIFTS':
        return const Color(0xFFE0F2FE);
      default:
        return const Color(0xFFEBF3FE);
    }
  }

  Color _getCategoryTextColor(String category) {
    switch (category.toUpperCase()) {
      case 'ESCALATOR':
        return AppColors.blue2563EB; // Vibrant blue from screenshot
      case 'SECURITY':
        return const Color(0xFFEA580C);
      case 'GATE':
      case 'GATES':
        return const Color(0xFF9333EA);
      case 'LIFT':
      case 'LIFTS':
        return const Color(0xFF0284C7);
      default:
        return const Color(0xFF2563EB);
    }
  }
}
