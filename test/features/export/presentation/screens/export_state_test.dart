import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/export/presentation/screens/export_screen.dart';

void main() {
  group('ExportState', () {
    test('should have default values', () {
      const state = ExportState();

      expect(state.format, ExportFormat.jpeg);
      expect(state.layout, ExportLayout.single);
      expect(state.paperSize, PaperSize.fourBySix);
    });

    test('should copy with new format', () {
      const state = ExportState();
      final newState = state.copyWith(format: ExportFormat.png);

      expect(newState.format, ExportFormat.png);
      expect(newState.layout, ExportLayout.single);
    });

    test('should copy with new layout', () {
      const state = ExportState();
      final newState = state.copyWith(layout: ExportLayout.grid4);

      expect(newState.format, ExportFormat.jpeg);
      expect(newState.layout, ExportLayout.grid4);
    });

    test('should copy with new paper size', () {
      const state = ExportState();
      final newState = state.copyWith(paperSize: PaperSize.a4);

      expect(newState.format, ExportFormat.jpeg);
      expect(newState.paperSize, PaperSize.a4);
    });
  });

  group('ExportFormat', () {
    test('should have jpeg and png', () {
      expect(ExportFormat.values.length, 2);
      expect(ExportFormat.jpeg.name, 'jpeg');
      expect(ExportFormat.png.name, 'png');
    });
  });

  group('ExportLayout', () {
    test('should have single, grid4, grid8', () {
      expect(ExportLayout.values.length, 3);
      expect(ExportLayout.single.name, 'single');
      expect(ExportLayout.grid4.name, 'grid4');
      expect(ExportLayout.grid8.name, 'grid8');
    });
  });

  group('PaperSize', () {
    test('should have fourBySix, a4, a5', () {
      expect(PaperSize.values.length, 3);
      expect(PaperSize.fourBySix.name, 'fourBySix');
      expect(PaperSize.a4.name, 'a4');
      expect(PaperSize.a5.name, 'a5');
    });
  });
}
