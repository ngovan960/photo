import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/core/utils/retry_helper.dart';
import 'package:photo_id/core/utils/performance_monitor.dart';
import 'package:photo_id/core/utils/device_capability.dart';

void main() {
  group('RetryHelper', () {
    test('should succeed on first attempt', () async {
      int attempts = 0;
      final result = await RetryHelper.withRetry<int>(
        () async {
          attempts++;
          return 42;
        },
      );

      expect(result, 42);
      expect(attempts, 1);
    });

    test('should retry on failure', () async {
      int attempts = 0;
      final result = await RetryHelper.withRetry<int>(
        () async {
          attempts++;
          if (attempts < 3) throw Exception('Failed');
          return 42;
        },
        delay: const Duration(milliseconds: 10),
      );

      expect(result, 42);
      expect(attempts, 3);
    });

    test('should throw after max retries', () async {
      int attempts = 0;
      try {
        await RetryHelper.withRetry<int>(
          () async {
            attempts++;
            throw Exception('Failed');
          },
          maxRetries: 3,
          delay: const Duration(milliseconds: 10),
        );
        fail('Should have thrown');
      } catch (e) {
        expect(attempts, 3);
      }
    });

    test('should retry based on result', () async {
      int attempts = 0;
      final result = await RetryHelper.withRetry<int>(
        () async {
          attempts++;
          return attempts;
        },
        shouldRetry: (result) => result < 3,
        delay: const Duration(milliseconds: 10),
      );

      expect(result, 3);
      expect(attempts, 3);
    });

    test('withRetryOrNull should return null on failure', () async {
      final result = await RetryHelper.withRetryOrNull<int>(
        () async {
          throw Exception('Failed');
        },
        maxRetries: 1,
        delay: const Duration(milliseconds: 10),
      );

      expect(result, isNull);
    });
  });

  group('PerformanceMonitor', () {
    setUp(() {
      PerformanceMonitor.clearAll();
    });

    test('should start and stop timer', () {
      PerformanceMonitor.startTimer('test');
      final duration = PerformanceMonitor.stopTimer('test');

      expect(duration.inMilliseconds, greaterThanOrEqualTo(0));
    });

    test('should return zero for non-existent timer', () {
      final duration = PerformanceMonitor.stopTimer('nonexistent');

      expect(duration, Duration.zero);
    });

    test('should track multiple timers', () {
      PerformanceMonitor.startTimer('timer1');
      PerformanceMonitor.startTimer('timer2');

      PerformanceMonitor.stopTimer('timer1');
      final duration2 = PerformanceMonitor.stopTimer('timer2');

      expect(duration2.inMilliseconds, greaterThanOrEqualTo(0));
    });

    test('should clear all timers', () {
      PerformanceMonitor.startTimer('timer1');
      PerformanceMonitor.startTimer('timer2');

      PerformanceMonitor.clearAll();

      expect(PerformanceMonitor.stopTimer('timer1'), Duration.zero);
      expect(PerformanceMonitor.stopTimer('timer2'), Duration.zero);
    });
  });

  group('DeviceCapability', () {
    test('should return a valid tier', () {
      final tier = DeviceCapability.getTier();

      expect(tier, isNotNull);
      expect(
        tier == DeviceTier.low ||
        tier == DeviceTier.mid ||
        tier == DeviceTier.high,
        true,
      );
    });

    test('should return valid max image size', () {
      final size = DeviceCapability.maxImageSize;

      expect(size, greaterThan(0));
    });

    test('should return valid cache size', () {
      final size = DeviceCapability.maxCacheSize;

      expect(size, greaterThan(0));
    });

    test('should return valid ML frame rate', () {
      final rate = DeviceCapability.mlFrameRate;

      expect(rate, greaterThan(0));
      expect(rate, lessThanOrEqualTo(60));
    });
  });
}
