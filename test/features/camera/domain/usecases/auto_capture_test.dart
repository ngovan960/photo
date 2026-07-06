import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/camera/domain/usecases/auto_capture.dart';
import 'package:photo_id/features/camera/domain/models/face_detection_result.dart';
import 'dart:ui';

void main() {
  group('AutoCaptureService', () {
    test('should not capture when no face detected', () {
      final result = AutoCaptureService.checkAutoCapture(
        faceResult: null,
        brightness: 128,
        sharpness: 150,
      );

      expect(result.shouldCapture, false);
      expect(result.reason, isNotNull);
    });

    test('should not capture when face not frontal', () {
      final result = AutoCaptureService.checkAutoCapture(
        faceResult: const FaceDetectionResult(
          boundingBox: Rect.fromLTRB(100, 50, 300, 350),
          eulerY: 15,
          eulerZ: 0,
          isFrontal: false,
          faceRatio: 0.75,
          eyePosition: 0.65,
        ),
        brightness: 128,
        sharpness: 150,
      );

      expect(result.shouldCapture, false);
      expect(result.reason, contains('thẳng'));
    });

    test('should not capture when face too small', () {
      final result = AutoCaptureService.checkAutoCapture(
        faceResult: const FaceDetectionResult(
          boundingBox: Rect.fromLTRB(100, 50, 300, 350),
          eulerY: 0,
          eulerZ: 0,
          isFrontal: true,
          faceRatio: 0.4, // Too small
          eyePosition: 0.65,
        ),
        brightness: 128,
        sharpness: 150,
      );

      expect(result.shouldCapture, false);
      expect(result.reason, isNotNull);
    });

    test('should not capture when brightness too low', () {
      final result = AutoCaptureService.checkAutoCapture(
        faceResult: const FaceDetectionResult(
          boundingBox: Rect.fromLTRB(100, 50, 300, 350),
          eulerY: 0,
          eulerZ: 0,
          isFrontal: true,
          faceRatio: 0.75,
          eyePosition: 0.65,
        ),
        brightness: 50, // Too dark
        sharpness: 150,
      );

      expect(result.shouldCapture, false);
      expect(result.reason, contains('sáng'));
    });

    test('should capture when all checks pass', () {
      final result = AutoCaptureService.checkAutoCapture(
        faceResult: const FaceDetectionResult(
          boundingBox: Rect.fromLTRB(100, 50, 300, 350),
          eulerY: 0,
          eulerZ: 0,
          isFrontal: true,
          faceRatio: 0.75,
          eyePosition: 0.65,
        ),
        brightness: 128,
        sharpness: 150,
      );

      expect(result.shouldCapture, true);
      expect(result.passedChecks, isNotEmpty);
      expect(result.failedChecks, isEmpty);
    });
  });

  group('AutoCaptureService.getHintText', () {
    test('should return hint for no face', () {
      final hint = AutoCaptureService.getHintText(null);
      expect(hint, contains('vòng tròn'));
    });

    test('should return hint for non-frontal face', () {
      final hint = AutoCaptureService.getHintText(const FaceDetectionResult(
        boundingBox: Rect.fromLTRB(100, 50, 300, 350),
        eulerY: 15,
        eulerZ: 0,
        isFrontal: false,
        faceRatio: 0.75,
        eyePosition: 0.65,
      ));
      expect(hint, contains('thẳng'));
    });

    test('should return hint for small face', () {
      final hint = AutoCaptureService.getHintText(const FaceDetectionResult(
        boundingBox: Rect.fromLTRB(100, 50, 300, 350),
        eulerY: 0,
        eulerZ: 0,
        isFrontal: true,
        faceRatio: 0.4,
        eyePosition: 0.65,
      ));
      expect(hint, contains('gần'));
    });
  });
}
