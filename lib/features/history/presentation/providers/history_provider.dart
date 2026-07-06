import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/editor/domain/models/photo_model.dart';
import 'package:photo_id/features/history/data/datasources/history_local_datasource.dart';
import 'package:photo_id/features/history/data/models/photo_record.dart';

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

// History provider with Hive persistence
class HistoryNotifier extends StateNotifier<HistoryState> {
  final HistoryLocalDataSource _dataSource;

  HistoryNotifier(this._dataSource) : super(const HistoryState()) {
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    state = state.copyWith(isLoading: true);
    try {
      final records = _dataSource.getAllPhotos();
      final photos = records.map((r) => Photo(
        id: r.id,
        countryCode: r.countryCode,
        documentId: r.documentId,
        createdAt: r.createdAt,
        qualityScore: r.qualityScore,
        validationResults: r.validationResults,
      )).toList();
      state = state.copyWith(photos: photos, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addPhoto(Photo photo) async {
    // Save to Hive
    final record = PhotoRecord(
      id: photo.id,
      countryCode: photo.countryCode,
      documentId: photo.documentId,
      createdAt: photo.createdAt,
      thumbnailPath: '',
      originalPath: '',
      qualityScore: photo.qualityScore,
      validationResults: photo.validationResults,
    );
    await _dataSource.savePhoto(record);

    // Update state
    state = state.copyWith(
      photos: [photo, ...state.photos],
    );
  }

  Future<void> removePhoto(String photoId) async {
    await _dataSource.deletePhoto(photoId);
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
  final dataSource = ref.watch(historyLocalDataSourceProvider);
  return HistoryNotifier(dataSource);
});

final historyLocalDataSourceProvider = Provider<HistoryLocalDataSource>((ref) {
  return HistoryLocalDataSource();
});
