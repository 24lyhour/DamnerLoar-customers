import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../controllers/otp_verification_controller.dart';
import '../widgets/otp_input_field.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

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
          AppString.verifyYourPhone.tr,
          style: AppTextStyle.titleMedium.copyWith(
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),

              // Title
              Text(
                AppString.enterOtpCode.tr,
                style: AppTextStyle.headlineSmall.copyWith(
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Subtitle with phone number
              Obx(() => Row(
                    children: [
                      Text(
                        '${AppString.sentTo.tr}${controller.phone.value}. ',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.changePhone,
                        child: Text(
                          AppString.change.tr,
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: AppSpacing.xxl),

              // OTP input fields
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      OtpVerificationController.otpLength,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          right:
                              index < OtpVerificationController.otpLength - 1
                                  ? AppSpacing.sm
                                  : 0,
                        ),
                        child: OtpInputField(
                          controller: controller.controllers[index],
                          focusNode: controller.focusNodes[index],
                          onChanged: (value) =>
                              controller.onDigitChanged(index, value),
                          hasError: controller.errorMessage.isNotEmpty,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: AppSpacing.lg),

              // Resend countdown / button
              Center(
                child: Obx(() {
                  if (controller.canResend) {
                    return TextButton(
                      onPressed: controller.resendCode,
                      child: Text(
                        AppString.resendCode.tr,
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  return Text(
                    '${AppString.resendCodeIn.tr}${controller.formatCountdown()}',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColor.textSecondary,
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Verify button
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed:
                          controller.canVerify ? controller.verify : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.primary,
                        side: BorderSide(
                          color: controller.canVerify
                              ? AppColor.primary
                              : AppColor.border,
                        ),
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
                                color: AppColor.primary,
                              ),
                            )
                          : Text(
                              AppString.verify.tr,
                              style: AppTextStyle.labelLarge.copyWith(
                                color: controller.canVerify
                                    ? AppColor.primary
                                    : AppColor.textTertiary,
                              ),
                            ),
                    ),
                  )),

              const Spacer(),

              // Warning text
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColor.warning.withAlpha(20),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: AppColor.warning,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        AppString.tooManyAttempts.tr,
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
