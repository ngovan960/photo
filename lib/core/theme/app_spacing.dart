class AppSpacing {
  static const double xs = 4;     // Half unit
  static const double sm = 8;     // Base unit (Stitch)
  static const double md = 16;    // Double unit
  static const double base = 16;  // Container padding (Stitch)
  static const double lg = 24;    // Section margin
  static const double xl = 32;    // Large gap
  static const double xxl = 48;   // Extra large
  static const double xxxl = 64;  // Maximum

  static const double screenPadding = 16;  // Stitch container-padding
  static const double cardPadding = 16;
  static const double sectionGap = 24;     // Stitch section-margin
  static const double itemGap = 16;        // Stitch stack-gap
  static const double inlineGap = 8;       // Stitch gutter
}

class AppBorderRadius {
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;    // Stitch ROUND_EIGHT
  static const double md = 8;    // Stitch ROUND_EIGHT
  static const double lg = 8;    // Stitch ROUND_EIGHT
  static const double xl = 16;
  static const double full = 9999;
}

class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
}
