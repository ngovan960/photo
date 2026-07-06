import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/subscription/presentation/providers/subscription_provider.dart';

void main() {
  group('SubscriptionState', () {
    test('should have default values', () {
      const state = SubscriptionState();

      expect(state.tier, SubscriptionTier.free);
      expect(state.photosUsed, 0);
      expect(state.photosQuota, 3);
      expect(state.isPro, false);
      expect(state.canCreatePhoto, true);
      expect(state.isLoading, false);
      expect(state.availablePackages, isEmpty);
    });

    test('should calculate remaining photos', () {
      const state = SubscriptionState(photosUsed: 1, photosQuota: 3);

      expect(state.remainingPhotos, 2);
    });

    test('should show unlimited for pro users', () {
      const state = SubscriptionState(tier: SubscriptionTier.proMonthly);

      expect(state.isPro, true);
      expect(state.remainingPhotos, -1);
    });

    test('should block when quota exceeded', () {
      const state = SubscriptionState(photosUsed: 3, photosQuota: 3);

      expect(state.canCreatePhoto, false);
    });

    test('should copy with new values', () {
      const state = SubscriptionState();
      final newState = state.copyWith(
        tier: SubscriptionTier.proYearly,
        photosUsed: 5,
      );

      expect(newState.tier, SubscriptionTier.proYearly);
      expect(newState.photosUsed, 5);
      expect(newState.photosQuota, 3);
    });
  });

  group('SubscriptionTier', () {
    test('should have all tiers', () {
      expect(SubscriptionTier.values.length, 4);
      expect(SubscriptionTier.free.name, 'free');
      expect(SubscriptionTier.proMonthly.name, 'proMonthly');
      expect(SubscriptionTier.proYearly.name, 'proYearly');
      expect(SubscriptionTier.lifetime.name, 'lifetime');
    });
  });
}
