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

class PackageSearchForm extends GetView<HomeController> {
  const PackageSearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // From / To fields
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildLocationField(
                      icon: Icons.circle_outlined,
                      label: AppString.from.tr,
                      value: controller.fromCity,
                      isFrom: true,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildLocationField(
                      icon: Icons.location_on_outlined,
                      label: AppString.to.tr,
                      value: controller.toCity,
                      isFrom: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: controller.swapCities,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.border),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(
                    Icons.swap_vert,
                    color: AppColor.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Depart / Return dates
          Row(
            children: [
              Expanded(
                child: Obx(() => _buildDateField(
                      icon: Icons.calendar_today_outlined,
                      label: AppString.depart.tr,
                      date: controller.departureDate.value,
                      isDepart: true,
                    )),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Obx(() => _buildDateField(
                      icon: Icons.calendar_today_outlined,
                      label: AppString.returnDate.tr,
                      date: controller.returnDateValue.value,
                      isDepart: false,
                    )),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Travellers & Rooms
          _buildTravellersRoomsField(onTap: () => _showTravellersRoomsPicker(Get.context!)),
          const SizedBox(height: AppSpacing.lg),

          // Search button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.searchPackages,
              icon: const Icon(Icons.search, size: 20),
              label: Text(AppString.searchPackages.tr),
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

  void _showLocationPicker(BuildContext context, bool isFrom) {
    ListPickerSheet.show(
      context: context,
      title: isFrom ? 'Where from?' : 'Where to?',
      items: HomeController.cities.map((c) => ListPickerItem(value: c)).toList(),
      selectedValue: isFrom ? controller.fromCity.value : controller.toCity.value,
      onSelected: isFrom ? controller.setFromCity : controller.setToCity,
      leadingIcon: Icons.location_on,
    );
  }

  void _showDatePicker(BuildContext context, bool isDepart) {
    final initialDate = isDepart ? controller.departureDate.value : controller.returnDateValue.value;
    final firstDate = isDepart ? DateTime.now() : controller.departureDate.value.add(const Duration(days: 1));

    DatePickerSheet.show(
      context: context,
      title: isDepart ? 'Select Departure Date' : 'Select Return Date',
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      onDateSelected: isDepart ? controller.setDepartureDate : controller.setReturnDate,
    );
  }

  void _showTravellersRoomsPicker(BuildContext context) {
    CounterPickerSheet.show(
      context: context,
      title: 'Travellers & Rooms',
      items: [
        CounterItem(
          label: 'Travellers',
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

  Widget _buildLocationField({
    required IconData icon,
    required String label,
    required RxString value,
    required bool isFrom,
  }) {
    return GestureDetector(
      onTap: () => _showLocationPicker(Get.context!, isFrom),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.border),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.primary, size: 20),
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
                  Obx(() => Text(
                        value.value,
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
    required bool isDepart,
  }) {
    return GestureDetector(
      onTap: () => _showDatePicker(Get.context!, isDepart),
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

  Widget _buildTravellersRoomsField({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
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
                    AppString.travellersRooms.tr,
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
