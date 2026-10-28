import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../data/models/hotel_model.dart';
import '../controllers/room_detail_controller.dart';

class RoomDetailView extends GetView<RoomDetailController> {
  const RoomDetailView({super.key});

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
                _buildRoomInfo(),
                _buildBookingDates(),
                _buildRoomDetails(),
                _buildAmenities(),
                _buildPolicies(),
                _buildOtherRooms(),
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
                    Icon(Icons.bed, size: 80, color: AppColor.primary.withAlpha(100)),
                    const SizedBox(height: 8),
                    Text(
                      controller.room.name,
                      style: AppTextStyle.subtitle.copyWith(color: AppColor.primary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
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
    );
  }

  Widget _buildRoomInfo() {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.room.name,
                      style: AppTextStyle.headline.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.hotel.name,
                      style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
                    ),
                  ],
                ),
              ),
              if (controller.room.isRefundable)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.success.withAlpha(20),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Free Cancellation',
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildQuickInfo(Icons.bed, controller.room.bedType),
              const SizedBox(width: AppSpacing.lg),
              _buildQuickInfo(Icons.square_foot, controller.room.sizeText),
              const SizedBox(width: AppSpacing.lg),
              _buildQuickInfo(Icons.people, '${controller.room.maxGuests} guests'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColor.primary),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
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
                Text(
                  'From 14:00',
                  style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
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
            child: Column(
              children: [
                const Icon(Icons.nights_stay, size: 20, color: AppColor.primary),
                const SizedBox(height: 2),
                Text(
                  '${controller.nights}',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'night(s)',
                  style: AppTextStyle.caption.copyWith(color: AppColor.primary),
                ),
              ],
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
                Text(
                  'Before 12:00',
                  style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomDetails() {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room Details',
            style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDetailRow('Room Size', controller.room.sizeText),
          _buildDetailRow('Bed Type', controller.room.bedType),
          _buildDetailRow('Max Guests', '${controller.room.maxGuests} person(s)'),
          _buildDetailRow('Available', '${controller.room.availableRooms} room(s) left'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
          ),
          Text(
            value,
            style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenities() {
    final amenities = controller.room.amenities;
    if (amenities.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room Amenities',
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

    switch (amenity.toLowerCase()) {
      case 'wifi':
        icon = Icons.wifi;
        label = 'WiFi';
        break;
      case 'ac':
        icon = Icons.ac_unit;
        label = 'Air Conditioning';
        break;
      case 'tv':
        icon = Icons.tv;
        label = 'TV';
        break;
      case 'minibar':
        icon = Icons.local_bar;
        label = 'Minibar';
        break;
      case 'bathtub':
        icon = Icons.bathtub;
        label = 'Bathtub';
        break;
      case 'balcony':
        icon = Icons.balcony;
        label = 'Balcony';
        break;
      case 'living room':
        icon = Icons.weekend;
        label = 'Living Room';
        break;
      case 'butler':
        icon = Icons.room_service;
        label = 'Butler Service';
        break;
      default:
        icon = Icons.check_circle;
        label = amenity;
    }

    return SizedBox(
      width: 90,
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPolicies() {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Policies',
            style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildPolicyItem(
            Icons.check_circle,
            AppColor.success,
            controller.room.isRefundable
                ? 'Free cancellation before check-in'
                : 'Non-refundable booking',
          ),
          _buildPolicyItem(
            Icons.access_time,
            AppColor.primary,
            'Check-in from 14:00, Check-out before 12:00',
          ),
          _buildPolicyItem(
            Icons.smoke_free,
            AppColor.textSecondary,
            'Non-smoking room',
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherRooms() {
    final otherRooms = controller.otherRooms;
    if (otherRooms.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Other Room Types',
            style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Compare other available rooms at this property',
            style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          ...otherRooms.map((room) => _buildOtherRoomCard(room)),
        ],
      ),
    );
  }

  Widget _buildOtherRoomCard(RoomType room) {
    return GestureDetector(
      onTap: room.isSoldOut ? null : () => controller.viewOtherRoom(room),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: room.isSoldOut ? AppColor.surface.withAlpha(150) : AppColor.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColor.border),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColor.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                Icons.bed,
                color: room.isSoldOut ? AppColor.textSecondary : AppColor.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: AppTextStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: room.isSoldOut ? AppColor.textSecondary : AppColor.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${room.bedType} · ${room.sizeText} · ${room.maxGuests} guests',
                    style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                  ),
                  if (room.isSoldOut)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Sold Out',
                        style: AppTextStyle.caption.copyWith(
                          color: AppColor.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  room.priceText,
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: room.isSoldOut ? AppColor.textSecondary : AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '/ night',
                  style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                ),
              ],
            ),
            if (!room.isSoldOut) ...[
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.chevron_right, color: AppColor.textSecondary),
            ],
          ],
        ),
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
      child: Obx(() => Row(
            children: [
              // Room count selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.border),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
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
                      onPressed: controller.selectedRoomCount.value < controller.room.availableRooms
                          ? controller.increaseRoomCount
                          : null,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
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
                label: 'Book Now',
                onPressed: controller.proceedToGuestInfo,
                size: AppButtonSize.medium,
              ),
            ],
          )),
    );
  }
}
