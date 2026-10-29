import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_spacing.dart';
import '../theme/app_color.dart';
import '../theme/app_text_style.dart';

class CounterItem {
  final String label;
  final int value;
  final int minValue;
  final int maxValue;
  final String? subtitle;

  const CounterItem({
    required this.label,
    required this.value,
    this.minValue = 1,
    this.maxValue = 10,
    this.subtitle,
  });

  CounterItem copyWith({int? value}) {
    return CounterItem(
      label: label,
      value: value ?? this.value,
      minValue: minValue,
      maxValue: maxValue,
      subtitle: subtitle,
    );
  }
}

class CounterPickerSheet extends StatelessWidget {
  const CounterPickerSheet({
    super.key,
    required this.title,
    required this.items,
    required this.onConfirm,
  });

  final String title;
  final List<CounterItem> items;
  final ValueChanged<List<int>> onConfirm;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<CounterItem> items,
    required ValueChanged<List<int>> onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CounterPickerSheet(
        title: title,
        items: items,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final counters = items.map((item) => item.value.obs).toList();

    return Container(
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
            title,
            style: AppTextStyle.subtitle.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Column(
              children: [
                if (index > 0) const Divider(height: AppSpacing.lg),
                Obx(() => _CounterRow(
                      label: item.label,
                      subtitle: item.subtitle,
                      value: counters[index].value,
                      minValue: item.minValue,
                      maxValue: item.maxValue,
                      onIncrement: () => counters[index].value++,
                      onDecrement: () => counters[index].value--,
                    )),
              ],
            );
          }),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                onConfirm(counters.map((c) => c.value).toList());
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

class _CounterRow extends StatelessWidget {
  const _CounterRow({
    required this.label,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onIncrement,
    required this.onDecrement,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final int value;
  final int minValue;
  final int maxValue;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyle.bodyMedium),
            if (subtitle != null)
              Text(
                subtitle!,
                style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
              ),
          ],
        ),
        Row(
          children: [
            _CounterButton(
              icon: Icons.remove,
              enabled: value > minValue,
              onPressed: onDecrement,
            ),
            SizedBox(
              width: 40,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            _CounterButton(
              icon: Icons.add,
              enabled: value < maxValue,
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? AppColor.primary : AppColor.border,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColor.primary : AppColor.border,
        ),
      ),
    );
  }
}
