import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_spacing.dart';
import '../../theme/app_color.dart';
import '../../theme/app_text_style.dart';

class PassengersPickerSheet extends StatefulWidget {
  const PassengersPickerSheet({
    super.key,
    required this.adults,
    this.children = 0,
    this.rooms = 1,
    this.showChildren = false,
    this.showRooms = false,
    this.maxAdults = 10,
    this.maxChildren = 6,
    this.maxRooms = 5,
  });

  final int adults;
  final int children;
  final int rooms;
  final bool showChildren;
  final bool showRooms;
  final int maxAdults;
  final int maxChildren;
  final int maxRooms;

  /// For transport - just adults
  static Future<int?> showForTransport({
    required int adults,
    int maxAdults = 10,
  }) async {
    return Get.bottomSheet<int>(
      PassengersPickerSheet(
        adults: adults,
        maxAdults: maxAdults,
      ),
    );
  }

  /// For hotels - adults, children, rooms
  static Future<({int adults, int children, int rooms})?> showForHotel({
    required int adults,
    int children = 0,
    int rooms = 1,
  }) async {
    return Get.bottomSheet<({int adults, int children, int rooms})>(
      PassengersPickerSheet(
        adults: adults,
        children: children,
        rooms: rooms,
        showChildren: true,
        showRooms: true,
      ),
    );
  }

  @override
  State<PassengersPickerSheet> createState() => _PassengersPickerSheetState();
}

class _PassengersPickerSheetState extends State<PassengersPickerSheet> {
  late int _adults;
  late int _children;
  late int _rooms;

  @override
  void initState() {
    super.initState();
    _adults = widget.adults;
    _children = widget.children;
    _rooms = widget.rooms;
  }

  int get _maxGuestsPerRoom => 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColor.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            widget.showRooms ? 'Guests & rooms' : 'Passengers',
            style: AppTextStyle.subtitle.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Adults
          _CounterRow(
            label: 'Adults',
            subtitle: 'Age 12+',
            value: _adults,
            minValue: 1,
            maxValue: widget.maxAdults,
            onChanged: (val) => setState(() => _adults = val),
          ),

          // Children
          if (widget.showChildren) ...[
            const SizedBox(height: AppSpacing.md),
            _CounterRow(
              label: 'Children',
              subtitle: 'Age 0-11',
              value: _children,
              minValue: 0,
              maxValue: widget.maxChildren,
              onChanged: (val) => setState(() => _children = val),
            ),
          ],

          // Rooms
          if (widget.showRooms) ...[
            const SizedBox(height: AppSpacing.md),
            _CounterRow(
              label: 'Rooms',
              subtitle: 'Hotel rooms',
              value: _rooms,
              minValue: 1,
              maxValue: widget.maxRooms,
              onChanged: (val) => setState(() => _rooms = val),
            ),
            const SizedBox(height: AppSpacing.md),
            // Info text
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColor.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColor.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Max $_maxGuestsPerRoom guests per room. Add children ages for the right price.',
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),

          // Done button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              child: const Text('Done'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  void _onDone() {
    if (widget.showRooms) {
      Get.back(result: (adults: _adults, children: _children, rooms: _rooms));
    } else {
      Get.back(result: _adults);
    }
  }
}

class _CounterRow extends StatelessWidget {
  const _CounterRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyle.caption.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.border),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CounterButton(
                icon: Icons.remove,
                enabled: value > minValue,
                onTap: () => onChanged(value - 1),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _CounterButton(
                icon: Icons.add,
                enabled: value < maxValue,
                onTap: () => onChanged(value + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            icon,
            size: 20,
            color: enabled ? AppColor.primary : AppColor.border,
          ),
        ),
      ),
    );
  }
}
