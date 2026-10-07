import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/feed/model/feed_post_model.dart';
import 'package:navyla_flight_app/feature/feed/provider/feed_notifier.dart';

class PostLiveUpdateScreen extends ConsumerStatefulWidget {
  final FeedPostModel? postToEdit;

  const PostLiveUpdateScreen({super.key, this.postToEdit});

  @override
  ConsumerState<PostLiveUpdateScreen> createState() =>
      _PostLiveUpdateScreenState();
}

class _PostLiveUpdateScreenState extends ConsumerState<PostLiveUpdateScreen> {
  late final TextEditingController _contentController;
  late final TextEditingController _customCategoryController;

  String _selectedCategory = 'Gate';
  bool _isCustomCategory = false;

  final List<String> _presetCategoryTitles = [
    'Gate',
    'Security',
    'Lift',
    'Escalator',
  ];

  bool get isEditing => widget.postToEdit != null;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.postToEdit?.content ?? '',
    );

    final initialCategory = widget.postToEdit?.category;
    if (initialCategory != null && initialCategory.isNotEmpty) {
      final matchingPreset = _presetCategoryTitles.firstWhere(
        (c) => c.toUpperCase() == initialCategory.toUpperCase(),
        orElse: () => '',
      );

      if (matchingPreset.isNotEmpty) {
        _selectedCategory = matchingPreset;
        _isCustomCategory = false;
        _customCategoryController = TextEditingController();
      } else {
        _selectedCategory = initialCategory;
        _isCustomCategory = true;
        _customCategoryController = TextEditingController(
          text: initialCategory,
        );
      }
    } else {
      _selectedCategory = 'Gate';
      _isCustomCategory = false;
      _customCategoryController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  void _selectPresetCategory(String title) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedCategory = title;
      _isCustomCategory = false;
      _customCategoryController.clear();
    });
  }

  void _submit() {
    final text = _contentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe what is happening'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final categoryToUse =
        _isCustomCategory && _customCategoryController.text.trim().isNotEmpty
        ? _customCategoryController.text.trim()
        : _selectedCategory;

    if (isEditing) {
      ref
          .read(feedNotifierProvider.notifier)
          .editPost(
            postId: widget.postToEdit!.id,
            category: categoryToUse,
            content: text,
          );
    } else {
      ref
          .read(feedNotifierProvider.notifier)
          .addNewPost(
            category: categoryToUse,
            content: text,
            authorName: 'Alex Rivers (You)',
          );
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CommonScreen(
      child: Column(
        children: [
          // 1. Top App Bar: (X) Circle button + Centered Title
          CustomBackButton(
            icon: Icons.close,
            title: isEditing ? "Edit Live Update" : "Post Live Update",
          ),

          SizedBox(height: 6.h),

          // 2. Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 8.h, bottom: 16.h + bottomInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),

                  // User Profile Row: Alex Rivers avatar + Name + POSTING TO NAVYLA FEED
                  Row(
                    children: [
                      SizedBox(
                        width: 44.w,
                        height: 44.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.asset(
                            ImageAssets.profile,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                                  ImageAssets.profile,
                                  fit: BoxFit.cover,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Rivers',
                            style: StyleManager.interBold16(
                              isDark ? AppColors.white : AppColors.blackShadow,
                            ),
                          ),

                          Text(
                            'POSTING TO NAVYLA FEED',
                            style: StyleManager.interBold10(
                              AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // WHAT'S HAPPENING? Section
                  Text(
                    "WHAT'S HAPPENING?",
                    style: StyleManager.sfProBold16(
                      AppColors.lightGray,
                    ).copyWith(letterSpacing: 0.9, fontSize: 12.sp),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 130.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBlack : Colors.white,
                      borderRadius: BorderRadius.circular(22.r),
                      border: Border.all(
                        color: isDark
                            ? AppColors.lightBlueGray.withValues(alpha: 0.4)
                            : const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        height: 1.45,
                        color: isDark
                            ? AppColors.white
                            : const Color(0xFF1E293B),
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: false,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText:
                            'Tell other travelers about gate status, queues, or facility updates...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          height: 1.45,
                          color: AppColors.lightGray,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 22.h),

                  // SELECT CATEGORY Section
                  Text(
                    'SELECT CATEGORY',
                    style: StyleManager.interMedium12(
                      AppColors.lightGray,
                    ).copyWith(letterSpacing: 0.9, fontSize: 12.sp),
                  ),
                  SizedBox(height: 10.h),

                  // 2x2 Grid of Category Tiles
                  Row(
                    children: [
                      _buildCategoryTile(
                        title: 'Gate',
                        iconWidget: (color) => SvgPicture.asset(
                          ImageAssets.gate,
                          width: 16.w,
                          height: 16.w,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      _buildCategoryTile(
                        title: 'Security',
                        iconWidget: (color) => SvgPicture.asset(
                          ImageAssets.security,
                          width: 18.w,
                          height: 18.w,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      _buildCategoryTile(
                        title: 'Lift',
                        iconWidget: (color) => SvgPicture.asset(
                          ImageAssets.lift,
                          width: 18.w,
                          height: 18.w,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      _buildCategoryTile(
                        title: 'Escalator',
                        iconWidget: (color) => SvgPicture.asset(
                          ImageAssets.escalator,
                          width: 16.w,
                          height: 16.w,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),

                  // CUSTOM CATEGORY Section
                  Text(
                    'CUSTOM CATEGORY',
                    style: StyleManager.sfProBold16(
                      AppColors.lightGray,
                    ).copyWith(fontSize: 12.sp, letterSpacing: 0.9),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBlack : Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: _isCustomCategory
                            ? AppColors.primaryColor
                            : isDark
                            ? AppColors.lightBlueGray.withValues(alpha: 0.4)
                            : const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Center(
                      child: TextField(
                        controller: _customCategoryController,
                        onChanged: (value) {
                          setState(() {
                            _isCustomCategory = value.trim().isNotEmpty;
                            if (_isCustomCategory) {
                              _selectedCategory = value.trim();
                            }
                          });
                        },
                        style: GoogleFonts.inter(
                          fontSize: 13.5.sp,
                          color: const Color(0xFF1E293B),
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          filled: false,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintText:
                              'Write the category name you want to post about',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 12.5.sp,
                            color: const Color(0xFFCBD5E1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),

                  CustomButton(
                    text: isEditing ? "Update Post" : "Post Update",
                    isEnabled: true,
                    onTap: () => _submit(),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile({
    required String title,
    required Widget Function(Color color) iconWidget,
  }) {
    final isSelected =
        !_isCustomCategory &&
        _selectedCategory.toUpperCase() == title.toUpperCase();

    final itemColor = isSelected
        ? Colors.white
        : (Theme.of(context).brightness == Brightness.dark
              ? AppColors.white
              : const Color(0xFF1E293B));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectPresetCategory(title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryColor
                : (isDark ? AppColors.darkBlack : Colors.white),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.grayColor.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              iconWidget(itemColor),
              SizedBox(width: 8.w),
              Text(
                title,
                style: StyleManager.interMedium12(
                  itemColor,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
