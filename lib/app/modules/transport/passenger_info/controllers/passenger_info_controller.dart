import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/helpers/toast_helper.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/widgets/seat_layout_widget.dart';
import '../../../../routes/app_pages.dart';
import '../../../payment/data/models/payment_data_model.dart';
import '../../data/models/transport_model.dart';
import '../../trip_list/controllers/trip_list_controller.dart';

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

  // Round-trip state
  final isRoundTrip = false.obs;
  BookingLeg? outboundLeg;
  BookingLeg? returnLeg;

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

      // Round-trip data
      isRoundTrip.value = args['isRoundTrip'] as bool? ?? false;
      outboundLeg = args['outboundLeg'] as BookingLeg?;
      returnLeg = args['returnLeg'] as BookingLeg?;
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

  /// Get outbound trip (for round-trip, use outboundLeg; for one-way, use trip)
  TripModel get outboundTrip => outboundLeg?.trip ?? trip;

  /// Get outbound seats
  List<Seat> get outboundSeats => outboundLeg?.seats ?? seats;

  /// Get return trip (null for one-way)
  TripModel? get returnTrip => returnLeg?.trip;

  /// Get return seats (null for one-way)
  List<Seat>? get returnSeats => returnLeg?.seats;

  void proceedToPayment() {
    if (!canProceed) {
      AppToast.warning(
        'Please fill all passenger details and agree to terms',
        title: 'Incomplete information',
      );
      return;
    }

    final timeFormat = DateFormat('HH:mm');

    // Create PaymentData for shared payment module
    final paymentData = PaymentData(
      bookingType: 'transport',
      title: '${trip.fromCity} → ${trip.toCity}',
      subtitle: '${trip.operatorName} · ${trip.busType}',
      date: trip.departureTime,
      time: timeFormat.format(trip.departureTime),
      itemCount: seats.length,
      itemLabel: 'seat(s)',
      itemDetails: seats.map((s) => s.label).toList(),
      unitPrice: trip.price,
      totalPrice: totalPrice,
      contactEmail: contactEmail.text,
      contactPhone: contactPhone.text,
      successRoute: Routes.BOOKING_CONFIRMATION,
      successArguments: {
        'trip': trip,
        'seats': seats,
        'passengers': passengers.toList(),
        'isRoundTrip': isRoundTrip.value,
        'outboundLeg': outboundLeg,
        'returnLeg': returnLeg,
      },
    );

    Get.toNamed(Routes.PAYMENT, arguments: paymentData);
  }
}
