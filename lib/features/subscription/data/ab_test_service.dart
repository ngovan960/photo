import 'package:photo_id/core/config/remote_config_service.dart';

class ABTestService {
  // Get variant for a specific test
  static String getVariant(String testId) {
    final remoteVariant = RemoteConfigService.getABTestVariant();
    return remoteVariant;
  }

  // Check if user is in control group
  static bool isControl(String testId) {
    return getVariant(testId) == 'control';
  }

  // Check if user is in variant group
  static bool isVariant(String testId, String variant) {
    return getVariant(testId) == variant;
  }

  // Log experiment exposure
  static void logExposure(String experimentId, String variant) {
    // In production, log to analytics
  }

  // Get paywall configuration based on variant
  static Map<String, dynamic> getPaywallConfig() {
    final variant = RemoteConfigService.getPaywallVariant();

    switch (variant) {
      case 'social_proof':
        return {
          'showReviews': true,
          'showUserCount': true,
          'showTestimonials': true,
        };
      case 'urgency':
        return {
          'showCountdown': true,
          'showLimitedOffer': true,
          'showExpiry': true,
        };
      case 'value':
        return {
          'showComparison': true,
          'showSavings': true,
          'showROI': true,
        };
      default:
        return {
          'showReviews': false,
          'showUserCount': false,
          'showTestimonials': false,
        };
    }
  }

  // Get trial configuration
  static Map<String, dynamic> getTrialConfig() {
    final variant = RemoteConfigService.getABTestVariant();

    switch (variant) {
      case 'trial_3day':
        return {
          'enabled': true,
          'duration': 3,
          'autoRenew': true,
        };
      case 'trial_7day':
        return {
          'enabled': true,
          'duration': 7,
          'autoRenew': true,
        };
      default:
        return {
          'enabled': false,
          'duration': 0,
          'autoRenew': false,
        };
    }
  }
}
