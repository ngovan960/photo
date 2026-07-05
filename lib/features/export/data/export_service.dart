import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:photo_id/features/export/presentation/screens/export_screen.dart';

class ExportService {
  Future<String> exportPhoto({
    required Uint8List imageBytes,
    required ExportFormat format,
    required ExportLayout layout,
    required PaperSize paperSize,
    String? fileName,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(dir.path, 'exports'));
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    final name = fileName ?? 'photo_${DateTime.now().millisecondsSinceEpoch}';
    final ext = format == ExportFormat.jpeg ? 'jpg' : 'png';
    final filePath = p.join(exportDir.path, '$name.$ext');

    if (layout == ExportLayout.single) {
      // Single photo
      await _saveImage(imageBytes, filePath, format);
    } else {
      // Grid layout
      final gridBytes = await _createGrid(imageBytes, layout, paperSize);
      await _saveImage(gridBytes, filePath, format);
    }

    return filePath;
  }

  Future<Uint8List> _createGrid(
    Uint8List imageBytes,
    ExportLayout layout,
    PaperSize paperSize,
  ) async {
    final image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Failed to decode image');

    final copies = layout == ExportLayout.grid4 ? 4 : 8;
    final paperWidth = _getPaperWidth(paperSize);
    final paperHeight = _getPaperHeight(paperSize);

    // Create paper canvas
    final paper = img.Image(
      width: paperWidth,
      height: paperHeight,
      backgroundColor: img.ColorRgb8(255, 255, 255),
    );

    // Calculate grid layout
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
    final padding = 10;

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
    }

    return Uint8List.fromList(img.encodeJpg(paper, quality: 95));
  }

  int _getPaperWidth(PaperSize paperSize) {
    switch (paperSize) {
      case PaperSize.fourBySix:
        return 1200; // 4 inches at 300 DPI
      case PaperSize.a4:
        return 2480; // 210mm at 300 DPI
      case PaperSize.a5:
        return 1748; // 148mm at 300 DPI
    }
  }

  int _getPaperHeight(PaperSize paperSize) {
    switch (paperSize) {
      case PaperSize.fourBySix:
        return 1800; // 6 inches at 300 DPI
      case PaperSize.a4:
        return 3508; // 297mm at 300 DPI
      case PaperSize.a5:
        return 2480; // 210mm at 300 DPI
    }
  }

  Future<void> _saveImage(Uint8List bytes, String path, ExportFormat format) async {
    final file = File(path);
    if (format == ExportFormat.jpeg) {
      final image = img.decodeImage(bytes);
      if (image != null) {
        await file.writeAsBytes(img.encodeJpg(image, quality: 95));
      }
    } else {
      await file.writeAsBytes(bytes);
    }
  }

  Future<void> sharePhoto(String filePath) async {
    await Share.shareXFiles([XFile(filePath)], text: 'Ảnh thẻ từ Photo ID');
  }

  Future<Uint8List> stripExif(Uint8List imageBytes) async {
    // Re-encode image to strip EXIF data
    final image = img.decodeImage(imageBytes);
    if (image == null) return imageBytes;
    return Uint8List.fromList(img.encodeJpg(image, quality: 95));
  }
}
