import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/core/cache/photo_cache_service.dart';

// Cache service provider
final photoCacheServiceProvider = Provider<PhotoCacheService>((ref) {
  return PhotoCacheService();
});

// Cache state
class CacheState {
  final int cacheSize;
  final int photoCount;
  final bool isLoading;

  const CacheState({
    this.cacheSize = 0,
    this.photoCount = 0,
    this.isLoading = false,
  });

  CacheState copyWith({
    int? cacheSize,
    int? photoCount,
    bool? isLoading,
  }) {
    return CacheState(
      cacheSize: cacheSize ?? this.cacheSize,
      photoCount: photoCount ?? this.photoCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  String get cacheSizeFormatted {
    if (cacheSize < 1024) return '$cacheSize B';
    if (cacheSize < 1024 * 1024) return '${(cacheSize / 1024).toStringAsFixed(1)} KB';
    return '${(cacheSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

// Cache manager
class CacheManager extends StateNotifier<CacheState> {
  final PhotoCacheService _service;

  CacheManager(this._service) : super(const CacheState());

  Future<void> loadCacheInfo() async {
    state = state.copyWith(isLoading: true);

    final size = await _service.getCacheSize();
    final ids = await _service.getAllPhotoIds();

    state = state.copyWith(
      cacheSize: size,
      photoCount: ids.length,
      isLoading: false,
    );
  }

  Future<String> saveOriginal(String photoId, Uint8List bytes) async {
    final path = await _service.saveOriginal(photoId, bytes);
    await loadCacheInfo(); // Refresh stats
    return path;
  }

  Future<String> saveThumbnail(String photoId, Uint8List bytes) async {
    final path = await _service.saveThumbnail(photoId, bytes);
    return path;
  }

  Future<String> saveExport(String photoId, Uint8List bytes, {String? suffix}) async {
    final path = await _service.saveExport(photoId, bytes, suffix: suffix);
    await loadCacheInfo();
    return path;
  }

  Future<Uint8List?> readPhoto(String path) async {
    return await _service.readPhoto(path);
  }

  Future<void> deletePhoto(String photoId) async {
    await _service.deletePhoto(photoId);
    await loadCacheInfo();
  }

  Future<void> clearCache() async {
    await _service.clearCache();
    await loadCacheInfo();
  }

  Future<void> evictIfNeeded() async {
    await _service.evictIfNeeded();
    await loadCacheInfo();
  }
}

final cacheManagerProvider = StateNotifierProvider<CacheManager, CacheState>((ref) {
  final service = ref.watch(photoCacheServiceProvider);
  return CacheManager(service);
});
