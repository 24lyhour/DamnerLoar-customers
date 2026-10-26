import 'package:flutter/material.dart';

import '../theme/app_color.dart';

/// DamnerLoar logo - displays the actual brand logo image.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 120,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _buildFallback(),
    );
  }

  /// Fallback if logo image fails to load
  Widget _buildFallback() {
    return Icon(
      Icons.directions_bus_rounded,
      size: size * 0.5,
      color: AppColor.primary,
    );
  }
}
