import 'package:image/image.dart' as img;

class ImageProcessingUtils {
  // Convert to grayscale
  static img.Image toGrayscale(img.Image image) {
    return img.grayscale(image);
  }

  // Calculate average brightness (0-255)
  static double calculateBrightness(img.Image image) {
    final grayscale = toGrayscale(image);
    int totalBrightness = 0;
    int pixelCount = 0;

    for (int y = 0; y < grayscale.height; y++) {
      for (int x = 0; x < grayscale.width; x++) {
        final pixel = grayscale.getPixel(x, y);
        totalBrightness += pixel.r.toInt();
        pixelCount++;
      }
    }

    return totalBrightness / pixelCount;
  }

  // Calculate Laplacian variance (sharpness measure)
  static double calculateSharpness(img.Image image) {
    final grayscale = toGrayscale(image);
    final width = grayscale.width;
    final height = grayscale.height;

    if (width < 3 || height < 3) return 0;

    double sum = 0;
    double sumSquared = 0;
    int count = 0;

    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        final center = grayscale.getPixel(x, y).r.toDouble();
        final top = grayscale.getPixel(x, y - 1).r.toDouble();
        final bottom = grayscale.getPixel(x, y + 1).r.toDouble();
        final left = grayscale.getPixel(x - 1, y).r.toDouble();
        final right = grayscale.getPixel(x + 1, y).r.toDouble();

        // Laplacian kernel: [0,1,0; 1,-4,1; 0,1,0]
        final laplacian = top + bottom + left + right - 4 * center;

        sum += laplacian;
        sumSquared += laplacian * laplacian;
        count++;
      }
    }

    // Variance = E[X^2] - (E[X])^2
    final mean = sum / count;
    final variance = (sumSquared / count) - (mean * mean);

    return variance;
  }

  // Calculate left-right brightness symmetry (shadow detection)
  static double calculateSymmetry(img.Image image, {double faceLeft = 0.3, double faceRight = 0.7}) {
    final grayscale = toGrayscale(image);
    final width = grayscale.width;
    final height = grayscale.height;

    final leftStart = (width * faceLeft).toInt();
    final leftEnd = (width * 0.5).toInt();
    final rightStart = (width * 0.5).toInt();
    final rightEnd = (width * faceRight).toInt();

    double leftBrightness = 0;
    int leftCount = 0;
    double rightBrightness = 0;
    int rightCount = 0;

    for (int y = 0; y < height; y++) {
      for (int x = leftStart; x < leftEnd; x++) {
        leftBrightness += grayscale.getPixel(x, y).r.toDouble();
        leftCount++;
      }
      for (int x = rightStart; x < rightEnd; x++) {
        rightBrightness += grayscale.getPixel(x, y).r.toDouble();
        rightCount++;
      }
    }

    final leftAvg = leftCount > 0 ? leftBrightness / leftCount : 0;
    final rightAvg = rightCount > 0 ? rightBrightness / rightCount : 0;

    // Return difference (0 = perfect symmetry, higher = more shadow)
    return (leftAvg - rightAvg).abs().toDouble();
  }

  // Analyze dominant color in background region
  static Map<int, int> analyzeDominantColors(img.Image image, {double faceTop = 0.3, double faceBottom = 0.7}) {
    final width = image.width;
    final height = image.height;

    final topRegion = (height * 0.1).toInt();
    final bottomRegion = (height * 0.9).toInt();

    final colorBuckets = <int, int>{};

    // Sample top and bottom regions (background areas)
    for (int y = 0; y < topRegion; y++) {
      for (int x = 0; x < width; x += 4) { // Sample every 4th pixel
        final pixel = image.getPixel(x, y);
        final bucket = _colorBucket(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
        colorBuckets[bucket] = (colorBuckets[bucket] ?? 0) + 1;
      }
    }

    for (int y = bottomRegion; y < height; y++) {
      for (int x = 0; x < width; x += 4) {
        final pixel = image.getPixel(x, y);
        final bucket = _colorBucket(pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
        colorBuckets[bucket] = (colorBuckets[bucket] ?? 0) + 1;
      }
    }

    return colorBuckets;
  }

  // Map color to bucket (simplified)
  static int _colorBucket(int r, int g, int b) {
    // White: r>200, g>200, b>200
    if (r > 200 && g > 200 && b > 200) return 0;
    // Blue: b > 150, r < 100
    if (b > 150 && r < 100) return 1;
    // Red: r > 150, g < 100, b < 100
    if (r > 150 && g < 100 && b < 100) return 2;
    // Gray: all channels close
    if ((r - g).abs() < 30 && (g - b).abs() < 30) return 3;
    // Other
    return 4;
  }

  // Check if background color matches allowed list
  static bool isBackgroundAllowed(Map<int, int> colorBuckets, List<String> allowed) {
    final dominantBucket = _getDominantBucket(colorBuckets);

    for (final allowedColor in allowed) {
      switch (allowedColor) {
        case 'white':
          if (dominantBucket == 0) return true;
          break;
        case 'blue':
          if (dominantBucket == 1) return true;
          break;
        case 'red':
          if (dominantBucket == 2) return true;
          break;
        case 'gray':
          if (dominantBucket == 3) return true;
          break;
      }
    }

    return false;
  }

  static int _getDominantBucket(Map<int, int> buckets) {
    int maxCount = 0;
    int dominantBucket = 0;

    for (final entry in buckets.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        dominantBucket = entry.key;
      }
    }

    return dominantBucket;
  }
}
