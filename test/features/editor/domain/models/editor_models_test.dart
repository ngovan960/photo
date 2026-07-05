import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/editor/domain/models/photo_model.dart';
import 'package:photo_id/features/editor/domain/models/background_color.dart';
import 'package:photo_id/features/editor/domain/models/validation_result.dart';

void main() {
  group('Photo Model', () {
    test('should create photo with required fields', () {
      final photo = Photo(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
      );

      expect(photo.id, '1');
      expect(photo.countryCode, 'VN');
      expect(photo.documentId, 'vn_cccd');
      expect(photo.qualityScore, 0);
      expect(photo.validationResults, isEmpty);
    });

    test('should copy with new values', () {
      final photo = Photo(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
      );

      final updated = photo.copyWith(qualityScore: 85);

      expect(updated.qualityScore, 85);
      expect(updated.id, '1');
    });

    test('should count passed and failed checks', () {
      final photo = Photo(
        id: '1',
        countryCode: 'VN',
        documentId: 'vn_cccd',
        createdAt: DateTime(2026, 1, 1),
        validationResults: {
          'face_size': true,
          'background': true,
          'lighting': false,
          'expression': true,
        },
      );

      expect(photo.passedChecks, 3);
      expect(photo.failedChecks, 1);
      expect(photo.allChecksPassed, false);
    });
  });

  group('BackgroundColor', () {
    test('should have correct labels', () {
      expect(BackgroundColor.white.label, 'Trắng');
      expect(BackgroundColor.blue.label, 'Xanh');
      expect(BackgroundColor.red.label, 'Đỏ');
      expect(BackgroundColor.gray.label, 'Xám');
    });

    test('should have correct hex values', () {
      expect(BackgroundColor.white.hex, '#FFFFFF');
      expect(BackgroundColor.blue.hex, '#4DA8DA');
      expect(BackgroundColor.red.hex, '#DC3545');
      expect(BackgroundColor.gray.hex, '#B0BEC5');
    });
  });

  group('ValidationResult', () {
    test('should count passed checks correctly', () {
      const result = ValidationResult(
        faceSizeOk: true,
        backgroundOk: true,
        lightingOk: false,
        expressionOk: true,
        sharpnessOk: false,
        shadowFree: true,
        score: 67,
      );

      expect(result.passedChecks, 4);
      expect(result.totalChecks, 6);
      expect(result.allPassed, false);
    });

    test('should detect all passed', () {
      const result = ValidationResult(
        faceSizeOk: true,
        backgroundOk: true,
        lightingOk: true,
        expressionOk: true,
        sharpnessOk: true,
        shadowFree: true,
        score: 100,
      );

      expect(result.allPassed, true);
    });

    test('should copy with new values', () {
      const result = ValidationResult(score: 50);
      final updated = result.copyWith(score: 80);

      expect(updated.score, 80);
    });
  });
}
