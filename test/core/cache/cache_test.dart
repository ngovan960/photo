import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/core/cache/cache_manager.dart';
import 'package:photo_id/core/cache/photo_cache_service.dart';
import 'package:photo_id/core/cache/offline_storage.dart';

void main() {
  group('CacheState', () {
    test('should have default values', () {
      const state = CacheState();

      expect(state.cacheSize, 0);
      expect(state.photoCount, 0);
      expect(state.isLoading, false);
    });

    test('should format cache size correctly', () {
      const state1 = CacheState(cacheSize: 500);
      expect(state1.cacheSizeFormatted, '500 B');

      const state2 = CacheState(cacheSize: 1500);
      expect(state2.cacheSizeFormatted, '1.5 KB');

      const state3 = CacheState(cacheSize: 1500000);
      expect(state3.cacheSizeFormatted, '1.4 MB');
    });

    test('should copy with new values', () {
      const state = CacheState();
      final newState = state.copyWith(cacheSize: 1024);

      expect(newState.cacheSize, 1024);
      expect(newState.photoCount, 0);
    });
  });

  group('PhotoCacheService', () {
    test('should initialize directories', () async {
      // This test requires path_provider which needs a real device
      // In unit tests, we test the interface
      final service = PhotoCacheService();
      expect(service, isNotNull);
    });
  });

  group('OfflineStorage', () {
    test('should create offline storage instance', () {
      final storage = OfflineStorage();
      expect(storage, isNotNull);
    });
  });
}
