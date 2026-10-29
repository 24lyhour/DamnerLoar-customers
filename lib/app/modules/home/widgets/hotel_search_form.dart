import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/widgets/counter_picker_sheet.dart';
import '../../../core/widgets/date_picker_sheet.dart';
import '../../../core/widgets/list_picker_sheet.dart';
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
                      isCheckIn: true,
                    )),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Obx(() => _buildDateField(
                      icon: Icons.calendar_today_outlined,
                      label: AppString.checkOut.tr,
                      date: controller.checkOutDate.value,
                      isCheckIn: false,
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
      onTap: () => _showDestinationPicker(Get.context!),
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

  void _showDestinationPicker(BuildContext context) {
    ListPickerSheet.show(
      context: context,
      title: 'Select Destination',
      items: HomeController.hotelDestinations
          .map((d) => ListPickerItem(value: d))
          .toList(),
      selectedValue: controller.hotelDestination.value,
      onSelected: controller.setHotelDestination,
      leadingIcon: Icons.location_on,
    );
  }

  void _showDatePicker(BuildContext context, bool isCheckIn) {
    final initialDate = isCheckIn ? controller.checkInDate.value : controller.checkOutDate.value;
    final firstDate = isCheckIn ? DateTime.now() : controller.checkInDate.value.add(const Duration(days: 1));

    DatePickerSheet.show(
      context: context,
      title: isCheckIn ? 'Select Check-in Date' : 'Select Check-out Date',
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      onDateSelected: (date) {
        if (isCheckIn) {
          controller.setCheckInDate(date);
        } else {
          controller.setCheckOutDate(date);
        }
      },
    );
  }

  void _showGuestsRoomsPicker(BuildContext context) {
    CounterPickerSheet.show(
      context: context,
      title: 'Guests & Rooms',
      items: [
        CounterItem(
          label: 'Guests',
          value: controller.guestCount.value,
          minValue: 1,
          maxValue: 10,
        ),
        CounterItem(
          label: 'Rooms',
          value: controller.roomCount.value,
          minValue: 1,
          maxValue: 5,
        ),
      ],
      onConfirm: (values) {
        controller.guestCount.value = values[0];
        controller.roomCount.value = values[1];
      },
    );
  }

  Widget _buildDateField({
    required IconData icon,
    required String label,
    required DateTime date,
    required bool isCheckIn,
  }) {
    return GestureDetector(
      onTap: () => _showDatePicker(Get.context!, isCheckIn),
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
      onTap: () => _showGuestsRoomsPicker(Get.context!),
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
