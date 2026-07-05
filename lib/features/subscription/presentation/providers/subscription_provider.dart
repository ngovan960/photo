import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SubscriptionTier { free, proMonthly, proYearly, lifetime }

class SubscriptionState {
  final SubscriptionTier tier;
  final int photosUsed;
  final int photosQuota;
  final bool isLoading;

  const SubscriptionState({
    this.tier = SubscriptionTier.free,
    this.photosUsed = 0,
    this.photosQuota = 3,
    this.isLoading = false,
  });

  bool get isPro => tier != SubscriptionTier.free;
  bool get canCreatePhoto => isPro || photosUsed < photosQuota;
  int get remainingPhotos => isPro ? -1 : photosQuota - photosUsed;

  SubscriptionState copyWith({
    SubscriptionTier? tier,
    int? photosUsed,
    int? photosQuota,
    bool? isLoading,
  }) {
    return SubscriptionState(
      tier: tier ?? this.tier,
      photosUsed: photosUsed ?? this.photosUsed,
      photosQuota: photosQuota ?? this.photosQuota,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState());

  void usePhoto() {
    if (state.isPro) return;
    state = state.copyWith(photosUsed: state.photosUsed + 1);
  }

  void upgradeToPro(SubscriptionTier tier) {
    state = state.copyWith(tier: tier);
  }

  void restoreSubscription(SubscriptionTier tier) {
    state = state.copyWith(tier: tier);
  }

  void reset() {
    state = const SubscriptionState();
  }
}

final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});
