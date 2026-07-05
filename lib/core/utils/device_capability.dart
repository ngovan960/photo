import 'dart:io';

enum DeviceTier { low, mid, high }

class DeviceCapability {
  static DeviceTier? _cachedTier;

  static DeviceTier getTier() {
    if (_cachedTier != null) return _cachedTier!;

    final ram = _getAvailableRAM();
    
    if (ram < 3000) {
      _cachedTier = DeviceTier.low;
    } else if (ram < 6000) {
      _cachedTier = DeviceTier.mid;
    } else {
      _cachedTier = DeviceTier.high;
    }

    return _cachedTier!;
  }

  static int _getAvailableRAM() {
    // Placeholder: In production, use platform channel
    // to get actual available RAM
    if (Platform.isAndroid) {
      // Estimate based on device info
      return 4000; // Default to mid-range
    } else if (Platform.isIOS) {
      // iOS devices generally have more RAM
      return 4000;
    }
    return 4000;
  }

  static bool get isLowEnd => getTier() == DeviceTier.low;
  static bool get isMidRange => getTier() == DeviceTier.mid;
  static bool get isHighEnd => getTier() == DeviceTier.high;

  static int get maxImageSize {
    switch (getTier()) {
      case DeviceTier.low:
        return 1024;
      case DeviceTier.mid:
        return 2048;
      case DeviceTier.high:
        return 4096;
    }
  }

  static int get maxCacheSize {
    switch (getTier()) {
      case DeviceTier.low:
        return 20 * 1024 * 1024; // 20MB
      case DeviceTier.mid:
        return 50 * 1024 * 1024; // 50MB
      case DeviceTier.high:
        return 100 * 1024 * 1024; // 100MB
    }
  }

  static int get mlFrameRate {
    switch (getTier()) {
      case DeviceTier.low:
        return 10; // 10 FPS
      case DeviceTier.mid:
        return 15; // 15 FPS
      case DeviceTier.high:
        return 30; // 30 FPS
    }
  }

  static Duration get mlProcessingTimeout {
    switch (getTier()) {
      case DeviceTier.low:
        return const Duration(seconds: 5);
      case DeviceTier.mid:
        return const Duration(seconds: 3);
      case DeviceTier.high:
        return const Duration(seconds: 2);
    }
  }
}
