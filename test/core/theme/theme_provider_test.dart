import 'package:flutter_test/flutter_test.dart';
import 'package:photo_id/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';

void main() {
  group('ThemeNotifier', () {
    test('should start with system theme', () {
      final notifier = ThemeNotifier();

      expect(notifier.state, ThemeMode.system);
      expect(notifier.isSystem, true);
    });

    test('should toggle from system to light', () {
      final notifier = ThemeNotifier();

      notifier.toggleTheme();

      expect(notifier.state, ThemeMode.light);
      expect(notifier.isLight, true);
    });

    test('should toggle from light to dark', () {
      final notifier = ThemeNotifier();
      notifier.setThemeMode(ThemeMode.light);

      notifier.toggleTheme();

      expect(notifier.state, ThemeMode.dark);
      expect(notifier.isDark, true);
    });

    test('should toggle from dark to light', () {
      final notifier = ThemeNotifier();
      notifier.setThemeMode(ThemeMode.dark);

      notifier.toggleTheme();

      expect(notifier.state, ThemeMode.light);
    });

    test('should set theme mode directly', () {
      final notifier = ThemeNotifier();

      notifier.setThemeMode(ThemeMode.dark);

      expect(notifier.state, ThemeMode.dark);
    });

    test('should return correct theme label', () {
      final notifier = ThemeNotifier();

      notifier.setThemeMode(ThemeMode.light);
      expect(notifier.themeLabel, 'Light');

      notifier.setThemeMode(ThemeMode.dark);
      expect(notifier.themeLabel, 'Dark');

      notifier.setThemeMode(ThemeMode.system);
      expect(notifier.themeLabel, 'System');
    });
  });
}
