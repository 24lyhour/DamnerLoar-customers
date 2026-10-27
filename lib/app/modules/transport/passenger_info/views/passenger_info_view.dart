import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../../core/widgets/seat_layout_widget.dart';
import '../../data/models/transport_model.dart';
import '../controllers/passenger_info_controller.dart';

class PassengerInfoView extends GetView<PassengerInfoController> {
  const PassengerInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Passenger Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trip summaries
                    Obx(() {
                      if (controller.isRoundTrip.value) {
                        return Column(
                          children: [
                            _buildTripSummaryCard(
                              label: 'Outbound',
                              trip: controller.outboundTrip,
                              seats: controller.outboundSeats,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            if (controller.returnTrip != null)
                              _buildTripSummaryCard(
                                label: 'Return',
                                trip: controller.returnTrip!,
                                seats: controller.returnSeats!,
                              ),
                          ],
                        );
                      }
                      return _buildTripSummary();
                    }),
                    const SizedBox(height: AppSpacing.lg),

                    // Passenger forms
                    Obx(
                      () => Column(
                        children: List.generate(
                          controller.passengers.length,
                          (index) => _buildPassengerForm(index),
                        ),
                      ),
                    ),

                    // Contact info
                    _buildContactSection(),
                    const SizedBox(height: AppSpacing.md),

                    // Terms checkbox
                    _buildTermsCheckbox(),
                  ],
                ),
              ),
            ),
          ),

          // Bottom bar
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTripSummary() {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('EEE, d MMM');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        children: [
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
                      '${controller.trip.busType} · ${controller.seats.length} seat(s)',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(controller.trip.departureTime),
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.textSecondary,
                ),
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

  Widget _buildTripSummaryCard({
    required String label,
    required TripModel trip,
    required List<Seat> seats,
  }) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('EEE, d MMM');

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
          // Label badge
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
              Text(trip.durationText, style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary)),
              const Icon(Icons.arrow_forward, size: 14, color: AppColor.textSecondary),
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

  Widget _buildPassengerForm(int index) {
    final passenger = controller.passengers[index];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with seat badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Seat ${passenger.seatLabel}',
                  style: AppTextStyle.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Passenger ${index + 1}',
                style: AppTextStyle.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Name field
          _buildTextField(
            controller: passenger.nameController,
            label: 'Full Name',
            hint: 'Enter passenger name',
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Phone field
          _buildTextField(
            controller: passenger.phoneController,
            label: 'Phone Number',
            hint: 'Enter phone number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
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
          Text(
            'Contact Information',
            style: AppTextStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'We\'ll send your e-ticket to this contact',
            style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),

          _buildTextField(
            controller: controller.contactEmail,
            label: 'Email',
            hint: 'Enter email address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.sm),

          _buildTextField(
            controller: controller.contactPhone,
            label: 'Phone',
            hint: 'Enter phone number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: controller.agreeToTerms.value,
              onChanged: (v) => controller.agreeToTerms.value = v ?? false,
              activeColor: AppColor.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.agreeToTerms.toggle(),
              child: Text.rich(
                TextSpan(
                  text: 'I agree to the ',
                  style: AppTextStyle.bodySmall,
                  children: [
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyle.bodySmall.copyWith(
              color: AppColor.textSecondary.withAlpha(150),
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: AppColor.textSecondary)
                : null,
            filled: true,
            fillColor: AppColor.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: AppColor.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
          ),
          style: AppTextStyle.bodySmall,
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: AppSpacing.md + MediaQuery.of(Get.context!).padding.bottom,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${controller.totalPrice.toStringAsFixed(2)}',
                  style: AppTextStyle.subtitle.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => AppButton(
              label: 'Proceed to Payment',
              onPressed: controller.canProceed ? controller.proceedToPayment : null,
              size: AppButtonSize.medium,
            ),
          ),
        ],
      ),
    );
  }
}
