import 'package:flutter/material.dart';

/// Static banner widget for home screen header.
class HomeBannerSlider extends StatelessWidget {
  const HomeBannerSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: Image.asset(
        'assets/images/banners/home_banner.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.topCenter,
        errorBuilder: (context, error, stackTrace) => Container(
          color: const Color(0xFF174A8B),
        ),
      ),
    );
  }
}
