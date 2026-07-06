import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:photo_id/ml/retouch/retouch_service.dart';

void main() {
  // Helper to create test image
  Uint8List createTestImage({int width = 100, int height = 100}) {
    final image = img.Image(width: width, height: height);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        image.setPixelRgba(x, y, 200, 180, 160, 255);
      }
    }
    return Uint8List.fromList(img.encodeJpg(image));
  }

  group('RetouchService', () {
    test('should smooth skin', () {
      final imageBytes = createTestImage();
      final result = RetouchService.smoothSkin(imageBytes);

      expect(result, isNotNull);
      expect(result.length, greaterThan(0));
    });

    test('should brighten face', () {
      final imageBytes = createTestImage();
      final result = RetouchService.brightenFace(imageBytes, factor: 1.3);

      expect(result, isNotNull);
      expect(result.length, greaterThan(0));
    });

    test('should auto enhance', () {
      final imageBytes = createTestImage();
      final result = RetouchService.autoEnhance(imageBytes);

      expect(result, isNotNull);
      expect(result.length, greaterThan(0));
    });

    test('should apply alpha matting', () {
      final imageBytes = createTestImage();
      final result = RetouchService.alphaMatting(imageBytes);

      expect(result, isNotNull);
      expect(result.length, greaterThan(0));
    });

    test('should add drop shadow', () {
      final imageBytes = createTestImage();
      final result = RetouchService.addDropShadow(imageBytes);

      expect(result, isNotNull);
      expect(result.length, greaterThan(0));
    });

    test('should remove red eye', () {
      final imageBytes = createTestImage();
      final result = RetouchService.removeRedEye(imageBytes);

      expect(result, isNotNull);
      expect(result.length, greaterThan(0));
    });
  });
}
