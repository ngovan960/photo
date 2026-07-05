import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/history/presentation/providers/history_provider.dart';
import 'package:photo_id/features/subscription/presentation/providers/subscription_provider.dart';

class ProfileState {
  final String displayName;
  final String email;
  final int totalPhotos;
  final int totalCountries;
  final String subscriptionTier;
  final bool isPro;

  const ProfileState({
    this.displayName = 'User',
    this.email = '',
    this.totalPhotos = 0,
    this.totalCountries = 0,
    this.subscriptionTier = 'Free',
    this.isPro = false,
  });

  ProfileState copyWith({
    String? displayName,
    String? email,
    int? totalPhotos,
    int? totalCountries,
    String? subscriptionTier,
    bool? isPro,
  }) {
    return ProfileState(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      totalPhotos: totalPhotos ?? this.totalPhotos,
      totalCountries: totalCountries ?? this.totalCountries,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      isPro: isPro ?? this.isPro,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final HistoryNotifier _historyNotifier;
  final SubscriptionNotifier _subscriptionNotifier;

  ProfileNotifier({
    required HistoryNotifier historyNotifier,
    required SubscriptionNotifier subscriptionNotifier,
  })  : _historyNotifier = historyNotifier,
        _subscriptionNotifier = subscriptionNotifier,
        super(const ProfileState());

  void loadProfile() {
    final historyState = _historyNotifier.state;
    final subscriptionState = _subscriptionNotifier.state;

    state = state.copyWith(
      totalPhotos: historyState.photos.length,
      totalCountries: historyState.photos.map((p) => p.countryCode).toSet().length,
      subscriptionTier: subscriptionState.isPro ? 'Pro' : 'Free',
      isPro: subscriptionState.isPro,
    );
  }

  void updateDisplayName(String name) {
    state = state.copyWith(displayName: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final historyNotifier = ref.watch(historyProvider.notifier);
  final subscriptionNotifier = ref.watch(subscriptionProvider.notifier);
  return ProfileNotifier(
    historyNotifier: historyNotifier,
    subscriptionNotifier: subscriptionNotifier,
  );
});
