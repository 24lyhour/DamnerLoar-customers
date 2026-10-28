import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/widgets/date_picker_sheet.dart';
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Destination',
              style: AppTextStyle.subtitle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.md),
            ...HomeController.hotelDestinations.map((destination) => ListTile(
                  leading: const Icon(Icons.location_on, color: AppColor.primary),
                  title: Text(destination),
                  trailing: controller.hotelDestination.value == destination
                      ? const Icon(Icons.check, color: AppColor.primary)
                      : null,
                  onTap: () {
                    controller.setHotelDestination(destination);
                    Get.back();
                  },
                )),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guests & Rooms',
              style: AppTextStyle.subtitle.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Guests
            Obx(() => _buildCounterRow(
                  label: 'Guests',
                  value: controller.guestCount.value,
                  onIncrement: controller.incrementGuests,
                  onDecrement: controller.decrementGuests,
                  minValue: 1,
                  maxValue: 10,
                )),
            const Divider(height: AppSpacing.lg),
            // Rooms
            Obx(() => _buildCounterRow(
                  label: 'Rooms',
                  value: controller.roomCount.value,
                  onIncrement: controller.incrementRooms,
                  onDecrement: controller.decrementRooms,
                  minValue: 1,
                  maxValue: 5,
                )),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                child: Text(
                  'Done',
                  style: AppTextStyle.button.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow({
    required String label,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required int minValue,
    required int maxValue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.bodyMedium),
        Row(
          children: [
            IconButton(
              onPressed: value > minValue ? onDecrement : null,
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: value > minValue ? AppColor.primary : AppColor.border,
                  ),
                ),
                child: Icon(
                  Icons.remove,
                  size: 18,
                  color: value > minValue ? AppColor.primary : AppColor.border,
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              onPressed: value < maxValue ? onIncrement : null,
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: value < maxValue ? AppColor.primary : AppColor.border,
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: 18,
                  color: value < maxValue ? AppColor.primary : AppColor.border,
                ),
              ),
            ),
          ],
        ),
      ],
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
