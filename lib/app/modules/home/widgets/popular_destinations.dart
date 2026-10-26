import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';

class PopularDestinations extends StatelessWidget {
  const PopularDestinations({super.key});

  static const _destinations = [
    _Destination('Siem Reap', 12, 'assets/images/destinations/siem_reap.jpg'),
    _Destination('Koh Kong', 15, 'assets/images/destinations/koh_kong.jpg'),
    _Destination('Phnom Penh', 8, 'assets/images/destinations/phnom_penh.jpg'),
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
                AppString.popularDestinations.tr,
                style: AppTextStyle.subtitle.copyWith(
                  color: AppColor.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all destinations
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
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            scrollDirection: Axis.horizontal,
            itemCount: _destinations.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final dest = _destinations[index];
              return _DestinationCard(destination: dest);
            },
          ),
        ),
      ],
    );
  }
}

class _Destination {
  const _Destination(this.name, this.price, this.image);
  final String name;
  final int price;
  final String image;
}

class _DestinationCard extends StatelessWidget {
  const _DestinationCard({required this.destination});
  final _Destination destination;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to destination
      },
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Placeholder gradient (replace with real image)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColor.primary.withAlpha(180),
                      AppColor.primaryDark,
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.landscape,
                    color: Colors.white38,
                    size: 40,
                  ),
                ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withAlpha(150),
                    ],
                  ),
                ),
              ),
              // Content
              Positioned(
                left: AppSpacing.sm,
                right: AppSpacing.sm,
                bottom: AppSpacing.sm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'from \$${destination.price}',
                      style: AppTextStyle.caption.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
