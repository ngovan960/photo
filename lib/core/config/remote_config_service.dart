import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static bool _initialized = false;

  // Initialize Remote Config
  static Future<void> init() async {
    if (_initialized) return;

    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await remoteConfig.setDefaults({
      'country_rules_version': '1.0',
      'country_rules_json': '{}',
      'ab_test_variant': 'control',
      'paywall_variant': 'standard',
    });

    _initialized = true;
  }

  // Fetch and activate
  static Future<void> fetchAndActivate() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.fetchAndActivate();
    } catch (e) {
      // Use defaults if fetch fails
    }
  }

  // Get country rules from Remote Config
  static Future<Map<String, dynamic>?> getCountryRules() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      final json = remoteConfig.getString('country_rules_json');
      if (json.isEmpty || json == '{}') return null;
      return jsonDecode(json);
    } catch (e) {
      return null;
    }
  }

  // Get country rules version
  static String getCountryRulesVersion() {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      return remoteConfig.getString('country_rules_version');
    } catch (e) {
      return '1.0';
    }
  }

  // Get A/B test variant
  static String getABTestVariant() {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      return remoteConfig.getString('ab_test_variant');
    } catch (e) {
      return 'control';
    }
  }

  // Get paywall variant
  static String getPaywallVariant() {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      return remoteConfig.getString('paywall_variant');
    } catch (e) {
      return 'standard';
    }
  }

  // Get any config value
  static dynamic getValue(String key, {dynamic defaultValue}) {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      return remoteConfig.getValue(key).toString();
    } catch (e) {
      return defaultValue;
    }
  }
}
