import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/profile/presentation/providers/profile_provider.dart';

void main() {
  group('ProfileState', () {
    test('should have default values', () {
      const state = ProfileState();

      expect(state.displayName, 'User');
      expect(state.email, '');
      expect(state.totalPhotos, 0);
      expect(state.totalCountries, 0);
      expect(state.subscriptionTier, 'Free');
      expect(state.isPro, false);
    });

    test('should copy with new values', () {
      const state = ProfileState();
      final newState = state.copyWith(
        displayName: 'Minh',
        totalPhotos: 5,
      );

      expect(newState.displayName, 'Minh');
      expect(newState.totalPhotos, 5);
      expect(newState.email, '');
    });
  });
}
