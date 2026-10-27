import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../controllers/booking_confirmation_controller.dart';

class BookingConfirmationView extends GetView<BookingConfirmationController> {
  const BookingConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xl),

                    // Success icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColor.success.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        size: 60,
                        color: AppColor.success,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Success message
                    Text(
                      'Booking Confirmed!',
                      style: AppTextStyle.headline.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Your ticket has been booked successfully',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Booking details card
                    _buildBookingCard(),
                    const SizedBox(height: AppSpacing.md),

                    // Trip summary
                    _buildTripSummary(),
                  ],
                ),
              ),
            ),

            // Bottom actions
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        children: [
          // Booking ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking ID',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              Row(
                children: [
                  Text(
                    controller.bookingId,
                    style: AppTextStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  GestureDetector(
                    onTap: () {
                      // Copy to clipboard
                      Get.snackbar(
                        'Copied',
                        'Booking ID copied to clipboard',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: const Icon(
                      Icons.copy,
                      size: 18,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg),

          // Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColor.success.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Confirmed',
                  style: AppTextStyle.caption.copyWith(
                    color: AppColor.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Payment method
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              Text(
                controller.paymentMethod,
                style: AppTextStyle.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Total paid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Paid',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              Text(
                '\$${controller.totalPaid.toStringAsFixed(2)}',
                style: AppTextStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripSummary() {
    final dateFormat = DateFormat('EEE, d MMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Operator
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColor.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.directions_bus,
                    color: AppColor.primary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.trip.operatorName,
                      style: AppTextStyle.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      controller.trip.busType,
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg),

          // Route and time
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeFormat.format(controller.trip.departureTime),
                      style: AppTextStyle.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.trip.fromCity,
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    controller.trip.durationText,
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.textSecondary,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: AppColor.textSecondary,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeFormat.format(controller.trip.arrivalTime),
                      style: AppTextStyle.subtitle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.trip.toCity,
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.lg),

          // Date and seats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColor.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    dateFormat.format(controller.trip.departureTime),
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                'Seats: ${controller.seats.map((s) => s.label).join(", ")}',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: 'View E-Ticket',
            onPressed: controller.viewETicket,
            isExpanded: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'My Bookings',
                  onPressed: controller.viewMyBookings,
                  variant: AppButtonVariant.secondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: 'Back to Home',
                  onPressed: controller.goToHome,
                  variant: AppButtonVariant.text,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
