import 'package:flutter/material.dart';

class AppColors {
  // === Primary ===
  static const Color primary = Color(0xFF1A73E8);        // Blue 600
  static const Color primaryLight = Color(0xFF4A90E2);   // Blue 400
  static const Color primaryDark = Color(0xFF1557B0);    // Blue 800
  static const Color primarySurface = Color(0xFFE8F0FE); // Blue 50

  // === Secondary ===
  static const Color secondary = Color(0xFF5F6368);      // Gray 700
  static const Color secondaryLight = Color(0xFF9AA0A6); // Gray 400
  static const Color secondaryDark = Color(0xFF3C4043);  // Gray 800

  // === Semantic ===
  static const Color success = Color(0xFF34A853);        // Green 500
  static const Color successLight = Color(0xFFE6F4EA);   // Green 50
  static const Color warning = Color(0xFFFBBC04);        // Yellow 500
  static const Color warningLight = Color(0xFFFEF7E0);   // Yellow 50
  static const Color error = Color(0xFFEA4335);          // Red 500
  static const Color errorLight = Color(0xFFFCE8E6);     // Red 50
  static const Color info = Color(0xFF4285F4);           // Blue 500
  static const Color infoLight = Color(0xFFE8F0FE);      // Blue 50

  // === Neutral ===
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF8F9FA);
  static const Color gray100 = Color(0xFFF1F3F4);
  static const Color gray200 = Color(0xFFE8EAED);
  static const Color gray300 = Color(0xFFDADCE0);
  static const Color gray400 = Color(0xFFBDC1C6);
  static const Color gray500 = Color(0xFF9AA0A6);
  static const Color gray600 = Color(0xFF80868B);
  static const Color gray700 = Color(0xFF5F6368);
  static const Color gray800 = Color(0xFF3C4043);
  static const Color gray900 = Color(0xFF202124);
  static const Color black = Color(0xFF000000);

  // === Background Colors (for photo backgrounds) ===
  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color bgBlue = Color(0xFF4DA8DA);         // Passport blue
  static const Color bgRed = Color(0xFFDC3545);          // Chinese ID red
  static const Color bgGray = Color(0xFFB0BEC5);         // EU gray
}

class AppDarkColors {
  static const Color background = AppColors.gray900;
  static const Color surface = AppColors.gray800;
  static const Color surfaceVariant = AppColors.gray700;

  // Text
  static const Color textPrimary = AppColors.white;
  static const Color textSecondary = AppColors.gray400;

  // Border & Divider
  static const Color border = AppColors.gray700;
  static const Color divider = AppColors.gray800;

  // Semantic
  static const Color primary = AppColors.primaryLight;
  static const Color primarySurface = AppColors.primaryDark;
  static const Color success = AppColors.success;
  static const Color warning = AppColors.warning;
  static const Color error = AppColors.error;
}
