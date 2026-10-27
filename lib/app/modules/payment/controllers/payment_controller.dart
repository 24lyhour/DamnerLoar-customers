import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helpers/toast_helper.dart';
import '../data/models/payment_data_model.dart';

enum PaymentMethod { card, mobileBanking, cashOnDelivery }

class PaymentController extends GetxController {
  late final PaymentData paymentData;

  final selectedPaymentMethod = Rx<PaymentMethod?>(null);
  final isProcessing = false.obs;
  final promoCode = TextEditingController();
  final promoDiscount = 0.0.obs;
  final promoApplied = false.obs;

  final double serviceFee = 1.0;

  double get subtotal => paymentData.totalPrice;
  double get discount => promoDiscount.value;
  double get grandTotal => subtotal + serviceFee - discount;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  @override
  void onClose() {
    promoCode.dispose();
    super.onClose();
  }

  void _loadArguments() {
    final args = Get.arguments;
    if (args is PaymentData) {
      paymentData = args;
    } else if (args is Map<String, dynamic> &&
        args['paymentData'] is PaymentData) {
      paymentData = args['paymentData'] as PaymentData;
    } else {
      // Fallback for testing
      paymentData = PaymentData(
        bookingType: 'transport',
        title: 'Phnom Penh → Siem Reap',
        subtitle: 'Giant Ibis · VIP Sleeper',
        date: DateTime.now().add(const Duration(days: 1)),
        time: '07:30',
        itemCount: 2,
        itemLabel: 'seat(s)',
        itemDetails: ['7A', '7B'],
        unitPrice: 18.0,
        totalPrice: 36.0,
        contactEmail: 'test@example.com',
        contactPhone: '+855 12 345 678',
        successRoute: '/home',
        successArguments: {},
      );
    }
  }

  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
  }

  void applyPromoCode() {
    final code = promoCode.text.trim().toUpperCase();
    if (code.isEmpty) {
      AppToast.error('Please enter a promo code');
      return;
    }

    if (code == 'SAVE10') {
      promoDiscount.value = paymentData.totalPrice * 0.1;
      promoApplied.value = true;
      AppToast.success('10% discount applied!');
    } else if (code == 'FIRST5') {
      promoDiscount.value = 5.0;
      promoApplied.value = true;
      AppToast.success('\$5 discount applied!');
    } else {
      AppToast.error('This promo code is not valid', title: 'Invalid Code');
    }
  }

  void removePromoCode() {
    promoCode.clear();
    promoDiscount.value = 0.0;
    promoApplied.value = false;
  }

  bool get canPay => selectedPaymentMethod.value != null;

  Future<void> processPayment() async {
    if (!canPay) {
      AppToast.info('Please select a payment method', title: 'Select Payment');
      return;
    }

    isProcessing.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isProcessing.value = false;

    // Generate booking ID
    final now = DateTime.now();
    final baseId =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecondsSinceEpoch.toString().substring(8)}';
    final bookingId = 'DL-$baseId';

    String paymentMethodName;
    switch (selectedPaymentMethod.value!) {
      case PaymentMethod.card:
        paymentMethodName = 'Credit/Debit Card';
      case PaymentMethod.mobileBanking:
        paymentMethodName = 'Mobile Banking';
      case PaymentMethod.cashOnDelivery:
        paymentMethodName = 'Pay at Counter';
    }

    // Merge payment result into success arguments
    final successArgs = Map<String, dynamic>.from(paymentData.successArguments);
    successArgs['bookingId'] = bookingId;
    successArgs['paymentMethod'] = paymentMethodName;
    successArgs['totalPaid'] = grandTotal;

    Get.offNamed(paymentData.successRoute, arguments: successArgs);
  }
}
