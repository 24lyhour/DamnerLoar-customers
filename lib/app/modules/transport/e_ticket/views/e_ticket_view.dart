import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../controllers/e_ticket_controller.dart';

class ETicketView extends GetView<ETicketController> {
  const ETicketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'E-Ticket',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: controller.shareTicket,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _buildTicketCard(),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildTicketCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with QR
          _buildQRSection(),

          // Dashed divider with circles
          _buildDashedDivider(),

          // Trip details
          _buildTripDetails(),

          // Passenger & seat info
          _buildPassengerSection(),

          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildQRSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // QR Code
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColor.border),
            ),
            child: QrImageView(
              data: controller.qrData,
              version: QrVersions.auto,
              size: 160,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColor.textPrimary,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppColor.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Booking ID
          Text(
            controller.bookingId,
            style: AppTextStyle.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Show this QR code to the driver',
            style: AppTextStyle.caption.copyWith(
              color: AppColor.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return Stack(
      children: [
        // Dashed line
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: List.generate(
              30,
              (index) => Expanded(
                child: Container(
                  height: 1,
                  color: index.isEven ? AppColor.border : Colors.transparent,
                ),
              ),
            ),
          ),
        ),
        // Left circle cutout
        Positioned(
          left: -12,
          top: -12,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColor.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Right circle cutout
        Positioned(
          right: -12,
          top: -12,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColor.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTripDetails() {
    final dateFormat = DateFormat('EEE, d MMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Route
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeFormat.format(controller.trip.departureTime),
                      style: AppTextStyle.headline.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      controller.trip.fromCity,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Journey indicator
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      controller.trip.durationText,
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 2,
                        color: AppColor.primary,
                      ),
                      const Icon(
                        Icons.directions_bus,
                        size: 16,
                        color: AppColor.primary,
                      ),
                      Container(
                        width: 40,
                        height: 2,
                        color: AppColor.primary,
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.primary, width: 2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeFormat.format(controller.trip.arrivalTime),
                      style: AppTextStyle.headline.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      controller.trip.toCity,
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Date
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColor.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  dateFormat.format(controller.trip.departureTime),
                  style: AppTextStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          _buildInfoRow('Operator', controller.trip.operatorName),
          const Divider(height: AppSpacing.md),
          _buildInfoRow('Bus Type', controller.trip.busType),
          const Divider(height: AppSpacing.md),
          _buildInfoRow('Seat(s)', controller.seatLabels),
          const Divider(height: AppSpacing.md),
          _buildInfoRow('Passengers', '${controller.seats.length} person(s)'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.bodySmall.copyWith(
            color: AppColor.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                size: 14,
                color: AppColor.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Please arrive 15 minutes before departure',
                style: AppTextStyle.caption.copyWith(
                  color: AppColor.textSecondary,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Download & Share row
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Download',
                  icon: Icons.download,
                  onPressed: controller.downloadTicket,
                  variant: AppButtonVariant.secondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: 'Share',
                  icon: Icons.share,
                  onPressed: controller.shareTicket,
                  variant: AppButtonVariant.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Back to Home button
          AppButton(
            label: 'Back to Home',
            onPressed: () => Get.offAllNamed('/home'),
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}
