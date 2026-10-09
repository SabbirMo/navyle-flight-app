import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navyla_flight_app/feature/setting/profile_details/model/profile_details_state.dart';

class ProfileDetailsNotifier extends Notifier<ProfileDetailsState> {
  final ImagePicker _picker = ImagePicker();

  @override
  ProfileDetailsState build() => ProfileDetailsState();

  Future<void> pickImageFromGallery() async {
    try {
      debugPrint("Opening gallery...");
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        debugPrint("Image picked: ${pickedFile.path}");
        state = state.copyWith(imageFile: File(pickedFile.path));
      }
    } catch (e, stack) {
      debugPrint("Error picking image: $e\n$stack");
    }
  }
}

final profileDetailsProvider =
    NotifierProvider.autoDispose<ProfileDetailsNotifier, ProfileDetailsState>(
      ProfileDetailsNotifier.new,
    );
