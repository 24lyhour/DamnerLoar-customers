import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/seat_layout_widget.dart';
import '../controllers/seat_selection_controller.dart';

class SeatSelectionView extends GetView<SeatSelectionController> {
  const SeatSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Select Seats',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false, // Handle bottom padding in the BottomBar
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CupertinoActivityIndicator(radius: 14),
            );
          }

          return Column(
            children: [
              // Trip info card
              _TripInfoCard(
                operatorName: controller.trip.operatorName,
                busType: controller.trip.busType,
                departureTime: controller.trip.departureTime,
                arrivalTime: controller.trip.arrivalTime,
                price: controller.trip.price,
              ),

              // Legend - using the reusable widget
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: AppColor.border, width: 1),
                  ),
                ),
                child: const SeatLegendWidget(),
              ),

              // Seat grid - using the reusable widget
              Expanded(
                child: ClipRect(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Obx(() => SeatLayoutWidget(
                          seats: controller.seats.toList(),
                          layout: controller.layout,
                          onSeatTap: controller.toggleSeat,
                          selectedSeats: controller.selectedSeatIds.toList(),
                          maxSelectable: controller.passengerCount.value,
                          seatSize: 36,
                          seatSpacing: 8,
                          aisleWidth: 20,
                        )),
                  ),
                ),
              ),

              // Bottom bar
              Obx(() => _BottomBar(
                    selectedLabel: controller.selectedSeatsLabel,
                    totalPrice: controller.totalPrice,
                    selectedCount: controller.selectedSeatIds.length,
                    requiredCount: controller.passengerCount.value,
                    canProceed: controller.canProceed,
                    onProceed: controller.proceedToPassengerInfo,
                  )),
            ],
          );
        }),
      ),
    );
  }
}

// ============================================================================
// PRIVATE WIDGETS
// ============================================================================

class _TripInfoCard extends StatelessWidget {
  const _TripInfoCard({
    required this.operatorName,
    required this.busType,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
  });

  final String operatorName;
  final String busType;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  operatorName,
                  style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${timeFormat.format(departureTime)} - ${timeFormat.format(arrivalTime)}',
                  style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                busType,
                style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${price.toStringAsFixed(0)}/seat',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColor.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.selectedLabel,
    required this.totalPrice,
    required this.selectedCount,
    required this.requiredCount,
    required this.canProceed,
    required this.onProceed,
  });

  final String selectedLabel;
  final double totalPrice;
  final int selectedCount;
  final int requiredCount;
  final bool canProceed;
  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + bottomPadding,
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
          // Price info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedLabel,
                  style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${totalPrice.toStringAsFixed(0)}',
                  style: AppTextStyle.subtitle.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Continue button using AppButton
          AppButton(
            label: 'Continue ($selectedCount/$requiredCount)',
            onPressed: canProceed ? onProceed : null,
            size: AppButtonSize.medium,
          ),
        ],
      ),
    );
  }
}
