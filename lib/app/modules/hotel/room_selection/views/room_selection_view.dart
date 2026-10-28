import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../data/models/hotel_model.dart';
import '../controllers/room_selection_controller.dart';

class RoomSelectionView extends GetView<RoomSelectionController> {
  const RoomSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Select Room',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildHotelHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: controller.hotel.roomTypes.length,
              itemBuilder: (context, index) {
                final room = controller.hotel.roomTypes[index];
                return Obx(() => _RoomCard(
                      room: room,
                      nights: controller.nights,
                      isSelected: controller.selectedRoom.value?.id == room.id,
                      onTap: () => controller.selectRoom(room),
                    ));
              },
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHotelHeader() {
    final dateFormat = DateFormat('d MMM');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColor.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.hotel, color: AppColor.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.hotel.name,
                  style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: AppColor.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${dateFormat.format(controller.checkIn)} - ${dateFormat.format(controller.checkOut)}',
                      style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '(${controller.nights} nights)',
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.primary,
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
    );
  }

  Widget _buildBottomBar() {
    return Obx(() {
      final hasSelection = controller.selectedRoom.value != null;

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
        child: Row(
          children: [
            if (hasSelection) ...[
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
                    Obx(() => Text(
                          '${controller.selectedRoomCount.value}',
                          style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        )),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: controller.increaseRoomCount,
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
                    Obx(() => Text(
                          '\$${controller.totalPrice.toStringAsFixed(0)}',
                          style: AppTextStyle.subtitle.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
              ),
            ] else
              Expanded(
                child: Text(
                  'Select a room to continue',
                  style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
                ),
              ),
            AppButton(
              label: 'Continue',
              onPressed: hasSelection ? controller.proceedToGuestInfo : null,
              size: AppButtonSize.medium,
            ),
          ],
        ),
      );
    });
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.room,
    required this.nights,
    required this.isSelected,
    required this.onTap,
  });

  final RoomType room;
  final int nights;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: room.isSoldOut ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected ? AppColor.primary : AppColor.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.primary.withAlpha(30),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: room.isSoldOut
                    ? AppColor.textSecondary.withAlpha(20)
                    : AppColor.primary.withAlpha(20),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusMd - 1),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.bed,
                      size: 40,
                      color: room.isSoldOut
                          ? AppColor.textSecondary.withAlpha(100)
                          : AppColor.primary.withAlpha(100),
                    ),
                  ),
                  if (room.isSoldOut)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(50),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(AppSpacing.radiusMd - 1),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'SOLD OUT',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (isSelected)
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColor.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, size: 16, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.name,
                          style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (room.isRefundable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColor.success.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Free cancellation',
                            style: AppTextStyle.caption.copyWith(
                              color: AppColor.success,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Details
                  Row(
                    children: [
                      _buildDetail(Icons.bed, room.bedType),
                      const SizedBox(width: AppSpacing.md),
                      _buildDetail(Icons.square_foot, room.sizeText),
                      const SizedBox(width: AppSpacing.md),
                      _buildDetail(Icons.people, '${room.maxGuests} guests'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Amenities
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: room.amenities.take(4).map((amenity) {
                      return Text(
                        '• ${amenity.toUpperCase()}',
                        style: AppTextStyle.caption.copyWith(
                          color: AppColor.textSecondary,
                          fontSize: 10,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Price
                  Row(
                    children: [
                      Text(
                        room.priceText,
                        style: AppTextStyle.subtitle.copyWith(
                          color: room.isSoldOut ? AppColor.textSecondary : AppColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' / night',
                        style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                      ),
                      const Spacer(),
                      if (!room.isSoldOut)
                        Text(
                          '${room.availableRooms} left',
                          style: AppTextStyle.caption.copyWith(
                            color: room.availableRooms <= 3 ? AppColor.error : AppColor.textSecondary,
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

  Widget _buildDetail(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColor.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
        ),
      ],
    );
  }
}
