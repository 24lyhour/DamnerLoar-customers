import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../controllers/onboard_screen_controller.dart';
import '../widgets/intro_feature_tile.dart';
import '../widgets/intro_slide.dart';
import '../widgets/page_indicator.dart';

/// S2 Intro · Bus, Hotel, Package in one app. Skip anytime.
class OnboardScreenView extends GetView<OnboardScreenController> {
  const OnboardScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    PageView(
                      controller: controller.pageController,
                      onPageChanged: controller.onPageChanged,
                      children: [
                        IntroSlide(
                          icon: Icons.directions_bus_rounded,
                          title: AppString.introTitle1.tr,
                          body: AppString.introBody1.tr,
                          child: Column(
                            children: [
                              IntroFeatureTile(
                                icon: Icons.directions_bus_outlined,
                                title: AppString.tickets.tr,
                                subtitle: AppString.ticketsDesc.tr,
                              ),
                              IntroFeatureTile(
                                icon: Icons.apartment_outlined,
                                title: AppString.hotels.tr,
                                subtitle: AppString.hotelsDesc.tr,
                              ),
                              IntroFeatureTile(
                                icon: Icons.luggage_outlined,
                                title: AppString.transportHotel.tr,
                                subtitle: AppString.transportHotelDesc.tr,
                              ),
                            ],
                          ),
                        ),
                        IntroSlide(
                          icon: Icons.event_seat_rounded,
                          title: AppString.introTitle2.tr,
                          body: AppString.introBody2.tr,
                        ),
                        IntroSlide(
                          icon: Icons.qr_code_2_rounded,
                          title: AppString.introTitle3.tr,
                          body: AppString.introBody3.tr,
                        ),
                      ],
                    ),
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.lg,
                      child: _SkipButton(onTap: controller.finish),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.md,
                  AppSpacing.screen,
                  AppSpacing.lg,
                ),
                child: Obx(
                  () => Column(
                    children: [
                      PageIndicator(
                        count: OnboardScreenController.pageCount,
                        current: controller.currentPage.value,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      ElevatedButton(
                        onPressed: controller.next,
                        child: Text(
                          controller.isLastPage
                              ? AppString.getStarted.tr
                              : AppString.next.tr,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.background,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            AppString.skip.tr,
            style: AppTextStyle.bodyBold.copyWith(color: AppColor.primary),
          ),
        ),
      ),
    );
  }
}
