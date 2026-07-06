import 'dart:typed_data';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PdfExportService {
  // Export single photo as PDF
  static Future<String> exportSinglePhoto({
    required Uint8List imageBytes,
    required double widthMm,
    required double heightMm,
    String? fileName,
  }) async {
    final pdf = pw.Document();

    // Convert mm to points (1mm = 2.835 points)
    final widthPoints = widthMm * 2.835;
    final heightPoints = heightMm * 2.835;

    // Create page with photo
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(widthPoints, heightPoints),
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Image(
                  pw.MemoryImage(imageBytes),
                  fit: pw.BoxFit.contain,
                ),
          );
        },
      ),
    );

    // Save PDF
    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(dir.path, 'exports'));
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    final name = fileName ?? 'photo_${DateTime.now().millisecondsSinceEpoch}';
    final filePath = p.join(exportDir.path, '$name.pdf');
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  // Export grid layout as PDF
  static Future<String> exportGridLayout({
    required Uint8List imageBytes,
    required int copies,
    required double paperWidthMm,
    required double paperHeightMm,
    String? fileName,
  }) async {
    final pdf = pw.Document();

    // Convert mm to points
    final widthPoints = paperWidthMm * 2.835;
    final heightPoints = paperHeightMm * 2.835;

    // Calculate grid
    int cols, rows;
    if (copies <= 4) {
      cols = 2;
      rows = 2;
    } else {
      cols = 2;
      rows = 4;
    }

    final cellWidth = widthPoints / cols;
    final cellHeight = heightPoints / rows;
    final padding = 10.0;

    // Create page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(widthPoints, heightPoints),
        build: (pw.Context context) {
          return pw.Stack(
            children: List.generate(copies, (i) {
              final col = i % cols;
              final row = i ~/ cols;
              final x = col * cellWidth + padding;
              final y = row * cellHeight + padding;

              return pw.Positioned(
                left: x,
                top: y,
                child: pw.Container(
                  width: cellWidth - padding * 2,
                  height: cellHeight - padding * 2,
                  child: pw.Image(
                    pw.MemoryImage(imageBytes),
                    fit: pw.BoxFit.contain,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );

    // Save PDF
    final dir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(dir.path, 'exports'));
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    final name = fileName ?? 'photo_grid_${DateTime.now().millisecondsSinceEpoch}';
    final filePath = p.join(exportDir.path, '$name.pdf');
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }
}
