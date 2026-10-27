import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_spacing.dart';
import '../theme/app_color.dart';
import '../theme/app_text_style.dart';

/// Brand-styled toast/snackbar helper.
/// Matches dropdown UI style for consistency.
class AppToast {
  AppToast._();

  /// Success toast - green accent
  static void success(String message, {String? title}) {
    _show(
      message: message,
      icon: Icons.check_circle_rounded,
      iconColor: AppColor.success,
      title: title,
    );
  }

  /// Error toast - red accent
  static void error(String message, {String? title}) {
    _show(
      message: message,
      icon: Icons.error_rounded,
      iconColor: AppColor.error,
      title: title,
    );
  }

  /// Warning toast - orange accent
  static void warning(String message, {String? title}) {
    _show(
      message: message,
      icon: Icons.warning_rounded,
      iconColor: AppColor.warning,
      title: title,
    );
  }

  /// Info toast - primary blue
  static void info(String message, {String? title}) {
    _show(
      message: message,
      icon: Icons.info_rounded,
      iconColor: AppColor.primary,
      title: title,
    );
  }

  /// Simple message toast
  static void show(String message) {
    _show(message: message);
  }

  /// Copied to clipboard toast
  static void copied([String? label]) {
    _show(
      message: label ?? 'Copied to clipboard',
      icon: Icons.content_copy_rounded,
      iconColor: AppColor.primary,
    );
  }

  /// Loading toast with progress indicator
  static void loading(String message) {
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: const Duration(seconds: 60),
        backgroundColor: Colors.white,
        borderRadius: AppSpacing.radiusMd,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        messageText: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Text(
                message,
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.textPrimary,
                ),
              ),
            ),
          ],
        ),
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
      ),
    );
  }

  /// Dismiss current toast
  static void dismiss() {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
  }

  /// Internal show method - matches dropdown card style
  static void _show({
    required String message,
    IconData? icon,
    Color? iconColor,
    String? title,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.white,
        borderRadius: AppSpacing.radiusMd,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.lg,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        messageText: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColor.primary).withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColor.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title,
                      style: AppTextStyle.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    message,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: title != null
                          ? AppColor.textSecondary
                          : AppColor.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
      ),
    );
  }
}
