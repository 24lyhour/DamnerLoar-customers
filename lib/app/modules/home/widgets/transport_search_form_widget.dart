import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/widgets/pickers_widget/date_picker_sheet_widget.dart';
import '../../../core/widgets/pickers_widget/location_picker_sheet_widget.dart';
import '../../../core/widgets/pickers_widget/passengers_picker_sheet_widget.dart';
import '../controllers/home_controller.dart';

class TransportSearchForm extends GetView<HomeController> {
  const TransportSearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // Round-trip / One-way toggle (round-trip first as default)
          Obx(
            () => Row(
              children: [
                _buildTripTypeButton(
                  label: AppString.roundTrip.tr,
                  isSelected: controller.isRoundTrip.value,
                  onTap: () => controller.isRoundTrip.value = true,
                ),
                const SizedBox(width: AppSpacing.sm),
                _buildTripTypeButton(
                  label: AppString.oneWay.tr,
                  isSelected: !controller.isRoundTrip.value,
                  onTap: () => controller.isRoundTrip.value = false,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

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
                      onTap: () => _showLocationPicker(isFrom: true),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildLocationField(
                      icon: Icons.location_on_outlined,
                      label: AppString.to.tr,
                      value: controller.toCity,
                      onTap: () => _showLocationPicker(isFrom: false),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Swap button
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

          // Date fields - show depart only for one-way, depart + return for round-trip
          Obx(
            () => controller.isRoundTrip.value
                ? Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          icon: Icons.calendar_today_outlined,
                          label: AppString.departure.tr,
                          date: controller.departureDate.value,
                          onTap: _showRoundTripDatePicker,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildDateField(
                          icon: Icons.calendar_today_outlined,
                          label: 'Return',
                          date: controller.returnDateValue.value,
                          onTap: _showRoundTripDatePicker,
                        ),
                      ),
                    ],
                  )
                : _buildDateField(
                    icon: Icons.calendar_today_outlined,
                    label: AppString.departure.tr,
                    date: controller.departureDate.value,
                    onTap: _showDatePicker,
                  ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Passengers
          _buildPassengersField(onTap: _showPassengersPicker),
          const SizedBox(height: AppSpacing.lg),

          // Search button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.searchBuses,
              icon: const Icon(Icons.search, size: 20),
              label: Text(AppString.searchBuses.tr),
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

  Widget _buildTripTypeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primarySelected : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.border,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Text(
          label,
          style: AppTextStyle.bodySmall.copyWith(
            color: isSelected ? AppColor.primary : AppColor.textSecondary,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required IconData icon,
    required String label,
    required RxString value,
    required VoidCallback onTap,
  }) {
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
                  Obx(
                    () => Text(
                      value.value,
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildDateField({
    required IconData icon,
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
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

  Widget _buildPassengersField({required VoidCallback onTap}) {
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
            const Icon(
              Icons.people_outline,
              color: AppColor.textSecondary,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.passengers.tr,
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.textTertiary,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '${controller.adultCount.value} ${AppString.adults.tr}',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
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

  // ==================== PICKER METHODS ====================

  Future<void> _showDatePicker() async {
    final selected = await DatePickerSheet.show(
      title: 'Select departure date',
      initialDate: controller.departureDate.value,
      firstDate: DateTime.now(),
    );
    if (selected != null) {
      controller.departureDate.value = selected;
    }
  }

  Future<void> _showRoundTripDatePicker() async {
    final result = await DatePickerSheet.showRoundTrip(
      departDate: controller.departureDate.value,
      returnDate: controller.returnDateValue.value,
    );
    if (result != null) {
      controller.departureDate.value = result.depart;
      if (result.returnDate != null) {
        controller.returnDateValue.value = result.returnDate!;
      }
    }
  }

  Future<void> _showLocationPicker({required bool isFrom}) async {
    final result = await Get.bottomSheet<String>(
      LocationPickerSheet(
        title: isFrom ? 'Where from?' : 'Where to?',
        locations: cambodiaCities,
        selectedLocation: isFrom
            ? controller.fromCity.value
            : controller.toCity.value,
        popularLocations: const [
          'Phnom Penh',
          'Siem Reap',
          'Sihanoukville',
          'Kampot',
        ],
      ),
      isScrollControlled: true,
    );
    if (result != null) {
      if (isFrom) {
        controller.fromCity.value = result;
      } else {
        controller.toCity.value = result;
      }
    }
  }

  Future<void> _showPassengersPicker() async {
    final result = await PassengersPickerSheet.showForTransport(
      adults: controller.adultCount.value,
    );
    if (result != null) {
      controller.adultCount.value = result;
    }
  }
}
