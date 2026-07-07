import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:photo_id/features/countries/domain/models/country_model.dart';
import 'package:photo_id/ml/validation/photo_validator.dart';

void main() {
  group('CCCD Vietnam Processing pipeline', () {
    test('Process images to standard CCCD Vietnam', () {
      final imgTestDir = Directory('img_test');
      if (!imgTestDir.existsSync()) {
        print('img_test directory not found!');
        return;
      }

      final outputDir = Directory('img_test/processed');
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: true);
      }

      final files = imgTestDir.listSync();
      
      // Standard spec for Vietnam CCCD: 30x40 mm, white background
      const cccdSpec = Document(
        id: 'vn_cccd',
        name: 'CCCD Việt Nam',
        widthMm: 30,
        heightMm: 40,
        allowedBackgrounds: ['white'],
        requirements: ['Nhìn thẳng', 'Không cười', 'Nền trắng', 'Không đeo kính'],
        faceRatio: FaceRatioSpec(min: 0.70, max: 0.80, minEye: 0.60, maxEye: 0.70),
      );

      final validator = PhotoValidator();

      print('=== PROCESSING IMAGES TO STANDARD CCCD VIETNAM (30x40mm, White Background) ===');

      for (final entity in files) {
        if (entity is! File) continue;
        final file = entity;
        final filename = file.uri.pathSegments.last;

        if (filename.startsWith('.')) continue;

        print('\n----------------------------------------');
        print('Processing: $filename');

        final bytes = file.readAsBytesSync();
        final originalImage = img.decodeImage(bytes);

        if (originalImage == null) {
          print('FAILED: Could not decode $filename');
          continue;
        }

        print('Original Resolution: ${originalImage.width}x${originalImage.height}');

        // Step 1: Background removal & color replacement (making it pure white)
        // We will perform a color-based segmentation for the test files to replace their background with white
        final bgReplaced = img.Image.from(originalImage);
        
        // Sample background color at top-left and top-right corners
        final tlPixel = originalImage.getPixel(10, 10);
        final trPixel = originalImage.getPixel(originalImage.width - 10, 10);
        
        final tlR = tlPixel.r.toInt();
        final tlG = tlPixel.g.toInt();
        final tlB = tlPixel.b.toInt();
        
        final trR = trPixel.r.toInt();
        final trG = trPixel.g.toInt();
        final trB = trPixel.b.toInt();

        // Standard Euclidean color distance threshold
        // If a pixel is close in color to either corner sample, and is not in the very middle of the image, replace with white
        for (int y = 0; y < originalImage.height; y++) {
          for (int x = 0; x < originalImage.width; x++) {
            final p = originalImage.getPixel(x, y);
            final r = p.r.toInt();
            final g = p.g.toInt();
            final b = p.b.toInt();

            // Distance to top-left corner color
            final distTl = sqrt(pow(r - tlR, 2) + pow(g - tlG, 2) + pow(b - tlB, 2));
            // Distance to top-right corner color
            final distTr = sqrt(pow(r - trR, 2) + pow(g - trG, 2) + pow(b - trB, 2));

            // Heuristic: If we are close to the edges, or color matches background
            final minBorderDist = [x, y, originalImage.width - 1 - x, originalImage.height - 1 - y].reduce(min);
            final inFaceRegion = (x > originalImage.width * 0.3 && x < originalImage.width * 0.7 &&
                                  y > originalImage.height * 0.25 && y < originalImage.height * 0.75);

            // If color matches background corner with tolerance, and not in the core face region
            bool replace = false;
            if (!inFaceRegion) {
              if (distTl < 75 || distTr < 75) {
                replace = true;
              }
            } else {
              // In face region, only replace if very close to corner colors and near top
              if (y < originalImage.height * 0.35 && (distTl < 40 || distTr < 40)) {
                replace = true;
              }
            }

            if (replace) {
              bgReplaced.setPixelRgba(x, y, 255, 255, 255, 255); // Pure white
            }
          }
        }

        // Step 2: Crop to CCCD Aspect Ratio (3:4)
        final targetRatio = cccdSpec.widthMm / cccdSpec.heightMm; // 30/40 = 0.75
        final currentRatio = bgReplaced.width / bgReplaced.height;

        int cropWidth, cropHeight;
        int offsetX, offsetY;

        if (currentRatio > targetRatio) {
          cropHeight = bgReplaced.height;
          cropWidth = (bgReplaced.height * targetRatio).round();
          offsetX = (bgReplaced.width - cropWidth) ~/ 2;
          offsetY = 0;
        } else {
          cropWidth = bgReplaced.width;
          cropHeight = (bgReplaced.width / targetRatio).round();
          offsetX = 0;
          offsetY = (bgReplaced.height - cropHeight) ~/ 2;
        }

        final cropped = img.copyCrop(
          bgReplaced,
          x: offsetX,
          y: offsetY,
          width: cropWidth,
          height: cropHeight,
        );

        // Step 3: Resize to 300 DPI standard resolution (30mm x 40mm)
        // 30mm = 354px, 40mm = 472px
        final targetWidth = (cccdSpec.widthMm / 25.4 * 300).round(); // 354
        final targetHeight = (cccdSpec.heightMm / 25.4 * 300).round(); // 472

        final processed = img.copyResize(
          cropped,
          width: targetWidth,
          height: targetHeight,
          interpolation: img.Interpolation.linear,
        );

        // Save processed image
        final outName = filename.split('.').first + '_cccd.jpg';
        final outFile = File('img_test/processed/$outName');
        final processedBytes = Uint8List.fromList(img.encodeJpg(processed, quality: 95));
        outFile.writeAsBytesSync(processedBytes);

        print('Saved standard CCCD image to: ${outFile.path}');
        print('Processed Resolution: ${processed.width}x${processed.height} (${cccdSpec.sizeString})');

        // Step 4: Re-validate the processed image
        // Mock faceRatio as 0.75 and isFrontal as true to verify image quality checks
        final validation = validator.validate(
          imageBytes: processedBytes,
          documentSpec: cccdSpec,
          faceRatio: 0.75,
          isFrontal: true,
        );

        print('Post-Processing Validation Result:');
        print('  - Score: ${validation.score}/100');
        print('  - Background Ok (White): ${validation.backgroundOk ? "YES" : "NO"}');
        print('  - Lighting Ok: ${validation.lightingOk ? "YES" : "NO"}');
        print('  - Sharpness Ok: ${validation.sharpnessOk ? "YES" : "NO"}');
        print('  - Shadow Free (Symmetry): ${validation.shadowFree ? "YES" : "NO"}');
        if (validation.errors.isNotEmpty) {
          print('  - Remaining Errors: ${validation.errors.join(', ')}');
        } else {
          print('  - All checks passed for Vietnamese CCCD!');
        }
      }
      print('========================================');
    });
  });
}
