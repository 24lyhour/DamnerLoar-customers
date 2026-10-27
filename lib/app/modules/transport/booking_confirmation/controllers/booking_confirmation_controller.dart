import 'package:get/get.dart';

import '../../../../core/widgets/seat_layout_widget.dart';
import '../../../../routes/app_pages.dart';
import '../../data/models/transport_model.dart';
import '../../passenger_info/controllers/passenger_info_controller.dart';

class BookingConfirmationController extends GetxController {
  late final String bookingId;
  late final TripModel trip;
  late final List<Seat> seats;
  late final List<PassengerModel> passengers;
  late final double totalPaid;
  late final String paymentMethod;
  late final DateTime bookingTime;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      bookingId = args['bookingId'] as String;
      trip = args['trip'] as TripModel;
      final seatsList = args['seats'] as List;
      seats = seatsList.map((s) => s as Seat).toList();
      final passengersList = args['passengers'] as List;
      passengers = passengersList.map((p) => p as PassengerModel).toList();
      totalPaid = args['totalPaid'] as double;
      paymentMethod = args['paymentMethod'] as String;
      bookingTime = DateTime.now();
    } else {
      // Fallback for testing
      bookingId = 'DL-2026102700001';
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
      seats = [const Seat(id: '1', row: 0, column: 0, label: '7A')];
      passengers = [];
      totalPaid = 18.0;
      paymentMethod = 'Credit Card';
      bookingTime = DateTime.now();
    }
  }

  void viewETicket() {
    Get.toNamed(Routes.E_TICKET, arguments: {
      'bookingId': bookingId,
      'trip': trip,
      'seats': seats,
      'passengers': passengers,
    });
  }

  void goToHome() {
    Get.offAllNamed(Routes.HOME);
  }

  void viewMyBookings() {
    Get.offAllNamed(Routes.BOOKING);
  }
}
