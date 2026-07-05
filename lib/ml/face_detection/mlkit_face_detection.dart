import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:photo_id/features/camera/domain/models/face_detection_result.dart';
import 'face_detection_service.dart';

class MLKitFaceDetectionService implements FaceDetectionService {
  final FaceDetector _faceDetector;

  MLKitFaceDetectionService()
      : _faceDetector = FaceDetector(
          options: FaceDetectorOptions(
            enableContours: false,
            enableLandmarks: false,
            enableClassification: false,
            enableTracking: false,
            performanceMode: FaceDetectorMode.fast,
          ),
        );

  @override
  Future<FaceDetectionResult?> detectFace(Uint8List imageBytes) async {
    final faces = await _detectFaces(imageBytes);
    if (faces.isEmpty) return null;

    final face = faces.first;
    return _mapFaceToResult(face, imageBytes);
  }

  @override
  Future<List<FaceDetectionResult>> detectAllFaces(Uint8List imageBytes) async {
    final faces = await _detectFaces(imageBytes);
    final results = <FaceDetectionResult>[];

    for (final face in faces) {
      results.add(_mapFaceToResult(face, imageBytes));
    }

    return results;
  }

  Future<List<Face>> _detectFaces(Uint8List imageBytes) async {
    final inputImage = InputImage.fromBytes(
      bytes: imageBytes,
      metadata: InputImageMetadata(
        size: await _getImageSize(imageBytes),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.yuv420,
        bytesPerRow: 0,
      ),
    );

    return _faceDetector.processImage(inputImage);
  }

  Future<ui.Size> _getImageSize(Uint8List imageBytes) async {
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final size = ui.Size(image.width.toDouble(), image.height.toDouble());
    image.dispose();
    return size;
  }

  FaceDetectionResult _mapFaceToResult(Face face, Uint8List imageBytes) {
    final boundingBox = face.boundingBox;
    final eulerY = face.headEulerAngleY ?? 0;
    final eulerZ = face.headEulerAngleZ ?? 0;

    // Calculate face ratio (face height / image height)
    // This is approximate - actual implementation needs image dimensions
    final faceRatio = boundingBox.height / 400; // Placeholder
    final eyePosition = (boundingBox.top + boundingBox.height * 0.3) / 400;

    final isFrontal = eulerY.abs() < 10 && eulerZ.abs() < 10;

    return FaceDetectionResult(
      boundingBox: boundingBox,
      eulerY: eulerY,
      eulerZ: eulerZ,
      isFrontal: isFrontal,
      faceRatio: faceRatio,
      eyePosition: eyePosition,
    );
  }

  void dispose() {
    _faceDetector.close();
  }
}
