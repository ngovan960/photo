import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:photo_id/features/subscription/data/revenue_cat_service.dart';
import 'package:photo_id/features/subscription/data/firebase_service.dart';

enum SubscriptionTier { free, proMonthly, proYearly, lifetime }

class SubscriptionState {
  final SubscriptionTier tier;
  final int photosUsed;
  final int photosQuota;
  final bool isLoading;
  final List<Package> availablePackages;

  const SubscriptionState({
    this.tier = SubscriptionTier.free,
    this.photosUsed = 0,
    this.photosQuota = 3,
    this.isLoading = false,
    this.availablePackages = const [],
  });

  bool get isPro => tier != SubscriptionTier.free;
  bool get canCreatePhoto => isPro || photosUsed < photosQuota;
  int get remainingPhotos => isPro ? -1 : photosQuota - photosUsed;

  SubscriptionState copyWith({
    SubscriptionTier? tier,
    int? photosUsed,
    int? photosQuota,
    bool? isLoading,
    List<Package>? availablePackages,
  }) {
    return SubscriptionState(
      tier: tier ?? this.tier,
      photosUsed: photosUsed ?? this.photosUsed,
      photosQuota: photosQuota ?? this.photosQuota,
      isLoading: isLoading ?? this.isLoading,
      availablePackages: availablePackages ?? this.availablePackages,
    );
  }
}

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState());

  Future<void> init() async {
    state = state.copyWith(isLoading: true);

    try {
      final isPro = await RevenueCatService.isPro();
      if (isPro) {
        state = state.copyWith(
          tier: SubscriptionTier.proMonthly,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }

      final packages = await RevenueCatService.getAvailablePackages();
      state = state.copyWith(availablePackages: packages);

      await FirebaseService.logEvent('subscription_init', parameters: {
        'is_pro': isPro,
        'packages_count': packages.length,
      });
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void usePhoto() {
    if (state.isPro) return;
    state = state.copyWith(photosUsed: state.photosUsed + 1);

    FirebaseService.logEvent('photo_used', parameters: {
      'photos_used': state.photosUsed,
      'remaining': state.remainingPhotos,
    });
  }

  Future<bool> purchase(SubscriptionTier tier) async {
    state = state.copyWith(isLoading: true);

    try {
      Package? package;
      for (final p in state.availablePackages) {
        if (tier == SubscriptionTier.proMonthly && p.packageType == PackageType.monthly) {
          package = p;
          break;
        } else if (tier == SubscriptionTier.proYearly && p.packageType == PackageType.annual) {
          package = p;
          break;
        } else if (tier == SubscriptionTier.lifetime && p.packageType == PackageType.lifetime) {
          package = p;
          break;
        }
      }

      if (package == null) {
        state = state.copyWith(isLoading: false);
        return false;
      }

      final success = await RevenueCatService.purchasePackage(package);

      if (success) {
        state = state.copyWith(
          tier: tier,
          isLoading: false,
        );

        await FirebaseService.logEvent('subscription_purchased', parameters: {
          'tier': tier.name,
        });
      } else {
        state = state.copyWith(isLoading: false);
      }

      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<bool> restore() async {
    state = state.copyWith(isLoading: true);

    try {
      final success = await RevenueCatService.restorePurchases();

      if (success) {
        final info = await RevenueCatService.getSubscriptionInfo();
        final tier = _getTierFromInfo(info);

        state = state.copyWith(
          tier: tier,
          isLoading: false,
        );

        await FirebaseService.logEvent('subscription_restored');
      } else {
        state = state.copyWith(isLoading: false);
      }

      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  SubscriptionTier _getTierFromInfo(Map<String, dynamic>? info) {
    if (info == null) return SubscriptionTier.free;

    final productId = info['productIdentifier'] as String? ?? '';
    if (productId.contains('monthly')) return SubscriptionTier.proMonthly;
    if (productId.contains('yearly') || productId.contains('annual')) return SubscriptionTier.proYearly;
    if (productId.contains('lifetime')) return SubscriptionTier.lifetime;

    return SubscriptionTier.proMonthly;
  }

  void reset() {
    state = const SubscriptionState();
  }
}

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});
