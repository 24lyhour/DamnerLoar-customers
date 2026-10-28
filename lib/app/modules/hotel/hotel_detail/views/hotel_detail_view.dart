import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../data/models/hotel_model.dart';
import '../controllers/hotel_detail_controller.dart';

class HotelDetailView extends GetView<HotelDetailController> {
  const HotelDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHotelInfo(),
                _buildBookingDates(),
                _buildDescription(),
                _buildAmenities(),
                _buildRoomPreview(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColor.primary,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColor.primary.withAlpha(30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hotel, size: 80, color: AppColor.primary.withAlpha(100)),
                    const SizedBox(height: 8),
                    Text(
                      controller.hotel.name,
                      style: AppTextStyle.subtitle.copyWith(color: AppColor.primary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Obx(() => IconButton(
              icon: Icon(
                controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                color: controller.isFavorite.value ? Colors.red : Colors.white,
              ),
              onPressed: controller.toggleFavorite,
            )),
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHotelInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  controller.hotel.name,
                  style: AppTextStyle.headline.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              _buildRatingBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColor.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  controller.hotel.address,
                  style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${controller.hotel.reviewCount} reviews',
            style: AppTextStyle.caption.copyWith(color: AppColor.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.warning,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            controller.hotel.ratingText,
            style: AppTextStyle.bodySmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDates() {
    final dateFormat = DateFormat('EEE, d MMM');

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Check-in',
                  style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(controller.checkIn),
                  style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColor.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              '${controller.nights} night(s)',
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColor.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Check-out',
                  style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(controller.checkOut),
                  style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            controller.hotel.description.isNotEmpty
                ? controller.hotel.description
                : 'Experience luxury and comfort at ${controller.hotel.name}. Located in the heart of ${controller.hotel.location}, our hotel offers world-class amenities and exceptional service for an unforgettable stay.',
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColor.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities() {
    final amenities = controller.hotel.amenities;

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: amenities.map((amenity) => _buildAmenityItem(amenity)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(String amenity) {
    IconData icon;
    String label;

    switch (amenity) {
      case 'wifi':
        icon = Icons.wifi;
        label = 'Free WiFi';
        break;
      case 'pool':
        icon = Icons.pool;
        label = 'Pool';
        break;
      case 'spa':
        icon = Icons.spa;
        label = 'Spa';
        break;
      case 'restaurant':
        icon = Icons.restaurant;
        label = 'Restaurant';
        break;
      case 'gym':
        icon = Icons.fitness_center;
        label = 'Gym';
        break;
      case 'parking':
        icon = Icons.local_parking;
        label = 'Parking';
        break;
      case 'breakfast':
        icon = Icons.free_breakfast;
        label = 'Breakfast';
        break;
      case 'butler':
        icon = Icons.room_service;
        label = 'Butler';
        break;
      default:
        icon = Icons.check_circle;
        label = amenity;
    }

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColor.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColor.primary, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRoomPreview() {
    final rooms = controller.hotel.roomTypes;
    if (rooms.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select a Room',
                style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '${rooms.length} type(s)',
                style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Obx(() => Column(
            children: rooms.map((room) => _buildRoomCard(room)).toList(),
          )),
        ],
      ),
    );
  }

  Widget _buildRoomCard(RoomType room) {
    final isSelected = controller.selectedRoom.value?.id == room.id;
    final isSoldOut = room.isSoldOut;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: isSelected ? AppColor.primary : AppColor.border,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [BoxShadow(color: AppColor.primary.withAlpha(30), blurRadius: 8)]
            : null,
      ),
      child: Column(
        children: [
          // Room info - tappable for details
          GestureDetector(
            onTap: () => controller.viewRoomDetail(room),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSoldOut
                          ? AppColor.textSecondary.withAlpha(20)
                          : AppColor.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(
                      Icons.bed,
                      color: isSoldOut ? AppColor.textSecondary : AppColor.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                room.name,
                                style: AppTextStyle.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isSoldOut ? AppColor.textSecondary : null,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: AppColor.textSecondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${room.bedType} · ${room.sizeText} · ${room.maxGuests} guests',
                          style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              room.priceText,
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: isSoldOut ? AppColor.textSecondary : AppColor.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' / night',
                              style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Select button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
            child: isSoldOut
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Center(
                      child: Text(
                        'Sold Out',
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : isSelected
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Booked',
                              style: AppTextStyle.bodySmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () => controller.selectRoom(room),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColor.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Center(
                            child: Text(
                              'Book',
                              style: AppTextStyle.bodySmall.copyWith(
                                color: AppColor.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + MediaQuery.of(Get.context!).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() {
        if (!controller.hasSelection) {
          // No room selected - show starting price
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'From',
                      style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          controller.hotel.priceText,
                          style: AppTextStyle.headline.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' / night',
                          style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  'Choose a room',
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        }

        // Room selected - show room count, total, and Continue
        return Row(
          children: [
            // Room count selector
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.border),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: controller.selectedRoomCount.value > 1
                        ? controller.decreaseRoomCount
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  Text(
                    '${controller.selectedRoomCount.value}',
                    style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: controller.selectedRoomCount.value <
                            controller.selectedRoom.value!.availableRooms
                        ? controller.increaseRoomCount
                        : null,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Total price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${controller.nights} night(s) · ${controller.selectedRoomCount.value} room(s)',
                    style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                  ),
                  Text(
                    '\$${controller.totalPrice.toStringAsFixed(0)}',
                    style: AppTextStyle.subtitle.copyWith(
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            AppButton(
              label: 'Continue',
              onPressed: controller.proceedToGuestInfo,
              size: AppButtonSize.medium,
            ),
          ],
        );
      }),
    );
  }
}
