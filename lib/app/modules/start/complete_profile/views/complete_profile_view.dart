import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../controllers/complete_profile_controller.dart';
import '../widgets/photo_picker.dart';
import '../widgets/profile_dropdown.dart';
import '../widgets/profile_text_field.dart';

class CompleteProfileView extends GetView<CompleteProfileController> {
  const CompleteProfileView({super.key});

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
          AppString.completeYourProfile.tr,
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

              // Photo picker
              Obx(() => PhotoPicker(
                    photoPath: controller.photoPath.value,
                    onTap: controller.pickPhoto,
                  )),
              const SizedBox(height: AppSpacing.xl),

              // Full name
              ProfileTextField(
                label: AppString.fullName.tr,
                controller: controller.nameController,
                hintText: AppString.fullNameHint.tr,
                onChanged: (_) => controller.update(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Email
              ProfileTextField(
                label: AppString.email.tr,
                controller: controller.emailController,
                hintText: AppString.emailHint.tr,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => controller.update(),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Gender and Nationality row
              Row(
                children: [
                  Expanded(
                    child: Obx(() => ProfileDropdown(
                          label: AppString.gender.tr,
                          value: controller.selectedGender.value,
                          options: controller.genderOptions,
                          onChanged: controller.setGender,
                          hintText: 'Select',
                        )),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Obx(() => ProfileDropdown(
                          label: AppString.nationality.tr,
                          value: controller.selectedNationality.value,
                          options: controller.nationalityOptions,
                          onChanged: controller.setNationality,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Trip notifications toggle
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColor.border),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppString.tripNotifications.tr,
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: AppColor.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            AppString.tripNotificationsDesc.tr,
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColor.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() => Switch(
                          value: controller.tripNotifications.value,
                          onChanged: controller.toggleNotifications,
                          activeTrackColor: AppColor.primary,
                          thumbColor: WidgetStateProperty.all(Colors.white),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Save button
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.canSave
                          ? controller.saveAndContinue
                          : null,
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
                              AppString.saveAndContinue.tr,
                              style: AppTextStyle.labelLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
