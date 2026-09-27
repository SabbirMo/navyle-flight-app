import 'dart:io';

class ProfileDetailsState {
  final bool isLoading;
  final bool isPasswordVisible;
  final File? imageFile;

  ProfileDetailsState({
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.imageFile,
  });

  ProfileDetailsState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    File? imageFile,
  }) {
    return ProfileDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}
