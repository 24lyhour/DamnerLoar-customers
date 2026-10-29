import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/widgets/option_picker_sheet.dart';
import '../controllers/hotel_controller.dart';
import '../data/models/hotel_model.dart';

class HotelView extends GetView<HotelController> {
  const HotelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Hotels',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchSummary(),
          _buildSortBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.hotels.isEmpty) {
                return const Center(child: Text('No hotels found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: controller.hotels.length,
                itemBuilder: (context, index) {
                  return _HotelCard(
                    hotel: controller.hotels[index],
                    nights: controller.nights,
                    onTap: () => controller.selectHotel(controller.hotels[index]),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSummary() {
    final dateFormat = DateFormat('d MMM');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: AppColor.primary,
      child: Obx(() => Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: Colors.white70),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  controller.location.value,
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      '${dateFormat.format(controller.checkInDate.value)} - ${dateFormat.format(controller.checkOutDate.value)}',
                      style: AppTextStyle.caption.copyWith(color: Colors.white),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Icons.person, size: 14, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      '${controller.guestCount.value}',
                      style: AppTextStyle.caption.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildSortBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      color: Colors.white,
      child: Row(
        children: [
          Obx(() => Text(
                '${controller.hotels.length} hotels found',
                style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
              )),
          const Spacer(),
          // Filter button
          Obx(() => GestureDetector(
                onTap: () => _showFilterSheet(Get.context!),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                  decoration: BoxDecoration(
                    color: controller.hasActiveFilters.value
                        ? AppColor.primary.withAlpha(20)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: controller.hasActiveFilters.value
                          ? AppColor.primary
                          : AppColor.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.filter_list,
                        size: 18,
                        color: controller.hasActiveFilters.value
                            ? AppColor.primary
                            : AppColor.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Filter',
                        style: AppTextStyle.bodySmall.copyWith(
                          color: controller.hasActiveFilters.value
                              ? AppColor.primary
                              : AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          const SizedBox(width: AppSpacing.md),
          Obx(() => GestureDetector(
                onTap: () => _showSortSheet(Get.context!),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColor.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sort, size: 18, color: AppColor.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        _sortLabel(controller.sortOption.value),
                        style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColor.textSecondary),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  String _sortLabel(HotelSortOption option) {
    switch (option) {
      case HotelSortOption.recommended:
        return 'Recommended';
      case HotelSortOption.priceLow:
        return 'Price: Low';
      case HotelSortOption.priceHigh:
        return 'Price: High';
      case HotelSortOption.rating:
        return 'Rating';
    }
  }

  Future<void> _showSortSheet(BuildContext context) async {
    final result = await OptionPickerSheet.show<HotelSortOption>(
      context: context,
      title: 'Sort By',
      options: const [
        OptionItem(value: HotelSortOption.recommended, label: 'Recommended', icon: Icons.recommend),
        OptionItem(value: HotelSortOption.priceLow, label: 'Price: Low to High', icon: Icons.arrow_upward),
        OptionItem(value: HotelSortOption.priceHigh, label: 'Price: High to Low', icon: Icons.arrow_downward),
        OptionItem(value: HotelSortOption.rating, label: 'Rating', icon: Icons.star),
      ],
      selectedValue: controller.sortOption.value,
    );
    if (result != null) {
      controller.setSortOption(result);
    }
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterBottomSheet(controller: controller),
    );
  }
}

class _FilterBottomSheet extends StatelessWidget {
  const _FilterBottomSheet({required this.controller});

  final HotelController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter',
                style: AppTextStyle.subtitle.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  controller.clearFilters();
                  Get.back();
                },
                child: Text(
                  'Clear All',
                  style: AppTextStyle.bodySmall.copyWith(color: AppColor.primary),
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg),

          // Price Range
          Text(
            'Price Range',
            style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${controller.minPrice.value.toInt()}',
                    style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
                  ),
                  Text(
                    '\$${controller.maxPrice.value.toInt()}',
                    style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
                  ),
                ],
              )),
          Obx(() => RangeSlider(
                values: RangeValues(controller.minPrice.value, controller.maxPrice.value),
                min: 0,
                max: 500,
                divisions: 50,
                activeColor: AppColor.primary,
                onChanged: (values) {
                  controller.setPriceRange(values.start, values.end);
                },
              )),
          const SizedBox(height: AppSpacing.md),

          // Rating
          Text(
            'Minimum Rating',
            style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Obx(() => Row(
                children: [3.0, 3.5, 4.0, 4.5].map((rating) {
                  final isSelected = controller.minRating.value == rating;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => controller.setMinRating(
                        controller.minRating.value == rating ? 0 : rating,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColor.primary : Colors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          border: Border.all(
                            color: isSelected ? AppColor.primary : AppColor.border,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: isSelected ? Colors.white : AppColor.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$rating+',
                              style: AppTextStyle.bodySmall.copyWith(
                                color: isSelected ? Colors.white : AppColor.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: AppSpacing.md),

          // Amenities
          Text(
            'Amenities',
            style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Obx(() => Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: HotelController.availableAmenities.map((amenity) {
                  final isSelected = controller.selectedAmenities.contains(amenity);
                  return GestureDetector(
                    onTap: () => controller.toggleAmenity(amenity),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColor.primary : Colors.white,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        border: Border.all(
                          color: isSelected ? AppColor.primary : AppColor.border,
                        ),
                      ),
                      child: Text(
                        _amenityLabel(amenity),
                        style: AppTextStyle.bodySmall.copyWith(
                          color: isSelected ? Colors.white : AppColor.textPrimary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: AppSpacing.lg),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.applyFilters();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: AppTextStyle.button.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
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

class _HotelCard extends StatelessWidget {
  const _HotelCard({
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
            // Image placeholder
            Container(
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
            ),

            Padding(
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
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
                      ),
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
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: hotel.amenities.take(4).map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 2,
                        ),
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
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Price
                  Row(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
