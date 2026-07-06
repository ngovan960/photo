import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:photo_id/features/editor/domain/models/background_color.dart';
import 'package:photo_id/ml/tflite/tflite_service.dart';
import 'package:photo_id/features/subscription/data/cloud_ai_service.dart';
import 'background_removal_service.dart';

class MediaPipeBackgroundRemovalService implements BackgroundRemovalService {
  @override
  Future<Uint8List> removeBackground(Uint8List imageBytes) async {
    // Try local TFLite first
    await TFLiteService.loadModel();
    final mask = await TFLiteService.runInference(imageBytes);

    if (mask != null) {
      // Process with local mask
      return _processMask(imageBytes, mask);
    }

    // Fallback to CloudAIService
    final cloudResult = await CloudAIService.removeBackground(imageBytes);
    if (cloudResult != null) {
      return cloudResult;
    }

    // Final fallback: return original
    return imageBytes;
  }

  // Process mask to create transparent background
  Uint8List _processMask(Uint8List imageBytes, Uint8List mask) {
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;

    final result = img.Image(width: image.width, height: image.height);

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final maskIndex = y * image.width + x;
        final maskValue = maskIndex < mask.length ? mask[maskIndex] : 255;

        if (maskValue > 128) {
          result.setPixelRgba(x, y, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt(), 255);
        } else {
          result.setPixelRgba(x, y, 0, 0, 0, 0);
        }
      }
    }

    return Uint8List.fromList(img.encodePng(result));
  }

  @override
  Future<Uint8List> changeBackground(
    Uint8List imageBytes,
    BackgroundColor color,
  ) async {
    // First remove background
    final transparentImage = await removeBackground(imageBytes);

    // Decode the transparent image
    final image = img.decodeImage(transparentImage);
    if (image == null) return imageBytes;

    // Create background color layer
    final bgColor = color.color;
    final background = img.Image(width: image.width, height: image.height);
    for (int y = 0; y < background.height; y++) {
      for (int x = 0; x < background.width; x++) {
        background.setPixelRgba(x, y, bgColor.red, bgColor.green, bgColor.blue, 255);
      }
    }

    // Composite: background + foreground (using alpha)
    final result = img.Image(width: image.width, height: image.height);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final fg = image.getPixel(x, y);
        final bg = background.getPixel(x, y);

        if (fg.a > 128) {
          // Foreground pixel
          result.setPixelRgba(x, y, fg.r.toInt(), fg.g.toInt(), fg.b.toInt(), 255);
        } else {
          // Background pixel
          result.setPixelRgba(x, y, bg.r.toInt(), bg.g.toInt(), bg.b.toInt(), 255);
        }
      }
    }

    return Uint8List.fromList(img.encodeJpg(result, quality: 95));
  }
}
