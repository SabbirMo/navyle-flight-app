import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/feature/explore_nearby/model/explore_nearby_state.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class ExploreHubDetailsScreen extends StatefulWidget {
  final AirportHubItem? hub;

  const ExploreHubDetailsScreen({super.key, this.hub});

  @override
  State<ExploreHubDetailsScreen> createState() =>
      _ExploreHubDetailsScreenState();
}

class _ExploreHubDetailsScreenState extends State<ExploreHubDetailsScreen> {
  String _selectedCategory = 'Food & Drinks';

  final List<Map<String, String>> _categories = const [
    {'name': 'All', 'emoji': ''},
    {'name': 'Food & Drinks', 'emoji': '☕'},
    {'name': 'Duty Free', 'emoji': '🛍️'},
    {'name': 'Restrooms', 'emoji': '🚻'},
  ];

  late final AirportHubItem _currentHub;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _currentHub =
        widget.hub ??
        const AirportHubItem(
          code: 'LHR',
          name: 'London Heathrow',
          subtitle: 'London, UK • T2, T3, T4, T5',
        );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.blackShadow : const Color(0xFFFBF8F4),
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Interactive Floor Plan / Airport Map (uses dark_map.png in dark mode)
            Positioned.fill(
              child: GestureDetector(
                onDoubleTap: () {
                  _transformationController.value = Matrix4.identity();
                },
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 0.8,
                  maxScale: 3.5,
                  boundaryMargin: isDark
                      ? const EdgeInsets.all(120)
                      : EdgeInsets.all(80.r),
                  child: isDark
                      ? SizedBox.expand(
                          child: Image.asset(
                            ImageAssets.darkMap,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 110.h,
                              bottom: 270.h,
                              left: 12.w,
                              right: 12.w,
                            ),
                            child: _buildTerminalFloorLayout(),
                          ),
                        ),
                ),
              ),
            ),

            // 2. Top Header & Category Filter Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopHeaderAndChips(context, isDark),
            ),

            // 3. Floating Bottom POI Card (Gordon Ramsay Plane Food)
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              child: _buildFloatingPoiCard(context, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeaderAndChips(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.textFieldBgColor : const Color(0xF5FBF8F4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar with Back Button & Centered Title
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.white.withValues(alpha: 0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark
                            ? AppColors.lightBlueGray.withValues(alpha: 0.3)
                            : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 14.sp,
                        color: isDark
                            ? AppColors.white
                            : const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'EXPLORE YOUR AIRPORT',
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                            color: isDark
                                ? AppColors.white
                                : const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${_currentHub.name} (${_currentHub.code.toUpperCase()})',
                          style: GoogleFonts.inter(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.primaryColor
                                : const Color(0xFF2563EB),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 38.w), // Balance back button
              ],
            ),
            SizedBox(height: 12.h),

            // Horizontal Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = cat['name'] == _selectedCategory;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat['name']!;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                    ? AppColors.primaryColor.withValues(
                                        alpha: 0.25,
                                      )
                                    : const Color(0xFF0F243A))
                              : (isDark
                                    ? AppColors.darkBlack
                                    : const Color(0xFFE9EEF4)),
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (cat['emoji']!.isNotEmpty) ...[
                              Text(
                                cat['emoji']!,
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              SizedBox(width: 6.w),
                            ],
                            Text(
                              cat['name']!,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: isSelected
                                    ? (isDark
                                          ? AppColors.primaryColor
                                          : const Color(0XFF5BB8FE))
                                    : (isDark
                                          ? AppColors.lightGray
                                          : const Color(0xFF334155)),
                              ),
                            ),
                            if (isSelected) ...[
                              SizedBox(width: 6.w),
                              Container(
                                width: 5.w,
                                height: 5.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark
                                      ? AppColors.primaryColor
                                      : const Color(0xFF38BDF8),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 6.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTerminalFloorLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column of Zones
        Expanded(
          flex: 44,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Zone 1: Terminal 5 - Block A
              _buildZoneHeader('Terminal 5 - Block A'),
              Container(
                height: 110.h,
                margin: EdgeInsets.only(bottom: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 68.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F4E9),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),

              // Zone 2: Dining Plaza (Starbucks)
              _buildZoneHeader('Dining Plaza'),
              Container(
                height: 145.h,
                margin: EdgeInsets.only(bottom: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 14.w,
                      bottom: 42.h,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFF00704A),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            'Starbucks',
                            style: GoogleFonts.inter(
                              fontSize: 9.5.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 14.w),

        // Right Column of Zones
        Expanded(
          flex: 56,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Zone 1: Duty Free Zone (Pin + Red Button + Curved Route)
              _buildZoneHeader('Duty Free Zone'),
              Container(
                height: 125.h,
                margin: EdgeInsets.only(bottom: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Curved Dashed Route Line connecting origin to amber pin
                    Positioned(
                      left: -20.w,
                      top: 40.h,
                      child: SizedBox(
                        width: 55.w,
                        height: 50.h,
                        child: CustomPaint(
                          painter: _DashedCurvedLinePainter(
                            color: const Color(0xFF0284C7),
                            strokeWidth: 2.2,
                          ),
                        ),
                      ),
                    ),

                    // Soft Glowing Origin Blue Dot
                    Positioned(
                      left: -24.w,
                      bottom: 26.h,
                      child: Container(
                        width: 22.w,
                        height: 22.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0x5938BDF8),
                        ),
                        child: Center(
                          child: Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Golden Amber Location Pin
                    Positioned(
                      left: 10.w,
                      top: 24.h,
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0x99FDE68A),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.location_on_rounded,
                            color: const Color(0xFFD97706),
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),

                    // Red Circular Plus Action Button
                    Positioned(
                      right: 18.w,
                      top: 28.h,
                      child: Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEF4444),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x59EF4444),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Zone 2: Gate B1-B24
              _buildZoneHeader('Gate B1-B24'),
              Container(
                height: 185.h,
                margin: EdgeInsets.only(bottom: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    // Status Dots on left
                    Positioned(
                      left: 8.w,
                      top: 28.h,
                      child: Column(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF97316),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFBAE6FD),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Interior Green Zone
                    Positioned(
                      left: 28.w,
                      top: 48.h,
                      child: Container(
                        width: 90.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F4E9),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),

                    // Gate B24 Orange Marker
                    Positioned(
                      bottom: 12.h,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 28.w,
                            height: 28.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF97316),
                            ),
                            child: Center(
                              child: Transform.rotate(
                                angle: 0.78, // 45 degrees
                                child: Icon(
                                  Icons.navigation_rounded,
                                  color: Colors.white,
                                  size: 15.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Gate B24',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFF97316),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildZoneHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h, left: 2.w),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF94A3B8),
        ),
      ),
    );
  }

  Widget _buildFloatingPoiCard(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.textFieldBgColor : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 24,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Badges on left, Restaurant Thumbnail on right
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge row: NAVYLA Partner & Fast Track
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF78350F).withValues(alpha: 0.3)
                                : const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.stars_rounded,
                                size: 12.sp,
                                color: isDark
                                    ? const Color(0xFFFBBF24)
                                    : const Color(0xFF78350F),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'NAVYLA Partner',
                                style: GoogleFonts.inter(
                                  fontSize: 9.5.sp,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? const Color(0xFFFBBF24)
                                      : const Color(0xFF78350F),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Fast Track',
                          style: GoogleFonts.inter(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),

                    // POI Title: Gordon Ramsay Plane Food
                    Text(
                      'Gordon Ramsay Plane\nFood',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.white
                            : const Color(0xFF0F172A),
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),

              // Restaurant Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  ImageAssets.gordonRamsay,
                  width: 54.w,
                  height: 54.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    ImageAssets.barcelonaOffer,
                    width: 54.w,
                    height: 54.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),

          // Subtitle
          Text(
            'Terminal 5 • Fine Dining & Grab-and-Go',
            style: GoogleFonts.inter(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.lightGray : const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 8.h),

          // Meta Row: Rating • Walk Time • Hours
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 15.sp,
                  color: const Color(0xFFF59E0B),
                ),
                SizedBox(width: 2.w),
                Text(
                  '4.7',
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.white : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  ' (1.2k)',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: isDark
                        ? AppColors.lightGray
                        : const Color(0xFF64748B),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Container(
                    width: 3.w,
                    height: 3.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.lightBlueGray
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                ),
                Icon(
                  Icons.directions_walk_rounded,
                  size: 14.sp,
                  color: const Color(0xFF0284C7),
                ),
                SizedBox(width: 2.w),
                Text(
                  '3 min walk(180m)',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.lightGray
                        : const Color(0xFF334155),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Container(
                    width: 3.w,
                    height: 3.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.lightBlueGray
                          : const Color(0xFFCBD5E1),
                    ),
                  ),
                ),
                Container(
                  width: 5.w,
                  height: 5.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF0284C7),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  'Open til 21:30',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Priority Perk Container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBlack : const Color(0xFFF0F6FE),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  color: isDark
                      ? const Color(0xFFFBBF24)
                      : const Color(0xFF78350F),
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Priority Perk: 15% dining credit with NAVYLA First & Business passes.',
                    style: GoogleFonts.inter(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.white : const Color(0xFF334155),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Action Button: Take Me There
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              final terminalName =
                  _currentHub.code.toUpperCase() == 'LHR'
                      ? 'Terminal 5'
                      : 'Terminal 1';
              context.push(
                AppRouterName.liveNavigationScreen,
                extra: {
                  'destinationName': 'Gordon Ramsay Plane Food',
                  'destinationInstruction':
                      'Follow $terminalName North concourse toward Gate A10',
                  'durationMinutes': '4',
                  'distanceEta': '320 m • 4 min walk',
                },
              );
            },
            child: Container(
              width: double.infinity,
              height: 42.h,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryColor
                    : const Color(0xFF2B1801),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.near_me_outlined,
                    color: isDark ? Colors.white : const Color(0xFFF59E0B),
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Take Me There',
                    style: GoogleFonts.inter(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedCurvedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  static const double _dashLength = 4.0;
  static const double _dashGap = 3.5;

  _DashedCurvedLinePainter({required this.color, this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.05, size.width, 0);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = (distance + _dashLength < metric.length)
            ? _dashLength
            : metric.length - distance;
        final extract = metric.extractPath(distance, distance + length);
        canvas.drawPath(extract, paint);
        distance += _dashLength + _dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
