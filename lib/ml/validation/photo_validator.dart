import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:photo_id/features/editor/domain/models/validation_result.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';
import 'package:photo_id/ml/validation/image_processing_utils.dart';

class PhotoValidator {
  ValidationResult validate({
    required Uint8List imageBytes,
    required Document documentSpec,
    double? faceRatio,
    double? eyePosition,
    bool? isFrontal,
  }) {
    final errors = <String>[];
    final suggestions = <String>[];

    // Decode image
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      return const ValidationResult(
        score: 0,
        errors: ['Không thể đọc ảnh'],
        suggestions: ['Thử chọn ảnh khác'],
      );
    }

    // Check face size ratio
    final faceSizeOk = _validateFaceSize(faceRatio, documentSpec);
    if (!faceSizeOk) {
      errors.add('Kích thước khuôn mặt không đạt');
      suggestions.add('Đảm bảo khuôn mặt chiếm 70-80% ảnh');
    }

    // Check background
    final backgroundOk = _validateBackground(image, documentSpec);
    if (!backgroundOk) {
      errors.add('Nền không phù hợp');
      suggestions.add('Sử dụng nền ${documentSpec.allowedBackgrounds.first}');
    }

    // Check lighting
    final lightingOk = _validateLighting(image);
    if (!lightingOk) {
      errors.add('Ánh sáng không đủ');
      suggestions.add('Thử chụp nơi đủ sáng hơn');
    }

    // Check expression
    final expressionOk = isFrontal ?? true;
    if (!expressionOk) {
      errors.add('Khuôn mặt không thẳng');
      suggestions.add('Nhìn thẳng vào camera');
    }

    // Check sharpness
    final sharpnessOk = _validateSharpness(image);
    if (!sharpnessOk) {
      errors.add('Ảnh bị mờ');
      suggestions.add('Giữ stead khi chụp');
    }

    // Check shadows
    final shadowFree = _validateShadow(image);
    if (!shadowFree) {
      errors.add('Có bóng đổ');
      suggestions.add('Đứng cách tường 1m');
    }

    // Calculate score
    final checks = [faceSizeOk, backgroundOk, lightingOk, expressionOk, sharpnessOk, shadowFree];
    final passedCount = checks.where((c) => c).length;
    final score = ((passedCount / checks.length) * 100).round();

    return ValidationResult(
      faceSizeOk: faceSizeOk,
      backgroundOk: backgroundOk,
      lightingOk: lightingOk,
      expressionOk: expressionOk,
      sharpnessOk: sharpnessOk,
      shadowFree: shadowFree,
      score: score,
      errors: errors,
      suggestions: suggestions,
    );
  }

  bool _validateFaceSize(double? faceRatio, Document spec) {
    if (faceRatio == null) return false;
    return faceRatio >= spec.faceRatio.min && faceRatio <= spec.faceRatio.max;
  }

  // Real implementation: Check average brightness
  bool _validateLighting(img.Image image) {
    final brightness = ImageProcessingUtils.calculateBrightness(image);
    // Good range: 80-200 (0=black, 255=white)
    return brightness >= 80 && brightness <= 200;
  }

  // Real implementation: Check sharpness using Laplacian variance
  bool _validateSharpness(img.Image image) {
    final variance = ImageProcessingUtils.calculateSharpness(image);
    // Higher variance = sharper image
    // Threshold: > 100 is considered sharp
    return variance > 100;
  }

  // Real implementation: Check background color
  bool _validateBackground(img.Image image, Document spec) {
    final colorBuckets = ImageProcessingUtils.analyzeDominantColors(image);
    return ImageProcessingUtils.isBackgroundAllowed(colorBuckets, spec.allowedBackgrounds);
  }

  // Real implementation: Check shadow using left-right symmetry
  bool _validateShadow(img.Image image) {
    final symmetry = ImageProcessingUtils.calculateSymmetry(image);
    // Low symmetry = shadows present
    // Threshold: < 20 is acceptable
    return symmetry < 20;
  }
}
