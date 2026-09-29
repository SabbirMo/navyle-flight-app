import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/live_nav_bottom_panel.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/live_nav_floating_buttons.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/live_nav_map_canvas.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/live_nav_top_banner.dart';

class LiveNavigationScreen extends StatefulWidget {
  const LiveNavigationScreen({super.key});

  @override
  State<LiveNavigationScreen> createState() => _LiveNavigationScreenState();
}

class _LiveNavigationScreenState extends State<LiveNavigationScreen>
    with SingleTickerProviderStateMixin {
  late final TransformationController _transformationController;
  late final AnimationController _animationController;
  Animation<Matrix4>? _mapAnimation;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..addListener(() {
        if (_mapAnimation != null) {
          _transformationController.value = _mapAnimation!.value;
        }
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _resetMap() {
    _mapAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animationController.forward(from: 0);
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isMuted ? 'Voice guidance muted' : 'Voice guidance enabled',
          style: GoogleFonts.inter(
            fontSize: 12.5.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1400),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  void _showRoutesModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'Alternative Routes',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 12.h),
              _buildRouteTile(
                title: 'Via Square RD (Fastest)',
                duration: '40 min',
                distance: '2.9 km',
                isSelected: true,
                onTap: () => Navigator.of(ctx).pop(),
              ),
              _buildRouteTile(
                title: 'Via Airport Link Road',
                duration: '43 min',
                distance: '3.2 km',
                isSelected: false,
                onTap: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRouteTile({
    required String title,
    required String duration,
    required String distance,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF7ED) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : const Color(0xFFE2E8F0),
          width: isSelected ? 1.4 : 1.0,
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF0F172A),
          ),
        ),
        subtitle: Text(
          '$distance • Walking route',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFF64748B),
          ),
        ),
        trailing: Text(
          duration,
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.primaryColor : const Color(0xFF0F172A),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7ECEF),
      body: Stack(
        children: [
          // 1. Live Navigation Map Canvas (Interactive & pinch-to-zoom)
          Positioned.fill(
            child: LiveNavMapCanvas(
              transformationController: _transformationController,
            ),
          ),

          // 2. Top Direction Banner
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            left: 0,
            right: 0,
            child: LiveNavTopBanner(
              streetName: 'Square RD',
              instruction: 'Continue straight',
              onThenTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Next step: Turn right after Kaderia Tower',
                      style: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: AppColors.primaryColor,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. Right Floating Action Buttons (Compass, Search, Volume, GPS)
          Positioned(
            right: 16.w,
            bottom: 120.h,
            child: LiveNavFloatingButtons(
              isMuted: _isMuted,
              onCompassTap: _resetMap,
              onSearchTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Search along route',
                      style: GoogleFonts.inter(fontSize: 12.5.sp),
                    ),
                    backgroundColor: const Color(0xFF0F172A),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                );
              },
              onVolumeTap: _toggleMute,
              onLocateTap: _resetMap,
            ),
          ),

          // 4. Bottom Navigation Panel (Close, Duration, Alternate routes)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LiveNavBottomPanel(
              duration: '40',
              distanceEta: '2.9 km • 9:35 AM',
              onClose: () => Navigator.of(context).maybePop(),
              onRoutesTap: _showRoutesModal,
            ),
          ),
        ],
      ),
    );
  }
}
