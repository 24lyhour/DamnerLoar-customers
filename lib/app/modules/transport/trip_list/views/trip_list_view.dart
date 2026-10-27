import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../controllers/trip_list_controller.dart';
import '../widgets/trip_card_widget.dart';

class TripListView extends GetView<TripListController> {
  const TripListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Obx(() => Column(
              children: [
                // Show leg indicator for round-trip
                if (controller.isRoundTrip.value)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      controller.isSelectingReturn.value ? 'Return Trip' : 'Outbound Trip',
                      style: AppTextStyle.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ),
                Text(
                  '${controller.fromCity.value} → ${controller.toCity.value}',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${DateFormat('EEE, d MMM').format(controller.departureDate.value)} · ${controller.passengerCount.value} passengers',
                  style: AppTextStyle.caption.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: controller.swapCities,
            tooltip: 'Swap cities',
          ),
        ],
      ),
      body: Column(
        children: [
          // Sort & filter bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screen,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sort dropdown
                Obx(() => _SortButton(
                      currentSort: controller.sortOption.value,
                      onChanged: controller.setSortOption,
                    )),
                // Filter button
                GestureDetector(
                  onTap: () {
                    // TODO: Show filter bottom sheet
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          size: 16,
                          color: AppColor.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Filter',
                          style: AppTextStyle.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColor.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Trip list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildSkeletonList();
              }

              if (controller.trips.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.fetchTrips,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  itemCount: controller.trips.length,
                  itemBuilder: (context, index) {
                    final trip = controller.trips[index];
                    return TripCard(
                      trip: trip,
                      onTap: () => controller.selectTrip(trip),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _TripCardSkeleton();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_bus_outlined,
              size: 64,
              color: AppColor.textSecondary.withAlpha(100),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No trips found',
              style: AppTextStyle.subtitle.copyWith(
                color: AppColor.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Try changing your search dates or destination',
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColor.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Modify search'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  const _SortButton({
    required this.currentSort,
    required this.onChanged,
  });

  final SortOption currentSort;
  final ValueChanged<SortOption> onChanged;

  String get _label {
    switch (currentSort) {
      case SortOption.departure:
        return 'Departure';
      case SortOption.price:
        return 'Price';
      case SortOption.duration:
        return 'Duration';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSortSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sort_rounded,
              size: 16,
              color: AppColor.primary,
            ),
            const SizedBox(width: 6),
            Text(
              'Sort: $_label',
              style: AppTextStyle.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(width: 4),
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

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet<SortOption>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Options card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Sort by',
                      style: AppTextStyle.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildOption(context, SortOption.departure, 'Departure time'),
                  _buildOption(context, SortOption.price, 'Lowest price'),
                  _buildOption(context, SortOption.duration, 'Shortest duration'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Cancel button
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.subtitle.copyWith(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    ).then((value) {
      if (value != null) {
        onChanged(value);
      }
    });
  }

  Widget _buildOption(BuildContext context, SortOption option, String label) {
    final isSelected = currentSort == option;
    return Column(
      children: [
        Container(height: 0.5, color: AppColor.border),
        InkWell(
          onTap: () => Navigator.pop(context, option),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelected) ...[
                  Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: AppColor.primary,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: AppTextStyle.subtitle.copyWith(
                    color: AppColor.primary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TripCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: AppSpacing.xs,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        children: [
          // Header row
          Row(
            children: [
              _buildShimmerBox(40, 40, radius: 8),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(120, 14),
                    const SizedBox(height: 6),
                    _buildShimmerBox(80, 10),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildShimmerBox(50, 18),
                  const SizedBox(height: 4),
                  _buildShimmerBox(40, 10),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Time row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerBox(50, 20),
              _buildShimmerBox(60, 12),
              _buildShimmerBox(50, 20),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          // Bottom row
          Row(
            children: [
              _buildShimmerBox(24, 24, radius: 4),
              const SizedBox(width: 6),
              _buildShimmerBox(24, 24, radius: 4),
              const SizedBox(width: 6),
              _buildShimmerBox(24, 24, radius: 4),
              const Spacer(),
              _buildShimmerBox(60, 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height, {double radius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColor.border,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
