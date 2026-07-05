import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/gallery/presentation/providers/gallery_provider.dart';

void main() {
  group('GalleryState', () {
    test('should have default values', () {
      const state = GalleryState();

      expect(state.selectedImage, isNull);
      expect(state.imageBytes, isNull);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('should copy with new values', () {
      const state = GalleryState();
      final newState = state.copyWith(isLoading: true);

      expect(newState.isLoading, true);
      expect(newState.selectedImage, isNull);
    });

    test('should clear image', () {
      const state = GalleryState(
        selectedImage: null,
        imageBytes: null,
      );
      final newState = state.copyWith(clearImage: true);

      expect(newState.selectedImage, isNull);
      expect(newState.imageBytes, isNull);
    });

    test('should clear error', () {
      const state = GalleryState(error: 'Test error');
      final newState = state.copyWith(clearError: true);

      expect(newState.error, isNull);
    });
  });
}
