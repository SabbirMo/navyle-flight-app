import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ref
          .read(feedNotifierProvider.notifier)
          .addNewPost(
            category: categoryToUse,
            content: text,
            authorName: 'Alex Rivers (You)',
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Live update published'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top App Bar: (X) Circle button + Centered Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close_rounded,
                          size: 19.sp,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    isEditing ? 'Edit Live Update' : 'Post Live Update',
                    style: GoogleFonts.inter(
                      fontSize: 17.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(width: 38.w), // Balance spacing for center title
                ],
              ),
            ),

            // 2. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  20.w,
                  8.h,
                  20.w,
                  16.h + bottomInset,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),

                    // User Profile Row: Alex Rivers avatar + Name + POSTING TO NAVYLA FEED
                    Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              ImageAssets.alexRivers,
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
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'POSTING TO NAVYLA FEED',
                              style: GoogleFonts.inter(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: AppColors.primaryColor,
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
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      height: 155.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
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
                              'Tell other travelers about gate status, queues, or facility updates...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            height: 1.45,
                            color: const Color(0xFFCBD5E1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 22.h),

                    // SELECT CATEGORY Section
                    Text(
                      'SELECT CATEGORY',
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // 2x2 Grid of Category Tiles
                    Row(
                      children: [
                        _buildCategoryTile(
                          title: 'Gate',
                          iconWidget: (color) => Icon(
                            Icons.sensor_door_outlined,
                            size: 19.sp,
                            color: color,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        _buildCategoryTile(
                          title: 'Security',
                          iconWidget: (color) =>
                              Icon(Icons.shield, size: 18.sp, color: color),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _buildCategoryTile(
                          title: 'Lift',
                          iconWidget: (color) =>
                              Icon(Icons.elevator, size: 19.sp, color: color),
                        ),
                        SizedBox(width: 12.w),
                        _buildCategoryTile(
                          title: 'Escalator',
                          iconWidget: (color) =>
                              _StairsZigzagIcon(color: color),
                        ),
                      ],
                    ),
                    SizedBox(height: 22.h),

                    // CUSTOM CATEGORY Section
                    Text(
                      'CUSTOM CATEGORY',
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.7,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: _isCustomCategory
                              ? AppColors.primaryColor
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

    final itemColor = isSelected ? Colors.white : const Color(0xFF1E293B);

    return Expanded(
      child: GestureDetector(
        onTap: () => _selectPresetCategory(title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          height: 48.h,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget(itemColor),
              SizedBox(width: 8.w),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w600,
                  color: itemColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom Escalator Zigzag Stair Step icon matching the design exactly
class _StairsZigzagIcon extends StatelessWidget {
  final Color color;

  const _StairsZigzagIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(18.sp, 18.sp),
      painter: _StairsZigzagPainter(color: color),
    );
  }
}

class _StairsZigzagPainter extends CustomPainter {
  final Color color;

  _StairsZigzagPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter;

    final path = Path();
    path.moveTo(size.width * 0.15, size.height * 0.85);
    path.lineTo(size.width * 0.40, size.height * 0.85);
    path.lineTo(size.width * 0.40, size.height * 0.50);
    path.lineTo(size.width * 0.65, size.height * 0.50);
    path.lineTo(size.width * 0.65, size.height * 0.15);
    path.lineTo(size.width * 0.90, size.height * 0.15);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StairsZigzagPainter oldDelegate) =>
      oldDelegate.color != color;
}
