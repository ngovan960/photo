import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_id/core/router/app_router.dart';
import 'dart:ui';
import 'app_colors.dart';

class AppTypography {
  static String? get fontFamily => GoogleFonts.inter().fontFamily;

  static bool get _isDark {
    final context = AppRouter.navigatorKey.currentContext;
    if (context != null) {
      return Theme.of(context).brightness == Brightness.dark;
    }
    return PlatformDispatcher.instance.platformBrightness == Brightness.dark;
  }

  static Color get _primaryTextColor => _isDark ? AppDarkColors.textPrimary : AppColors.gray900;
  static Color get _secondaryTextColor => _isDark ? AppDarkColors.textSecondary : AppColors.gray700;
  static Color get _mutedTextColor => _isDark ? AppDarkColors.textSecondary.withOpacity(0.8) : AppColors.gray600;
  static Color get _captionTextColor => _isDark ? AppDarkColors.textSecondary.withOpacity(0.6) : AppColors.gray500;

  static TextStyle get displayLarge => GoogleFonts.hankenGrotesk(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        height: 1.2,
        color: _primaryTextColor,
      );

  static TextStyle get displayMedium => GoogleFonts.hankenGrotesk(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.25,
        height: 1.2,
        color: _primaryTextColor,
      );

  static TextStyle get h1 => GoogleFonts.hankenGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        height: 1.3,
        color: _primaryTextColor,
      );

  static TextStyle get h2 => GoogleFonts.hankenGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
        color: _primaryTextColor,
      );

  static TextStyle get h3 => GoogleFonts.hankenGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
        color: _primaryTextColor,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.5,
        color: _primaryTextColor,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.5,
        color: _secondaryTextColor,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.5,
        color: _mutedTextColor,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
        color: _primaryTextColor,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.3,
        color: _secondaryTextColor,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.3,
        color: _mutedTextColor,
      );

  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.4,
        color: _captionTextColor,
      );
}
