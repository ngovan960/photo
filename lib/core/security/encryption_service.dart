import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const String _keyName = 'photo_id_encryption_key';
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static Key? _encryptionKey;

  // Get or generate encryption key
  static Future<Key> getEncryptionKey() async {
    if (_encryptionKey != null) return _encryptionKey!;

    // Try to read existing key
    final existingKey = await _secureStorage.read(key: _keyName);

    if (existingKey != null) {
      _encryptionKey = Key.fromBase64(existingKey);
      return _encryptionKey!;
    }

    // Generate new key
    final newKey = Key.fromSecureRandom(32);
    await _secureStorage.write(key: _keyName, value: newKey.base64);
    _encryptionKey = newKey;

    return _encryptionKey!;
  }

  // Encrypt data
  static Future<Uint8List> encrypt(Uint8List data) async {
    final key = await getEncryptionKey();
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    final encrypted = encrypter.encryptBytes(data, iv: iv);

    // Prepend IV to encrypted data
    final result = Uint8List(iv.bytes.length + encrypted.bytes.length);
    result.setRange(0, iv.bytes.length, iv.bytes);
    result.setRange(iv.bytes.length, result.length, encrypted.bytes);

    return result;
  }

  // Decrypt data
  static Future<Uint8List> decrypt(Uint8List encryptedData) async {
    final key = await getEncryptionKey();

    // Extract IV from first 16 bytes
    final iv = IV(encryptedData.sublist(0, 16));
    final encrypted = Encrypted(encryptedData.sublist(16));

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return Uint8List.fromList(encrypter.decryptBytes(encrypted, iv: iv));
  }

  // Delete encryption key
  static Future<void> deleteKey() async {
    await _secureStorage.delete(key: _keyName);
    _encryptionKey = null;
  }
}
