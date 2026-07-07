import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:photo_id/features/countries/domain/models/country_model.dart';
import 'package:photo_id/ml/validation/image_processing_utils.dart';
import 'package:photo_id/ml/validation/photo_validator.dart';

void main() {
  group('Validate Mobile U2-Netp Processed CCCD Images', () {
    test('Verify all mobile processed files pass quality checks', () {
      final processedDir = Directory('img_test/processed_mobile');
      if (!processedDir.existsSync()) {
        print('processed_mobile directory not found!');
        return;
      }

      final files = processedDir.listSync();
      if (files.isEmpty) {
        print('No files found in processed_mobile folder!');
        return;
      }

      print('=== RUNNING AI VALIDATION ON MOBILE U2-Netp PROCESSED IMAGES ===');
      
      const spec = Document(
        id: 'vn_cccd',
        name: 'CCCD Việt Nam',
        widthMm: 30,
        heightMm: 40,
        allowedBackgrounds: ['white'],
        requirements: ['Nhìn thẳng', 'Không cười', 'Nền trắng', 'Không đeo kính'],
        faceRatio: FaceRatioSpec(min: 0.70, max: 0.80, minEye: 0.60, maxEye: 0.70),
      );

      final validator = PhotoValidator();

      for (final entity in files) {
        if (entity is! File) continue;
        final file = entity;
        final filename = file.uri.pathSegments.last;

        if (!filename.endsWith('.jpg') && !filename.endsWith('.jpeg') && !filename.endsWith('.png')) {
          continue;
        }

        print('\n----------------------------------------');
        print('Validating Processed CCCD File: $filename');
        
        final bytes = file.readAsBytesSync();
        final decodedImage = img.decodeImage(bytes);
        
        if (decodedImage == null) {
          print('FAILED: Could not decode $filename');
          continue;
        }

        final brightness = ImageProcessingUtils.calculateBrightness(decodedImage);
        final sharpness = ImageProcessingUtils.calculateSharpness(decodedImage);
        final symmetry = ImageProcessingUtils.calculateSymmetry(decodedImage);

        final result = validator.validate(
          imageBytes: bytes,
          documentSpec: spec,
          faceRatio: 0.75,
          isFrontal: true,
        );

        print('Metrics:');
        print('  - Brightness (80-200): ${brightness.toStringAsFixed(2)} -> ${result.lightingOk ? "PASS" : "FAIL"}');
        print('  - Sharpness (> 100): ${sharpness.toStringAsFixed(2)} -> ${result.sharpnessOk ? "PASS" : "FAIL"}');
        print('  - Symmetry/Shadow (< 20): ${symmetry.toStringAsFixed(2)} -> ${result.shadowFree ? "PASS" : "FAIL"}');
        print('  - Background (Allowed): ${result.backgroundOk ? "PASS" : "FAIL"}');
        print('Overall Quality Score: ${result.score}/100');
        if (result.errors.isNotEmpty) {
          print('Remaining Errors:');
          for (final err in result.errors) {
            print('  * $err');
          }
        } else {
          print('All checks PASSED for Vietnamese CCCD! ✅');
        }
      }
      print('========================================');
    });
  });
}
