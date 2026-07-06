import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:photo_id/l10n/app_localizations.dart';

class AppLocalizationsDelegate {
  static const supportedLocales = [
    Locale('en'),
    Locale('vi'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
    Locale('th'),
    Locale('id'),
  ];

  static const localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const supportedLanguages = [
    'English',
    'Tiếng Việt',
    '日本語',
    '한국어',
    '中文',
    'ภาษาไทย',
    'Bahasa Indonesia',
  ];

  static Locale getLocaleFromLanguage(String language) {
    switch (language) {
      case 'English':
        return const Locale('en');
      case 'Tiếng Việt':
        return const Locale('vi');
      case '日本語':
        return const Locale('ja');
      case '한국어':
        return const Locale('ko');
      case '中文':
        return const Locale('zh');
      case 'ภาษาไทย':
        return const Locale('th');
      case 'Bahasa Indonesia':
        return const Locale('id');
      default:
        return const Locale('en');
    }
  }

  static String getLanguageFromLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Tiếng Việt';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      case 'th':
        return 'ภาษาไทย';
      case 'id':
        return 'Bahasa Indonesia';
      default:
        return 'English';
    }
  }
}
