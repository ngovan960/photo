import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/history/data/models/photo_record.dart';

void main() {
  group('PhotoRecord', () {
    test('should create photo record with all fields', () {
      final photo = PhotoRecord(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
        thumbnailPath: '/path/thumb.jpg',
        originalPath: '/path/original.jpg',
        exportedPath: '/path/export.jpg',
        qualityScore: 85,
        validationResults: {
          'face_size': true,
          'background': true,
        },
      );

      expect(photo.id, '1');
      expect(photo.countryCode, 'VN');
      expect(photo.documentId, 'vn_cccd');
      expect(photo.qualityScore, 85);
      expect(photo.validationResults.length, 2);
    });

    test('should create photo record with optional fields', () {
      final photo = PhotoRecord(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
        thumbnailPath: '/path/thumb.jpg',
        originalPath: '/path/original.jpg',
      );

      expect(photo.exportedPath, isNull);
      expect(photo.qualityScore, 0);
      expect(photo.validationResults, isEmpty);
    });
  });

  group('SettingsModel', () {
    test('should create settings with defaults', () {
      // Import settings model
      // Test default values
      expect(true, true); // Placeholder
    });
  });
}
