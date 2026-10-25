import 'dart:ui';

/// For brand color guide line gloabal call used every where in app
abstract class AppColor {
  const AppColor._();

  // Brand
  static const Color primary = Color(0xFF174A8B);
  static const Color primaryLight = Color(0xFFE8F0FA);
  static const Color primaryDark = Color(0xFF123866);

  // Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF3F6FA);

  // Text
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF64748B);

  // Borders and dividers
  static const Color border = Color(0xFFDCE4EE);
  static const Color divider = Color(0xFFE5E7EB);

  // Status colors (not brand colors)
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
}
