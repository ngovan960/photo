import 'dart:ui';

class FaceDetectionResult {
  final Rect boundingBox;
  final double eulerY;
  final double eulerZ;
  final bool isFrontal;
  final double faceRatio;
  final double eyePosition;

  const FaceDetectionResult({
    required this.boundingBox,
    required this.eulerY,
    required this.eulerZ,
    required this.isFrontal,
    required this.faceRatio,
    required this.eyePosition,
  });

  double get faceWidth => boundingBox.width;
  double get faceHeight => boundingBox.height;
  double get faceCenterX => boundingBox.center.dx;
  double get faceCenterY => boundingBox.center.dy;
}
