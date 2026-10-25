import 'package:flutter/material.dart';
import 'app_color.dart';

/// for the color brand guide line
abstract class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    primaryColor: AppColor.primary,
    scaffoldBackgroundColor: AppColor.background,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColor.textPrimary),
      bodyMedium: TextStyle(color: AppColor.textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
