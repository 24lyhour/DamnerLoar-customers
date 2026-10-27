import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../data/models/transport_model.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.trip,
    required this.onTap,
  });

  final TripModel trip;
  final VoidCallback onTap;

  static final _timeFormat = DateFormat('HH:mm');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: trip.isSoldOut ? null : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.xs,
        ),
        decoration: _cardDecoration,
        child: Opacity(
          opacity: trip.isSoldOut ? 0.5 : 1.0,
          child: Column(
            children: [
              _buildCardContent(),
              const _TicketDivider(),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration get _cardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      );

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          _OperatorRow(trip: trip),
          const SizedBox(height: AppSpacing.md),
          _TimelineRow(
            departureTime: _timeFormat.format(trip.departureTime),
            arrivalTime: _timeFormat.format(trip.arrivalTime),
            duration: trip.durationText,
          ),
          const SizedBox(height: 4),
          _CityRow(fromCity: trip.fromCity, toCity: trip.toCity),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(child: _AmenitiesRow(amenities: trip.amenities)),
          _AvailabilityBadge(
            availableSeats: trip.availableSeats,
            isSoldOut: trip.isSoldOut,
            hasLowAvailability: trip.hasLowAvailability,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PRIVATE WIDGETS
// ============================================================================

class _OperatorRow extends StatelessWidget {
  const _OperatorRow({required this.trip});

  final TripModel trip;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _OperatorLogo(name: trip.operatorName),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _OperatorInfo(
            name: trip.operatorName,
            busType: trip.busType,
            rating: trip.rating,
          ),
        ),
        _PriceTag(price: trip.price),
      ],
    );
  }
}

class _OperatorLogo extends StatelessWidget {
  const _OperatorLogo({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColor.primarySelected,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'B',
          style: AppTextStyle.subtitle.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _OperatorInfo extends StatelessWidget {
  const _OperatorInfo({
    required this.name,
    required this.busType,
    this.rating,
  });

  final String name;
  final String busType;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              busType,
              style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
            ),
            if (rating != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.star, size: 14, color: Colors.amber.shade700),
              const SizedBox(width: 2),
              Text(
                rating!.toStringAsFixed(1),
                style: AppTextStyle.caption.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _PriceTag extends StatelessWidget {
  const _PriceTag({required this.price});

  final double price;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\$${price.toStringAsFixed(0)}',
          style: AppTextStyle.subtitle.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          'per seat',
          style: AppTextStyle.caption.copyWith(
            color: AppColor.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
  });

  final String departureTime;
  final String arrivalTime;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TimeText(time: departureTime),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _Timeline(duration: duration)),
        const SizedBox(width: AppSpacing.md),
        _TimeText(time: arrivalTime),
      ],
    );
  }
}

class _TimeText extends StatelessWidget {
  const _TimeText({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: AppTextStyle.headline.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.duration});

  final String duration;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          duration,
          style: AppTextStyle.caption.copyWith(
            color: AppColor.textSecondary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _buildDot(filled: false),
            Expanded(child: Container(height: 2, color: AppColor.border)),
            _buildDot(filled: true),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Direct',
          style: AppTextStyle.caption.copyWith(
            color: AppColor.success,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDot({required bool filled}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AppColor.primary : null,
        border: filled ? null : Border.all(color: AppColor.primary, width: 2),
      ),
    );
  }
}

class _CityRow extends StatelessWidget {
  const _CityRow({required this.fromCity, required this.toCity});

  final String fromCity;
  final String toCity;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          fromCity,
          style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
        ),
        Text(
          toCity,
          style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
        ),
      ],
    );
  }
}

class _TicketDivider extends StatelessWidget {
  const _TicketDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildNotch(isLeft: true),
        Expanded(child: _buildDashedLine()),
        _buildNotch(isLeft: false),
      ],
    );
  }

  Widget _buildNotch({required bool isLeft}) {
    return Container(
      width: 12,
      height: 24,
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.only(
          topRight: isLeft ? const Radius.circular(12) : Radius.zero,
          bottomRight: isLeft ? const Radius.circular(12) : Radius.zero,
          topLeft: isLeft ? Radius.zero : const Radius.circular(12),
          bottomLeft: isLeft ? Radius.zero : const Radius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.maxWidth / 8).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dashCount,
            (_) => Container(width: 4, height: 1, color: AppColor.border),
          ),
        );
      },
    );
  }
}

class _AmenitiesRow extends StatelessWidget {
  const _AmenitiesRow({required this.amenities});

  final List<String> amenities;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: amenities
          .take(4)
          .map((a) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: _AmenityIcon(amenity: a),
              ))
          .toList(),
    );
  }
}

class _AmenityIcon extends StatelessWidget {
  const _AmenityIcon({required this.amenity});

  final String amenity;

  static const _iconMap = {
    'wifi': Icons.wifi,
    'ac': Icons.ac_unit,
    'toilet': Icons.wc,
    'snack': Icons.fastfood_outlined,
    'usb': Icons.usb,
    'blanket': Icons.bed,
    'pillow': Icons.airline_seat_flat,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        _iconMap[amenity.toLowerCase()] ?? Icons.check_circle_outline,
        size: 16,
        color: AppColor.textSecondary,
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({
    required this.availableSeats,
    required this.isSoldOut,
    required this.hasLowAvailability,
  });

  final int availableSeats;
  final bool isSoldOut;
  final bool hasLowAvailability;

  @override
  Widget build(BuildContext context) {
    if (isSoldOut) {
      return Text(
        'Sold out',
        style: AppTextStyle.caption.copyWith(
          color: AppColor.error,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    if (hasLowAvailability) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
        decoration: BoxDecoration(
          color: AppColor.warning.withAlpha(25),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '$availableSeats seats left',
          style: AppTextStyle.caption.copyWith(
            color: AppColor.warning,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Text(
      '$availableSeats seats',
      style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
    );
  }
}
