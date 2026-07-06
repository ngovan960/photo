import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:photo_id/features/history/data/models/photo_record.dart';
import 'package:photo_id/features/history/data/datasources/history_local_datasource.dart';
import 'package:photo_id/features/settings/data/models/settings_model.dart';
import 'package:photo_id/features/settings/data/datasources/settings_local_datasource.dart';

void main() {
  setUp(() async {
    // Initialize Hive for testing
    Hive.init('./test_hive');
  });

  tearDown(() async {
    await Hive.close();
    // Clean up test directory
  });

  group('HistoryLocalDataSource', () {
    late HistoryLocalDataSource dataSource;

    setUp(() async {
      dataSource = HistoryLocalDataSource();
      await dataSource.init();
    });

    tearDown(() async {
      await dataSource.clearAll();
    });

    test('should save and retrieve photo', () async {
      final photo = PhotoRecord(
        id: 'test-001',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
        thumbnailPath: '/path/thumb.jpg',
        originalPath: '/path/original.jpg',
      );

      await dataSource.savePhoto(photo);
      final retrieved = dataSource.getPhoto('test-001');

      expect(retrieved, isNotNull);
      expect(retrieved!.id, 'test-001');
      expect(retrieved.countryCode, 'VN');
    });

    test('should get all photos', () async {
      await dataSource.savePhoto(PhotoRecord(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
        thumbnailPath: '/path/1.jpg',
        originalPath: '/path/1.jpg',
      ));
      await dataSource.savePhoto(PhotoRecord(
        id: '2',
        countryCode: 'JP',
        documentId: 'jp_passport',
        createdAt: DateTime(2026, 1, 2),
        thumbnailPath: '/path/2.jpg',
        originalPath: '/path/2.jpg',
      ));

      final photos = dataSource.getAllPhotos();
      expect(photos.length, 2);
    });

    test('should get photos by country', () async {
      await dataSource.savePhoto(PhotoRecord(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
        thumbnailPath: '/path/1.jpg',
        originalPath: '/path/1.jpg',
      ));
      await dataSource.savePhoto(PhotoRecord(
        id: '2',
        countryCode: 'JP',
        documentId: 'jp_passport',
        createdAt: DateTime(2026, 1, 2),
        thumbnailPath: '/path/2.jpg',
        originalPath: '/path/2.jpg',
      ));

      final vnPhotos = dataSource.getPhotosByCountry('VN');
      expect(vnPhotos.length, 1);
      expect(vnPhotos.first.countryCode, 'VN');
    });

    test('should delete photo', () async {
      await dataSource.savePhoto(PhotoRecord(
        id: 'test-delete',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
        thumbnailPath: '/path/thumb.jpg',
        originalPath: '/path/original.jpg',
      ));

      await dataSource.deletePhoto('test-delete');
      final photo = dataSource.getPhoto('test-delete');
      expect(photo, isNull);
    });

    test('should clear all photos', () async {
      await dataSource.savePhoto(PhotoRecord(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
        thumbnailPath: '/path/1.jpg',
        originalPath: '/path/1.jpg',
      ));

      await dataSource.clearAll();
      expect(dataSource.photoCount, 0);
    });
  });

  group('SettingsLocalDataSource', () {
    late SettingsLocalDataSource dataSource;

    setUp(() async {
      dataSource = SettingsLocalDataSource();
      await dataSource.init();
    });

    test('should save and retrieve settings', () async {
      final settings = SettingsModel(
        themeMode: 'dark',
        language: 'vi',
      );

      await dataSource.saveSettings(settings);
      final retrieved = dataSource.getSettings();

      expect(retrieved.themeMode, 'dark');
      expect(retrieved.language, 'vi');
    });

    test('should update theme', () async {
      await dataSource.updateTheme('dark');
      final settings = dataSource.getSettings();

      expect(settings.themeMode, 'dark');
    });

    test('should update language', () async {
      await dataSource.updateLanguage('ja');
      final settings = dataSource.getSettings();

      expect(settings.language, 'ja');
    });

    test('should reset to defaults', () async {
      await dataSource.updateTheme('dark');
      await dataSource.updateLanguage('ja');

      await dataSource.resetToDefaults();
      final settings = dataSource.getSettings();

      expect(settings.themeMode, 'system');
      expect(settings.language, 'en');
    });
  });
}
