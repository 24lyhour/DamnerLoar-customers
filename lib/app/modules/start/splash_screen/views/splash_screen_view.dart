import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../controllers/splash_screen_controller.dart';
import '../widgets/splash_brand.dart';

/// S1 Splash · logo in Brand Blue, loads session and settings.
class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        // Same flat blue as the native launch screen, so the hand-off is invisible.
        backgroundColor: AppColor.primary,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const _Glow(),
            SafeArea(
              child: Obx(() {
                final exiting = controller.isExiting.value;
                return AnimatedOpacity(
                  opacity: exiting ? 0 : 1,
                  duration: SplashScreenController.exitDuration,
                  curve: Curves.easeIn,
                  child: AnimatedScale(
                    scale: exiting ? 1.08 : 1,
                    duration: SplashScreenController.exitDuration,
                    curve: Curves.easeIn,
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const Spacer(),
                          const SplashBrand(),
                          const Spacer(),
                          AnimatedOpacity(
                            opacity: controller.version.isEmpty ? 0 : 1,
                            duration: const Duration(milliseconds: 600),
                            child: Text(
                              controller.version.value,
                              style: AppTextStyle.caption.copyWith(
                                color: AppColor.textOnPrimary.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

/// Soft radial glow (lighter centre, darker edges) that fades in over the flat blue.
class _Glow extends StatelessWidget {
  const _Glow();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.15),
            radius: 1.1,
            colors: [AppColor.primary, AppColor.primaryDark],
          ),
        ),
      ),
    );
  }
}
