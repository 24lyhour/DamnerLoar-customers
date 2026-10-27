import 'package:get/get.dart';

import '../../../../core/helpers/toast_helper.dart';
import '../../../../core/widgets/seat_layout_widget.dart';
import '../../data/models/transport_model.dart';
import '../../passenger_info/controllers/passenger_info_controller.dart';

class ETicketController extends GetxController {
  late final String bookingId;
  late final TripModel trip;
  late final List<Seat> seats;
  late final List<PassengerModel> passengers;

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
      final passengersList = args['passengers'] as List?;
      passengers = passengersList?.map((p) => p as PassengerModel).toList() ?? [];
    } else {
      // Fallback for testing
      bookingId = 'DL-2026102700001';
      trip = TripModel(
        id: 'test',
        operatorName: 'Giant Ibis',
        operatorLogo: null,
        busType: 'VIP Sleeper',
        departureTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
        arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 8)),
        duration: const Duration(hours: 6),
        fromCity: 'Phnom Penh',
        toCity: 'Siem Reap',
        price: 18.0,
        availableSeats: 20,
        totalSeats: 40,
      );
      seats = [
        const Seat(id: '1', row: 6, column: 0, label: '7A'),
        const Seat(id: '2', row: 6, column: 1, label: '7B'),
      ];
      passengers = [];
    }
  }

  String get seatLabels => seats.map((s) => s.label).join(', ');

  String get qrData => 'DAMNERLOAR:$bookingId:${trip.id}:$seatLabels';

  void downloadTicket() {
    AppToast.success('E-Ticket saved to gallery');
  }

  void shareTicket() {
    AppToast.info('Share options opened');
  }
}
