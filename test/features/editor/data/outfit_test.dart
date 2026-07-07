import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/editor/domain/models/outfit_template.dart';
import 'package:photo_id/features/editor/data/outfit_library_service.dart';

void main() {
  group('OutfitTemplate', () {
    test('should create outfit template', () {
      final template = OutfitTemplate(
        id: 'test',
        name: 'Test Outfit',
        category: OutfitCategory.formal,
        gender: OutfitGender.male,
        imageBytes: Uint8List(0),
      );

      expect(template.id, 'test');
      expect(template.name, 'Test Outfit');
      expect(template.category, OutfitCategory.formal);
      expect(template.gender, OutfitGender.male);
    });
  });

  group('OutfitLibraryService', () {
    test('should load templates', () async {
      await OutfitLibraryService.loadTemplates();
      final templates = OutfitLibraryService.getAllTemplates();

      expect(templates, isNotEmpty);
    });

    test('should filter by category', () async {
      await OutfitLibraryService.loadTemplates();
      final formalTemplates = OutfitLibraryService.getTemplatesByCategory(OutfitCategory.formal);

      expect(formalTemplates, isNotEmpty);
      for (final t in formalTemplates) {
        expect(t.category, OutfitCategory.formal);
      }
    });

    test('should filter by gender', () async {
      await OutfitLibraryService.loadTemplates();
      final maleTemplates = OutfitLibraryService.getTemplatesByGender(OutfitGender.male);

      expect(maleTemplates, isNotEmpty);
      for (final t in maleTemplates) {
        expect(t.gender == OutfitGender.male || t.gender == OutfitGender.unisex, true);
      }
    });

    test('should get template by id', () async {
      await OutfitLibraryService.loadTemplates();
      final template = OutfitLibraryService.getTemplateById('vest_male');

      expect(template, isNotNull);
      expect(template!.id, 'vest_male');
    });

    test('should return null for non-existent id', () async {
      await OutfitLibraryService.loadTemplates();
      final template = OutfitLibraryService.getTemplateById('non_existent');

      expect(template, isNull);
    });
  });
}
