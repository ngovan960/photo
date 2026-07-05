import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/editor/domain/models/photo_model.dart';

// History state
class HistoryState {
  final List<Photo> photos;
  final bool isLoading;

  const HistoryState({
    this.photos = const [],
    this.isLoading = false,
  });

  HistoryState copyWith({
    List<Photo>? photos,
    bool? isLoading,
  }) {
    return HistoryState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// History provider
class HistoryNotifier extends StateNotifier<HistoryState> {
  HistoryNotifier() : super(const HistoryState());

  void addPhoto(Photo photo) {
    state = state.copyWith(
      photos: [photo, ...state.photos],
    );
  }

  void removePhoto(String photoId) {
    state = state.copyWith(
      photos: state.photos.where((p) => p.id != photoId).toList(),
    );
  }

  Photo? getPhotoById(String photoId) {
    try {
      return state.photos.firstWhere((p) => p.id == photoId);
    } catch (_) {
      return null;
    }
  }

  List<Photo> getPhotosByCountry(String countryCode) {
    return state.photos.where((p) => p.countryCode == countryCode).toList();
  }

  List<String> get savedCountries {
    return state.photos.map((p) => p.countryCode).toSet().toList();
  }
}

final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>((ref) {
  return HistoryNotifier();
});
