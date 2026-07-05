import 'dart:typed_data';
import 'package:photo_id/features/camera/domain/models/face_detection_result.dart';

abstract class CameraRepository {
  Future<void> initialize();
  Future<void> dispose();
  Future<void> toggleFlash();
  Future<void> switchCamera();
  Future<Uint8List?> capturePhoto();
  Future<FaceDetectionResult?> detectFace(Uint8List imageBytes);
  bool get isInitialized;
  bool get isFrontCamera;
}
