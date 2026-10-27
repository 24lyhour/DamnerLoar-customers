import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/app_spacing.dart';
import '../../theme/app_color.dart';
import '../../theme/app_text_style.dart';

class DatePickerSheet extends StatefulWidget {
  const DatePickerSheet({
    super.key,
    required this.initialDate,
    this.firstDate,
    this.lastDate,
    this.returnDate,
    this.showReturnTab = false,
  });

  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? returnDate;
  final bool showReturnTab;

  static Future<DateTime?> show({
    required String title,
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    return Get.bottomSheet<DateTime>(
      DatePickerSheet(
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime.now(),
        lastDate: lastDate,
      ),
      isScrollControlled: true,
    );
  }

  static Future<({DateTime depart, DateTime? returnDate})?> showRoundTrip({
    required DateTime departDate,
    DateTime? returnDate,
  }) async {
    return Get.bottomSheet<({DateTime depart, DateTime? returnDate})>(
      DatePickerSheet(
        initialDate: departDate,
        firstDate: DateTime.now(),
        returnDate: returnDate,
        showReturnTab: true,
      ),
      isScrollControlled: true,
    );
  }

  @override
  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  late DateTime _departDate;
  late DateTime? _returnDate;
  late DateTime _displayedMonth;
  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _departDate = widget.initialDate;
    // For round-trip, ensure return date has a default value
    if (widget.showReturnTab) {
      _returnDate = widget.returnDate ?? _departDate.add(const Duration(days: 4));
    } else {
      _returnDate = widget.returnDate;
    }
    _displayedMonth = DateTime(_departDate.year, _departDate.month);
  }

  DateTime get _firstDate => widget.firstDate ?? DateTime.now();
  DateTime get _lastDate =>
      widget.lastDate ?? DateTime.now().add(const Duration(days: 365));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            _buildHeader(),
            if (widget.showReturnTab) ...[
              const SizedBox(height: AppSpacing.sm),
              _buildTabs(),
            ],
            const SizedBox(height: AppSpacing.lg),
            _buildMonthNavigation(),
            const SizedBox(height: AppSpacing.md),
            _buildWeekdayRow(),
            const SizedBox(height: AppSpacing.sm),
            _buildCalendarGrid(),
            const SizedBox(height: AppSpacing.xl),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
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
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.md, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select dates',
            style: AppTextStyle.subtitle.copyWith(fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.close, size: 24, color: AppColor.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Depart · ${DateFormat('EEE d MMM').format(_departDate)}',
              isActive: _activeTab == 0,
              onTap: () => setState(() => _activeTab = 0),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _TabButton(
              label: _returnDate != null
                  ? 'Return · ${DateFormat('EEE d MMM').format(_returnDate!)}'
                  : 'Return',
              isActive: _activeTab == 1,
              onTap: () => setState(() => _activeTab = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _canGoBack ? _previousMonth : null,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.chevron_left,
                color: _canGoBack ? AppColor.textPrimary : AppColor.border,
              ),
            ),
          ),
          Text(
            DateFormat('MMMM yyyy').format(_displayedMonth),
            style:
                AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: _canGoForward ? _nextMonth : null,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.chevron_right,
                color: _canGoForward ? AppColor.textPrimary : AppColor.border,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _canGoBack {
    final prevMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    return prevMonth.isAfter(DateTime(_firstDate.year, _firstDate.month - 1));
  }

  bool get _canGoForward {
    final nextMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    return nextMonth.isBefore(DateTime(_lastDate.year, _lastDate.month + 2));
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  Widget _buildWeekdayRow() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: days
            .map((d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final lastDay =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0);
    final startWeekday = firstDay.weekday % 7;

    final rows = <Widget>[];
    var currentDay = 1 - startWeekday;

    while (currentDay <= lastDay.day) {
      final rowDays = <Widget>[];
      for (var i = 0; i < 7; i++) {
        if (currentDay < 1 || currentDay > lastDay.day) {
          rowDays.add(const Expanded(child: SizedBox(height: 44)));
        } else {
          final date = DateTime(
              _displayedMonth.year, _displayedMonth.month, currentDay);
          rowDays.add(Expanded(child: _buildDayCell(date)));
        }
        currentDay++;
      }
      rows.add(Row(children: rowDays));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(children: rows),
    );
  }

  Widget _buildDayCell(DateTime date) {
    final isDepart = _isSame(date, _departDate);
    final isReturn = _returnDate != null && _isSame(date, _returnDate!);
    final isSelected = isDepart || isReturn;
    final isInRange = widget.showReturnTab &&
        _returnDate != null &&
        date.isAfter(_departDate) &&
        date.isBefore(_returnDate!);
    final isPast = _normalize(date).isBefore(_normalize(_firstDate));
    final isDisabled = isPast ||
        _normalize(date).isAfter(_normalize(_lastDate)) ||
        (_activeTab == 1 && _normalize(date).isBefore(_normalize(_departDate)));

    // Determine range position for background styling
    _RangePosition? rangePosition;
    if (widget.showReturnTab && _returnDate != null) {
      if (isDepart) {
        rangePosition = _RangePosition.start;
      } else if (isReturn) {
        rangePosition = _RangePosition.end;
      } else if (isInRange) {
        rangePosition = _RangePosition.middle;
      }
    }

    return GestureDetector(
      onTap: isDisabled ? null : () => _selectDate(date),
      child: SizedBox(
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Range background - horizontal bar
            if (rangePosition != null)
              Positioned.fill(
                child: _RangeBackground(position: rangePosition),
              ),
            // Selected circle or normal day
            Container(
              width: 40,
              height: 40,
              decoration: isSelected
                  ? const BoxDecoration(
                      color: AppColor.primary,
                      shape: BoxShape.circle,
                    )
                  : null,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: isDisabled
                        ? AppColor.textTertiary
                        : isSelected
                            ? Colors.white
                            : AppColor.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _confirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            elevation: 0,
          ),
          child: const Text('Confirm dates',
              style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  void _selectDate(DateTime date) {
    setState(() {
      if (_activeTab == 0) {
        // Selecting depart date
        _departDate = date;
        // Auto-set return date to depart + 4 days if null or before new depart
        if (widget.showReturnTab) {
          if (_returnDate == null || !_returnDate!.isAfter(date)) {
            _returnDate = date.add(const Duration(days: 4));
            // Clamp to lastDate if needed
            if (_returnDate!.isAfter(_lastDate)) {
              _returnDate = _lastDate;
            }
          }
          // Switch to return tab but DON'T jump months (industry standard)
          _activeTab = 1;
        }
      } else {
        // Selecting return date
        _returnDate = date;
      }
    });
  }

  void _confirm() {
    if (widget.showReturnTab) {
      Get.back(result: (depart: _departDate, returnDate: _returnDate));
    } else {
      Get.back(result: _departDate);
    }
  }

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);
  bool _isSame(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

enum _RangePosition { start, middle, end }

class _RangeBackground extends StatelessWidget {
  const _RangeBackground({required this.position});

  final _RangePosition position;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left half
        Expanded(
          child: Container(
            height: 40,
            color: position == _RangePosition.start
                ? Colors.transparent
                : AppColor.primarySelected,
          ),
        ),
        // Right half
        Expanded(
          child: Container(
            height: 40,
            color: position == _RangePosition.end
                ? Colors.transparent
                : AppColor.primarySelected,
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          border: Border.all(
            color: isActive ? AppColor.primary : AppColor.border,
            width: isActive ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyle.bodySmall.copyWith(
              color: isActive ? AppColor.primary : AppColor.textSecondary,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
