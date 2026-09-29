import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/feature/navigate_airport/model/airport_route_model.dart';
import 'package:navyla_flight_app/feature/navigate_airport/provider/navigate_airport_notifier.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/route_floating_controls.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/route_map_view.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/route_search_suggestions.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/route_top_header.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/terminal_bottom_sheet.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class NavigateAirportRoute extends ConsumerStatefulWidget {
  const NavigateAirportRoute({super.key});

  @override
  ConsumerState<NavigateAirportRoute> createState() =>
      _NavigateAirportRouteState();
}

class _NavigateAirportRouteState extends ConsumerState<NavigateAirportRoute>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final TransformationController _transformationController;
  late final AnimationController _animationController;
  Animation<Matrix4>? _mapAnimation;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _transformationController = TransformationController();
    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
        )..addListener(() {
          if (_mapAnimation != null) {
            _transformationController.value = _mapAnimation!.value;
          }
        });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _animateMapTo(Matrix4 targetMatrix) {
    _mapAnimation =
        Matrix4Tween(
          begin: _transformationController.value,
          end: targetMatrix,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward(from: 0);
  }

  void _resetMapToCenter() {
    _animateMapTo(Matrix4.identity());
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Centered on Gate B24',
          style: GoogleFonts.inter(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w500,
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

  void _handleChipTap(RouteCategoryChip chip) {
    ref.read(navigateAirportNotifierProvider.notifier).selectChip(chip.id);

    switch (chip.id) {
      case 'ask_navyla':
        context.push(AppRouterName.aiChatScreen);
        break;
      case 'home':
        ref.read(navbarNotifierProvider.notifier).setIndex(0);
        context.go(AppRouterName.homeScreen);
        break;
      case 'ticket':
        ref.read(navbarNotifierProvider.notifier).setIndex(1);
        context.go(AppRouterName.navbarScreen);
        break;
      case 'feed':
        ref.read(navbarNotifierProvider.notifier).setIndex(3);
        context.go(AppRouterName.navbarScreen);
        break;
      default:
        break;
    }
  }

  void _handlePoiSelect(AirportPointOfInterest poi) {
    ref.read(navigateAirportNotifierProvider.notifier).selectPoi(poi);
    _searchController.text = poi.name;
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected: ${poi.name} (${poi.walkingMinutes} walk)',
          style: GoogleFonts.inter(
            fontSize: 12.5.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.blue2563EB,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  void _showTerminalDetailsModal(NavigateAirportState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.terminalInfo.terminalName,
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        state.terminalInfo.airportName,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      '${state.terminalInfo.temperature} • ${state.terminalInfo.aqi}',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF16A34A),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Text(
                'Key Locations in this Terminal',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 10.h),
              ...state.points.map(
                (p) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      p.icon,
                      size: 18.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  title: Text(
                    p.name,
                    style: GoogleFonts.inter(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  subtitle: Text(
                    p.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  trailing: Text(
                    p.walkingMinutes,
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue2563EB,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _handlePoiSelect(p);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(navigateAirportNotifierProvider);
    final notifier = ref.read(navigateAirportNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F9),
      body: Stack(
        children: [
          // 1. Map View (Full screen Interactive route map)
          Positioned.fill(
            child: RouteMapView(
              transformationController: _transformationController,
              onDoubleTap: _resetMapToCenter,
            ),
          ),

          // 2. Top Header Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: RouteTopHeader(
              searchController: _searchController,
              onSearchChanged: (val) {
                notifier.updateSearch(val);
              },
              onSearchClear: () {
                notifier.clearSearch();
              },
              onMicTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Voice search: Speak terminal or gate name...',
                      style: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: const Color(0xFF0F172A),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                );
              },
              onAvatarTap: () {
                context.push(AppRouterName.profileDetailsScreen);
              },
              chips: state.chips,
              selectedChipId: state.selectedChipId,
              onChipTap: _handleChipTap,
            ),
          ),

          // 3. Search Suggestions Overlay (If searching)
          if (state.isSearchExpanded)
            Positioned(
              top: MediaQuery.of(context).padding.top + 148.h,
              left: 0,
              right: 0,
              child: RouteSearchSuggestions(
                suggestions: state.filteredPoints,
                onSelect: _handlePoiSelect,
              ),
            ),

          // 4. Floating Action Controls (Right side above bottom card)
          Positioned(
            right: 18.w,
            bottom: 146.h,
            child: RouteFloatingControls(
              isNavigating: state.isNavigating,
              onLocateTap: _resetMapToCenter,
              onNavigateTap: () {
                context.push(AppRouterName.liveNavigationScreen);
              },
            ),
          ),

          // 5. Active Navigation Banner (When active)

          // 6. Bottom Sheet / Card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () => _showTerminalDetailsModal(state),
              child: TerminalBottomSheet(
                terminalInfo: state.terminalInfo,
                onBookmarkTap: () {
                  notifier.toggleBookmark();
                  final isBookmarked = !state.terminalInfo.isBookmarked;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isBookmarked
                            ? 'Saved Main Terminal 5 to bookmarks'
                            : 'Removed from bookmarks',
                        style: GoogleFonts.inter(
                          fontSize: 12.5.sp,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: const Color(0xFF0F172A),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  );
                },
                onDetailsTap: () => _showTerminalDetailsModal(state),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
