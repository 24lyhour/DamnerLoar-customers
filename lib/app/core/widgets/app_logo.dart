import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../theme/app_color.dart';

/// Placeholder for the Concept #3 logo (pin + bed + road).
/// TODO: replace with the designer's vector logo asset.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 120, this.background = AppColor.background});

  final double size;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.location_on_rounded, size: size * 0.62, color: AppColor.primary),
          Positioned(
            right: size * 0.14,
            bottom: size * 0.18,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColor.primary,
                shape: BoxShape.circle,
                border: Border.all(color: background, width: 2),
              ),
              child: Icon(Icons.hotel_rounded, size: size * 0.18, color: AppColor.textOnPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
