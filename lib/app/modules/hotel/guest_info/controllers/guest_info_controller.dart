import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/helpers/toast_helper.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_pages.dart';
import '../../../payment/data/models/payment_data_model.dart';
import '../../data/models/hotel_model.dart';

class GuestModel {
  final String roomLabel;
  final TextEditingController nameController;
  final TextEditingController emailController;

  GuestModel({required this.roomLabel})
      : nameController = TextEditingController(),
        emailController = TextEditingController();

  void dispose() {
    nameController.dispose();
    emailController.dispose();
  }

  bool get isValid =>
      nameController.text.trim().isNotEmpty && emailController.text.trim().isNotEmpty;

  String get name => nameController.text.trim();
  String get email => emailController.text.trim();
}

class GuestInfoController extends GetxController {
  late final HotelBooking booking;

  final guests = <GuestModel>[].obs;
  final contactPhone = TextEditingController();
  final specialRequests = TextEditingController();
  final agreeToTerms = false.obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
    _initGuests();
  }

  @override
  void onClose() {
    for (final g in guests) {
      g.dispose();
    }
    contactPhone.dispose();
    specialRequests.dispose();
    super.onClose();
  }

  void _loadArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      booking = args['booking'] as HotelBooking;
    } else {
      // Fallback
      booking = HotelBooking(
        hotel: HotelModel(
          id: 'test',
          name: 'Test Hotel',
          location: 'Siem Reap',
          address: 'Test Address',
          rating: 4.5,
          reviewCount: 100,
          pricePerNight: 100,
        ),
        room: const RoomType(
          id: 'r1',
          name: 'Deluxe Room',
          pricePerNight: 100,
          maxGuests: 2,
          bedType: 'King Bed',
          roomSize: 35,
          availableRooms: 5,
        ),
        checkIn: DateTime.now().add(const Duration(days: 7)),
        checkOut: DateTime.now().add(const Duration(days: 9)),
        rooms: 1,
        guests: 2,
      );
    }
  }

  void _initGuests() {
    final storage = StorageService.to;

    // One guest per room
    guests.value = List.generate(booking.rooms, (index) {
      return GuestModel(roomLabel: 'Room ${index + 1}');
    });

    // Auto-fill first guest
    if (guests.isNotEmpty) {
      final userName = storage.userName;
      final userEmail = storage.userEmail;

      if (userName != null && userName.isNotEmpty) {
        guests.first.nameController.text = userName;
      }
      if (userEmail != null && userEmail.isNotEmpty) {
        guests.first.emailController.text = userEmail;
      }
    }

    // Auto-fill contact
    final userPhone = storage.userPhone;
    if (userPhone != null && userPhone.isNotEmpty) {
      contactPhone.text = userPhone;
    }
  }

  bool get canProceed {
    if (!agreeToTerms.value) return false;
    if (contactPhone.text.isEmpty) return false;
    return guests.every((g) => g.isValid);
  }

  void proceedToPayment() {
    if (!canProceed) {
      AppToast.warning(
        'Please fill all guest details and agree to terms',
        title: 'Incomplete information',
      );
      return;
    }

    final guestEmail = guests.first.emailController.text;

    final paymentData = PaymentData(
      bookingType: 'hotel',
      title: booking.hotel.name,
      subtitle: '${booking.room.name} · ${booking.nights} night(s)',
      date: booking.checkIn,
      endDate: booking.checkOut,
      itemCount: booking.rooms,
      itemLabel: 'room(s)',
      itemDetails: List.generate(booking.rooms, (i) => 'Room ${i + 1}'),
      unitPrice: booking.room.pricePerNight,
      totalPrice: booking.totalPrice,
      contactEmail: guestEmail,
      contactPhone: contactPhone.text,
      successRoute: Routes.HOTEL_VOUCHER,
      successArguments: {
        'booking': booking,
        'guests': guests.map((g) => {'name': g.name, 'email': g.email}).toList(),
        'contactPhone': contactPhone.text,
        'specialRequests': specialRequests.text,
      },
    );

    Get.toNamed(Routes.PAYMENT, arguments: paymentData);
  }
}
