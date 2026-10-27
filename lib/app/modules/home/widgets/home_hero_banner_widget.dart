import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';

/// Full-bleed hero banner for home screen header background.
/// Shows a single static image with gradient overlay.
class HomeHeroBanner extends StatelessWidget {
  const HomeHeroBanner({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Static banner image
          Image.asset(
            'assets/images/banners/home_banner.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) => Container(
              color: AppColor.primaryDark,
            ),
          ),
          // Gradient overlay for text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.primaryDark.withAlpha(180),
                  AppColor.primaryDark.withAlpha(220),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
