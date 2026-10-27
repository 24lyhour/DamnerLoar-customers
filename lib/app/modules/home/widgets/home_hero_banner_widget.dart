import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';

/// Full-bleed hero banner for home screen header background.
class HomeHeroBanner extends StatefulWidget {
  const HomeHeroBanner({super.key, required this.height});

  final double height;

  @override
  State<HomeHeroBanner> createState() => _HomeHeroBannerState();
}

class _HomeHeroBannerState extends State<HomeHeroBanner> {
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  static const List<String> _banners = [
    'assets/images/banners/home_banner.png',
    'assets/images/banners/home_banner_2.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
      final nextPage = (_currentPage + 1) % _banners.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Banner images
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _banners[index],
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColor.primaryDark,
                ),
              );
            },
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
