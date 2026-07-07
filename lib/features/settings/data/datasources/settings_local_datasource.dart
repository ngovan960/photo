import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_id/features/settings/data/models/settings_model.dart';

class SettingsLocalDataSource {
  static const String _boxName = 'settings';
  
  Box get _box => Hive.box(_boxName);

  Future<void> init() async {
    // Box is pre-opened in main.dart
  }

  Future<void> saveSettings(SettingsModel settings) async {
    await _box.put('settings', {
      'themeMode': settings.themeMode,
      'language': settings.language,
      'notificationsEnabled': settings.notificationsEnabled,
      'biometricLockEnabled': settings.biometricLockEnabled,
      'autoDeleteDays': settings.autoDeleteDays,
      'analyticsEnabled': settings.analyticsEnabled,
      'crashReportsEnabled': settings.crashReportsEnabled,
    });
  }

  SettingsModel getSettings() {
    final data = _box.get('settings');
    if (data == null) return SettingsModel();

    final map = Map<String, dynamic>.from(data);
    return SettingsModel(
      themeMode: map['themeMode'] ?? 'system',
      language: map['language'] ?? 'en',
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      biometricLockEnabled: map['biometricLockEnabled'] ?? false,
      autoDeleteDays: map['autoDeleteDays'] ?? '7',
      analyticsEnabled: map['analyticsEnabled'] ?? true,
      crashReportsEnabled: map['crashReportsEnabled'] ?? true,
    );
  }

  Future<void> updateTheme(String themeMode) async {
    final settings = getSettings();
    await saveSettings(settings.copyWith(themeMode: themeMode));
  }

  Future<void> updateLanguage(String language) async {
    final settings = getSettings();
    await saveSettings(settings.copyWith(language: language));
  }

  Future<void> updateAutoDelete(String days) async {
    final settings = getSettings();
    await saveSettings(settings.copyWith(autoDeleteDays: days));
  }

  Future<void> resetToDefaults() async {
    await saveSettings(SettingsModel());
  }
}
