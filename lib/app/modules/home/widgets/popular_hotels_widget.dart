import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';

class PopularHotels extends StatelessWidget {
  const PopularHotels({super.key});

  static const _hotels = [
    _Hotel('Sofitel Angkor', 'Siem Reap', 120, 4.8),
    _Hotel('Raffles Le Royal', 'Phnom Penh', 180, 4.9),
    _Hotel('Song Saa Resort', 'Koh Rong', 350, 4.7),
    _Hotel('Navutu Dreams', 'Siem Reap', 95, 4.6),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.popularHotels.tr,
                style: AppTextStyle.subtitle.copyWith(
                  color: AppColor.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all hotels
                },
                child: Text(
                  AppString.seeAll.tr,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 170,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            scrollDirection: Axis.horizontal,
            itemCount: _hotels.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final hotel = _hotels[index];
              return _HotelCard(hotel: hotel);
            },
          ),
        ),
      ],
    );
  }
}

class _Hotel {
  const _Hotel(this.name, this.location, this.price, this.rating);
  final String name;
  final String location;
  final int price;
  final double rating;
}

class _HotelCard extends StatelessWidget {
  const _HotelCard({required this.hotel});
  final _Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to hotel detail
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusMd),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.primary.withAlpha(150),
                    AppColor.primaryDark,
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.apartment,
                  color: Colors.white38,
                  size: 36,
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel.name,
                          style: AppTextStyle.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: AppColor.textSecondary,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                hotel.location,
                                style: AppTextStyle.caption.copyWith(
                                  color: AppColor.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              hotel.rating.toString(),
                              style: AppTextStyle.caption.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '\$${hotel.price}/night',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
