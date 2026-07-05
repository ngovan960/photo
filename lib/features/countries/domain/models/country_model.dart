class Country {
  final String code;
  final String name;
  final String nameEn;
  final String region;
  final List<Document> documents;

  const Country({
    required this.code,
    required this.name,
    required this.nameEn,
    required this.region,
    required this.documents,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      code: json['code'] as String,
      name: json['name'] as String,
      nameEn: json['nameEn'] as String,
      region: json['region'] as String,
      documents: (json['documents'] as List)
          .map((d) => Document.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }

  String get flagEmoji {
    final codePoints = code.codeUnits.map((c) => 0x1F1E6 - 65 + c).toList();
    return String.fromCharCodes(codePoints);
  }
}

class Document {
  final String id;
  final String name;
  final double widthMm;
  final double heightMm;
  final List<String> allowedBackgrounds;
  final List<String> requirements;
  final FaceRatioSpec faceRatio;

  const Document({
    required this.id,
    required this.name,
    required this.widthMm,
    required this.heightMm,
    required this.allowedBackgrounds,
    required this.requirements,
    required this.faceRatio,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    final faceRatioJson = json['faceRatio'] as Map<String, dynamic>;
    return Document(
      id: json['id'] as String,
      name: json['name'] as String,
      widthMm: (json['widthMm'] as num).toDouble(),
      heightMm: (json['heightMm'] as num).toDouble(),
      allowedBackgrounds: List<String>.from(json['allowedBackgrounds']),
      requirements: List<String>.from(json['requirements']),
      faceRatio: FaceRatioSpec.fromJson(faceRatioJson),
    );
  }

  String get sizeString => '${widthMm.toInt()}x${heightMm.toInt()} mm';
}

class FaceRatioSpec {
  final double min;
  final double max;
  final double minEye;
  final double maxEye;

  const FaceRatioSpec({
    required this.min,
    required this.max,
    required this.minEye,
    required this.maxEye,
  });

  factory FaceRatioSpec.fromJson(Map<String, dynamic> json) {
    return FaceRatioSpec(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      minEye: (json['minEye'] as num).toDouble(),
      maxEye: (json['maxEye'] as num).toDouble(),
    );
  }
}
