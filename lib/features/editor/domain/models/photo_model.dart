import 'dart:typed_data';

class Photo {
  final String id;
  final String countryCode;
  final String documentId;
  final DateTime createdAt;
  final Uint8List? originalBytes;
  final Uint8List? processedBytes;
  final Uint8List? thumbnailBytes;
  final int qualityScore;
  final Map<String, bool> validationResults;

  const Photo({
    required this.id,
    required this.countryCode,
    required this.documentId,
    required this.createdAt,
    this.originalBytes,
    this.processedBytes,
    this.thumbnailBytes,
    this.qualityScore = 0,
    this.validationResults = const {},
  });

  Photo copyWith({
    String? id,
    String? countryCode,
    String? documentId,
    DateTime? createdAt,
    Uint8List? originalBytes,
    Uint8List? processedBytes,
    Uint8List? thumbnailBytes,
    int? qualityScore,
    Map<String, bool>? validationResults,
    bool clearOriginal = false,
    bool clearProcessed = false,
    bool clearThumbnail = false,
  }) {
    return Photo(
      id: id ?? this.id,
      countryCode: countryCode ?? this.countryCode,
      documentId: documentId ?? this.documentId,
      createdAt: createdAt ?? this.createdAt,
      originalBytes: clearOriginal ? null : (originalBytes ?? this.originalBytes),
      processedBytes: clearProcessed ? null : (processedBytes ?? this.processedBytes),
      thumbnailBytes: clearThumbnail ? null : (thumbnailBytes ?? this.thumbnailBytes),
      qualityScore: qualityScore ?? this.qualityScore,
      validationResults: validationResults ?? this.validationResults,
    );
  }

  bool get hasOriginal => originalBytes != null;
  bool get hasProcessed => processedBytes != null;
  bool get hasThumbnail => thumbnailBytes != null;

  int get passedChecks => validationResults.values.where((v) => v).length;
  int get failedChecks => validationResults.values.where((v) => !v).length;
  bool get allChecksPassed => failedChecks == 0;
}
