import 'dart:typed_data';
import 'dart:ui';

class OutfitTemplate {
  final String id;
  final String name;
  final String category; // 'formal', 'casual', 'business'
  final String gender; // 'male', 'female', 'unisex'
  final Uint8List imageBytes;
  final double defaultScale;
  final Offset defaultPosition;

  const OutfitTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.gender,
    required this.imageBytes,
    this.defaultScale = 1.0,
    this.defaultPosition = Offset.zero,
  });
}

class OutfitCategory {
  static const String formal = 'formal';
  static const String casual = 'casual';
  static const String business = 'business';
}

class OutfitGender {
  static const String male = 'male';
  static const String female = 'female';
  static const String unisex = 'unisex';
}
