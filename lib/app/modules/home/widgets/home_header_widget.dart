import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_text_style.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/logo/logo.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.directions_bus_rounded,
                        color: Color(0xFF174A8B),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.appNameKm,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    AppString.appName,
                    style: AppTextStyle.caption.copyWith(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Language toggle
          GestureDetector(
            onTap: _toggleLanguage,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white38),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language, color: Colors.white, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    Get.locale?.languageCode.toUpperCase() ?? 'EN',
                    style: AppTextStyle.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          // Notifications
          IconButton(
            onPressed: () {
              // TODO: Navigate to notifications
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleLanguage() {
    final current = Get.locale?.languageCode ?? 'en';
    final newCode = current == 'en' ? 'km' : 'en';
    Get.updateLocale(Locale(newCode));
    StorageService.to.setLanguageCode(newCode);
  }
}
