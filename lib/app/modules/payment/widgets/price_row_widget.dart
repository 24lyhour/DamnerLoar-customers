import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';

class PriceRow extends StatelessWidget {
  const PriceRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600)
              : AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
        ),
        Text(
          value,
          style: isBold
              ? AppTextStyle.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? AppColor.primary,
                )
              : AppTextStyle.bodySmall.copyWith(
                  color: valueColor ?? AppColor.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
        ),
      ],
    );
  }
}
