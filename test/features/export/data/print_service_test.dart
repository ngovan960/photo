import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/export/data/print_service.dart';
import 'package:image/image.dart' as img;

void main() {
  group('PrintService', () {
    test('should create print layout with crop marks', () {
      // Create a simple test image
      final testImage = img.Image(width: 100, height: 133); // 3:4 ratio
      for (int y = 0; y < 133; y++) {
        for (int x = 0; x < 100; x++) {
          testImage.setPixelRgba(x, y, 200, 200, 200, 255);
        }
      }
      final imageBytes = Uint8List.fromList(img.encodeJpg(testImage));

      final result = PrintService.createPrintLayout(
        imageBytes: imageBytes,
        copies: 4,
        paperWidth: 1200,
        paperHeight: 1800,
        showCropMarks: true,
      );

      expect(result, isNotNull);
      expect(result.length, greaterThan(0));
    });

    test('should create grid without crop marks', () {
      final testImage = img.Image(width: 100, height: 133);
      for (int y = 0; y < 133; y++) {
        for (int x = 0; x < 100; x++) {
          testImage.setPixelRgba(x, y, 200, 200, 200, 255);
        }
      }
      final imageBytes = Uint8List.fromList(img.encodeJpg(testImage));

      final result = PrintService.createPrintLayout(
        imageBytes: imageBytes,
        copies: 4,
        paperWidth: 1200,
        paperHeight: 1800,
        showCropMarks: false,
      );

      expect(result, isNotNull);
      expect(result.length, greaterThan(0));
    });
  });
}
