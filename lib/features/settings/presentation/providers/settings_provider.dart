import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_id/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:photo_id/features/settings/data/models/settings_model.dart';

// Settings provider with Hive persistence
class SettingsNotifier extends StateNotifier<SettingsModel> {
  final SettingsLocalDataSource _dataSource;

  SettingsNotifier(this._dataSource) : super(SettingsModel()) {
    _loadSettings();
  }

  void _loadSettings() {
    state = _dataSource.getSettings();
  }

  Future<void> updateTheme(String themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _dataSource.saveSettings(state);
  }

  Future<void> updateLanguage(String language) async {
    state = state.copyWith(language: language);
    await _dataSource.saveSettings(state);
  }

  Future<void> updateNotifications(bool enabled) async {
    state = state.copyWith(notificationsEnabled: enabled);
    await _dataSource.saveSettings(state);
  }

  Future<void> updateBiometricLock(bool enabled) async {
    state = state.copyWith(biometricLockEnabled: enabled);
    await _dataSource.saveSettings(state);
  }

  Future<void> updateAutoDelete(String days) async {
    state = state.copyWith(autoDeleteDays: days);
    await _dataSource.saveSettings(state);
  }

  Future<void> updateAnalytics(bool enabled) async {
    state = state.copyWith(analyticsEnabled: enabled);
    await _dataSource.saveSettings(state);
  }

  Future<void> updateCrashReports(bool enabled) async {
    state = state.copyWith(crashReportsEnabled: enabled);
    await _dataSource.saveSettings(state);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsModel>((ref) {
  final dataSource = SettingsLocalDataSource();
  return SettingsNotifier(dataSource);
});
