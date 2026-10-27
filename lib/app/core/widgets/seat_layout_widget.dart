import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../theme/app_color.dart';
import '../theme/app_text_style.dart';

// =============================================================================
// SEAT ENUMS & MODELS
// =============================================================================

enum SeatState { available, selected, booked, disabled }

enum SeatType { normal, vip, sleeper, driver, empty }

class Seat {
  const Seat({
    required this.id,
    required this.label,
    required this.row,
    required this.column,
    this.state = SeatState.available,
    this.type = SeatType.normal,
    this.price,
  });

  final String id;
  final String label;
  final int row;
  final int column;
  final SeatState state;
  final SeatType type;
  final double? price;

  bool get isSelectable => state == SeatState.available || state == SeatState.selected;
  bool get isSelected => state == SeatState.selected;

  Seat copyWith({SeatState? state}) {
    return Seat(
      id: id,
      label: label,
      row: row,
      column: column,
      state: state ?? this.state,
      type: type,
      price: price,
    );
  }
}

class VehicleLayout {
  const VehicleLayout({
    required this.rows,
    required this.seatsPerRow,
    this.aisleAfterColumn,
    this.hasDriver = true,
    this.driverPosition = DriverPosition.frontLeft,
  });

  final int rows;
  final int seatsPerRow;
  final int? aisleAfterColumn;
  final bool hasDriver;
  final DriverPosition driverPosition;

  static const bus2x2 = VehicleLayout(rows: 10, seatsPerRow: 4, aisleAfterColumn: 2);
  static const bus2x1 = VehicleLayout(rows: 12, seatsPerRow: 3, aisleAfterColumn: 2);
  static const minivan = VehicleLayout(rows: 4, seatsPerRow: 3, aisleAfterColumn: 1, hasDriver: true);
  static const sleeper = VehicleLayout(rows: 8, seatsPerRow: 4, aisleAfterColumn: 2);
}

enum DriverPosition { frontLeft, frontRight }

// =============================================================================
// SEAT LAYOUT WIDGET
// =============================================================================

class SeatLayoutWidget extends StatelessWidget {
  const SeatLayoutWidget({
    super.key,
    required this.seats,
    required this.layout,
    required this.onSeatTap,
    this.selectedSeats = const [],
    this.maxSelectable,
    this.seatSize = 44.0,
    this.seatSpacing = 6.0,
    this.aisleWidth = 24.0,
    this.showLabels = true,
    this.seatBuilder,
  });

  final List<Seat> seats;
  final VehicleLayout layout;
  final ValueChanged<Seat> onSeatTap;
  final List<String> selectedSeats;
  final int? maxSelectable;
  final double seatSize;
  final double seatSpacing;
  final double aisleWidth;
  final bool showLabels;
  final Widget Function(Seat seat, bool isSelected)? seatBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Front indicator
          _buildFrontIndicator(),
          const SizedBox(height: AppSpacing.md),

          // Driver row
          if (layout.hasDriver) ...[
            _buildDriverRow(),
            const SizedBox(height: AppSpacing.md),
          ],

          // Seat rows
          ...List.generate(layout.rows, (rowIndex) {
            return Padding(
              padding: EdgeInsets.only(bottom: seatSpacing),
              child: _buildSeatRow(rowIndex),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFrontIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Center(
        child: Text(
          'FRONT',
          style: AppTextStyle.caption.copyWith(
            color: AppColor.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildDriverRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDriverSeat(),
        SizedBox(width: layout.aisleAfterColumn == 1 ? aisleWidth : seatSpacing),
        SizedBox(width: seatSize, height: seatSize),
      ],
    );
  }

  Widget _buildDriverSeat() {
    return Container(
      width: seatSize,
      height: seatSize,
      decoration: BoxDecoration(
        color: AppColor.textSecondary.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.border),
      ),
      child: const Icon(
        Icons.airline_seat_recline_extra,
        size: 20,
        color: AppColor.textSecondary,
      ),
    );
  }

  Widget _buildSeatRow(int rowIndex) {
    final rowSeats = seats.where((s) => s.row == rowIndex).toList();
    final widgets = <Widget>[];

    for (var col = 0; col < layout.seatsPerRow; col++) {
      final seat = rowSeats.where((s) => s.column == col).firstOrNull;

      // Add aisle spacing
      if (layout.aisleAfterColumn != null && col == layout.aisleAfterColumn) {
        widgets.add(SizedBox(width: aisleWidth, key: ValueKey('aisle_${rowIndex}_$col')));
      } else if (col > 0) {
        widgets.add(SizedBox(width: seatSpacing, key: ValueKey('space_${rowIndex}_$col')));
      }

      if (seat != null) {
        widgets.add(_buildSeat(seat));
      } else {
        widgets.add(SizedBox(
          key: ValueKey('empty_${rowIndex}_$col'),
          width: seatSize,
          height: seatSize,
        ));
      }
    }

    return Row(
      key: ValueKey('row_$rowIndex'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }

  Widget _buildSeat(Seat seat) {
    if (seat.type == SeatType.empty) {
      return SizedBox(key: ValueKey('empty_${seat.id}'), width: seatSize, height: seatSize);
    }

    final isSelected = selectedSeats.contains(seat.id) || seat.isSelected;

    if (seatBuilder != null) {
      return GestureDetector(
        key: ValueKey(seat.id),
        onTap: seat.isSelectable ? () => onSeatTap(seat) : null,
        child: seatBuilder!(seat, isSelected),
      );
    }

    return GestureDetector(
      key: ValueKey(seat.id),
      onTap: seat.isSelectable ? () => onSeatTap(seat) : null,
      child: Container(
        width: seatSize,
        height: seatSize,
        decoration: _getSeatDecoration(seat, isSelected),
        child: Center(
          child: showLabels
              ? Text(
                  seat.label,
                  style: AppTextStyle.caption.copyWith(
                    color: _getSeatTextColor(seat, isSelected),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: seatSize < 40 ? 10 : 11,
                  ),
                )
              : _getSeatIcon(seat, isSelected),
        ),
      ),
    );
  }

  BoxDecoration _getSeatDecoration(Seat seat, bool isSelected) {
    Color bgColor;
    Color borderColor;
    double borderWidth = 1;

    switch (seat.state) {
      case SeatState.available:
        bgColor = isSelected ? AppColor.primary : AppColor.surface;
        borderColor = isSelected ? AppColor.primary : AppColor.border;
        borderWidth = isSelected ? 2 : 1;
        break;
      case SeatState.selected:
        bgColor = AppColor.primary;
        borderColor = AppColor.primary;
        borderWidth = 2;
        break;
      case SeatState.booked:
        bgColor = AppColor.textSecondary.withAlpha(40);
        borderColor = AppColor.textSecondary.withAlpha(60);
        break;
      case SeatState.disabled:
        bgColor = AppColor.border;
        borderColor = AppColor.border;
        break;
    }

    // VIP seat styling
    if (seat.type == SeatType.vip && seat.state == SeatState.available && !isSelected) {
      bgColor = AppColor.warning.withAlpha(20);
      borderColor = AppColor.warning.withAlpha(100);
    }

    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(seatSize < 40 ? 6 : 8),
      border: Border.all(color: borderColor, width: borderWidth),
    );
  }

  Color _getSeatTextColor(Seat seat, bool isSelected) {
    if (isSelected || seat.state == SeatState.selected) {
      return Colors.white;
    }
    if (seat.state == SeatState.booked || seat.state == SeatState.disabled) {
      return AppColor.textTertiary;
    }
    return AppColor.textPrimary;
  }

  Widget? _getSeatIcon(Seat seat, bool isSelected) {
    if (seat.state == SeatState.booked) {
      return const Icon(Icons.close, size: 16, color: AppColor.textTertiary);
    }
    if (isSelected) {
      return const Icon(Icons.check, size: 16, color: Colors.white);
    }
    return null;
  }
}

// =============================================================================
// SEAT LEGEND WIDGET
// =============================================================================

class SeatLegendWidget extends StatelessWidget {
  const SeatLegendWidget({
    super.key,
    this.showVip = false,
    this.compact = false,
  });

  final bool showVip;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final items = [
      _LegendItem(
        color: AppColor.surface,
        borderColor: AppColor.border,
        label: 'Available',
      ),
      _LegendItem(
        color: AppColor.primary,
        borderColor: AppColor.primary,
        label: 'Selected',
      ),
      _LegendItem(
        color: AppColor.textSecondary.withAlpha(40),
        borderColor: AppColor.textSecondary.withAlpha(60),
        label: 'Booked',
      ),
      if (showVip)
        _LegendItem(
          color: AppColor.warning.withAlpha(20),
          borderColor: AppColor.warning.withAlpha(100),
          label: 'VIP',
        ),
    ];

    if (compact) {
      return Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.sm,
        children: items,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: item,
              ))
          .toList(),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.borderColor,
    required this.label,
  });

  final Color color;
  final Color borderColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: AppTextStyle.caption),
      ],
    );
  }
}

// =============================================================================
// HELPER: GENERATE SEATS
// =============================================================================

List<Seat> generateSeats({
  required VehicleLayout layout,
  List<String> bookedSeatIds = const [],
  List<String> vipRows = const [],
  double? basePrice,
  double? vipPriceMultiplier,
}) {
  final seats = <Seat>[];
  final labels = 'ABCDEFGHIJ'.split('');

  for (var row = 0; row < layout.rows; row++) {
    for (var col = 0; col < layout.seatsPerRow; col++) {
      final label = '${row + 1}${labels[col]}';
      final id = 'seat_${row}_$col';
      final isVip = vipRows.contains('${row + 1}');
      final isBooked = bookedSeatIds.contains(id);

      seats.add(Seat(
        id: id,
        label: label,
        row: row,
        column: col,
        state: isBooked ? SeatState.booked : SeatState.available,
        type: isVip ? SeatType.vip : SeatType.normal,
        price: basePrice != null
            ? (isVip ? basePrice * (vipPriceMultiplier ?? 1.5) : basePrice)
            : null,
      ));
    }
  }

  return seats;
}
