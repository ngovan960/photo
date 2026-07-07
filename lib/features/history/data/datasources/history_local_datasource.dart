import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_id/features/history/data/models/photo_record.dart';

class HistoryLocalDataSource {
  static const String _boxName = 'photos';

  Box get _box => Hive.box(_boxName);

  Future<void> init() async {
    // Box is pre-opened in main.dart
  }

  Future<void> savePhoto(PhotoRecord photo) async {
    await _box.put(photo.id, {
      'id': photo.id,
      'countryCode': photo.countryCode,
      'documentId': photo.documentId,
      'createdAt': photo.createdAt.toIso8601String(),
      'thumbnailPath': photo.thumbnailPath,
      'originalPath': photo.originalPath,
      'exportedPath': photo.exportedPath,
      'qualityScore': photo.qualityScore,
      'validationResults': photo.validationResults,
    });
  }

  PhotoRecord? getPhoto(String id) {
    final data = _box.get(id);
    if (data == null) return null;

    final map = Map<String, dynamic>.from(data);
    return PhotoRecord(
      id: map['id'],
      countryCode: map['countryCode'],
      documentId: map['documentId'],
      createdAt: DateTime.parse(map['createdAt']),
      thumbnailPath: map['thumbnailPath'],
      originalPath: map['originalPath'],
      exportedPath: map['exportedPath'],
      qualityScore: map['qualityScore'] ?? 0,
      validationResults: Map<String, bool>.from(map['validationResults'] ?? {}),
    );
  }

  List<PhotoRecord> getAllPhotos() {
    final photos = <PhotoRecord>[];
    for (final key in _box.keys) {
      final photo = getPhoto(key);
      if (photo != null) {
        photos.add(photo);
      }
    }
    // Sort by createdAt descending
    photos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return photos;
  }

  List<PhotoRecord> getPhotosByCountry(String countryCode) {
    return getAllPhotos().where((p) => p.countryCode == countryCode).toList();
  }

  Future<void> deletePhoto(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }

  int get photoCount => _box.length;
}
