import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../theme/app_color.dart';
import '../theme/app_text_style.dart';

class ChipItem {
  final String value;
  final String label;
  final IconData? icon;

  const ChipItem({
    required this.value,
    String? label,
    this.icon,
  }) : label = label ?? value;
}

class ChipSelector extends StatelessWidget {
  const ChipSelector({
    super.key,
    required this.items,
    required this.selectedValues,
    required this.onChanged,
    this.multiSelect = true,
    this.wrap = true,
  });

  final List<ChipItem> items;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onChanged;
  final bool multiSelect;
  final bool wrap;

  void _onTap(String value) {
    final newSelection = List<String>.from(selectedValues);

    if (multiSelect) {
      if (newSelection.contains(value)) {
        newSelection.remove(value);
      } else {
        newSelection.add(value);
      }
    } else {
      if (newSelection.contains(value)) {
        newSelection.clear();
      } else {
        newSelection
          ..clear()
          ..add(value);
      }
    }

    onChanged(newSelection);
  }

  @override
  Widget build(BuildContext context) {
    final chips = items.map((item) {
      final isSelected = selectedValues.contains(item.value);
      return _Chip(
        item: item,
        isSelected: isSelected,
        onTap: () => _onTap(item.value),
      );
    }).toList();

    if (wrap) {
      return Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: chips,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips
            .map((chip) => Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: chip,
                ))
            .toList(),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final ChipItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: 16,
                color: isSelected ? Colors.white : AppColor.textSecondary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              item.label,
              style: AppTextStyle.bodySmall.copyWith(
                color: isSelected ? Colors.white : AppColor.textPrimary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingChipSelector extends StatelessWidget {
  const RatingChipSelector({
    super.key,
    required this.ratings,
    required this.selectedRating,
    required this.onChanged,
  });

  final List<double> ratings;
  final double? selectedRating;
  final ValueChanged<double?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ratings.map((rating) {
        final isSelected = selectedRating == rating;
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: GestureDetector(
            onTap: () => onChanged(isSelected ? null : rating),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primary : Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(
                  color: isSelected ? AppColor.primary : AppColor.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: isSelected ? Colors.white : AppColor.warning,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$rating+',
                    style: AppTextStyle.bodySmall.copyWith(
                      color: isSelected ? Colors.white : AppColor.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
