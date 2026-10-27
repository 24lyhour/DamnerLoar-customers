import 'package:get/get.dart';

import '../../../../core/widgets/seat_layout_widget.dart';
import '../../../../routes/app_pages.dart';
import '../../data/models/transport_model.dart';
import '../../passenger_info/controllers/passenger_info_controller.dart';
import '../../trip_list/controllers/trip_list_controller.dart';

class BookingConfirmationController extends GetxController {
  late final String bookingId;
  late final TripModel trip;
  late final List<Seat> seats;
  late final List<PassengerModel> passengers;
  late final double totalPaid;
  late final String paymentMethod;
  late final DateTime bookingTime;

  // Round-trip state
  final isRoundTrip = false.obs;
  BookingLeg? outboundLeg;
  BookingLeg? returnLeg;
  String? returnBookingId;

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

      // Round-trip data
      isRoundTrip.value = args['isRoundTrip'] as bool? ?? false;
      outboundLeg = args['outboundLeg'] as BookingLeg?;
      returnLeg = args['returnLeg'] as BookingLeg?;
      returnBookingId = args['returnBookingId'] as String?;
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

  /// Get outbound trip (for round-trip, use outboundLeg; for one-way, use trip)
  TripModel get outboundTrip => outboundLeg?.trip ?? trip;

  /// Get outbound seats
  List<Seat> get outboundSeats => outboundLeg?.seats ?? seats;

  /// Get return trip (null for one-way)
  TripModel? get returnTrip => returnLeg?.trip;

  /// Get return seats (null for one-way)
  List<Seat>? get returnSeats => returnLeg?.seats;

  void viewETicket() {
    // For round-trip, show outbound ticket first
    Get.toNamed(Routes.E_TICKET, arguments: {
      'bookingId': bookingId,
      'trip': outboundTrip,
      'seats': outboundSeats,
      'passengers': passengers,
      'isRoundTrip': isRoundTrip.value,
      'returnBookingId': returnBookingId,
      'returnTrip': returnTrip,
      'returnSeats': returnSeats,
    });
  }

  void viewReturnTicket() {
    if (!isRoundTrip.value || returnTrip == null) return;

    Get.toNamed(Routes.E_TICKET, arguments: {
      'bookingId': returnBookingId,
      'trip': returnTrip,
      'seats': returnSeats,
      'passengers': passengers,
      'isRoundTrip': false, // Viewing single ticket
    });
  }

  void goToHome() {
    Get.offAllNamed(Routes.HOME);
  }

  void viewMyBookings() {
    Get.offAllNamed(Routes.BOOKING);
  }
}
