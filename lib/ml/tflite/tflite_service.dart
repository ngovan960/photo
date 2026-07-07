import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class TFLiteService {
  static bool _modelLoaded = false;
  static String? _modelPath;

  // Load model from assets
  static Future<void> loadModel() async {
    if (_modelLoaded) return;

    try {
      // Copy model from assets to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final modelDir = Directory(p.join(appDir.path, 'ml_models'));
      if (!await modelDir.exists()) {
        await modelDir.create(recursive: true);
      }

      _modelPath = p.join(modelDir.path, 'selfie_segmentation.tflite');

      // Check if model already exists
      final modelFile = File(_modelPath!);
      if (!await modelFile.exists()) {
        // Copy from assets
        final ByteData data = await rootBundle.load('assets/ml/selfie_segmentation.tflite');
        final bytes = data.buffer.asUint8List();
        await modelFile.writeAsBytes(bytes);
      }

      _modelLoaded = true;
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  // Get model path
  static String? get modelPath => _modelPath;

  // Check if model is loaded
  static bool get isModelLoaded => _modelLoaded;

  // Run inference on image
  // Returns mask as Uint8List
  static Future<Uint8List?> runInference(Uint8List imageBytes) async {
    if (!_modelLoaded) {
      await loadModel();
    }

    // TODO: Implement actual TFLite inference
    // In production:
    // 1. Create interpreter from model
    // 2. Preprocess image (resize, normalize)
    // 3. Run inference
    // 4. Postprocess mask

    // Placeholder: Return null to trigger fallback to CloudAIService
    return null;
  }

  // Dispose resources
  static void dispose() {
    _modelLoaded = false;
    _modelPath = null;
  }
}
