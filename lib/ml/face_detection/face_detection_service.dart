import 'dart:typed_data';
import 'package:photo_id/features/camera/domain/models/face_detection_result.dart';

abstract class FaceDetectionService {
  Future<FaceDetectionResult?> detectFace(Uint8List imageBytes);
  Future<List<FaceDetectionResult>> detectAllFaces(Uint8List imageBytes);
}
