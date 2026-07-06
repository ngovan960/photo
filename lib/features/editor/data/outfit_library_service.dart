import 'dart:typed_data';
import 'dart:ui';
import 'package:photo_id/features/editor/domain/models/outfit_template.dart';

class OutfitLibraryService {
  static final List<OutfitTemplate> _templates = [];

  // Load templates (in production, load from assets)
  static Future<void> loadTemplates() async {
    // Placeholder: In production, load PNG files from assets
    // For now, create placeholder templates
    _templates.clear();

    // Male formal
    _templates.add(OutfitTemplate(
      id: 'male_formal_1',
      name: 'Áo sơ mi trắng',
      category: OutfitCategory.formal,
      gender: OutfitGender.male,
      imageBytes: Uint8List(0), // Placeholder
      defaultScale: 1.0,
      defaultPosition: const Offset(0, 0.3),
    ));

    _templates.add(OutfitTemplate(
      id: 'male_formal_2',
      name: 'Vest đen',
      category: OutfitCategory.formal,
      gender: OutfitGender.male,
      imageBytes: Uint8List(0),
      defaultScale: 1.0,
      defaultPosition: const Offset(0, 0.25),
    ));

    // Female formal
    _templates.add(OutfitTemplate(
      id: 'female_formal_1',
      name: 'Áo sơ mi nữ',
      category: OutfitCategory.formal,
      gender: OutfitGender.female,
      imageBytes: Uint8List(0),
      defaultScale: 1.0,
      defaultPosition: const Offset(0, 0.3),
    ));

    _templates.add(OutfitTemplate(
      id: 'female_formal_2',
      name: 'Vest nữ',
      category: OutfitCategory.formal,
      gender: OutfitGender.female,
      imageBytes: Uint8List(0),
      defaultScale: 1.0,
      defaultPosition: const Offset(0, 0.25),
    ));

    // Unisex
    _templates.add(OutfitTemplate(
      id: 'unisex_formal_1',
      name: 'Áo sơ mi',
      category: OutfitCategory.formal,
      gender: OutfitGender.unisex,
      imageBytes: Uint8List(0),
      defaultScale: 1.0,
      defaultPosition: const Offset(0, 0.3),
    ));
  }

  // Get all templates
  static List<OutfitTemplate> getAllTemplates() => List.from(_templates);

  // Get templates by category
  static List<OutfitTemplate> getTemplatesByCategory(String category) {
    return _templates.where((t) => t.category == category).toList();
  }

  // Get templates by gender
  static List<OutfitTemplate> getTemplatesByGender(String gender) {
    return _templates.where((t) => t.gender == gender || t.gender == OutfitGender.unisex).toList();
  }

  // Get template by id
  static OutfitTemplate? getTemplateById(String id) {
    try {
      return _templates.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
