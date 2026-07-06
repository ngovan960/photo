import 'dart:typed_data';
import 'package:image/image.dart' as img;

class PrintService {
  // Create print layout with crop marks
  static Uint8List createPrintLayout({
    required Uint8List imageBytes,
    required int copies,
    required int paperWidth,
    required int paperHeight,
    bool showCropMarks = true,
  }) {
    final image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Failed to decode image');

    // Create paper canvas
    final paper = img.Image(
      width: paperWidth,
      height: paperHeight,
      backgroundColor: img.ColorRgb8(255, 255, 255),
    );

    // Calculate grid
    int cols, rows;
    if (copies <= 4) {
      cols = 2;
      rows = 2;
    } else {
      cols = 2;
      rows = 4;
    }

    final cellWidth = paperWidth ~/ cols;
    final cellHeight = paperHeight ~/ rows;
    final padding = 15;
    final cropMarkLength = 20;
    final cropMarkOffset = 5;

    // Resize image to fit cell
    final imgWidth = cellWidth - padding * 2;
    final imgHeight = cellHeight - padding * 2;
    final resized = img.copyResize(
      image,
      width: imgWidth,
      height: imgHeight,
      interpolation: img.Interpolation.linear,
    );

    // Place copies
    for (int i = 0; i < copies; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final x = col * cellWidth + padding;
      final y = row * cellHeight + padding;

      img.compositeImage(paper, resized, dstX: x, dstY: y);

      // Draw crop marks
      if (showCropMarks) {
        _drawCropMarks(
          paper,
          x: x,
          y: y,
          width: imgWidth,
          height: imgHeight,
          markLength: cropMarkLength,
          offset: cropMarkOffset,
        );
      }
    }

    return Uint8List.fromList(img.encodeJpg(paper, quality: 95));
  }

  // Draw crop marks around an image
  static void _drawCropMarks(
    img.Image paper, {
    required int x,
    required int y,
    required int width,
    required int height,
    required int markLength,
    required int offset,
  }) {
    final markColor = img.ColorRgb8(0, 0, 0); // Black marks
    final markWidth = 1;

    // Top-left
    _drawLine(paper, x - offset - markLength, y - offset, x - offset, y - offset, markColor, markWidth);
    _drawLine(paper, x - offset, y - offset - markLength, x - offset, y - offset, markColor, markWidth);

    // Top-right
    _drawLine(paper, x + width + offset, y - offset, x + width + offset + markLength, y - offset, markColor, markWidth);
    _drawLine(paper, x + width + offset, y - offset - markLength, x + width + offset, y - offset, markColor, markWidth);

    // Bottom-left
    _drawLine(paper, x - offset - markLength, y + height + offset, x - offset, y + height + offset, markColor, markWidth);
    _drawLine(paper, x - offset, y + height + offset, x - offset, y + height + offset + markLength, markColor, markWidth);

    // Bottom-right
    _drawLine(paper, x + width + offset, y + height + offset, x + width + offset + markLength, y + height + offset, markColor, markWidth);
    _drawLine(paper, x + width + offset, y + height + offset, x + width + offset, y + height + offset + markLength, markColor, markWidth);
  }

  // Draw a line on image
  static void _drawLine(img.Image image, int x1, int y1, int x2, int y2, img.Color color, int width) {
    // Clamp coordinates
    x1 = x1.clamp(0, image.width - 1);
    y1 = y1.clamp(0, image.height - 1);
    x2 = x2.clamp(0, image.width - 1);
    y2 = y2.clamp(0, image.height - 1);

    // Bresenham's line algorithm
    int dx = (x2 - x1).abs();
    int dy = (y2 - y1).abs();
    int sx = x1 < x2 ? 1 : -1;
    int sy = y1 < y2 ? 1 : -1;
    int err = dx - dy;

    while (true) {
      // Draw pixel and neighbors for width
      for (int wx = -width ~/ 2; wx <= width ~/ 2; wx++) {
        for (int wy = -width ~/ 2; wy <= width ~/ 2; wy++) {
          int px = (x1 + wx).clamp(0, image.width - 1);
          int py = (y1 + wy).clamp(0, image.height - 1);
          image.setPixelRgba(px, py, color.r.toInt(), color.g.toInt(), color.b.toInt(), 255);
        }
      }

      if (x1 == x2 && y1 == y2) break;

      int e2 = 2 * err;
      if (e2 > -dy) {
        err -= dy;
        x1 += sx;
      }
      if (e2 < dx) {
        err += dx;
        y1 += sy;
      }
    }
  }
}
