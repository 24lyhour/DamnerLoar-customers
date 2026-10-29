import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_spacing.dart';
import '../theme/app_color.dart';
import '../theme/app_text_style.dart';

class OptionItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const OptionItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

class OptionPickerSheet<T> extends StatelessWidget {
  const OptionPickerSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  final String title;
  final List<OptionItem<T>> options;
  final T? selectedValue;
  final ValueChanged<T> onSelected;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<OptionItem<T>> options,
    T? selectedValue,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _OptionPickerSheetContent<T>(
        title: title,
        options: options,
        selectedValue: selectedValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _OptionPickerSheetContent<T>(
      title: title,
      options: options,
      selectedValue: selectedValue,
    );
  }
}

class _OptionPickerSheetContent<T> extends StatelessWidget {
  const _OptionPickerSheetContent({
    required this.title,
    required this.options,
    required this.selectedValue,
  });

  final String title;
  final List<OptionItem<T>> options;
  final T? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              title,
              style: AppTextStyle.subtitle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...options.map((option) {
            final isSelected = option.value == selectedValue;
            return ListTile(
              leading: option.icon != null
                  ? Icon(
                      option.icon,
                      color: isSelected ? AppColor.primary : AppColor.textSecondary,
                    )
                  : null,
              title: Text(
                option.label,
                style: AppTextStyle.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColor.primary : AppColor.textPrimary,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: AppColor.primary)
                  : null,
              onTap: () => Get.back(result: option.value),
            );
          }),
        ],
      ),
    );
  }
}
