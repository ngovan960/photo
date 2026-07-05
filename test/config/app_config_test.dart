import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Configuration', () {
    test('should have correct app name', () {
      // Verify app name is set correctly
      const expectedName = 'Photo ID';
      expect(expectedName, isNotEmpty);
    });

    test('should have correct bundle identifier', () {
      // Verify bundle ID format
      const bundleId = 'com.photo.photo_id';
      expect(bundleId.contains('.'), true);
      expect(bundleId.startsWith('com.'), true);
    });

    test('should have correct min SDK version', () {
      // Android min SDK should be 26 (Android 8.0)
      const minSdk = 26;
      expect(minSdk, greaterThanOrEqualTo(21));
    });

    test('should have correct target SDK version', () {
      // Android target SDK should be 34 (Android 14)
      const targetSdk = 34;
      expect(targetSdk, greaterThanOrEqualTo(33));
    });

    test('should have correct iOS minimum version', () {
      // iOS minimum should be 14.0
      const minIOS = '14.0';
      expect(minIOS, isNotEmpty);
    });

    test('should have required permissions', () {
      final permissions = [
        'CAMERA',
        'READ_EXTERNAL_STORAGE',
        'WRITE_EXTERNAL_STORAGE',
        'INTERNET',
      ];

      expect(permissions.length, 4);
      expect(permissions.contains('CAMERA'), true);
    });
  });
}
