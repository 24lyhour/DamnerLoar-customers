import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_spacing.dart';
import '../theme/app_color.dart';
import '../theme/app_text_style.dart';

class DatePickerSheet extends StatelessWidget {
  const DatePickerSheet({
    super.key,
    required this.title,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  final String title;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateSelected;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DatePickerSheet(
        title: title,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        onDateSelected: onDateSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = initialDate.obs;

    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.subtitle.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(primary: AppColor.primary),
              ),
              child: CalendarDatePicker(
                initialDate: initialDate,
                firstDate: firstDate,
                lastDate: lastDate,
                onDateChanged: (date) => selectedDate.value = date,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onDateSelected(selectedDate.value);
                Get.back();
              },
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
    );
  }
}
