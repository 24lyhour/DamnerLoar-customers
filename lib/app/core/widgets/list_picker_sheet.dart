import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_spacing.dart';
import '../theme/app_color.dart';
import '../theme/app_text_style.dart';

class ListPickerItem {
  final String value;
  final String? subtitle;
  final IconData? icon;

  const ListPickerItem({
    required this.value,
    this.subtitle,
    this.icon,
  });
}

class ListPickerSheet extends StatelessWidget {
  const ListPickerSheet({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    this.leadingIcon,
  });

  final String title;
  final List<ListPickerItem> items;
  final String? selectedValue;
  final ValueChanged<String> onSelected;
  final IconData? leadingIcon;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<ListPickerItem> items,
    String? selectedValue,
    required ValueChanged<String> onSelected,
    IconData? leadingIcon,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ListPickerSheet(
        title: title,
        items: items,
        selectedValue: selectedValue,
        onSelected: onSelected,
        leadingIcon: leadingIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
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
          const SizedBox(height: AppSpacing.md),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item.value == selectedValue;

                return ListTile(
                  leading: Icon(
                    item.icon ?? leadingIcon ?? Icons.location_on,
                    color: isSelected ? AppColor.primary : AppColor.textSecondary,
                  ),
                  title: Text(
                    item.value,
                    style: AppTextStyle.bodyMedium.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColor.primary : AppColor.textPrimary,
                    ),
                  ),
                  subtitle: item.subtitle != null
                      ? Text(
                          item.subtitle!,
                          style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                        )
                      : null,
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColor.primary)
                      : null,
                  onTap: () {
                    onSelected(item.value);
                    Get.back();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
