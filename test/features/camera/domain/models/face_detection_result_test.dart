import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/camera/domain/models/face_detection_result.dart';
import 'dart:ui';

void main() {
  group('FaceDetectionResult', () {
    test('should create face detection result with all fields', () {
      const result = FaceDetectionResult(
        boundingBox: Rect.fromLTRB(100, 50, 300, 350),
        eulerY: 5.0,
        eulerZ: -2.0,
        isFrontal: true,
        faceRatio: 0.75,
        eyePosition: 0.65,
      );

      expect(result.boundingBox, const Rect.fromLTRB(100, 50, 300, 350));
      expect(result.eulerY, 5.0);
      expect(result.eulerZ, -2.0);
      expect(result.isFrontal, true);
      expect(result.faceRatio, 0.75);
      expect(result.eyePosition, 0.65);
    });

    test('should calculate face width and height', () {
      const result = FaceDetectionResult(
        boundingBox: Rect.fromLTRB(100, 50, 300, 350),
        eulerY: 0,
        eulerZ: 0,
        isFrontal: true,
        faceRatio: 0.75,
        eyePosition: 0.65,
      );

      expect(result.faceWidth, 200);
      expect(result.faceHeight, 300);
    });

    test('should calculate face center', () {
      const result = FaceDetectionResult(
        boundingBox: Rect.fromLTRB(100, 50, 300, 350),
        eulerY: 0,
        eulerZ: 0,
        isFrontal: true,
        faceRatio: 0.75,
        eyePosition: 0.65,
      );

      expect(result.faceCenterX, 200);
      expect(result.faceCenterY, 200);
    });

    test('should detect non-frontal face', () {
      const result = FaceDetectionResult(
        boundingBox: Rect.fromLTRB(100, 50, 300, 350),
        eulerY: 15.0,
        eulerZ: 5.0,
        isFrontal: false,
        faceRatio: 0.75,
        eyePosition: 0.65,
      );

      expect(result.isFrontal, false);
    });
  });
}
