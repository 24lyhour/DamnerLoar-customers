import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../controllers/hotel_voucher_controller.dart';

class HotelVoucherView extends GetView<HotelVoucherController> {
  const HotelVoucherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Hotel Voucher',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: controller.shareVoucher,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Screenshot(
                controller: controller.screenshotController,
                child: _buildVoucherCard(),
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildVoucherCard() {
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
          _buildQRSection(),
          _buildDashedDivider(),
          _buildHotelDetails(),
          _buildGuestSection(),
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
          Text(
            controller.bookingId,
            style: AppTextStyle.subtitle.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Show this voucher at check-in',
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

  Widget _buildHotelDetails() {
    final dateFormat = DateFormat('EEE, d MMM yyyy');
    final booking = controller.booking;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Hotel name
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
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
                      booking.hotel.name,
                      style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.hotel.address,
                      style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Check-in / Check-out
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHECK-IN',
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(booking.checkIn),
                      style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w600),
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
                      '${booking.nights}',
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
                      'CHECK-OUT',
                      style: AppTextStyle.caption.copyWith(
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateFormat.format(booking.checkOut),
                      style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w600),
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
        ],
      ),
    );
  }

  Widget _buildGuestSection() {
    final booking = controller.booking;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          _buildInfoRow('Room Type', booking.room.name),
          const Divider(height: AppSpacing.md),
          _buildInfoRow('Guest Name', controller.primaryGuestName),
          const Divider(height: AppSpacing.md),
          _buildInfoRow('Rooms', '${booking.rooms}'),
          const Divider(height: AppSpacing.md),
          _buildInfoRow('Guests', '${booking.guests}'),
          const Divider(height: AppSpacing.md),
          _buildInfoRow('Total Paid', '\$${controller.totalPaid.toStringAsFixed(2)}'),
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
            'Present valid ID at check-in',
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
              onPressed: controller.downloadVoucher,
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
