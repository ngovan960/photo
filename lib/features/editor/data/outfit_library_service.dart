import 'package:flutter/services.dart';
import 'package:photo_id/features/editor/domain/models/outfit_template.dart';

class OutfitLibraryService {
  static final List<OutfitTemplate> _templates = [];
  static bool _loaded = false;

  static Future<void> loadTemplates() async {
    if (_loaded) return;
    _templates.clear();

    final assetPaths = {
      'vest_male': ('Vest Nam', OutfitCategory.formal, OutfitGender.male),
      'shirt_male': ('Áo sơ mi nam', OutfitCategory.formal, OutfitGender.male),
      'vest_female': ('Vest Nữ', OutfitCategory.formal, OutfitGender.female),
      'shirt_female': ('Áo sơ mi nữ', OutfitCategory.formal, OutfitGender.female),
    };

    for (final entry in assetPaths.entries) {
      final assetKey = entry.key;
      final (name, category, gender) = entry.value;

      try {
        final data = await rootBundle.load('assets/outfits/$assetKey.png');
        final bytes = data.buffer.asUint8List();

        _templates.add(OutfitTemplate(
          id: assetKey,
          name: name,
          category: category,
          gender: gender,
          imageBytes: bytes,
          defaultScale: 1.0,
          defaultPosition: const Offset(0, 0.3),
        ));
      } catch (e) {
        _templates.add(OutfitTemplate(
          id: assetKey,
          name: name,
          category: category,
          gender: gender,
          imageBytes: Uint8List(0),
          defaultScale: 1.0,
          defaultPosition: const Offset(0, 0.3),
        ));
      }
    }

    _loaded = true;
  }

  static List<OutfitTemplate> getAllTemplates() => List.from(_templates);

  static List<OutfitTemplate> getTemplatesByCategory(String category) {
    return _templates.where((t) => t.category == category).toList();
  }

  static List<OutfitTemplate> getTemplatesByGender(String gender) {
    return _templates.where((t) => t.gender == gender || t.gender == OutfitGender.unisex).toList();
  }

  static OutfitTemplate? getTemplateById(String id) {
    try {
      return _templates.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  static void reset() {
    _templates.clear();
    _loaded = false;
  }
}
