import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navyla_flight_app/feature/scan/model/scan_camera_state.dart';

class ScanCameraNotifier extends Notifier<ScanCameraState> {
  final ImagePicker _picker = ImagePicker();
  CameraController? _controller;

  @override
  ScanCameraState build() {
    ref.onDispose(() {
      _controller?.dispose();
      _controller = null;
    });

    Future.microtask(_initializeCamera);
    return const ScanCameraState();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final backCamera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        );

        final controller = CameraController(
          backCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await controller.initialize();
        _controller = controller;
        state = state.copyWith(
          cameraController: controller,
          isCameraInitialized: true,
        );
      }
    } catch (e, stack) {
      debugPrint('Camera initialization error: $e\n$stack');
      state = state.copyWith(
        isCameraInitialized: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<XFile?> captureImage() async {
    if (state.isCapturing) return null;

    // 1. If live camera is initialized, take picture from controller
    if (state.isCameraInitialized &&
        _controller != null &&
        _controller!.value.isInitialized) {
      try {
        state = state.copyWith(isCapturing: true);
        final picture = await _controller!.takePicture();
        state = state.copyWith(
          capturedImage: picture,
          isCapturing: false,
        );
        return picture;
      } catch (e) {
        debugPrint('Live capture error, trying fallback: $e');
        state = state.copyWith(isCapturing: false);
      }
    }

    // 2. Fallback to image picker camera if hardware controller not ready
    try {
      state = state.copyWith(isCapturing: true);
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      state = state.copyWith(
        capturedImage: photo,
        isCapturing: false,
      );
      return photo;
    } catch (e) {
      debugPrint('Fallback camera error: $e');
      state = state.copyWith(
        isCapturing: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<XFile?> pickGalleryImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        state = state.copyWith(capturedImage: pickedFile);
        return pickedFile;
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    }
    return null;
  }

  void retake() {
    state = state.copyWith(clearCapturedImage: true);
  }
}

final scanCameraNotifierProvider =
    NotifierProvider.autoDispose<ScanCameraNotifier, ScanCameraState>(
      ScanCameraNotifier.new,
    );
