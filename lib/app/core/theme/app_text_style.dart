import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

/// Inter for Latin text, Noto Sans Khmer as fallback for Khmer text.
abstract class AppTextStyle {
  const AppTextStyle._();

  static TextStyle _style(double size, FontWeight weight, [Color color = AppColor.textPrimary]) {
    return GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color).copyWith(
      fontFamilyFallback: [GoogleFonts.notoSansKhmer(fontWeight: weight).fontFamily!],
    );
  }

  /// Screen headline, e.g. "Choose your language".
  static TextStyle get headline => _style(24, FontWeight.w700);

  /// Title · Inter Bold 20, e.g. "Where are you going?".
  static TextStyle get title => _style(20, FontWeight.w700);

  static TextStyle get subtitle => _style(16, FontWeight.w600);

  /// Body · Inter Regular 14.
  static TextStyle get body => _style(14, FontWeight.w400);
  static TextStyle get bodySecondary => _style(14, FontWeight.w400, AppColor.textSecondary);
  static TextStyle get bodyBold => _style(14, FontWeight.w600);

  static TextStyle get caption => _style(12, FontWeight.w400, AppColor.textSecondary);

  static TextStyle get button => _style(16, FontWeight.w600);
}
