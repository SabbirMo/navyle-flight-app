import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/feature/setting/smart_watch/model/smart_watch_state.dart';
import 'package:navyla_flight_app/feature/setting/smart_watch/widget/smart_watch_device_view.dart';
import 'package:navyla_flight_app/feature/setting/smart_watch/widget/smart_watch_feature_card.dart';
import 'package:navyla_flight_app/feature/setting/smart_watch/widget/smart_watch_icon_box.dart';
import 'package:navyla_flight_app/feature/setting/smart_watch/widget/smart_watch_radar_painter.dart';
import 'package:url_launcher/url_launcher.dart';

class SmartWatchScreen extends StatefulWidget {
  final bool? isIOSOverride;
  final SmartWatchType? initialWatchType;
  final SmartWatchSyncState? initialState;

  const SmartWatchScreen({
    super.key,
    this.isIOSOverride,
    this.initialWatchType,
    this.initialState,
  });

  @override
  State<SmartWatchScreen> createState() => _SmartWatchScreenState();
}

class _SmartWatchScreenState extends State<SmartWatchScreen>
    with SingleTickerProviderStateMixin {
  late SmartWatchType _watchType;
  late SmartWatchSyncState _syncState;
  late AnimationController _badgeFloatController;
  late Animation<double> _badgeFadeAnimation;
  late Animation<Offset> _badgeSlideAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // 1. Open appropriate approved platform directly (Apple Watch on iOS, Wear OS on Android)
    final isIOS =
        widget.isIOSOverride ?? (defaultTargetPlatform == TargetPlatform.iOS);
    _watchType =
        widget.initialWatchType ??
        (isIOS ? SmartWatchType.appleWatch : SmartWatchType.wearOs);

    // 2. Open directly in the approved device state (simulated ready & connected)
    _syncState = widget.initialState ?? SmartWatchSyncState.ready;

    // 3. Floating entrance animation for the device badge over the radar
    _badgeFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _badgeFadeAnimation = CurvedAnimation(
      parent: _badgeFloatController,
      curve: Curves.easeIn,
    );

    _badgeSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _badgeFloatController,
            curve: Curves.easeOutBack,
          ),
        );

    // While radar spins, badge smoothly floats in over the animation
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _badgeFloatController.forward();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      if (widget.initialWatchType == null && widget.isIOSOverride == null) {
        final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
        _watchType = isIOS ? SmartWatchType.appleWatch : SmartWatchType.wearOs;
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _badgeFloatController.dispose();
    super.dispose();
  }

  void _togglePlatform() {
    setState(() {
      _watchType = _isAppleWatch
          ? SmartWatchType.wearOs
          : SmartWatchType.appleWatch;
    });
    _badgeFloatController.reset();
    _badgeFloatController.forward();
  }

  bool get _isAppleWatch => _watchType == SmartWatchType.appleWatch;

  Future<void> _openWatchApp() async {
    final url = _isAppleWatch
        ? "itms-watch://"
        : "https://play.google.com/store/apps/details?id=com.google.android.wearable.app";
    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint("Could not open watch companion app: $e");
    }
  }

  void _onActionButtonPressed() {
    switch (_syncState) {
      case SmartWatchSyncState.notPaired:
      case SmartWatchSyncState.appNotInstalled:
        _openWatchApp();
        break;
      case SmartWatchSyncState.ready:
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonScreen(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(context: context),
            SizedBox(height: 4.h),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Center Graphic (Radar with floating badge on top and center device/icon)
                    _buildCenterGraphic(),
                    SizedBox(height: 8.h),

                    // Title & Description
                    _buildHeadings(context: context),
                    SizedBox(height: 18.h),

                    // Feature Status Section
                    _buildFeatureStatusSection(),
                    SizedBox(height: 24.h),

                    // Bottom Action Button (Scrolls naturally with content)
                    _buildActionButton(),
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

  // 1. App Bar with Back Button, Centered Title, and Help Icon
  Widget _buildAppBar({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.1)
                  : AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14.sp,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ),
        ),

        // Centered Title
        Text(
          "Smartwatch",
          style: StyleManager.sfProBold16(
            isDark ? AppColors.white : AppColors.black,
          ).copyWith(fontSize: 17.sp, fontWeight: FontWeight.w700),
        ),

        // Help Button
        GestureDetector(
          onTap: () => _showHelpDialog(),
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFF942B).withValues(alpha: 0.7),
                width: 1.2,
              ),
            ),
            child: Center(
              child: Text(
                "?",
                style: GoogleFonts.inter(
                  color: const Color(0xFFFF942B),
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 2. Floating Device Badge ("Android • Wear OS" / "iPhone • Apple Watch")
  Widget _buildFloatingDeviceBadge({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String badgeText = _isAppleWatch
        ? "iPhone • Apple Watch"
        : "Android • Wear OS";
    final Widget badgeIconWidget = _isAppleWatch
        ? Icon(
            Icons.phone_iphone_rounded,
            size: 13.5.sp,
            color: isDark ? Colors.white : const Color(0xFF2563EB),
          )
        : SvgPicture.asset(ImageAssets.android, width: 12.5.w, height: 14.5.h);

    return FadeTransition(
      opacity: _badgeFadeAnimation,
      child: SlideTransition(
        position: _badgeSlideAnimation,
        child: GestureDetector(
          onTap: _togglePlatform,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.12)
                  : const Color(0xFFEAF0FE),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                badgeIconWidget,
                SizedBox(width: 5.w),
                Text(
                  badgeText,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Active & Connected badge for State 3 (Ready)
  Widget _buildActiveConnectedBadge({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.white.withValues(alpha: 0.32)
            : const Color(0xFFDCFCE7).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.transparent : const Color(0xFFBBF7D0),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.w,
            height: 5.w,
            decoration: BoxDecoration(
              color: isDark ? Color(0xff00FF89) : const Color(0xFF16A34A),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            "Active & Connected",
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Color(0xff00FF89) : const Color(0xFF16A34A),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom detected chip for State 2 (App Not Installed)
  Widget _buildBottomDetectedChip({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String detectedText = _isAppleWatch
        ? "Apple Watch detected"
        : "Wear OS watch detected";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.5.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.white.withValues(alpha: 0.12)
            : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? Colors.transparent : const Color(0xFFBFDBFE),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.watch_rounded,
            size: 13.sp,
            color: const Color(0xFF2563EB),
          ),
          SizedBox(width: 5.w),
          Text(
            detectedText,
            style: GoogleFonts.inter(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Center Graphic (Radar + Floating Top Device Badge + Center Device/Icon + Bottom Detected Chip)
  Widget _buildCenterGraphic() {
    Widget innerContent;

    if (_syncState == SmartWatchSyncState.ready) {
      innerContent = _isAppleWatch
          ? const AppleWatchDeviceView()
          : const WearOsWatchDeviceView();
    } else {
      innerContent = const SmartWatchIconBox();
    }

    return SizedBox(
      width: 280.w,
      height: 220.h,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 1. Radar background with concentric circles & rotating dots
          SmartWatchRadarBackground(isAnimating: true, child: innerContent),

          // 2. Floating Top Device Badge ("Android • Wear OS" / "iPhone • Apple Watch")
          // Positioned at the exact red marked location (across the middle ring above the center squircle)
          Positioned(
            top: _syncState == SmartWatchSyncState.ready ? 6.h : 30.h,
            child: _syncState == SmartWatchSyncState.ready
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFloatingDeviceBadge(context: context),
                      SizedBox(height: 5.h),
                      _buildActiveConnectedBadge(context: context),
                    ],
                  )
                : _buildFloatingDeviceBadge(context: context),
          ),

          // 3. Screen 2 Bottom Detected Chip (sitting on the bottom curve of the radar)
          if (_syncState == SmartWatchSyncState.appNotInstalled)
            Positioned(
              bottom: 6.h,
              child: _buildBottomDetectedChip(context: context),
            ),
        ],
      ),
    );
  }

  // 4. Headings & Subtitles based on Watch Type & State
  Widget _buildHeadings({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String title;
    String subtitle;
    String? extraNote;

    switch (_syncState) {
      case SmartWatchSyncState.notPaired:
        if (_isAppleWatch) {
          title = "No Apple Watch Paired";
          subtitle =
              "Pair your Apple Watch in the Apple Watch app on your iPhone to sync boarding passes and flight alerts.";
        } else {
          title = "No compatible smartwatch connected";
          subtitle =
              "Connect a Wear OS smartwatch in the Wear OS app on your phone to sync boarding passes and flight alerts with NAVYLA.";
        }
        break;

      case SmartWatchSyncState.appNotInstalled:
        title = "NAVYLA isn't installed";
        if (_isAppleWatch) {
          subtitle =
              "Install NAVYLA on your Apple Watch to receive boarding pass updates and flight alerts.";
        } else {
          subtitle =
              "Install NAVYLA on your smartwatch to receive boarding pass updates and flight alerts.";
          extraNote =
              "Works with Wear OS devices like Samsung Galaxy Watch and Google Pixel Watch.";
        }
        break;

      case SmartWatchSyncState.ready:
        if (_isAppleWatch) {
          title = "Apple Watch Ready";
          subtitle =
              "NAVYLA is installed and ready to sync on your Apple Watch.";
        } else {
          title = "Smartwatch Ready";
          subtitle =
              "NAVYLA is installed and ready on your Wear OS smartwatch.";
        }
        break;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7.h),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.grayD3D3D3.withValues(alpha: 0.9)
                  : const Color(0xFF64748B),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          if (extraNote != null) ...[
            SizedBox(height: 6.h),
            Text(
              extraNote,
              style: GoogleFonts.inter(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF94A3B8),
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  // 5. FEATURE STATUS Section
  Widget _buildFeatureStatusSection() {
    FeatureStatusType boardingPassStatusType;
    String boardingPassStatusText;
    String boardingPassDescription;

    FeatureStatusType flightAlertsStatusType;
    String flightAlertsStatusText;
    String flightAlertsDescription;

    switch (_syncState) {
      case SmartWatchSyncState.notPaired:
        boardingPassStatusType = FeatureStatusType.unavailable;
        boardingPassStatusText = "Unavailable until paired";
        boardingPassDescription = _isAppleWatch
            ? "Your boarding pass can appear on your watch once an Apple Watch is paired and NAVYLA is installed."
            : "Your boarding pass can appear on your watch once a compatible Wear OS device is connected and NAVYLA is installed.";

        flightAlertsStatusType = FeatureStatusType.unavailable;
        flightAlertsStatusText = "Unavailable until paired";
        flightAlertsDescription = _isAppleWatch
            ? "Gate changes and boarding alerts will be available on your watch after pairing."
            : "Gate changes and boarding alerts will be available on your smartwatch after connection.";
        break;

      case SmartWatchSyncState.appNotInstalled:
        boardingPassStatusType = FeatureStatusType.waiting;
        boardingPassStatusText = "Waiting for Watch app";
        boardingPassDescription = _isAppleWatch
            ? "Install NAVYLA on your watch to display your active flight pass and QR code directly on your wrist."
            : "Install NAVYLA on your watch to display your active flight pass directly on your wrist.";

        flightAlertsStatusType = FeatureStatusType.waiting;
        flightAlertsStatusText = "Waiting for Watch app";
        flightAlertsDescription = _isAppleWatch
            ? "Gate changes, boarding countdowns and departure chimes require the NAVYLA watch companion app."
            : "Live gate changes and boarding updates require the NAVYLA smartwatch app.";
        break;

      case SmartWatchSyncState.ready:
        boardingPassStatusType = FeatureStatusType.available;
        boardingPassStatusText = _isAppleWatch
            ? "Available on Apple Watch"
            : "Available on Watch";
        boardingPassDescription = _isAppleWatch
            ? "Your boarding pass is ready to view on your Apple Watch."
            : "Your boarding pass is ready to view on your Wear OS watch.";

        flightAlertsStatusType = FeatureStatusType.available;
        flightAlertsStatusText = "Enabled";
        flightAlertsDescription = _isAppleWatch
            ? "Gate changes, boarding updates and important flight alerts will appear on your Apple Watch."
            : "Gate changes, boarding updates and important flight alerts will appear on your Wear OS smartwatch.";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
          child: Text(
            "FEATURE STATUS",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: const Color(0xFF64748B),
            ),
          ),
        ),

        // Boarding Pass Card
        SmartWatchFeatureCard(
          icon: Icons.confirmation_number_outlined,
          title: "Boarding Pass",
          statusText: boardingPassStatusText,
          statusType: boardingPassStatusType,
          description: boardingPassDescription,
        ),
        SizedBox(height: 12.h),

        // Flight Alerts Card
        SmartWatchFeatureCard(
          icon: Icons.notifications_none_rounded,
          title: "Flight Alerts",
          statusText: flightAlertsStatusText,
          statusType: flightAlertsStatusType,
          description: flightAlertsDescription,
        ),
      ],
    );
  }

  // 6. Action Button
  Widget _buildActionButton() {
    String buttonText;
    IconData buttonIcon;

    switch (_syncState) {
      case SmartWatchSyncState.notPaired:
        buttonText = _isAppleWatch
            ? "Open Apple Watch App"
            : "Open Wear OS App";
        buttonIcon = Icons.open_in_new_rounded;
        break;
      case SmartWatchSyncState.appNotInstalled:
        buttonText = "Install NAVYLA";
        buttonIcon = Icons.download_rounded;
        break;
      case SmartWatchSyncState.ready:
        buttonText = "Done";
        buttonIcon = Icons.check_circle_outline_rounded;
        break;
    }

    return CustomButton(
      text: buttonText,
      prefixIcon: buttonIcon,
      onTap: _onActionButtonPressed,
      height: 44.h,
      borderRadius: 28.r,
    );
  }

  // Help Dialog
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            "Smartwatch Sync",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isAppleWatch
                    ? "Sync flight boarding passes and live alerts directly with your Apple Watch."
                    : "Sync flight boarding passes and live alerts directly with your Wear OS smartwatch.",
                style: GoogleFonts.inter(fontSize: 13.sp),
              ),
              SizedBox(height: 12.h),
              Text(
                "Tip: Tap the top badge anytime to toggle between iPhone and Wear OS views.",
                style: GoogleFonts.inter(
                  fontSize: 11.5.sp,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Got it"),
            ),
          ],
        );
      },
    );
  }
}
