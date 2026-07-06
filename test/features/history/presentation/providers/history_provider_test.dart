import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/history/presentation/providers/history_provider.dart';
import 'package:photo_id/features/editor/domain/models/photo_model.dart';

void main() {
  group('HistoryState', () {
    test('should have default values', () {
      const state = HistoryState();
      expect(state.photos, isEmpty);
      expect(state.isLoading, false);
    });

    test('should copy with new values', () {
      const state = HistoryState();
      final newState = state.copyWith(isLoading: true);
      expect(newState.isLoading, true);
    });

    test('should copy with photos', () {
      const state = HistoryState();
      final photo = Photo(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
      );
      final newState = state.copyWith(photos: [photo]);
      expect(newState.photos.length, 1);
    });
  });

  group('Photo model', () {
    test('should create photo with all fields', () {
      final photo = Photo(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
        qualityScore: 85,
        validationResults: {'face_size': true, 'background': true},
      );

      expect(photo.id, '1');
      expect(photo.countryCode, 'VN');
      expect(photo.qualityScore, 85);
      expect(photo.validationResults.length, 2);
    });

    test('should calculate passed checks', () {
      final photo = Photo(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
        validationResults: {
          'face_size': true,
          'background': true,
          'lighting': false,
        },
      );

      expect(photo.passedChecks, 2);
      expect(photo.failedChecks, 1);
    });
  });
}
