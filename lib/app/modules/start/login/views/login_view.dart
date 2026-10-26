import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../controllers/login_controller.dart';
import '../widgets/phone_input_field.dart';
import '../widgets/social_login_button.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppString.logInOrSignUp.tr,
          style: AppTextStyle.titleMedium.copyWith(
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),

              // Title
              Text(
                AppString.enterPhoneNumber.tr,
                style: AppTextStyle.headlineSmall.copyWith(
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Subtitle
              Text(
                AppString.enterPhoneNumberDesc.tr,
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Phone input
              PhoneInputField(
                controller: controller.phoneController,
                onChanged: (_) => controller.update(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Terms checkbox
              Obx(() => _TermsCheckbox(
                    value: controller.agreedToTerms.value,
                    onChanged: controller.toggleTerms,
                  )),
              const SizedBox(height: AppSpacing.xl),

              // Send code button
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          controller.canSubmit ? controller.sendCode : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColor.primary.withAlpha(100),
                        disabledForegroundColor: Colors.white70,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md + 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              AppString.sendCode.tr,
                              style: AppTextStyle.labelLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  )),
              const SizedBox(height: AppSpacing.xl),

              // Divider with "or continue with"
              Row(
                children: [
                  Expanded(child: Divider(color: AppColor.border)),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      AppString.orContinueWith.tr,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.textTertiary,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColor.border)),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Social login buttons
              Row(
                children: [
                  Expanded(
                    child: SocialLoginButton(
                      label: 'Google',
                      icon: _buildGoogleIcon(),
                      onPressed: controller.continueWithGoogle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: SocialLoginButton(
                      label: 'Apple',
                      icon: const Icon(
                        Icons.apple,
                        size: 20,
                        color: AppColor.textPrimary,
                      ),
                      onPressed: controller.continueWithApple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Info text
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: AppColor.textTertiary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      AppString.loginNotNeeded.tr,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColor.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: BorderSide(color: AppColor.border, width: 1.5),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColor.textSecondary,
              ),
              children: [
                TextSpan(text: AppString.agreeToTerms.tr),
                TextSpan(
                  text: AppString.terms.tr,
                  style: const TextStyle(color: AppColor.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // TODO: Open terms
                    },
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: AppString.privacyPolicy.tr,
                  style: const TextStyle(color: AppColor.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // TODO: Open privacy policy
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Draws Google's "G" logo.
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Blue arc (right side)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.5,
      1.8,
      true,
      paint,
    );

    // Green arc (bottom right)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      1.3,
      1.2,
      true,
      paint,
    );

    // Yellow arc (bottom left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.5,
      1.0,
      true,
      paint,
    );

    // Red arc (top left)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.5,
      1.3,
      true,
      paint,
    );

    // White center circle
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.55, paint);

    // Blue bar (right side of G)
    paint.color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - radius * 0.1,
        center.dy - radius * 0.2,
        radius * 1.1,
        radius * 0.4,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
