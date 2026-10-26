import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/app_logo_widget.dart';
import '../controllers/language_controller.dart';
import '../widgets/language_option_tile.dart';

/// S3 Language · Khmer / English. Browse as guest.
class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: Obx(
              () => Column(
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  Container(
                    width: 170,
                    height: 170,
                    decoration: const BoxDecoration(
                      color: AppColor.surface,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const AppLogo(size: 110),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    AppString.chooseLanguage.tr,
                    style: AppTextStyle.headline,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppString.chooseLanguageDesc.tr,
                    style: AppTextStyle.bodySecondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  LanguageOptionTile(
                    title: 'ខ្មែរ',
                    subtitle: 'Khmer',
                    selected:
                        controller.selected.value == LanguageController.khmer,
                    onTap: () => controller.select(LanguageController.khmer),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LanguageOptionTile(
                    title: 'English',
                    subtitle: 'English',
                    selected:
                        controller.selected.value == LanguageController.english,
                    onTap: () => controller.select(LanguageController.english),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton(
                    onPressed: controller.confirm,
                    child: Text(AppString.continueText.tr),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: controller.browseAsGuest,
                    child: Text(AppString.browseAsGuest.tr),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
