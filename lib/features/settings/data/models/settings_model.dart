class SettingsModel {
  final String themeMode;
  final String language;
  final bool notificationsEnabled;
  final bool biometricLockEnabled;
  final String autoDeleteDays;
  final bool analyticsEnabled;
  final bool crashReportsEnabled;

  SettingsModel({
    this.themeMode = 'system',
    this.language = 'en',
    this.notificationsEnabled = true,
    this.biometricLockEnabled = false,
    this.autoDeleteDays = '7',
    this.analyticsEnabled = true,
    this.crashReportsEnabled = true,
  });

  SettingsModel copyWith({
    String? themeMode,
    String? language,
    bool? notificationsEnabled,
    bool? biometricLockEnabled,
    String? autoDeleteDays,
    bool? analyticsEnabled,
    bool? crashReportsEnabled,
  }) {
    return SettingsModel(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricLockEnabled: biometricLockEnabled ?? this.biometricLockEnabled,
      autoDeleteDays: autoDeleteDays ?? this.autoDeleteDays,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      crashReportsEnabled: crashReportsEnabled ?? this.crashReportsEnabled,
    );
  }
}
