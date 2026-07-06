import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    await Firebase.initializeApp();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    _initialized = true;
  }

  static Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: name,
        parameters: parameters?.map((k, v) => MapEntry(k, v)),
      );
    } catch (e) {
      // Silently fail
    }
  }

  static Future<void> logScreenView(String screenName) async {
    try {
      await FirebaseAnalytics.instance.logScreenView(
        screenName: screenName,
      );
    } catch (e) {
      // Silently fail
    }
  }

  static Future<void> setUserProperty(String name, String? value) async {
    try {
      await FirebaseAnalytics.instance.setUserProperty(
        name: name,
        value: value,
      );
    } catch (e) {
      // Silently fail
    }
  }

  static Future<void> recordError(
    dynamic error,
    StackTrace? stack, {
    String? reason,
    Map<String, dynamic>? context,
  }) async {
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: reason,
      );
    } catch (e) {
      // Silently fail
    }
  }

  static Future<void> log(String message) async {
    try {
      await FirebaseCrashlytics.instance.log(message);
    } catch (e) {
      // Silently fail
    }
  }

  static Future<void> setCustomKey(String key, dynamic value) async {
    try {
      await FirebaseCrashlytics.instance.setCustomKey(key, value);
    } catch (e) {
      // Silently fail
    }
  }
}
