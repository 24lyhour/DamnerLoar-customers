import 'dart:ui';

/// Brand colour guideline (UI/UX v3.1 page 5): 3 brand colours + 2 status colours.
abstract class AppColor {
  const AppColor._();

  // Brand
  static const Color primary = Color(0xFF174A8B);
  static const Color primaryLight = Color(0xFFE8F0FA);
  static const Color primaryDark = Color(0xFF123866);

  /// Selected states: Brand Blue at 8% opacity.
  static const Color primarySelected = Color(0x14174A8B);

  // Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF3F6FA);

  // Text (neutral greys, for text and lines only)
  static const Color textPrimary = Color(0xFF1B2533);
  static const Color textSecondary = Color(0xFF6B7685);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders and dividers
  static const Color border = Color(0xFFE4E9F0);
  static const Color divider = Color(0xFFE4E9F0);

  // Status colours (functional, not brand)
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
}
