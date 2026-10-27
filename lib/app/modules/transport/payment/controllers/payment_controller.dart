import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/seat_layout_widget.dart';
import '../../../../routes/app_pages.dart';
import '../../data/models/transport_model.dart';
import '../../passenger_info/controllers/passenger_info_controller.dart';

enum PaymentMethod { card, mobileBanking, cashOnDelivery }

class PaymentController extends GetxController {
  late final TripModel trip;
  late final List<Seat> seats;
  late final List<PassengerModel> passengers;
  late final double totalPrice;
  late final String contactEmail;
  late final String contactPhone;

  final selectedPaymentMethod = Rx<PaymentMethod?>(null);
  final isProcessing = false.obs;
  final promoCode = TextEditingController();
  final promoDiscount = 0.0.obs;
  final promoApplied = false.obs;

  // Fees
  final double serviceFee = 1.0;

  double get subtotal => totalPrice;
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
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      trip = args['trip'] as TripModel;
      seats = args['seats'] as List<Seat>;
      passengers = args['passengers'] as List<PassengerModel>;
      totalPrice = args['totalPrice'] as double;
      contactEmail = args['contactEmail'] as String;
      contactPhone = args['contactPhone'] as String;
    } else {
      // Fallback for testing
      trip = TripModel(
        id: 'test',
        operatorName: 'Giant Ibis',
        operatorLogo: null,
        busType: 'VIP Sleeper',
        departureTime: DateTime.now().add(const Duration(days: 1)),
        arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 6)),
        duration: const Duration(hours: 6),
        fromCity: 'Phnom Penh',
        toCity: 'Siem Reap',
        price: 18.0,
        availableSeats: 20,
        totalSeats: 40,
      );
      seats = [const Seat(id: '1', row: 2, column: 0, label: '3A')];
      passengers = [];
      totalPrice = 18.0;
      contactEmail = 'test@example.com';
      contactPhone = '+855 12 345 678';
    }
  }

  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
  }

  void applyPromoCode() {
    final code = promoCode.text.trim().toUpperCase();
    if (code.isEmpty) {
      Get.snackbar('Error', 'Please enter a promo code',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Mock promo codes
    if (code == 'SAVE10') {
      promoDiscount.value = totalPrice * 0.1;
      promoApplied.value = true;
      Get.snackbar('Success', '10% discount applied!',
          snackPosition: SnackPosition.BOTTOM);
    } else if (code == 'FIRST5') {
      promoDiscount.value = 5.0;
      promoApplied.value = true;
      Get.snackbar('Success', '\$5 discount applied!',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Invalid Code', 'This promo code is not valid',
          snackPosition: SnackPosition.BOTTOM);
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
      Get.snackbar('Select Payment', 'Please select a payment method',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isProcessing.value = true;

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    isProcessing.value = false;

    // Generate booking ID
    final now = DateTime.now();
    final bookingId = 'DL-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecondsSinceEpoch.toString().substring(8)}';

    // Get readable payment method name
    String paymentMethodName;
    switch (selectedPaymentMethod.value!) {
      case PaymentMethod.card:
        paymentMethodName = 'Credit/Debit Card';
      case PaymentMethod.mobileBanking:
        paymentMethodName = 'Mobile Banking';
      case PaymentMethod.cashOnDelivery:
        paymentMethodName = 'Pay at Counter';
    }

    // Navigate to confirmation
    Get.offNamed(Routes.BOOKING_CONFIRMATION, arguments: {
      'trip': trip,
      'seats': seats,
      'passengers': passengers,
      'totalPaid': grandTotal,
      'bookingId': bookingId,
      'paymentMethod': paymentMethodName,
    });
  }
}
