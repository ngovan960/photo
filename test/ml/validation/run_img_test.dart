import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:photo_id/features/countries/domain/models/country_model.dart';
import 'package:photo_id/ml/validation/image_processing_utils.dart';
import 'package:photo_id/ml/validation/photo_validator.dart';

void main() {
  group('Image Test Suite for MVP Functions', () {
    test('Validate all images in img_test folder', () {
      final imgTestDir = Directory('img_test');
      if (!imgTestDir.existsSync()) {
        print('img_test directory not found!');
        return;
      }

      final files = imgTestDir.listSync();
      if (files.isEmpty) {
        print('No files found in img_test folder!');
        return;
      }

      print('=== RUNNING TESTS ON IMAGES IN img_test ===');
      
      // Standard spec for testing (e.g. Vietnam CCCD: 30x40 mm, white background)
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
        
        // Skip hidden files
        if (filename.startsWith('.')) {
          continue;
        }

        print('\n----------------------------------------');
        print('Testing File: $filename');
        
        final bytes = file.readAsBytesSync();
        final decodedImage = img.decodeImage(bytes);
        
        if (decodedImage == null) {
          print('FAILED: Could not decode image $filename');
          continue;
        }

        print('Resolution: ${decodedImage.width}x${decodedImage.height}');

        // Calculate individual parameters
        final brightness = ImageProcessingUtils.calculateBrightness(decodedImage);
        final sharpness = ImageProcessingUtils.calculateSharpness(decodedImage);
        final symmetry = ImageProcessingUtils.calculateSymmetry(decodedImage);
        final colorBuckets = ImageProcessingUtils.analyzeDominantColors(decodedImage);
        
        // Find dominant bucket
        int maxCount = 0;
        int dominantBucket = -1;
        for (final entry in colorBuckets.entries) {
          if (entry.value > maxCount) {
            maxCount = entry.value;
            dominantBucket = entry.key;
          }
        }
        
        String bucketName = 'Unknown';
        switch (dominantBucket) {
          case 0: bucketName = 'White'; break;
          case 1: bucketName = 'Blue'; break;
          case 2: bucketName = 'Red'; break;
          case 3: bucketName = 'Gray'; break;
          case 4: bucketName = 'Other/Multi-color'; break;
        }

        // Run validation
        // Mock faceRatio as 0.75 (perfect) and isFrontal as true to isolate image processing parameters
        final result = validator.validate(
          imageBytes: bytes,
          documentSpec: spec,
          faceRatio: 0.75,
          isFrontal: true,
        );

        print('Image Analysis Metrics:');
        print('  - Brightness (Target 80-200): ${brightness.toStringAsFixed(2)} -> ${result.lightingOk ? "PASS" : "FAIL"}');
        print('  - Sharpness (Target > 100): ${sharpness.toStringAsFixed(2)} -> ${result.sharpnessOk ? "PASS" : "FAIL"}');
        print('  - Symmetry/Shadow (Target < 20): ${symmetry.toStringAsFixed(2)} -> ${result.shadowFree ? "PASS" : "FAIL"}');
        print('  - Dominant Background: $bucketName -> ${result.backgroundOk ? "PASS" : "FAIL"}');
        print('Overall Score: ${result.score}/100');
        if (result.errors.isNotEmpty) {
          print('Errors:');
          for (final err in result.errors) {
            print('  * $err');
          }
        } else {
          print('Errors: None');
        }
        if (result.suggestions.isNotEmpty) {
          print('Suggestions:');
          for (final sug in result.suggestions) {
            print('  * $sug');
          }
        }
      }
      print('========================================');
    });
  });
}
