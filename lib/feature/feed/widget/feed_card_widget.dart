import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
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
    final hasSpam = post.isSpamVoted || post.spamCount > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFEEF2F6), width: 1.2),
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
                  border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
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
                      style: GoogleFonts.inter(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      post.timeAgo,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),

              // Category Badge (e.g. SECURITY, ESCALATOR, GATE, LIFT)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: post.tagBackgroundColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  post.category.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: post.tagTextColor,
                  ),
                ),
              ),
            ],
          ),

          // 2. Post Content
          SizedBox(height: 14.h),
          Text(
            post.content,
            style: GoogleFonts.inter(
              fontSize: 13.5.sp,
              height: 1.45,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF334155),
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
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: post.isRealVoted
                          ? const Color(0xFFD1FAE5)
                          : const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: post.isRealVoted
                            ? const Color(0xFF6EE7B7)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          size: 16.sp,
                          color: const Color(0xFF059669),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "IT'S REAL (${post.realCount})",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ],
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
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: hasSpam
                          ? const Color(0xFFFEF2F2)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: hasSpam
                            ? const Color(0xFFFCA5A5)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.flag_rounded,
                          size: 15.sp,
                          color: hasSpam
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF94A3B8),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "SPAM (${post.spamCount})",
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                            color: hasSpam
                                ? const Color(0xFFDC2626)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
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
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            size: 19.sp,
                            color: const Color(0xFF2563EB),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'EDIT POST',
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: const Color(0xFF2563EB),
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
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 20.sp,
                        color: const Color(0xFFEF4444),
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
