import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';

class PopularTransport extends StatelessWidget {
  const PopularTransport({super.key});

  static const _routes = [
    _Route('Phnom Penh', 'Siem Reap', 12, '6h'),
    _Route('Phnom Penh', 'Sihanoukville', 15, '5h'),
    _Route('Siem Reap', 'Battambang', 8, '3h'),
    _Route('Phnom Penh', 'Kampot', 10, '3h'),
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
                AppString.popularTransport.tr,
                style: AppTextStyle.subtitle.copyWith(
                  color: AppColor.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all routes
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
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            scrollDirection: Axis.horizontal,
            itemCount: _routes.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final route = _routes[index];
              return _RouteCard(route: route);
            },
          ),
        ),
      ],
    );
  }
}

class _Route {
  const _Route(this.from, this.to, this.price, this.duration);
  final String from;
  final String to;
  final int price;
  final String duration;
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.route});
  final _Route route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to route search
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Route info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle_outlined,
                            size: 10,
                            color: AppColor.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              route.from,
                              style: AppTextStyle.bodySmall.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.more_vert,
                          size: 12,
                          color: AppColor.textSecondary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 10,
                            color: AppColor.error,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              route.to,
                              style: AppTextStyle.bodySmall.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.directions_bus,
                  color: AppColor.primary,
                  size: 28,
                ),
              ],
            ),
            // Price and duration
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'from \$${route.price}',
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 12,
                      color: AppColor.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      route.duration,
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
