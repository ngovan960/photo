import 'dart:typed_data';
import 'package:photo_id/features/editor/domain/models/background_color.dart';
import 'package:photo_id/features/editor/domain/models/validation_result.dart';
import 'package:photo_id/features/countries/domain/models/country_model.dart';

abstract class EditorRepository {
  Future<Uint8List> removeBackground(Uint8List imageBytes);
  Future<Uint8List> changeBackground(Uint8List imageBytes, BackgroundColor color);
  Future<Uint8List> cropAndResize(Uint8List imageBytes, double widthMm, double heightMm);
  ValidationResult validatePhoto({
    required Uint8List imageBytes,
    required Document documentSpec,
    double? faceRatio,
    bool? isFrontal,
  });
}
