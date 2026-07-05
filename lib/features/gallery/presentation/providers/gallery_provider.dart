import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class GalleryState {
  final XFile? selectedImage;
  final Uint8List? imageBytes;
  final bool isLoading;
  final String? error;

  const GalleryState({
    this.selectedImage,
    this.imageBytes,
    this.isLoading = false,
    this.error,
  });

  GalleryState copyWith({
    XFile? selectedImage,
    Uint8List? imageBytes,
    bool? isLoading,
    String? error,
    bool clearImage = false,
    bool clearError = false,
  }) {
    return GalleryState(
      selectedImage: clearImage ? null : (selectedImage ?? this.selectedImage),
      imageBytes: clearImage ? null : (imageBytes ?? this.imageBytes),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class GalleryNotifier extends StateNotifier<GalleryState> {
  final ImagePicker _picker;

  GalleryNotifier({ImagePicker? picker})
      : _picker = picker ?? ImagePicker(),
        super(const GalleryState());

  Future<void> pickImage() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 4096,
        maxHeight: 4096,
        imageQuality: 100,
      );

      if (image == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final bytes = await image.readAsBytes();

      state = state.copyWith(
        selectedImage: image,
        imageBytes: bytes,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> takePhoto() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 4096,
        maxHeight: 4096,
        imageQuality: 100,
      );

      if (image == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final bytes = await image.readAsBytes();

      state = state.copyWith(
        selectedImage: image,
        imageBytes: bytes,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearSelection() {
    state = state.copyWith(clearImage: true, clearError: true);
  }
}

final galleryProvider = StateNotifierProvider<GalleryNotifier, GalleryState>((ref) {
  return GalleryNotifier();
});
