import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../controllers/guest_info_controller.dart';

class GuestInfoView extends GetView<GuestInfoController> {
  const GuestInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Guest Details',
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
                    _buildBookingSummary(),
                    const SizedBox(height: AppSpacing.md),
                    _buildGuestForms(),
                    const SizedBox(height: AppSpacing.md),
                    _buildContactSection(),
                    const SizedBox(height: AppSpacing.md),
                    _buildSpecialRequests(),
                    const SizedBox(height: AppSpacing.md),
                    _buildTermsCheckbox(),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBookingSummary() {
    final dateFormat = DateFormat('EEE, d MMM');
    final booking = controller.booking;

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
                      style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      booking.room.name,
                      style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
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
                      'Check-in',
                      style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                    ),
                    Text(
                      dateFormat.format(booking.checkIn),
                      style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColor.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${booking.nights} night(s)',
                  style: AppTextStyle.caption.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w500,
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
                    Text(
                      dateFormat.format(booking.checkOut),
                      style: AppTextStyle.bodySmall.copyWith(fontWeight: FontWeight.w500),
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

  Widget _buildGuestForms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Guest Information',
          style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Obx(() => Column(
              children: controller.guests.asMap().entries.map((entry) {
                final index = entry.key;
                final guest = entry.value;
                return _buildGuestCard(guest, index);
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildGuestCard(GuestModel guest, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColor.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  guest.roomLabel,
                  style: AppTextStyle.caption.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (index == 0)
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                  child: Text(
                    '(Primary Guest)',
                    style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: guest.nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'As shown on ID',
              prefixIcon: const Icon(Icons.person_outline, size: 20),
              filled: true,
              fillColor: AppColor.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide.none,
              ),
            ),
            style: AppTextStyle.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: guest.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'For booking confirmation',
              prefixIcon: const Icon(Icons.email_outlined, size: 20),
              filled: true,
              fillColor: AppColor.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide.none,
              ),
            ),
            style: AppTextStyle.bodyMedium,
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
            'Contact Number',
            style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: controller.contactPhone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '+855 12 345 678',
              prefixIcon: const Icon(Icons.phone_outlined, size: 20),
              filled: true,
              fillColor: AppColor.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide.none,
              ),
            ),
            style: AppTextStyle.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialRequests() {
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
            'Special Requests',
            style: AppTextStyle.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Optional - subject to availability',
            style: AppTextStyle.caption.copyWith(color: AppColor.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: controller.specialRequests,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'E.g., high floor, late check-out, etc.',
              filled: true,
              fillColor: AppColor.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                borderSide: BorderSide.none,
              ),
            ),
            style: AppTextStyle.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Obx(() => GestureDetector(
          onTap: () => controller.agreeToTerms.toggle(),
          child: Row(
            children: [
              Checkbox(
                value: controller.agreeToTerms.value,
                onChanged: (v) => controller.agreeToTerms.value = v ?? false,
                activeColor: AppColor.primary,
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: 'I agree to the ',
                    style: AppTextStyle.bodySmall,
                    children: [
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Cancellation Policy',
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: AppTextStyle.bodySmall.copyWith(color: AppColor.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${controller.booking.totalPrice.toStringAsFixed(0)}',
                  style: AppTextStyle.subtitle.copyWith(
                    color: AppColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => AppButton(
                label: 'Continue to Payment',
                onPressed: controller.canProceed ? controller.proceedToPayment : null,
                size: AppButtonSize.medium,
              )),
        ],
      ),
    );
  }
}
