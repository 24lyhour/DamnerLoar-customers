import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_color.dart';
import '../theme/app_text_style.dart';

/// Global loading overlay with premium animation.
///
/// Usage:
/// ```dart
/// AppLoadingOverlay.show(); // Show loading
/// AppLoadingOverlay.show(message: 'Searching...'); // With message
/// AppLoadingOverlay.hide(); // Hide loading
/// ```
class AppLoadingOverlay {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  /// Show the loading overlay
  static void show({String? message}) {
    if (_isShowing) return;
    _isShowing = true;

    _overlayEntry = OverlayEntry(
      builder: (context) => _LoadingOverlayWidget(message: message),
    );

    final overlay = Overlay.of(Get.overlayContext!);
    overlay.insert(_overlayEntry!);
  }

  /// Hide the loading overlay
  static void hide() {
    if (!_isShowing) return;
    _isShowing = false;

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Show loading, execute async function, then hide
  static Future<T> wrap<T>(
    Future<T> Function() asyncFunction, {
    String? message,
  }) async {
    show(message: message);
    try {
      return await asyncFunction();
    } finally {
      hide();
    }
  }
}

class _LoadingOverlayWidget extends StatefulWidget {
  const _LoadingOverlayWidget({this.message});
  final String? message;

  @override
  State<_LoadingOverlayWidget> createState() => _LoadingOverlayWidgetState();
}

class _LoadingOverlayWidgetState extends State<_LoadingOverlayWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          color: Colors.black.withAlpha((100 * _fadeAnimation.value).toInt()),
          child: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _PulsingLoader(),
                      if (widget.message != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          widget.message!,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Animated pulsing dots loader
class _PulsingLoader extends StatefulWidget {
  const _PulsingLoader();

  @override
  State<_PulsingLoader> createState() => _PulsingLoaderState();
}

class _PulsingLoaderState extends State<_PulsingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = index * 0.2;
            final value = (_controller.value - delay).clamp(0.0, 1.0);
            final bounce = _calculateBounce(value);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.translate(
                offset: Offset(0, -8 * bounce),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColor.primary.withAlpha(
                      (255 * (0.4 + 0.6 * bounce)).toInt(),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  double _calculateBounce(double value) {
    // Create a bounce effect
    if (value < 0.5) {
      return 4 * value * value * value;
    } else {
      final f = (2 * value) - 2;
      return 0.5 * f * f * f + 1;
    }
  }
}
