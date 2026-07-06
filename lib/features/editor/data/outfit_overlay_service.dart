import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:photo_id/features/editor/domain/models/outfit_template.dart';

class OutfitOverlayService {
  // Composite outfit onto photo
  static Uint8List compositeOutfit({
    required Uint8List photoBytes,
    required OutfitTemplate outfit,
    required double scale,
    required double offsetX,
    required double offsetY,
  }) {
    final photo = img.decodeImage(photoBytes);
    if (photo == null) return photoBytes;

    final outfitImage = img.decodeImage(outfit.imageBytes);
    if (outfitImage == null) return photoBytes;

    // Resize outfit based on scale
    final resizedOutfit = img.copyResize(
      outfitImage,
      width: (outfitImage.width * scale).round(),
      height: (outfitImage.height * scale).round(),
      interpolation: img.Interpolation.linear,
    );

    // Calculate position
    final x = (photo.width / 2 + offsetX - resizedOutfit.width / 2).round();
    final y = (photo.height * 0.3 + offsetY).round();

    // Composite
    final result = img.Image(width: photo.width, height: photo.height);

    // Copy original photo
    for (int py = 0; py < photo.height; py++) {
      for (int px = 0; px < photo.width; px++) {
        final pixel = photo.getPixel(px, py);
        result.setPixelRgba(px, py, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 255);
      }
    }

    // Overlay outfit
    for (int oy = 0; oy < resizedOutfit.height; oy++) {
      for (int ox = 0; ox < resizedOutfit.width; ox++) {
        final px = x + ox;
        final py = y + oy;

        if (px >= 0 && px < photo.width && py >= 0 && py < photo.height) {
          final outfitPixel = resizedOutfit.getPixel(ox, oy);
          if (outfitPixel.a > 128) {
            result.setPixelRgba(
              px, py,
              outfitPixel.r.toInt(),
              outfitPixel.g.toInt(),
              outfitPixel.b.toInt(),
              255,
            );
          }
        }
      }
    }

    return Uint8List.fromList(img.encodeJpg(result, quality: 95));
  }
}
