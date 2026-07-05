import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:photo_id/features/editor/domain/models/background_color.dart';
import 'package:photo_id/features/editor/domain/models/validation_result.dart';
import 'package:photo_id/features/editor/domain/repositories/editor_repository.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';
import 'package:photo_id/ml/background_removal/background_removal_service.dart';
import 'package:photo_id/ml/validation/photo_validator.dart';

class EditorRepositoryImpl implements EditorRepository {
  final BackgroundRemovalService _bgRemovalService;
  final PhotoValidator _validator;

  EditorRepositoryImpl({
    required BackgroundRemovalService bgRemovalService,
    required PhotoValidator validator,
  })  : _bgRemovalService = bgRemovalService,
        _validator = validator;

  @override
  Future<Uint8List> removeBackground(Uint8List imageBytes) async {
    return await _bgRemovalService.removeBackground(imageBytes);
  }

  @override
  Future<Uint8List> changeBackground(
    Uint8List imageBytes,
    BackgroundColor color,
  ) async {
    return await _bgRemovalService.changeBackground(imageBytes, color);
  }

  @override
  Future<Uint8List> cropAndResize(
    Uint8List imageBytes,
    double widthMm,
    double heightMm,
  ) async {
    final image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Failed to decode image');

    // Calculate target aspect ratio
    final targetRatio = widthMm / heightMm;
    final currentRatio = image.width / image.height;

    int cropWidth, cropHeight;
    int offsetX, offsetY;

    if (currentRatio > targetRatio) {
      // Image is wider than target
      cropHeight = image.height;
      cropWidth = (image.height * targetRatio).round();
      offsetX = (image.width - cropWidth) ~/ 2;
      offsetY = 0;
    } else {
      // Image is taller than target
      cropWidth = image.width;
      cropHeight = (image.width / targetRatio).round();
      offsetX = 0;
      offsetY = (image.height - cropHeight) ~/ 2;
    }

    // Crop
    final cropped = img.copyCrop(
      image,
      x: offsetX,
      y: offsetY,
      width: cropWidth,
      height: cropHeight,
    );

    // Resize to standard resolution (300 DPI)
    // 35mm = 413px at 300 DPI, 45mm = 531px at 300 DPI
    final targetWidth = (widthMm / 25.4 * 300).round();
    final targetHeight = (heightMm / 25.4 * 300).round();

    final resized = img.copyResize(
      cropped,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.linear,
    );

    return Uint8List.fromList(img.encodeJpg(resized, quality: 95));
  }

  @override
  ValidationResult validatePhoto({
    required Uint8List imageBytes,
    required Document documentSpec,
    double? faceRatio,
    bool? isFrontal,
  }) {
    return _validator.validate(
      imageBytes: imageBytes,
      documentSpec: documentSpec,
      faceRatio: faceRatio,
      isFrontal: isFrontal,
    );
  }
}
