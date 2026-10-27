import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/helpers/toast_helper.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/seat_layout_widget.dart';
import '../../data/models/transport_model.dart';
import '../controllers/booking_confirmation_controller.dart';

class BookingConfirmationView extends GetView<BookingConfirmationController> {
  const BookingConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xl),

                    // Success icon with animation feel
                    _buildSuccessIcon(),
                    const SizedBox(height: AppSpacing.lg),

                    // Success message
                    Text(
                      'Booking Confirmed!',
                      style: AppTextStyle.title.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Your ticket has been booked successfully',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Booking details card
                    _buildBookingCard(),
                    const SizedBox(height: AppSpacing.md),

                    // Trip summaries
                    Obx(() {
                      if (controller.isRoundTrip.value) {
                        return Column(
                          children: [
                            _buildTripSummaryCard(
                              label: 'Outbound',
                              trip: controller.outboundTrip,
                              seats: controller.outboundSeats,
                              bookingId: controller.bookingId,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            if (controller.returnTrip != null)
                              _buildTripSummaryCard(
                                label: 'Return',
                                trip: controller.returnTrip!,
                                seats: controller.returnSeats!,
                                bookingId: controller.returnBookingId ?? '',
                              ),
                          ],
                        );
                      }
                      return _buildTripSummary();
                    }),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),

            // Bottom actions - clean 2 button layout
            _buildCleanBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: AppColor.success.withAlpha(25),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColor.success,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        children: [
          // Booking ID row
          _buildInfoRow(
            label: 'Booking ID',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.bookingId,
                  style: AppTextStyle.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: controller.bookingId));
                    AppToast.copied('Booking ID copied');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.copy_outlined,
                      size: 16,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: AppSpacing.lg),

          // Status row
          _buildInfoRow(
            label: 'Status',
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColor.success.withAlpha(20),
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
          ),
          const SizedBox(height: AppSpacing.sm),

          // Payment method
          _buildInfoRow(
            label: 'Payment',
            value: controller.paymentMethod,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Total paid
          _buildInfoRow(
            label: 'Total Paid',
            child: Text(
              '\$${controller.totalPaid.toStringAsFixed(2)}',
              style: AppTextStyle.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
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
          // Operator header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColor.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: AppColor.primary,
                  size: 22,
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

          // Route timeline
          Row(
            children: [
              // Departure
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
                    const SizedBox(height: 2),
                    Text(
                      controller.trip.fromCity,
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Duration indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        controller.trip.durationText,
                        style: AppTextStyle.caption.copyWith(
                          color: AppColor.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppColor.textTertiary,
                    ),
                  ],
                ),
              ),

              // Arrival
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
                    const SizedBox(height: 2),
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
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: AppColor.textSecondary.withAlpha(180),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    dateFormat.format(controller.trip.departureTime),
                    style: AppTextStyle.caption.copyWith(
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primary.withAlpha(15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Seats: ${controller.seats.map((s) => s.label).join(", ")}',
                  style: AppTextStyle.caption.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripSummaryCard({
    required String label,
    required TripModel trip,
    required List<Seat> seats,
    required String bookingId,
  }) {
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
          // Label badge with booking ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: label == 'Outbound'
                      ? AppColor.primary.withAlpha(20)
                      : AppColor.success.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: AppTextStyle.caption.copyWith(
                    color: label == 'Outbound' ? AppColor.primary : AppColor.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                bookingId,
                style: AppTextStyle.caption.copyWith(
                  color: AppColor.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Operator row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColor.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.directions_bus, color: AppColor.primary, size: 18),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.operatorName,
                      style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      trip.busType,
                      style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.md),

          // Time row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeFormat.format(trip.departureTime),
                      style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      trip.fromCity,
                      style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    trip.durationText,
                    style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary, fontSize: 10),
                  ),
                  const Icon(Icons.arrow_forward, size: 14, color: AppColor.textSecondary),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeFormat.format(trip.arrivalTime),
                      style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      trip.toCity,
                      style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.md),

          // Date and seats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(trip.departureTime),
                style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
              ),
              Text(
                'Seats: ${seats.map((s) => s.label).join(", ")}',
                style: AppTextStyle.caption.copyWith(
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

  Widget _buildInfoRow({
    required String label,
    String? value,
    Widget? child,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.bodySmall.copyWith(
            color: AppColor.textSecondary,
          ),
        ),
        child ??
            Text(
              value ?? '',
              style: AppTextStyle.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
      ],
    );
  }

  Widget _buildCleanBottomBar() {
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
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grid buttons row
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'View E-Ticket',
                  onPressed: controller.viewETicket,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: 'Back to Home',
                  onPressed: controller.goToHome,
                  variant: AppButtonVariant.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
