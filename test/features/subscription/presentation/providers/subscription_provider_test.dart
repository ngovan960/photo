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
  });

  group('SubscriptionNotifier', () {
    test('should use photo and increment count', () {
      final notifier = SubscriptionNotifier();

      notifier.usePhoto();

      expect(notifier.state.photosUsed, 1);
    });

    test('should not increment for pro users', () {
      final notifier = SubscriptionNotifier();
      notifier.upgradeToPro(SubscriptionTier.proMonthly);

      notifier.usePhoto();

      expect(notifier.state.photosUsed, 0);
    });

    test('should upgrade to pro', () {
      final notifier = SubscriptionNotifier();

      notifier.upgradeToPro(SubscriptionTier.proYearly);

      expect(notifier.state.tier, SubscriptionTier.proYearly);
      expect(notifier.state.isPro, true);
    });

    test('should restore subscription', () {
      final notifier = SubscriptionNotifier();

      notifier.restoreSubscription(SubscriptionTier.lifetime);

      expect(notifier.state.tier, SubscriptionTier.lifetime);
    });

    test('should reset to free', () {
      final notifier = SubscriptionNotifier();
      notifier.upgradeToPro(SubscriptionTier.proMonthly);
      notifier.usePhoto();

      notifier.reset();

      expect(notifier.state.tier, SubscriptionTier.free);
      expect(notifier.state.photosUsed, 0);
    });
  });
}
