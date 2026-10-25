import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/app_logo.dart';

/// Logo, names and tagline with a staggered entrance:
/// logo fades and settles in, then each line rises into place.
class SplashBrand extends StatefulWidget {
  const SplashBrand({super.key});

  @override
  State<SplashBrand> createState() => _SplashBrandState();
}

class _SplashBrandState extends State<SplashBrand>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _interval(double begin, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(begin, end, curve: Curves.easeOutCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logo = _interval(0.0, 0.55);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: logo,
          child: ScaleTransition(
            scale: Tween(begin: 0.86, end: 1.0).animate(logo),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryDark.withValues(alpha: 0.6),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: const AppLogo(size: 128),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
        _Rise(
          animation: _interval(0.35, 0.75),
          child: Text(
            AppString.appNameKm,
            style: AppTextStyle.headline.copyWith(
              color: AppColor.textOnPrimary,
              fontSize: 30,
              height: 1.3,
            ),
          ),
        ),
        _Rise(
          animation: _interval(0.45, 0.85),
          child: Text(
            AppString.appName,
            style: AppTextStyle.headline.copyWith(
              color: AppColor.textOnPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _Rise(
          animation: _interval(0.6, 1.0),
          child: Text(
            AppString.tagline,
            style: AppTextStyle.caption.copyWith(
              color: AppColor.textOnPrimary.withValues(alpha: 0.7),
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }
}

/// Fades in while moving up a few pixels.
class _Rise extends StatelessWidget {
  const _Rise({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.4),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }
}
