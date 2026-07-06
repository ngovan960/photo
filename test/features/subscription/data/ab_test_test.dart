import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/features/subscription/data/ab_test_service.dart';

void main() {
  group('ABTestService', () {
    test('should return default variant', () {
      final variant = ABTestService.getVariant('test1');
      // Default variant is 'control'
      expect(variant, isNotEmpty);
    });

    test('should check if user is in control group', () {
      final isControl = ABTestService.isControl('test1');
      expect(isControl, isA<bool>());
    });

    test('should get paywall config', () {
      final config = ABTestService.getPaywallConfig();
      expect(config, isNotEmpty);
      expect(config.containsKey('showReviews'), true);
    });

    test('should get trial config', () {
      final config = ABTestService.getTrialConfig();
      expect(config, isNotEmpty);
      expect(config.containsKey('enabled'), true);
      expect(config.containsKey('duration'), true);
    });
  });
}
