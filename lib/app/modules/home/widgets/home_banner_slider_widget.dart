import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';

/// Auto-scrolling banner slider for home screen header.
class HomeBannerSlider extends StatefulWidget {
  const HomeBannerSlider({super.key});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  // Banner images
  static const List<String> _bannerImages = [
    'assets/images/banners/home_banner.png',
    'assets/images/banners/home_banner_2.png',
  ];

  // Duplicate for infinite scroll effect
  List<String> get _banners => _bannerImages.length == 1
      ? [..._bannerImages, ..._bannerImages, ..._bannerImages]
      : _bannerImages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _bannerImages.length == 1 ? 1 : 0);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
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

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);

    // For single image infinite loop - jump back to middle
    if (_bannerImages.length == 1) {
      if (index == 0) {
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) {
            _pageController.jumpToPage(1);
            setState(() => _currentPage = 1);
          }
        });
      } else if (index == 2) {
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) {
            _pageController.jumpToPage(1);
            setState(() => _currentPage = 1);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Banner PageView
        PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemCount: _banners.length,
          itemBuilder: (context, index) {
            return Opacity(
              opacity: 0.35,
              child: Image.asset(
                _banners[index % _bannerImages.length],
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            );
          },
        ),

        // Page indicators (only show if multiple unique banners)
        if (_bannerImages.length > 1)
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
                  width: (_currentPage % _bannerImages.length) == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: (_currentPage % _bannerImages.length) == index
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
