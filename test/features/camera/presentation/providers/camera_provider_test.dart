import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/camera/presentation/providers/camera_provider.dart';
import 'package:photo_id/features/camera/domain/models/face_detection_result.dart';
import 'dart:ui';

void main() {
  group('CameraState', () {
    test('should have default values', () {
      const state = CameraState();

      expect(state.isInitialized, false);
      expect(state.isFrontCamera, true);
      expect(state.isFlashOn, false);
      expect(state.capturedPhoto, isNull);
      expect(state.faceResult, isNull);
      expect(state.isCapturing, false);
      expect(state.error, isNull);
      expect(state.controller, isNull);
    });

    test('should copy with new values', () {
      const state = CameraState();
      final newState = state.copyWith(
        isInitialized: true,
        isFlashOn: true,
      );

      expect(newState.isInitialized, true);
      expect(newState.isFlashOn, true);
      expect(state.isFrontCamera, true);
    });

    test('should clear photo and face', () {
      const state = CameraState(
        capturedPhoto: null,
        faceResult: FaceDetectionResult(
          boundingBox: Rect.fromLTRB(100, 50, 300, 350),
          eulerY: 0,
          eulerZ: 0,
          isFrontal: true,
          faceRatio: 0.75,
          eyePosition: 0.65,
        ),
      );
      final newState = state.copyWith(clearPhoto: true, clearFace: true);

      expect(newState.capturedPhoto, isNull);
      expect(newState.faceResult, isNull);
    });

    test('should clear error', () {
      const state = CameraState(error: 'Test error');
      final newState = state.copyWith(clearError: true);

      expect(newState.error, isNull);
    });
  });
}
