import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../controllers/home_controller.dart';

class HotelSearchForm extends GetView<HomeController> {
  const HotelSearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // Destination
          _buildDestinationField(),
          const SizedBox(height: AppSpacing.md),

          // Check-in / Check-out
          Row(
            children: [
              Expanded(
                child: Obx(() => _buildDateField(
                      icon: Icons.calendar_today_outlined,
                      label: AppString.checkIn.tr,
                      date: controller.checkInDate.value,
                    )),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Obx(() => _buildDateField(
                      icon: Icons.calendar_today_outlined,
                      label: AppString.checkOut.tr,
                      date: controller.checkOutDate.value,
                    )),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Guests & Rooms
          _buildGuestsRoomsField(),
          const SizedBox(height: AppSpacing.lg),

          // Search button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.searchHotels,
              icon: const Icon(Icons.search, size: 20),
              label: Text(AppString.searchHotels.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationField() {
    return GestureDetector(
      onTap: () {
        // TODO: Open destination picker
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: AppColor.primary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.destination.tr,
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.textTertiary,
                    ),
                  ),
                  Obx(() => Text(
                        controller.hotelDestination.value,
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required IconData icon,
    required String label,
    required DateTime date,
  }) {
    return GestureDetector(
      onTap: () {
        // TODO: Open date picker
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.textSecondary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.textTertiary,
                    ),
                  ),
                  Text(
                    DateFormat('EEE d MMM').format(date),
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColor.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestsRoomsField() {
    return GestureDetector(
      onTap: () {
        // TODO: Open guests/rooms picker
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Icon(Icons.people_outline, color: AppColor.textSecondary, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.guestsRooms.tr,
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.textTertiary,
                    ),
                  ),
                  Obx(() => Text(
                        '${controller.guestCount.value} ${AppString.adults.tr} · ${controller.roomCount.value} ${AppString.rooms.tr}',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColor.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
