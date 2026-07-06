import 'package:photo_id/features/camera/domain/models/face_detection_result.dart';

class AutoCaptureResult {
  final bool shouldCapture;
  final String? reason;
  final List<String> passedChecks;
  final List<String> failedChecks;

  const AutoCaptureResult({
    required this.shouldCapture,
    this.reason,
    this.passedChecks = const [],
    this.failedChecks = const [],
  });
}

class AutoCaptureService {
  // Check if auto-capture should trigger
  static AutoCaptureResult checkAutoCapture({
    required FaceDetectionResult? faceResult,
    required double? brightness,
    required double? sharpness,
  }) {
    final passedChecks = <String>[];
    final failedChecks = <String>[];

    // Check face detection
    if (faceResult == null) {
      failedChecks.add('Không detect khuôn mặt');
      return AutoCaptureResult(
        shouldCapture: false,
        reason: 'Không detect khuôn mặt',
        failedChecks: failedChecks,
      );
    }

    if (!faceResult.isFrontal) {
      failedChecks.add('Khuôn mặt không thẳng');
      return AutoCaptureResult(
        shouldCapture: false,
        reason: 'Vui lòng nhìn thẳng',
        failedChecks: failedChecks,
      );
    }

    passedChecks.add('Khuôn mặt OK');

    // Check face size ratio (should be 0.6-0.85 for auto-capture)
    if (faceResult.faceRatio < 0.6 || faceResult.faceRatio > 0.85) {
      failedChecks.add('Khuôn mặt quá nhỏ hoặc quá lớn');
      return AutoCaptureResult(
        shouldCapture: false,
        reason: 'Di chuyển lại gần hơn hoặc ra xa hơn',
        failedChecks: failedChecks,
      );
    }

    passedChecks.add('Kích thước OK');

    // Check brightness
    if (brightness != null) {
      if (brightness < 80 || brightness > 200) {
        failedChecks.add('Ánh sáng không đủ');
        return AutoCaptureResult(
          shouldCapture: false,
          reason: 'Thử chụp nơi đủ sáng hơn',
          failedChecks: failedChecks,
        );
      }
      passedChecks.add('Ánh sáng OK');
    }

    // Check sharpness
    if (sharpness != null && sharpness < 100) {
      failedChecks.add('Ảnh bị mờ');
      return AutoCaptureResult(
        shouldCapture: false,
        reason: 'Giữ steady khi chụp',
        failedChecks: failedChecks,
      );
    }

    if (sharpness != null) {
      passedChecks.add('Độ nét OK');
    }

    // All checks passed - should auto-capture
    return AutoCaptureResult(
      shouldCapture: true,
      passedChecks: passedChecks,
      failedChecks: failedChecks,
    );
  }

  // Get hint text based on face result
  static String getHintText(FaceDetectionResult? faceResult) {
    if (faceResult == null) {
      return 'Đưa khuôn mặt vào vòng tròn';
    }

    if (!faceResult.isFrontal) {
      return 'Nhìn thẳng vào camera';
    }

    if (faceResult.faceRatio < 0.6) {
      return 'Di chuyển lại gần hơn';
    }

    if (faceResult.faceRatio > 0.85) {
      return 'Di chuyển ra xa hơn';
    }

    if (faceResult.eulerY.abs() > 10) {
      return 'Xoay mặt thẳng hơn';
    }

    if (faceResult.eulerZ.abs() > 10) {
      return 'Nghiêng đầu thẳng hơn';
    }

    return 'Giữ nguyên vị trí';
  }
}
