import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveNavFloatingButtons extends StatefulWidget {
  final VoidCallback onCompassTap;
  final VoidCallback onSearchTap;
  final VoidCallback onVolumeTap;
  final VoidCallback onLocateTap;
  final bool isMuted;

  const LiveNavFloatingButtons({
    super.key,
    required this.onCompassTap,
    required this.onSearchTap,
    required this.onVolumeTap,
    required this.onLocateTap,
    this.isMuted = false,
  });

  @override
  State<LiveNavFloatingButtons> createState() => _LiveNavFloatingButtonsState();
}

class _LiveNavFloatingButtonsState extends State<LiveNavFloatingButtons> {
  Widget _buildCircleButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Compass with red dial
        _buildCircleButton(
          onTap: widget.onCompassTap,
          child: Icon(
            Icons.explore_outlined,
            size: 24.sp,
            color: const Color(0xFFEF4444),
          ),
        ),
        SizedBox(height: 12.h),

        // 2. Search / zoom
        _buildCircleButton(
          onTap: widget.onSearchTap,
          child: Icon(
            Icons.search_rounded,
            size: 22.sp,
            color: const Color(0xFF475569),
          ),
        ),
        SizedBox(height: 12.h),

        // 3. Sound / Voice guidance
        _buildCircleButton(
          onTap: widget.onVolumeTap,
          child: Icon(
            widget.isMuted
                ? Icons.volume_off_rounded
                : Icons.volume_up_rounded,
            size: 22.sp,
            color: const Color(0xFF475569),
          ),
        ),
        SizedBox(height: 12.h),

        // 4. Target / Re-center GPS
        _buildCircleButton(
          onTap: widget.onLocateTap,
          child: Icon(
            Icons.my_location_rounded,
            size: 22.sp,
            color: const Color(0xFF475569),
          ),
        ),
      ],
    );
  }
}
