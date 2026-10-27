import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_color.dart';
import '../theme/app_text_style.dart';

/// Button variants for different use cases.
enum AppButtonVariant {
  /// Filled primary button - main actions
  primary,

  /// Outlined button - secondary actions
  secondary,

  /// Text-only button - tertiary actions
  text,

  /// Destructive action (delete, cancel subscription)
  destructive,
}

/// Button sizes.
enum AppButtonSize {
  small, // height 36
  medium, // height 44
  large, // height 52
}

/// Reusable button widget with consistent styling across the app.
/// Supports loading state, icons, and different variants.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
    this.iconPosition = IconPosition.leading,
  });

  /// Button label text.
  final String label;

  /// Callback when button is pressed. Null disables the button.
  final VoidCallback? onPressed;

  /// Visual style variant.
  final AppButtonVariant variant;

  /// Button size.
  final AppButtonSize size;

  /// Shows loading indicator instead of label.
  final bool isLoading;

  /// Expands to fill available width.
  final bool isExpanded;

  /// Optional icon.
  final IconData? icon;

  /// Icon position relative to label.
  final IconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    final height = _getHeight();
    final horizontalPadding = _getHorizontalPadding();
    final fontSize = _getFontSize();
    final iconSize = _getIconSize();
    final borderRadius = BorderRadius.circular(10);

    // Colors based on variant
    final (bgColor, fgColor, borderColor) = _getColors(isDisabled);

    Widget content = isLoading
        ? SizedBox(
            width: iconSize + 4,
            height: iconSize + 4,
            child: CupertinoActivityIndicator(
              color: fgColor,
              radius: iconSize / 2,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && iconPosition == IconPosition.leading) ...[
                Icon(icon, size: iconSize, color: fgColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: AppTextStyle.button.copyWith(
                  fontSize: fontSize,
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (icon != null && iconPosition == IconPosition.trailing) ...[
                const SizedBox(width: 8),
                Icon(icon, size: iconSize, color: fgColor),
              ],
            ],
          );

    if (isExpanded) {
      content = Center(child: content);
    }

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: height,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
          border: borderColor != null ? Border.all(color: borderColor, width: 1.5) : null,
        ),
        child: content,
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 24;
      case AppButtonSize.large:
        return 32;
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppButtonSize.small:
        return 14;
      case AppButtonSize.medium:
        return 16;
      case AppButtonSize.large:
        return 17;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 22;
    }
  }

  (Color, Color, Color?) _getColors(bool isDisabled) {
    if (isDisabled) {
      switch (variant) {
        case AppButtonVariant.primary:
          return (AppColor.border, AppColor.textTertiary, null);
        case AppButtonVariant.secondary:
          return (Colors.transparent, AppColor.textTertiary, AppColor.border);
        case AppButtonVariant.text:
          return (Colors.transparent, AppColor.textTertiary, null);
        case AppButtonVariant.destructive:
          return (AppColor.border, AppColor.textTertiary, null);
      }
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return (AppColor.primary, Colors.white, null);
      case AppButtonVariant.secondary:
        return (Colors.transparent, AppColor.primary, AppColor.primary);
      case AppButtonVariant.text:
        return (Colors.transparent, AppColor.primary, null);
      case AppButtonVariant.destructive:
        return (AppColor.error, Colors.white, null);
    }
  }
}

enum IconPosition { leading, trailing }

// =============================================================================
// ICON BUTTON (Circular)
// =============================================================================

/// Circular icon button for toolbar actions.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 44,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final bg = backgroundColor ?? AppColor.surface;
    final fg = iconColor ?? (isDisabled ? AppColor.textTertiary : AppColor.textPrimary);

    final button = GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: iconSize ?? size * 0.5,
          color: fg,
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}

// =============================================================================
// TEXT LINK BUTTON
// =============================================================================

/// Simple text button that looks like a link.
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.underline = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool underline;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final textColor = color ?? (isDisabled ? AppColor.textTertiary : AppColor.primary);

    return GestureDetector(
      onTap: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: textColor,
          decoration: underline ? TextDecoration.underline : TextDecoration.none,
          decorationColor: textColor,
        ),
      ),
    );
  }
}

// =============================================================================
// FLOATING ACTION BUTTON
// =============================================================================

/// App-styled floating action button.
class AppFloatingButton extends StatelessWidget {
  const AppFloatingButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.isExtended = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? label;
  final bool isExtended;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    if (isExtended && label != null) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isDisabled ? AppColor.border : AppColor.primary,
            borderRadius: BorderRadius.circular(28),
            boxShadow: isDisabled
                ? null
                : [
                    BoxShadow(
                      color: AppColor.primary.withAlpha(60),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                label!,
                style: AppTextStyle.button.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isDisabled ? AppColor.border : AppColor.primary,
          shape: BoxShape.circle,
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: AppColor.primary.withAlpha(60),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
