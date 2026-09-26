import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

/// Ultra-optimized, high-performance Custom Bottom Navigation Bar
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNavBar({super.key, this.currentIndex = 0, this.onTap});

  // Cached layout constants
  static const double _barHeight = 64.0;
  static const double _extraTopRoom = 0.0;
  static const double _centerBtnSize = 54.0;
  static const Color _darkBg = Color(0xFF1E293B);
  static const Color _lightBg = AppColors.white;
  static const Color _inactiveColor = Color(0xFF8E9BAE);

  // Cached shadow lists to prevent GC allocations
  static const List<BoxShadow> _barShadow = [
    BoxShadow(
      color: Color(0x0D000000), // Colors.black with alpha 0.05
      blurRadius: 10,
      offset: Offset(0, -3),
    ),
  ];

  static const List<BoxShadow> _centerBtnShadow = [
    BoxShadow(
      color: Color(0x61FA8A35), // Primary color with alpha 0.38
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  // Cached text styles
  static const TextStyle _selectedStyle = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.primaryColor,
  );

  static const TextStyle _unselectedStyle = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: _inactiveColor,
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Selective viewPadding subscription avoids rebuilds when keyboard/textScale changes
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;
    final navBgColor = isDark ? _darkBg : _lightBg;

    // RepaintBoundary isolates paint layer so parent scrolling doesn't repaint navbar
    return RepaintBoundary(
      child: SizedBox(
        height: _barHeight + bottomPadding + _extraTopRoom,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // 1. Flat Bottom Bar Container
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: _barHeight + bottomPadding,
              child: Container(
                decoration: BoxDecoration(
                  color: navBgColor,
                  boxShadow: _barShadow,
                ),
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: Row(
                  children: [
                    // HOME
                    _NavBarItem(
                      index: 0,
                      icon: Icons.home_rounded,
                      label: AppString.navHome,
                      isSelected: currentIndex == 0,
                      onTap: onTap,
                    ),

                    // TICKET
                    _NavBarItem(
                      index: 1,
                      icon: Icons.confirmation_number_rounded,
                      label: AppString.navTicket,
                      isSelected: currentIndex == 1,
                      onTap: onTap,
                    ),

                    // SCAN (Center placeholder slot + label)
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onTap?.call(2);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              AppString.navScan,
                              style: currentIndex == 2
                                  ? _selectedStyle
                                  : _unselectedStyle,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // FEED
                    _NavBarItem(
                      index: 3,
                      icon: Icons.groups_rounded,
                      label: AppString.navFeed,
                      isSelected: currentIndex == 3,
                      onTap: onTap,
                    ),

                    // MORE
                    _NavBarItem(
                      index: 4,
                      icon: Icons.grid_view_rounded,
                      label: AppString.navMore,
                      isSelected: currentIndex == 4,
                      onTap: onTap,
                    ),
                  ],
                ),
              ),
            ),

            // 2. Elevated Floating Center Scan Button
            Positioned(
              bottom: bottomPadding + 24.0,
              child: _CenterScanButton(
                borderColor: navBgColor,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onTap?.call(2);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dedicated sub-widget for tab items to minimize rebuild tree depth
class _NavBarItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final bool isSelected;
  final ValueChanged<int>? onTap;

  const _NavBarItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = isSelected
        ? AppColors.primaryColor
        : CustomBottomNavBar._inactiveColor;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap?.call(index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 23.0, color: itemColor),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: isSelected
                  ? CustomBottomNavBar._selectedStyle
                  : CustomBottomNavBar._unselectedStyle,
            ),
          ],
        ),
      ),
    );
  }
}

/// Dedicated sub-widget for center scan button
class _CenterScanButton extends StatelessWidget {
  final Color borderColor;
  final VoidCallback onTap;

  const _CenterScanButton({required this.borderColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: CustomBottomNavBar._centerBtnSize,
        height: CustomBottomNavBar._centerBtnSize,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 2),
          boxShadow: CustomBottomNavBar._centerBtnShadow,
        ),
        child: const Center(
          child: Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 24.0,
          ),
        ),
      ),
    );
  }
}
