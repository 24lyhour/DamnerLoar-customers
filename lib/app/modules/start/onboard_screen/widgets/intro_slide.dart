import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';

/// One intro page: illustration on top, title, body and optional extra content.
class IntroSlide extends StatelessWidget {
  const IntroSlide({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.child,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // TODO: replace with the bus / seat / payment illustrations.
          Container(
            height: 260,
            width: double.infinity,
            color: AppColor.surface,
            alignment: Alignment.center,
            child: Icon(icon, size: 120, color: AppColor.primary),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screen),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                Text(
                  title,
                  style: AppTextStyle.headline,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  body,
                  style: AppTextStyle.bodySecondary,
                  textAlign: TextAlign.center,
                ),
                if (child != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  child!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
