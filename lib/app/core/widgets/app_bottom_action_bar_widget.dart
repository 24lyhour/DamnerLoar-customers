import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../theme/app_color.dart';
import '../theme/app_text_style.dart';
import 'app_button_widget.dart';

/// Reusable bottom action bar used across booking flows.
/// Supports single button, two buttons side by side, or price + button layout.
class BottomActionBarWidget extends StatelessWidget {
  const BottomActionBarWidget({
    super.key,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.primaryLoading = false,
    this.secondaryLabel,
    this.onSecondaryPressed,
    this.tertiaryLabel,
    this.onTertiaryPressed,
    this.priceLabel,
    this.priceValue,
    this.showShadow = true,
  });

  /// Primary button (right side or full width)
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final bool primaryLoading;

  /// Secondary button (left side, outline style)
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;

  /// Tertiary button (text style, used with secondary)
  final String? tertiaryLabel;
  final VoidCallback? onTertiaryPressed;

  /// Price display (left side, replaces secondary button)
  final String? priceLabel;
  final String? priceValue;

  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    // Layout: Price + Primary button
    if (priceLabel != null && priceValue != null) {
      return Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  priceLabel!,
                  style: AppTextStyle.caption.copyWith(
                    color: AppColor.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  priceValue!,
                  style: AppTextStyle.subtitle.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            label: primaryLabel,
            onPressed: onPrimaryPressed,
            isLoading: primaryLoading,
            size: AppButtonSize.medium,
          ),
        ],
      );
    }

    // Layout: Single primary button (full width)
    if (secondaryLabel == null && tertiaryLabel == null) {
      return AppButton(
        label: primaryLabel,
        onPressed: onPrimaryPressed,
        isLoading: primaryLoading,
        isExpanded: true,
      );
    }

    // Layout: Secondary + Tertiary row, then Primary
    if (secondaryLabel != null && tertiaryLabel != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: primaryLabel,
            onPressed: onPrimaryPressed,
            isLoading: primaryLoading,
            isExpanded: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: secondaryLabel!,
                  onPressed: onSecondaryPressed,
                  variant: AppButtonVariant.secondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: tertiaryLabel!,
                  onPressed: onTertiaryPressed,
                  variant: AppButtonVariant.text,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Layout: Secondary + Primary side by side
    return Row(
      children: [
        if (secondaryLabel != null) ...[
          Expanded(
            child: AppButton(
              label: secondaryLabel!,
              onPressed: onSecondaryPressed,
              variant: AppButtonVariant.secondary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: AppButton(
            label: primaryLabel,
            onPressed: onPrimaryPressed,
            isLoading: primaryLoading,
          ),
        ),
      ],
    );
  }
}
