import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../data/models/transport_model.dart';
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
        title: Obx(() {
          if (controller.isRoundTrip.value && controller.returnTrip != null) {
            return Text(
              controller.currentPage.value == 0 ? 'Outbound Ticket' : 'Return Ticket',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            );
          }
          return const Text(
            'E-Ticket',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          );
        }),
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
          // Page indicator for round-trip
          Obx(() {
            if (controller.isRoundTrip.value && controller.returnTrip != null) {
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPageDot(isActive: controller.currentPage.value == 0),
                    const SizedBox(width: 8),
                    _buildPageDot(isActive: controller.currentPage.value == 1),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Swipeable tickets
          Expanded(
            child: Obx(() {
              if (controller.isRoundTrip.value && controller.returnTrip != null) {
                return PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  children: [
                    // Outbound ticket
                    _buildTicketPage(
                      screenshotController: controller.outboundScreenshotController,
                      trip: controller.outboundTrip,
                      bookingId: controller.outboundBookingId,
                      qrData: controller.outboundQrData,
                      seatLabels: controller.outboundSeatLabels,
                      seatCount: controller.outboundSeats.length,
                    ),
                    // Return ticket
                    _buildTicketPage(
                      screenshotController: controller.returnScreenshotController,
                      trip: controller.returnTicketTrip!,
                      bookingId: controller.returnTicketBookingId,
                      qrData: controller.returnQrData,
                      seatLabels: controller.returnSeatLabels,
                      seatCount: controller.returnTicketSeats.length,
                    ),
                  ],
                );
              }
              // One-way: single ticket
              return _buildTicketPage(
                screenshotController: controller.outboundScreenshotController,
                trip: controller.outboundTrip,
                bookingId: controller.outboundBookingId,
                qrData: controller.outboundQrData,
                seatLabels: controller.outboundSeatLabels,
                seatCount: controller.outboundSeats.length,
              );
            }),
          ),

          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildPageDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withAlpha(100),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildTicketPage({
    required ScreenshotController screenshotController,
    required TripModel trip,
    required String bookingId,
    required String qrData,
    required String seatLabels,
    required int seatCount,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Screenshot(
        controller: screenshotController,
        child: _buildTicketCard(
          trip: trip,
          bookingId: bookingId,
          qrData: qrData,
          seatLabels: seatLabels,
          seatCount: seatCount,
        ),
      ),
    );
  }

  Widget _buildTicketCard({
    required TripModel trip,
    required String bookingId,
    required String qrData,
    required String seatLabels,
    required int seatCount,
  }) {
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
          _buildQRSection(bookingId: bookingId, qrData: qrData),
          _buildDashedDivider(),
          _buildTripDetails(trip: trip),
          _buildPassengerSection(trip: trip, seatLabels: seatLabels, seatCount: seatCount),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildQRSection({required String bookingId, required String qrData}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColor.border),
            ),
            child: QrImageView(
              data: qrData,
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
          Text(
            bookingId,
            style: AppTextStyle.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Show this QR code to the driver',
            style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return Stack(
      children: [
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

  Widget _buildTripDetails({required TripModel trip}) {
    final dateFormat = DateFormat('EEE, d MMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeFormat.format(trip.departureTime),
                      style: AppTextStyle.headline.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      trip.fromCity,
                      style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      trip.durationText,
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
                      Container(width: 40, height: 2, color: AppColor.primary),
                      const Icon(Icons.directions_bus, size: 16, color: AppColor.primary),
                      Container(width: 40, height: 2, color: AppColor.primary),
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
                      timeFormat.format(trip.arrivalTime),
                      style: AppTextStyle.headline.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      trip.toCity,
                      style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppColor.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  dateFormat.format(trip.departureTime),
                  style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerSection({
    required TripModel trip,
    required String seatLabels,
    required int seatCount,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          _buildInfoRow('Operator', trip.operatorName),
          const Divider(height: AppSpacing.md),
          _buildInfoRow('Bus Type', trip.busType),
          const Divider(height: AppSpacing.md),
          _buildInfoRow('Seat(s)', seatLabels),
          const Divider(height: AppSpacing.md),
          _buildInfoRow('Passengers', '$seatCount person(s)'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary)),
        Text(value, style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 14, color: AppColor.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Please arrive 15 minutes before departure',
            style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
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
      child: Row(
        children: [
          Expanded(
            child: _buildWhiteOutlinedButton(
              label: 'Download',
              icon: Icons.download,
              onPressed: controller.downloadTicket,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _buildWhiteFilledButton(
              label: 'Back to Home',
              onPressed: controller.goToHome,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteOutlinedButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyle.button.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhiteFilledButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyle.button.copyWith(color: AppColor.primary, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
