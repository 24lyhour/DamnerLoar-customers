import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/seat_layout_widget.dart';
import '../../data/models/transport_model.dart';

class PassengerModel {
  final String seatLabel;
  final TextEditingController nameController;
  final TextEditingController phoneController;

  PassengerModel({required this.seatLabel})
      : nameController = TextEditingController(),
        phoneController = TextEditingController();

  void dispose() {
    nameController.dispose();
    phoneController.dispose();
  }

  bool get isValid =>
      nameController.text.trim().isNotEmpty && phoneController.text.trim().isNotEmpty;

  String get name => nameController.text.trim();
  String get phone => phoneController.text.trim();
}

class PassengerInfoController extends GetxController {
  late final TripModel trip;
  late final List<Seat> seats;
  late final double totalPrice;

  final passengers = <PassengerModel>[].obs;
  final contactEmail = TextEditingController();
  final contactPhone = TextEditingController();
  final agreeToTerms = false.obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
    _initPassengers();
  }

  @override
  void onClose() {
    for (final p in passengers) {
      p.dispose();
    }
    contactEmail.dispose();
    contactPhone.dispose();
    super.onClose();
  }

  void _loadArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      trip = args['trip'] as TripModel;
      // Safe cast for List<Seat>
      final seatsList = args['seats'] as List;
      seats = seatsList.map((s) => s as Seat).toList();
      totalPrice = args['totalPrice'] as double;
    } else {
      // Fallback for testing
      trip = TripModel(
        id: 'test',
        operatorName: 'Test Bus',
        operatorLogo: null,
        busType: 'VIP',
        departureTime: DateTime.now(),
        arrivalTime: DateTime.now().add(const Duration(hours: 6)),
        duration: const Duration(hours: 6),
        fromCity: 'Phnom Penh',
        toCity: 'Siem Reap',
        price: 15.0,
        availableSeats: 20,
        totalSeats: 40,
      );
      seats = [
        const Seat(id: '1', row: 0, column: 0, label: '1A'),
      ];
      totalPrice = 15.0;
    }
  }

  void _initPassengers() {
    final storage = StorageService.to;

    passengers.value = seats.map((seat) {
      return PassengerModel(seatLabel: seat.label);
    }).toList();

    // Auto-fill first passenger with logged-in user's info
    if (passengers.isNotEmpty) {
      final userName = storage.userName;
      final userPhone = storage.userPhone;

      if (userName != null && userName.isNotEmpty) {
        passengers.first.nameController.text = userName;
      }
      if (userPhone != null && userPhone.isNotEmpty) {
        passengers.first.phoneController.text = userPhone;
      }
    }

    // Auto-fill contact info
    final userEmail = storage.userEmail;
    final userPhone = storage.userPhone;

    if (userEmail != null && userEmail.isNotEmpty) {
      contactEmail.text = userEmail;
    }
    if (userPhone != null && userPhone.isNotEmpty) {
      contactPhone.text = userPhone;
    }
  }

  bool get canProceed {
    if (!agreeToTerms.value) return false;
    if (contactEmail.text.isEmpty || contactPhone.text.isEmpty) return false;
    return passengers.every((p) => p.isValid);
  }

  void proceedToPayment() {
    if (!canProceed) {
      Get.snackbar(
        'Incomplete information',
        'Please fill all passenger details and agree to terms',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.toNamed('/transport/payment', arguments: {
      'trip': trip,
      'seats': seats,
      'passengers': passengers.toList(),
      'totalPrice': totalPrice,
      'contactEmail': contactEmail.text,
      'contactPhone': contactPhone.text,
    });
  }
}
