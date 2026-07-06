import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudAIService {
  static String? _baseUrl;
  static bool _initialized = false;

  // Initialize with API endpoint
  static void init(String baseUrl) {
    _baseUrl = baseUrl;
    _initialized = true;
  }

  // Check if cloud service is available
  static bool get isAvailable => _initialized && _baseUrl != null;

  // Remove background via cloud API
  static Future<Uint8List?> removeBackground(Uint8List imageBytes) async {
    if (!isAvailable) return null;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/remove-background'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'photo.jpg',
        ),
      );

      final response = await request.send().timeout(
        const Duration(seconds: 30),
      );

      if (response.statusCode == 200) {
        return await response.stream.toBytes();
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Enhance photo via cloud API
  static Future<Uint8List?> enhancePhoto(Uint8List imageBytes) async {
    if (!isAvailable) return null;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/enhance'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'photo.jpg',
        ),
      );

      final response = await request.send().timeout(
        const Duration(seconds: 30),
      );

      if (response.statusCode == 200) {
        return await response.stream.toBytes();
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Check health
  static Future<bool> checkHealth() async {
    if (!isAvailable) return false;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
