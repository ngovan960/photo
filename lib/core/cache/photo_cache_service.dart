import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PhotoCacheService {
  static const int _maxCacheSize = 100 * 1024 * 1024; // 100MB

  late Directory _appDir;
  late Directory _originalsDir;
  late Directory _thumbnailsDir;
  late Directory _exportsDir;
  late Directory _tempDir;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    _appDir = await getApplicationDocumentsDirectory();
    _originalsDir = Directory(p.join(_appDir.path, 'originals'));
    _thumbnailsDir = Directory(p.join(_appDir.path, 'thumbnails'));
    _exportsDir = Directory(p.join(_appDir.path, 'exports'));
    _tempDir = Directory(p.join(_appDir.path, 'temp'));

    for (final dir in [_originalsDir, _thumbnailsDir, _exportsDir, _tempDir]) {
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    }

    _initialized = true;
  }

  // Save original photo
  Future<String> saveOriginal(String photoId, Uint8List bytes) async {
    await initialize();
    final filePath = p.join(_originalsDir.path, '$photoId.jpg');
    await File(filePath).writeAsBytes(bytes);
    return filePath;
  }

  // Save thumbnail
  Future<String> saveThumbnail(String photoId, Uint8List bytes) async {
    await initialize();
    final filePath = p.join(_thumbnailsDir.path, '${photoId}_thumb.webp');
    await File(filePath).writeAsBytes(bytes);
    return filePath;
  }

  // Save exported photo
  Future<String> saveExport(String photoId, Uint8List bytes, {String? suffix}) async {
    await initialize();
    final name = suffix != null ? '${photoId}_$suffix' : photoId;
    final filePath = p.join(_exportsDir.path, '$name.jpg');
    await File(filePath).writeAsBytes(bytes);
    return filePath;
  }

  // Read photo
  Future<Uint8List?> readPhoto(String path) async {
    final file = File(path);
    if (!await file.exists()) return null;
    return await file.readAsBytes();
  }

  // Delete photo
  Future<void> deletePhoto(String photoId) async {
    await initialize();
    
    final files = [
      p.join(_originalsDir.path, '$photoId.jpg'),
      p.join(_thumbnailsDir.path, '${photoId}_thumb.webp'),
      p.join(_exportsDir.path, '$photoId.jpg'),
    ];

    for (final path in files) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  // Get cache size
  Future<int> getCacheSize() async {
    await initialize();
    int totalSize = 0;

    for (final dir in [_originalsDir, _thumbnailsDir, _exportsDir]) {
      if (await dir.exists()) {
        await for (final entity in dir.list(recursive: true)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }
    }

    return totalSize;
  }

  // Clear cache
  Future<void> clearCache() async {
    await initialize();
    
    for (final dir in [_originalsDir, _thumbnailsDir, _exportsDir, _tempDir]) {
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        await dir.create(recursive: true);
      }
    }
  }

  // Evict old files if over limit
  Future<void> evictIfNeeded() async {
    final size = await getCacheSize();
    if (size <= _maxCacheSize) return;

    // Sort files by modification time and delete oldest
    final allFiles = <File>[];
    for (final dir in [_originalsDir, _thumbnailsDir]) {
      if (await dir.exists()) {
        await for (final entity in dir.list(recursive: true)) {
          if (entity is File) {
            allFiles.add(entity);
          }
        }
      }
    }

    allFiles.sort((a, b) {
      final aTime = a.lastModifiedSync();
      final bTime = b.lastModifiedSync();
      return aTime.compareTo(bTime);
    });

    int currentSize = size;
    for (final file in allFiles) {
      if (currentSize <= _maxCacheSize) break;
      final fileSize = await file.length();
      await file.delete();
      currentSize -= fileSize;
    }
  }

  // Get all photo IDs
  Future<List<String>> getAllPhotoIds() async {
    await initialize();
    final ids = <String>{};

    if (await _originalsDir.exists()) {
      await for (final entity in _originalsDir.list()) {
        if (entity is File) {
          final name = p.basename(entity.path);
          ids.add(name.replaceAll('.jpg', ''));
        }
      }
    }

    return ids.toList();
  }

  // Check if photo exists
  Future<bool> photoExists(String photoId) async {
    await initialize();
    final file = File(p.join(_originalsDir.path, '$photoId.jpg'));
    return await file.exists();
  }
}
