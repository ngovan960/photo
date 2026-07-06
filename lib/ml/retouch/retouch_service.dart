import 'dart:typed_data';
import 'package:image/image.dart' as img;

class RetouchService {
  // Alpha Matting: Feathering edges for natural hair blending
  static Uint8List alphaMatting(Uint8List imageBytes, {int featherRadius = 3}) {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    final result = img.Image(width: image.width, height: image.height);

    // Find edges using simple edge detection
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final alpha = pixel.a;

        // Check if this is an edge pixel (alpha transitions)
        bool isEdge = false;
        if (alpha > 0 && alpha < 255) {
          isEdge = true;
        } else if (alpha == 255) {
          // Check neighbors for transparency
          for (int dy = -featherRadius; dy <= featherRadius; dy++) {
            for (int dx = -featherRadius; dx <= featherRadius; dx++) {
              final nx = x + dx;
              final ny = y + dy;
              if (nx >= 0 && nx < image.width && ny >= 0 && ny < image.height) {
                final neighbor = image.getPixel(nx, ny);
                if (neighbor.a < 128) {
                  isEdge = true;
                  break;
                }
              }
            }
          }
        }

        if (isEdge) {
          // Apply feathering: blend with周围 pixels
          double avgR = 0, avgG = 0, avgB = 0;
          int count = 0;

          for (int dy = -featherRadius; dy <= featherRadius; dy++) {
            for (int dx = -featherRadius; dx <= featherRadius; dx++) {
              final nx = x + dx;
              final ny = y + dy;
              if (nx >= 0 && nx < image.width && ny >= 0 && ny < image.height) {
                final neighbor = image.getPixel(nx, ny);
                if (neighbor.a > 128) {
                  avgR += neighbor.r;
                  avgG += neighbor.g;
                  avgB += neighbor.b;
                  count++;
                }
              }
            }
          }

          if (count > 0) {
            final r = (avgR / count).round();
            final g = (avgG / count).round();
            final b = (avgB / count).round();
            result.setPixelRgba(x, y, r, g, b, 255);
          } else {
            result.setPixelRgba(x, y, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 255);
          }
        } else {
          result.setPixelRgba(x, y, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 255);
        }
      }
    }

    return Uint8List.fromList(img.encodeJpg(result, quality: 95));
  }

  // Subtle Drop Shadow behind person
  static Uint8List addDropShadow(Uint8List imageBytes, {int shadowOffset = 5, double shadowOpacity = 0.3}) {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    // Create shadow layer
    final shadow = img.Image(width: image.width + 10, height: image.height + 10);

    // Draw shadow (simplified: dark copy offset)
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        if (pixel.a > 128) {
          // Shadow position
          final sx = x + shadowOffset;
          final sy = y + shadowOffset;
          if (sx >= 0 && sx < shadow.width && sy >= 0 && sy < shadow.height) {
            final shadowAlpha = (255 * shadowOpacity).round();
            shadow.setPixelRgba(sx, sy, 0, 0, 0, shadowAlpha);
          }
        }
      }
    }

    // Composite: shadow + original
    final result = img.Image(width: shadow.width, height: shadow.height);
    for (int y = 0; y < shadow.height; y++) {
      for (int x = 0; x < shadow.width; x++) {
        final shadowPixel = shadow.getPixel(x, y);

        // Check if there's an original pixel (offset back)
        final ox = x - shadowOffset;
        final oy = y - shadowOffset;
        if (ox >= 0 && ox < image.width && oy >= 0 && oy < image.height) {
          final origPixel = image.getPixel(ox, oy);
          if (origPixel.a > 128) {
            result.setPixelRgba(x, y, origPixel.r.toInt(), origPixel.g.toInt(), origPixel.b.toInt(), 255);
            continue;
          }
        }

        // Use shadow pixel
        if (shadowPixel.a > 0) {
          result.setPixelRgba(x, y, shadowPixel.r.toInt(), shadowPixel.g.toInt(), shadowPixel.b.toInt(), shadowPixel.a.toInt());
        }
      }
    }

    return Uint8List.fromList(img.encodeJpg(result, quality: 95));
  }

  // Red-eye Removal
  static Uint8List removeRedEye(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    final result = img.Image(width: image.width, height: image.height);

    // Simple red-eye detection: look for red pixels in eye region
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        // Detect red-eye: high red, low green, low blue
        if (r > 150 && g < 100 && b < 100 && (r - g) > 80 && (r - b) > 80) {
          // Replace with dark gray (natural eye color)
          result.setPixelRgba(x, y, 40, 30, 30, 255);
        } else {
          result.setPixelRgba(x, y, r, g, b, pixel.a.toInt());
        }
      }
    }

    return Uint8List.fromList(img.encodeJpg(result, quality: 95));
  }

  // Skin smoothing (existing)
  static Uint8List smoothSkin(Uint8List imageBytes, {double strength = 0.5}) {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    final blurred = img.gaussianBlur(image, radius: (3 * strength).round());
    final result = img.Image(width: image.width, height: image.height);

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final original = image.getPixel(x, y);
        final blurredPixel = blurred.getPixel(x, y);

        final r = (original.r * (1 - strength) + blurredPixel.r * strength).round();
        final g = (original.g * (1 - strength) + blurredPixel.g * strength).round();
        final b = (original.b * (1 - strength) + blurredPixel.b * strength).round();

        result.setPixelRgba(x, y, r, g, b, 255);
      }
    }

    return Uint8List.fromList(img.encodeJpg(result, quality: 95));
  }

  // Face brightening (existing)
  static Uint8List brightenFace(Uint8List imageBytes, {double factor = 1.2}) {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    final result = img.Image(width: image.width, height: image.height);

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

  // Auto-enhance (existing)
  static Uint8List autoEnhance(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    final enhanced = img.adjustColor(
      image,
      brightness: 0.1,
      contrast: 1.1,
      saturation: 1.05,
    );

    return Uint8List.fromList(img.encodeJpg(enhanced, quality: 95));
  }
}
