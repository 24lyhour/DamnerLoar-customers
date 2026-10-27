import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_spacing.dart';
import '../../theme/app_color.dart';
import '../../theme/app_text_style.dart';

/// A dropdown item with value, label, and optional icon/subtitle.
class DropdownItem<T> {
  const DropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.iconWidget,
    this.enabled = true,
  });

  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
  final Widget? iconWidget;
  final bool enabled;
}

/// Dropdown field following app brand guidelines (UI/UX v3.1).
/// Opens a bottom sheet picker with consistent styling.
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint,
    this.prefixIcon,
    this.enabled = true,
    this.isRequired = false,
    this.errorText,
    this.searchable = false,
    this.searchHint,
    this.sheetTitle,
  });

  final String label;
  final List<DropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final IconData? prefixIcon;
  final bool enabled;
  final bool isRequired;
  final String? errorText;
  final bool searchable;
  final String? searchHint;
  final String? sheetTitle;

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.where((i) => i.value == value).firstOrNull;
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                Text(
                  label,
                  style: AppTextStyle.caption.copyWith(
                    color: hasError ? AppColor.error : AppColor.textSecondary,
                  ),
                ),
                if (isRequired)
                  Text(
                    ' *',
                    style: AppTextStyle.caption.copyWith(color: AppColor.error),
                  ),
              ],
            ),
          ),

        // Field
        GestureDetector(
          onTap: enabled ? _showPicker : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: enabled ? AppColor.background : AppColor.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: hasError ? AppColor.error : AppColor.border,
                width: hasError ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                if (prefixIcon != null) ...[
                  Icon(
                    prefixIcon,
                    size: 20,
                    color: enabled ? AppColor.textSecondary : AppColor.textTertiary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    selectedItem?.label ?? hint ?? 'Select',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: selectedItem != null
                          ? (enabled ? AppColor.textPrimary : AppColor.textSecondary)
                          : AppColor.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: enabled ? AppColor.textSecondary : AppColor.textTertiary,
                ),
              ],
            ),
          ),
        ),

        // Error text
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              errorText!,
              style: AppTextStyle.caption.copyWith(color: AppColor.error),
            ),
          ),
      ],
    );
  }

  Future<void> _showPicker() async {
    final result = await Get.bottomSheet<T>(
      _DropdownPickerSheet<T>(
        title: sheetTitle ?? label,
        items: items,
        selectedValue: value,
        searchable: searchable,
        searchHint: searchHint,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if (result != null) {
      onChanged(result);
    }
  }
}

/// Compact dropdown for inline use (sort, filter).
class AppDropdownCompact<T> extends StatelessWidget {
  const AppDropdownCompact({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint,
    this.icon,
    this.enabled = true,
    this.sheetTitle,
  });

  final List<DropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final IconData? icon;
  final bool enabled;
  final String? sheetTitle;

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.where((i) => i.value == value).firstOrNull;

    return GestureDetector(
      onTap: enabled ? _showPicker : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColor.primary),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              selectedItem?.label ?? hint ?? 'Select',
              style: AppTextStyle.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: selectedItem != null ? AppColor.primary : AppColor.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: AppColor.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPicker() async {
    final result = await Get.bottomSheet<T>(
      _DropdownPickerSheet<T>(
        title: sheetTitle ?? 'Select',
        items: items,
        selectedValue: value,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );

    if (result != null) {
      onChanged(result);
    }
  }
}

// =============================================================================
// PICKER SHEET (Brand Styled)
// =============================================================================

class _DropdownPickerSheet<T> extends StatefulWidget {
  const _DropdownPickerSheet({
    required this.title,
    required this.items,
    this.selectedValue,
    this.searchable = false,
    this.searchHint,
  });

  final String title;
  final List<DropdownItem<T>> items;
  final T? selectedValue;
  final bool searchable;
  final String? searchHint;

  @override
  State<_DropdownPickerSheet<T>> createState() => _DropdownPickerSheetState<T>();
}

class _DropdownPickerSheetState<T> extends State<_DropdownPickerSheet<T>> {
  final _searchController = TextEditingController();
  List<DropdownItem<T>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) =>
                item.label.toLowerCase().contains(query.toLowerCase()) ||
                (item.subtitle?.toLowerCase().contains(query.toLowerCase()) ?? false))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.7;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: AppColor.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(),
          if (widget.searchable) _buildSearch(),
          const Divider(height: 1, color: AppColor.border),
          Flexible(child: _buildList()),
          SizedBox(height: bottomPadding),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColor.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Close button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColor.textSecondary,
              ),
            ),
          ),

          // Title
          Expanded(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: AppTextStyle.subtitle.copyWith(fontWeight: FontWeight.w600),
            ),
          ),

          // Spacer for symmetry
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearch,
          style: AppTextStyle.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.searchHint ?? 'Search',
            hintStyle: AppTextStyle.bodyMedium.copyWith(color: AppColor.textTertiary),
            prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColor.textSecondary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (_filteredItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: AppColor.textTertiary.withAlpha(100),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No items found',
                style: AppTextStyle.bodyMedium.copyWith(color: AppColor.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: _filteredItems.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        indent: AppSpacing.md,
        color: AppColor.border,
      ),
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        final isSelected = item.value == widget.selectedValue;

        return _DropdownListTile<T>(
          item: item,
          isSelected: isSelected,
          onTap: item.enabled ? () => Get.back(result: item.value) : null,
        );
      },
    );
  }
}

class _DropdownListTile<T> extends StatelessWidget {
  const _DropdownListTile({
    required this.item,
    required this.isSelected,
    this.onTap,
  });

  final DropdownItem<T> item;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        color: isSelected ? AppColor.primarySelected : Colors.transparent,
        child: Row(
          children: [
            // Icon or custom widget
            if (item.iconWidget != null) ...[
              item.iconWidget!,
              const SizedBox(width: AppSpacing.md),
            ] else if (item.icon != null) ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Icon(
                  item.icon,
                  size: 20,
                  color: item.enabled ? AppColor.textSecondary : AppColor.textTertiary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: item.enabled ? AppColor.textPrimary : AppColor.textTertiary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: AppTextStyle.caption,
                    ),
                  ],
                ],
              ),
            ),

            // Checkmark for selected
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColor.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// ACTION SHEET (Brand Styled)
// =============================================================================

/// Show a brand-styled action sheet with options.
Future<T?> showAppActionSheet<T>({
  required BuildContext context,
  String? title,
  String? message,
  required List<DropdownItem<T>> items,
  String cancelText = 'Cancel',
}) async {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      margin: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Options card
          Container(
            decoration: BoxDecoration(
              color: AppColor.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              children: [
                if (title != null || message != null)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        if (title != null)
                          Text(
                            title,
                            style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        if (message != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            message,
                            style: AppTextStyle.caption,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      if (index > 0 || title != null || message != null)
                        const Divider(height: 1, color: AppColor.border),
                      InkWell(
                        onTap: item.enabled ? () => Navigator.pop(context, item.value) : null,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          child: Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: item.enabled ? AppColor.primary : AppColor.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Cancel button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Text(
                  cancelText,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + AppSpacing.sm),
        ],
      ),
    ),
  );
}
