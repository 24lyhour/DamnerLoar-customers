import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';

/// Banner widget for home screen header.
/// Shows static image for single banner, slider for multiple.
class HomeBannerSlider extends StatefulWidget {
  const HomeBannerSlider({super.key});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  // Banner images list - add more images here to enable slider
  final List<String> _bannerImages = const [
    'assets/images/banners/home_banner.png',
    // Add more banners here to enable slider:
    // 'assets/images/banners/home_banner_2.png',
  ];

  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  bool get _isSingleImage => _bannerImages.length <= 1;

  @override
  void initState() {
    super.initState();
    if (!_isSingleImage) {
      _pageController = PageController();
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    if (!_isSingleImage) {
      _pageController.dispose();
    }
    super.dispose();
  }

  void _startAutoScroll() {
    if (_isSingleImage) return;

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % _bannerImages.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // SINGLE IMAGE - static display, no slider
    if (_isSingleImage) {
      return _buildStaticBanner();
    }

    // MULTIPLE IMAGES - slider with indicators
    return _buildSlider();
  }

  Widget _buildStaticBanner() {
    return Opacity(
      opacity: 0.4,
      child: Image.asset(
        _bannerImages.first,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.topCenter,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFF174A8B),
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemCount: _bannerImages.length,
          itemBuilder: (context, index) {
            return Opacity(
              opacity: 0.4,
              child: Image.asset(
                _bannerImages[index],
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF174A8B),
                ),
              ),
            );
          },
        ),
        // Page indicators
        Positioned(
          bottom: AppSpacing.md,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _bannerImages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentPage == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.white
                      : Colors.white.withAlpha(100),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
