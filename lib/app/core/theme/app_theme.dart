import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import 'app_color.dart';
import 'app_text_style.dart';

/// for the color brand guide line
abstract class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
    );
    const buttonSize = Size.fromHeight(AppSpacing.buttonHeight);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primary,
        primary: AppColor.primary,
        onPrimary: AppColor.textOnPrimary,
        surface: AppColor.background,
        onSurface: AppColor.textPrimary,
        error: AppColor.error,
      ),
      primaryColor: AppColor.primary,
      scaffoldBackgroundColor: AppColor.background,
      dividerColor: AppColor.divider,
      textTheme: TextTheme(
        headlineSmall: AppTextStyle.headline,
        titleLarge: AppTextStyle.title,
        titleMedium: AppTextStyle.subtitle,
        bodyLarge: AppTextStyle.body,
        bodyMedium: AppTextStyle.bodySecondary,
        bodySmall: AppTextStyle.caption,
        labelLarge: AppTextStyle.button,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.background,
        foregroundColor: AppColor.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyle.subtitle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.textOnPrimary,
          disabledBackgroundColor: AppColor.surface,
          disabledForegroundColor: AppColor.textSecondary,
          elevation: 0,
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: AppTextStyle.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.primary,
          side: const BorderSide(color: AppColor.border),
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: AppTextStyle.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColor.primary,
          minimumSize: const Size(48, 44),
          textStyle: AppTextStyle.bodyBold,
        ),
      ),
    );
  }
}
