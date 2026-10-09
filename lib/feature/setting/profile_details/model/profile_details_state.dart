import 'dart:io';

class ProfileDetailsState {
  final bool isLoading;
  final File? imageFile;

  ProfileDetailsState({this.isLoading = false, this.imageFile});

  ProfileDetailsState copyWith({bool? isLoading, File? imageFile}) {
    return ProfileDetailsState(
      isLoading: isLoading ?? this.isLoading,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}
