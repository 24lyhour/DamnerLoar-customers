import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/widgets/app_button_widget.dart';
import '../controllers/payment_controller.dart';
import '../widgets/payment_method_tile_widget.dart';
import '../widgets/price_row_widget.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderSummary(),
                  const SizedBox(height: AppSpacing.md),
                  _buildPromoSection(),
                  const SizedBox(height: AppSpacing.md),
                  _buildPaymentMethods(),
                  const SizedBox(height: AppSpacing.md),
                  _buildPriceBreakdown(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    final dateFormat = DateFormat('EEE, d MMM yyyy');
    final data = controller.paymentData;

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
            'Order Summary',
            style: AppTextStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(height: AppSpacing.lg),
          Row(
            children: [
              Icon(
                data.isTransport ? Icons.directions_bus : Icons.hotel,
                size: 20,
                color: AppColor.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  data.title,
                  style: AppTextStyle.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColor.textSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                dateFormat.format(data.date),
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
              if (data.time != null) ...[
                const SizedBox(width: AppSpacing.md),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColor.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  data.time!,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.business,
                size: 16,
                color: AppColor.textSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                data.subtitle,
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                data.isTransport ? Icons.event_seat : Icons.bed,
                size: 16,
                color: AppColor.textSecondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${data.itemCount} ${data.itemLabel}: ${data.itemDetails.join(", ")}',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColor.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
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
            'Promo Code',
            style: AppTextStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Obx(() {
            if (controller.promoApplied.value) {
              return Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColor.success.withAlpha(20),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: AppColor.success.withAlpha(50)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 20,
                      color: AppColor.success,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.promoCode.text.toUpperCase(),
                            style: AppTextStyle.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColor.success,
                            ),
                          ),
                          Text(
                            'You saved \$${controller.promoDiscount.value.toStringAsFixed(2)}',
                            style: AppTextStyle.caption.copyWith(
                              color: AppColor.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.removePromoCode,
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.promoCode,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      hintStyle: AppTextStyle.bodySmall.copyWith(
                        color: AppColor.textTertiary,
                      ),
                      filled: true,
                      fillColor: AppColor.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSm,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    style: AppTextStyle.bodySmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppButton(
                  label: 'Apply',
                  onPressed: controller.applyPromoCode,
                  size: AppButtonSize.small,
                  variant: AppButtonVariant.secondary,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
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
            'Payment Method',
            style: AppTextStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Obx(
            () => Column(
              children: [
                PaymentMethodTile(
                  icon: Icons.credit_card,
                  title: 'Credit/Debit Card',
                  subtitle: 'Visa, Mastercard, JCB',
                  isSelected:
                      controller.selectedPaymentMethod.value ==
                      PaymentMethod.card,
                  onTap: () =>
                      controller.selectPaymentMethod(PaymentMethod.card),
                ),
                const SizedBox(height: AppSpacing.sm),
                PaymentMethodTile(
                  icon: Icons.account_balance,
                  title: 'Mobile Banking',
                  subtitle: 'ABA, ACLEDA, Wing, etc.',
                  isSelected:
                      controller.selectedPaymentMethod.value ==
                      PaymentMethod.mobileBanking,
                  onTap: () => controller.selectPaymentMethod(
                    PaymentMethod.mobileBanking,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                PaymentMethodTile(
                  icon: Icons.payments_outlined,
                  title: 'Pay at Counter',
                  subtitle: 'Pay when you arrive',
                  isSelected:
                      controller.selectedPaymentMethod.value ==
                      PaymentMethod.cashOnDelivery,
                  onTap: () => controller.selectPaymentMethod(
                    PaymentMethod.cashOnDelivery,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    final data = controller.paymentData;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.border),
      ),
      child: Obx(
        () => Column(
          children: [
            PriceRow(
              label: 'Subtotal (${data.itemCount} ${data.itemLabel})',
              value: '\$${controller.subtotal.toStringAsFixed(2)}',
            ),
            const SizedBox(height: AppSpacing.xs),
            PriceRow(
              label: 'Service Fee',
              value: '\$${controller.serviceFee.toStringAsFixed(2)}',
            ),
            if (controller.promoApplied.value) ...[
              const SizedBox(height: AppSpacing.xs),
              PriceRow(
                label: 'Discount',
                value: '-\$${controller.discount.toStringAsFixed(2)}',
                valueColor: AppColor.success,
              ),
            ],
            const Divider(height: AppSpacing.lg),
            PriceRow(
              label: 'Total',
              value: '\$${controller.grandTotal.toStringAsFixed(2)}',
              isBold: true,
            ),
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
      child: Obx(
        () => Row(
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
                    '\$${controller.grandTotal.toStringAsFixed(2)}',
                    style: AppTextStyle.subtitle.copyWith(
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            AppButton(
              label: controller.isProcessing.value
                  ? 'Processing...'
                  : 'Pay Now',
              onPressed: controller.canPay && !controller.isProcessing.value
                  ? controller.processPayment
                  : null,
              isLoading: controller.isProcessing.value,
              size: AppButtonSize.medium,
            ),
          ],
        ),
      ),
    );
  }
}
