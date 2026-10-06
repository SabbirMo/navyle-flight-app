import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/feature/explore_nearby/model/explore_nearby_state.dart';
import 'package:navyla_flight_app/feature/explore_nearby/provider/explore_nearby_notifier.dart';
import 'package:navyla_flight_app/feature/explore_nearby/widget/explore_nearby_search_sheet.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/route_search_bar.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class ExploreNearbyScreen extends StatefulWidget {
  const ExploreNearbyScreen({super.key});

  @override
  State<ExploreNearbyScreen> createState() => _ExploreNearbyScreenState();
}

class _ExploreNearbyScreenState extends State<ExploreNearbyScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TransformationController _transformationController =
      TransformationController();
  final FocusNode _searchFocusNode = FocusNode();

  final List<String> _regions = const [
    'All Hubs',
    'Europe',
    'North America',
    'Middle East',
    'Asia',
    'Latin America',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _transformationController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _resetMap() {
    _transformationController.value = Matrix4.identity();
  }

  void _onMicTap() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Voice search listening...',
          style: GoogleFonts.inter(fontSize: 12.5.sp, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  void _onAvatarTap() {
    context.push(AppRouterName.profileDetailsScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(exploreNearbyNotifierProvider);
        final notifier = ref.read(exploreNearbyNotifierProvider.notifier);
        final isSearching = state.searchQuery.trim().isNotEmpty;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: Stack(
            children: [
              // 1. Moveable Map View (Interactive route map using route.png)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    _searchFocusNode.unfocus();
                  },
                  onDoubleTap: _resetMap,
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.6,
                    maxScale: 4.5,
                    boundaryMargin: const EdgeInsets.all(400),
                    child: SizedBox.expand(
                      child: Image.asset(
                        ImageAssets.route,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Top Header Card (Select Airport, Search bar, and Filter chips)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildHeaderCard(context, state, notifier),
              ),

              // 3. Floating Recenter Map Button (Only shown when not searching)
              if (!isSearching)
                Positioned(
                  right: 18.w,
                  bottom: 28.h,
                  child: SafeArea(
                    child: GestureDetector(
                      onTap: _resetMap,
                      child: Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.my_location_rounded,
                            color: const Color(0xFF2563EB),
                            size: 22.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // 4. Explore Nearby Search Sheet (Shows when searching / focused)
              if (isSearching)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ExploreNearbySearchSheet(
                    onExploreTap: () {
                      context.push(
                        AppRouterName.exploreHubDetailsScreen,
                        extra: state.selectedHub,
                      );
                    },
                    onClose: () {
                      _searchController.clear();
                      notifier.clearSearch();
                      _searchFocusNode.unfocus();
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    ExploreNearbyState state,
    ExploreNearbyNotifier notifier,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 18.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Bar: Back Button & SELECT AIRPORT Title
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 15.sp,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'SELECT AIRPORT',
                        style: GoogleFonts.inter(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 38.w), // Balance back button
                ],
              ),
              SizedBox(height: 14.h),

              // Search Bar
              RouteSearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                hintText: 'Search airport, city or IATA code...',
                onChanged: (query) {
                  notifier.updateSearchQuery(query);
                },
                onClear: () {
                  _searchController.clear();
                  notifier.clearSearch();
                  _searchFocusNode.unfocus();
                },
                onMicTap: _onMicTap,
                onAvatarTap: _onAvatarTap,
              ),
              SizedBox(height: 12.h),

              // Filter Chips Row
              SizedBox(
                height: 32.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _regions.length,
                  separatorBuilder: (context, index) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final region = _regions[index];
                    final isSelected = region == state.selectedRegion;
                    return GestureDetector(
                      onTap: () {
                        notifier.selectRegion(region);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF1A73E8)
                                : const Color(0xFFE2E8F0),
                            width: isSelected ? 1.4 : 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            region,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? const Color(0xFF1A73E8)
                                  : AppColors.lightBlueGray,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
