import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../data/models/hotel_model.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({
    super.key,
    required this.hotel,
    required this.nights,
    required this.onTap,
  });

  final HotelModel hotel;
  final int nights;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: AppColor.primary.withAlpha(20),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusMd),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hotel, size: 48, color: AppColor.primary.withAlpha(100)),
            const SizedBox(height: 8),
            Text(
              hotel.name,
              style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name & Rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  hotel.name,
                  style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildRatingBadge(),
            ],
          ),
          const SizedBox(height: 4),

          // Address
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: AppColor.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  hotel.address,
                  style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Amenities
          _buildAmenities(),
          const SizedBox(height: AppSpacing.md),

          // Price
          _buildPrice(),
        ],
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: AppColor.warning,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 14, color: Colors.white),
          const SizedBox(width: 2),
          Text(
            hotel.ratingText,
            style: AppTextStyle.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities() {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: hotel.amenities.take(4).map((amenity) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
          decoration: BoxDecoration(
            color: AppColor.surface,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _amenityLabel(amenity),
            style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrice() {
    return Row(
      children: [
        Text(
          hotel.priceText,
          style: AppTextStyle.subtitle.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          ' / night',
          style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
        ),
        const Spacer(),
        Text(
          '\$${(hotel.pricePerNight * nights).toStringAsFixed(0)} total',
          style: AppTextStyle.bodySmall.copyWith(
            color: AppColor.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _amenityLabel(String amenity) {
    switch (amenity) {
      case 'wifi':
        return 'WiFi';
      case 'pool':
        return 'Pool';
      case 'spa':
        return 'Spa';
      case 'restaurant':
        return 'Restaurant';
      case 'gym':
        return 'Gym';
      case 'parking':
        return 'Parking';
      case 'breakfast':
        return 'Breakfast';
      default:
        return amenity;
    }
  }
}
