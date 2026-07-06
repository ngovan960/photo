import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/ml/tflite/tflite_service.dart';

void main() {
  group('TFLiteService', () {
    test('should have model path as null initially', () {
      expect(TFLiteService.modelPath, isNull);
    });

    test('should report model not loaded initially', () {
      expect(TFLiteService.isModelLoaded, false);
    });

    test('should dispose correctly', () {
      TFLiteService.dispose();
      expect(TFLiteService.modelPath, isNull);
      expect(TFLiteService.isModelLoaded, false);
    });
  });
}
