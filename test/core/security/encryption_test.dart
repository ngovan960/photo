import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:encrypt/encrypt.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Encryption', () {
    test('should encrypt and decrypt data', () async {
      final key = Key.fromSecureRandom(32);
      final iv = IV.fromSecureRandom(16);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      final originalData = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);

      final encrypted = encrypter.encryptBytes(originalData, iv: iv);
      expect(encrypted.bytes.length, greaterThan(originalData.length));

      final decrypted = encrypter.decryptBytes(encrypted, iv: iv);
      expect(decrypted, equals(originalData));
    });

    test('should generate different encrypted data each time', () async {
      final key = Key.fromSecureRandom(32);
      final data = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);

      final iv1 = IV.fromSecureRandom(16);
      final iv2 = IV.fromSecureRandom(16);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

      final encrypted1 = encrypter.encryptBytes(data, iv: iv1);
      final encrypted2 = encrypter.encryptBytes(data, iv: iv2);

      expect(encrypted1.bytes, isNot(equals(encrypted2.bytes)));
    });
  });
}
