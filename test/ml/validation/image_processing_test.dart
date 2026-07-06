import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:photo_id/ml/validation/image_processing_utils.dart';

void main() {
  group('ImageProcessingUtils', () {
    late img.Image testImage;

    setUp(() {
      // Create a simple 10x10 test image
      testImage = img.Image(width: 10, height: 10);
      // Fill with gray (128, 128, 128)
      for (int y = 0; y < 10; y++) {
        for (int x = 0; x < 10; x++) {
          testImage.setPixelRgba(x, y, 128, 128, 128, 255);
        }
      }
    });

    test('toGrayscale should convert image to grayscale', () {
      final grayscale = ImageProcessingUtils.toGrayscale(testImage);
      expect(grayscale, isNotNull);
      expect(grayscale.width, 10);
      expect(grayscale.height, 10);
    });

    test('calculateBrightness should return correct value', () {
      final brightness = ImageProcessingUtils.calculateBrightness(testImage);
      // Gray image should have brightness around 128
      expect(brightness, greaterThan(100));
      expect(brightness, lessThan(160));
    });

    test('calculateBrightness should return high value for white image', () {
      final whiteImage = img.Image(width: 10, height: 10);
      for (int y = 0; y < 10; y++) {
        for (int x = 0; x < 10; x++) {
          whiteImage.setPixelRgba(x, y, 255, 255, 255, 255);
        }
      }
      final brightness = ImageProcessingUtils.calculateBrightness(whiteImage);
      expect(brightness, greaterThan(200));
    });

    test('calculateBrightness should return low value for dark image', () {
      final darkImage = img.Image(width: 10, height: 10);
      for (int y = 0; y < 10; y++) {
        for (int x = 0; x < 10; x++) {
          darkImage.setPixelRgba(x, y, 30, 30, 30, 255);
        }
      }
      final brightness = ImageProcessingUtils.calculateBrightness(darkImage);
      expect(brightness, lessThan(50));
    });

    test('calculateSharpness should return value for sharp image', () {
      // Create an image with edges (sharp)
      final sharpImage = img.Image(width: 10, height: 10);
      for (int y = 0; y < 10; y++) {
        for (int x = 0; x < 10; x++) {
          if (x < 5) {
            sharpImage.setPixelRgba(x, y, 255, 255, 255, 255); // White
          } else {
            sharpImage.setPixelRgba(x, y, 0, 0, 0, 255); // Black
          }
        }
      }
      final sharpness = ImageProcessingUtils.calculateSharpness(sharpImage);
      expect(sharpness, greaterThan(0));
    });

    test('calculateSymmetry should return low value for symmetric image', () {
      final symmetricImage = img.Image(width: 10, height: 10);
      // Fill with same brightness on both sides
      for (int y = 0; y < 10; y++) {
        for (int x = 0; x < 10; x++) {
          symmetricImage.setPixelRgba(x, y, 128, 128, 128, 255);
        }
      }
      final symmetry = ImageProcessingUtils.calculateSymmetry(symmetricImage);
      expect(symmetry, lessThan(5)); // Very symmetric
    });

    test('analyzeDominantColors should return color buckets', () {
      final buckets = ImageProcessingUtils.analyzeDominantColors(testImage);
      expect(buckets, isNotEmpty);
    });
  });
}
