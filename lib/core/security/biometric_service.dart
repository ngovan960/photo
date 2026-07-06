import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  // Check if biometric is available
  static Future<bool> isAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  // Get available biometric types
  static Future<List<BiometricType>> getAvailableTypes() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  // Authenticate with biometrics
  static Future<bool> authenticate({
    String reason = 'Xác thực để mở Photo ID',
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // Check if device has biometrics
  static Future<bool> hasBiometrics() async {
    final types = await getAvailableTypes();
    return types.isNotEmpty;
  }

  // Get biometric type name
  static String getBiometricName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Vân tay';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Sinh trắc học mạnh';
      case BiometricType.weak:
        return 'Sinh trắc học yếu';
      default:
        return 'Không xác định';
    }
  }
}
