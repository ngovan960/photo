class PhotoRecord {
  final String id;
  final String countryCode;
  final String documentId;
  final DateTime createdAt;
  final String thumbnailPath;
  final String originalPath;
  final String? exportedPath;
  final int qualityScore;
  final Map<String, bool> validationResults;

  PhotoRecord({
    required this.id,
    required this.countryCode,
    required this.documentId,
    required this.createdAt,
    required this.thumbnailPath,
    required this.originalPath,
    this.exportedPath,
    this.qualityScore = 0,
    this.validationResults = const {},
  });
}
