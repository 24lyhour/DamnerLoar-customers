import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../controllers/home_controller.dart';

class SearchTabBar extends GetView<HomeController> {
  const SearchTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.border),
        ),
      ),
      child: Obx(() => Row(
            children: [
              _buildTab(
                icon: Icons.directions_bus_outlined,
                label: AppString.busTickets.tr,
                tab: SearchTab.transport,
              ),
              _buildTab(
                icon: Icons.apartment_outlined,
                label: AppString.hotels.tr,
                tab: SearchTab.hotel,
              ),
              _buildTab(
                icon: Icons.card_travel_outlined,
                label: AppString.transportHotel.tr,
                tab: SearchTab.package,
              ),
            ],
          )),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required SearchTab tab,
  }) {
    final isSelected = controller.currentTab.value == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setTab(tab),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Column(
                children: [
                  Icon(
                    icon,
                    color:
                        isSelected ? AppColor.primary : AppColor.textSecondary,
                    size: 24,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.caption.copyWith(
                      color: isSelected
                          ? AppColor.primary
                          : AppColor.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Animated indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              height: 2,
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
