import 'dart:typed_data';
import 'package:photo_id/features/editor/domain/models/validation_result.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';

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

    // Check face size ratio
    final faceSizeOk = _validateFaceSize(faceRatio, documentSpec);
    if (!faceSizeOk) {
      errors.add('Kích thước khuôn mặt không đạt');
      suggestions.add('Đảm bảo khuôn mặt chiếm 70-80% ảnh');
    }

    // Check background
    final backgroundOk = _validateBackground(imageBytes, documentSpec);
    if (!backgroundOk) {
      errors.add('Nền không phù hợp');
      suggestions.add('Sử dụng nền ${documentSpec.allowedBackgrounds.first}');
    }

    // Check lighting
    final lightingOk = _validateLighting(imageBytes);
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
    final sharpnessOk = _validateSharpness(imageBytes);
    if (!sharpnessOk) {
      errors.add('Ảnh bị mờ');
      suggestions.add('Giữ stead khi chụp');
    }

    // Check shadows
    final shadowFree = _validateShadow(imageBytes);
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

  bool _validateLighting(Uint8List imageBytes) {
    // Placeholder: check average brightness
    // In production, analyze histogram
    return true;
  }

  bool _validateSharpness(Uint8List imageBytes) {
    // Placeholder: check image sharpness
    // In production, use Laplacian variance
    return true;
  }

  bool _validateBackground(Uint8List imageBytes, Document spec) {
    // Placeholder: check if background matches allowed colors
    // In production, analyze dominant color in non-face region
    return true;
  }

  bool _validateShadow(Uint8List imageBytes) {
    // Placeholder: check for shadows
    // In production, detect edges in background
    return true;
  }
}
