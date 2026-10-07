import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/feature/feed/model/feed_post_model.dart';

class FeedCardWidget extends StatelessWidget {
  final FeedPostModel post;
  final VoidCallback onToggleReal;
  final VoidCallback onToggleSpam;
  final bool showMyPostActions;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const FeedCardWidget({
    super.key,
    required this.post,
    this.showMyPostActions = false,
    required this.onToggleReal,
    required this.onToggleSpam,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBlack : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? AppColors.lightBlueGray.withValues(alpha: 0.4)
              : const Color(0xFFEEF2F6),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Author row & Category tag
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
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
                child: ClipOval(
                  child: post.avatarUrl != null
                      ? Image.network(
                          post.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildFallbackAvatar(),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: const Color(0xFFF1F5F9),
                              child: Center(
                                child: SizedBox(
                                  width: 14.w,
                                  height: 14.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : _buildFallbackAvatar(),
                ),
              ),
              SizedBox(width: 12.w),

              // Name & Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: StyleManager.interSemiBold14(
                        isDark ? AppColors.white : AppColors.blackShadow,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post.timeAgo,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightGray,
                      ),
                    ),
                  ],
                ),
              ),

              // Category Badge (e.g. SECURITY, ESCALATOR, GATE, LIFT)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.grayColor.withValues(alpha: 0.4)
                      : post.tagBackgroundColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  post.category.toUpperCase(),
                  style: StyleManager.interBold10(
                    post.tagTextColor,
                  ).copyWith(fontSize: 9.sp, letterSpacing: 1.0),
                ),
              ),
            ],
          ),

          // 2. Post Content
          SizedBox(height: 14.h),
          Text(
            post.content,
            style: StyleManager.interRegular14(
              isDark ? AppColors.lightGray : AppColors.darkGrayColor,
            ),
          ),

          // 3. Status Action Buttons (IT'S REAL & SPAM)
          SizedBox(height: 16.h),
          Row(
            children: [
              // IT'S REAL Button
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onToggleReal();
                  },
                  child: Container(
                    height: 34.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.feedGreen.withValues(alpha: 0.3)
                          : AppColors.feedGreenOpacity,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_rounded,
                              size: 16.sp,
                              color: AppColors.feedGreen,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "IT'S REAL (${post.realCount})",
                              style: StyleManager.interBold10(
                                AppColors.feedGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // SPAM Button
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onToggleSpam();
                  },
                  child: Container(
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.grayColor.withValues(alpha: 0.4)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.flag_rounded,
                              size: 15.sp,
                              color: AppColors.lightGray,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "SPAM (${post.spamCount})",
                              style: StyleManager.interBold10(
                                AppColors.lightGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 4. "My Post" Specific Row: EDIT POST + DELETE Buttons (Only shown when showMyPostActions is true)
          if (showMyPostActions) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                // EDIT POST Button
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onEdit?.call();
                    },
                    child: Container(
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.blue2563EB.withValues(alpha: 0.3)
                            : AppColors.feedBlueBg,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            ImageAssets.edit,
                            width: 18.w,
                            height: 18.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'EDIT POST',
                            style: StyleManager.interBold10(
                              AppColors.blue2563EB,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                // DELETE Button
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onDelete?.call();
                  },
                  child: Container(
                    width: 46.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.errorRed.withValues(alpha: 0.3)
                          : const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Image.asset(
                        ImageAssets.delete,
                        width: 18.w,
                        height: 18.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    return Image.asset(
      ImageAssets.profile,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: const Color(0xFFE2E8F0),
        child: Center(
          child: Text(
            post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : 'U',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }
}
