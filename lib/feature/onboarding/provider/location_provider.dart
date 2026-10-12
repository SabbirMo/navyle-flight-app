import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

/// Provider to track whether live location sharing is enabled
final locationTrackingEnabledProvider =
    NotifierProvider<LocationTrackingNotifier, bool>(
      LocationTrackingNotifier.new,
    );

class LocationTrackingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void enable() => state = true;
  void disable() => state = false;
}

/// StreamNotifier for real-time live location updates
class LiveLocationNotifier extends StreamNotifier<Position?> {
  @override
  Stream<Position?> build() async* {
    final isTracking = ref.watch(locationTrackingEnabledProvider);

    if (!isTracking) {
      yield null;
      return;
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    // Fetch initial position immediately for quick feedback
    try {
      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      debugPrint('====================================================');
      debugPrint('📍 [NAVYLA Location] SUCCESS! Initial Location:');
      debugPrint('📍 Latitude  : ${initialPosition.latitude}');
      debugPrint('📍 Longitude : ${initialPosition.longitude}');
      debugPrint('====================================================');
      yield initialPosition;
    } catch (e) {
      debugPrint('⚠️ [NAVYLA Location] Error getting initial position: $e');
    }

    // Stream continuous live position updates
    yield* Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (position) {
        debugPrint('====================================================');
        debugPrint('📍 [NAVYLA Live Stream] Position Updated:');
        debugPrint('📍 Latitude  : ${position.latitude}');
        debugPrint('📍 Longitude : ${position.longitude}');
        debugPrint('====================================================');
        return position;
      },
    );
  }

  /// Request permissions and start live tracking stream
  /// If location service is disabled, prompts the user to open system settings.
  Future<bool> startTracking([BuildContext? context]) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint(
        '⚠️ [NAVYLA Location] Location services are disabled on device.',
      );
      if (context != null && context.mounted) {
        await showEnableLocationDialog(context);
      }
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint(
          '❌ [NAVYLA Location] Location permissions are denied by user.',
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint(
        '❌ [NAVYLA Location] Location permissions are permanently denied.',
      );
      if (context != null && context.mounted) {
        await showPermissionSettingsDialog(context);
      }
      return false;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      ref.read(locationTrackingEnabledProvider.notifier).enable();
      return true;
    }

    return false;
  }

  /// Stop live tracking stream
  void stopTracking() {
    ref.read(locationTrackingEnabledProvider.notifier).disable();
  }

  /// Dialog to prompt user to turn on device Location Services
  static Future<void> showEnableLocationDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off_rounded,
                color: AppColors.primaryColor,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                "Enable Location",
                style: StyleManager.sfProBold16(AppColors.black),
              ),
            ),
          ],
        ),
        content: Text(
          "Location services are disabled on your device. Please turn on location in Settings to use live navigation.",
          style: StyleManager.interMedium12(AppColors.grayColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              "Cancel",
              style: StyleManager.interMedium12(AppColors.grayColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Geolocator.openLocationSettings();
            },
            child: Text(
              "Open Settings",
              style: StyleManager.interMedium12(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Dialog to prompt user to grant permission in app settings
  static Future<void> showPermissionSettingsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.settings_suggest_rounded,
                color: AppColors.primaryColor,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                "Permission Required",
                style: StyleManager.sfProBold16(AppColors.black),
              ),
            ),
          ],
        ),
        content: Text(
          "Location permission is permanently denied. Please allow location access in App Settings to continue.",
          style: StyleManager.interMedium12(AppColors.grayColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              "Cancel",
              style: StyleManager.interMedium12(AppColors.grayColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Geolocator.openAppSettings();
            },
            child: Text(
              "Open Settings",
              style: StyleManager.interMedium12(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

final liveLocationProvider =
    StreamNotifierProvider<LiveLocationNotifier, Position?>(
      LiveLocationNotifier.new,
    );
