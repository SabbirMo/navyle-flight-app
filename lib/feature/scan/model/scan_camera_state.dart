import 'package:camera/camera.dart';

class ScanCameraState {
  final CameraController? cameraController;
  final bool isCameraInitialized;
  final bool isCapturing;
  final XFile? capturedImage;
  final String? errorMessage;

  const ScanCameraState({
    this.cameraController,
    this.isCameraInitialized = false,
    this.isCapturing = false,
    this.capturedImage,
    this.errorMessage,
  });

  ScanCameraState copyWith({
    CameraController? cameraController,
    bool? isCameraInitialized,
    bool? isCapturing,
    XFile? capturedImage,
    bool clearCapturedImage = false,
    String? errorMessage,
  }) {
    return ScanCameraState(
      cameraController: cameraController ?? this.cameraController,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      isCapturing: isCapturing ?? this.isCapturing,
      capturedImage:
          clearCapturedImage ? null : (capturedImage ?? this.capturedImage),
      errorMessage: errorMessage,
    );
  }
}
