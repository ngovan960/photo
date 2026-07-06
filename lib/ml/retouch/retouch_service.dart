import 'dart:typed_data';
import 'package:image/image.dart' as img;

class RetouchService {
  // Apply bilateral filter for skin smoothing
  static Uint8List smoothSkin(Uint8List imageBytes, {double strength = 0.5}) {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    // Apply gaussian blur (simplified bilateral filter)
    final blurred = img.gaussianBlur(image, radius: (3 * strength).round());

    // Blend original and blurred based on strength
    final result = img.Image(width: image.width, height: image.height);

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final original = image.getPixel(x, y);
        final blurredPixel = blurred.getPixel(x, y);

        // Blend: original * (1 - strength) + blurred * strength
        final r = (original.r * (1 - strength) + blurredPixel.r * strength).round();
        final g = (original.g * (1 - strength) + blurredPixel.g * strength).round();
        final b = (original.b * (1 - strength) + blurredPixel.b * strength).round();

        result.setPixelRgba(x, y, r, g, b, 255);
      }
    }

    return Uint8List.fromList(img.encodeJpg(result, quality: 95));
  }

  // Brighten face area
  static Uint8List brightenFace(Uint8List imageBytes, {double factor = 1.2}) {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    final result = img.Image(width: image.width, height: image.height);

    // Copy and brighten
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = (pixel.r * factor).clamp(0, 255).round();
        final g = (pixel.g * factor).clamp(0, 255).round();
        final b = (pixel.b * factor).clamp(0, 255).round();

        result.setPixelRgba(x, y, r, g, b, 255);
      }
    }

    return Uint8List.fromList(img.encodeJpg(result, quality: 95));
  }

  // Auto-enhance (brightness + contrast)
  static Uint8List autoEnhance(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    // Auto adjust levels
    final enhanced = img.adjustColor(
      image,
      brightness: 0.1,
      contrast: 1.1,
      saturation: 1.05,
    );

    return Uint8List.fromList(img.encodeJpg(enhanced, quality: 95));
  }
}
