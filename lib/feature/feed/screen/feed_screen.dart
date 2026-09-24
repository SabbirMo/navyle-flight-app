import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/feed/provider/feed_notifier.dart';
import 'package:navyla_flight_app/feature/feed/widget/feed_card_widget.dart';
import 'package:navyla_flight_app/feature/feed/widget/feed_category_filter_widget.dart';
import 'package:navyla_flight_app/feature/feed/widget/feed_header_widget.dart';
import 'package:navyla_flight_app/feature/feed/widget/feed_tabs_widget.dart';

import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/feature/feed/model/feed_post_model.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  void _openCreatePost(BuildContext context) {
    context.push(AppRouterName.postLiveUpdateScreen);
  }

  void _openEditPost(BuildContext context, FeedPostModel post) {
    context.push(AppRouterName.postLiveUpdateScreen, extra: post);
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Delete Post?',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
          ),
        ),
        content: Text(
          'Are you sure you want to remove this update? This action cannot be undone.',
          style: GoogleFonts.inter(
            fontSize: 13.5.sp,
            color: const Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(feedNotifierProvider.notifier).deletePost(postId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post deleted successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedNotifierProvider);
    final feedNotifier = ref.read(feedNotifierProvider.notifier);
    final filteredPosts = feedState.filteredPosts;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Top Header (Logo + Orange Add Button)
            FeedHeaderWidget(
              onAddPostTap: () => _openCreatePost(context),
            ),
            SizedBox(height: 8.h),

            // 2. Horizontal Filter Categories
            FeedCategoryFilterWidget(
              categories: feedState.categories,
              selectedCategory: feedState.selectedCategory,
              onSelectCategory: (category) {
                feedNotifier.selectCategory(category);
              },
            ),
            SizedBox(height: 12.h),

            // 3. Sub-tabs (Feed vs My post)
            FeedTabsWidget(
              selectedTab: feedState.selectedTab,
              onTabChanged: (tab) {
                feedNotifier.selectTab(tab);
              },
            ),
            SizedBox(height: 12.h),

            // 4. Feed Post List / Empty State
            Expanded(
              child: filteredPosts.isEmpty
                  ? _buildEmptyState(feedState.selectedTab)
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 100.h),
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];
                        return FeedCardWidget(
                          key: ValueKey(post.id),
                          post: post,
                          showMyPostActions:
                              feedState.selectedTab == FeedTab.myPost,
                          onToggleReal: () =>
                              feedNotifier.toggleRealVote(post.id),
                          onToggleSpam: () =>
                              feedNotifier.toggleSpamVote(post.id),
                          onEdit: () => _openEditPost(context, post),
                          onDelete: () =>
                              _confirmDelete(context, ref, post.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(FeedTab tab) {
    final isMyPost = tab == FeedTab.myPost;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  isMyPost ? Icons.post_add_rounded : Icons.filter_alt_off_rounded,
                  size: 34.sp,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              isMyPost ? 'No Posts Yet' : 'No Updates in This Category',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              isMyPost
                  ? 'Tap the + button at the top to share an update about airport conditions.'
                  : 'Try selecting "All Updates" or check back later for live community reports.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                height: 1.4,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
