import 'package:get/get.dart';

import '../../../../core/widgets/seat_layout_widget.dart';
import '../../data/models/transport_model.dart';

class SeatSelectionController extends GetxController {
  // Trip info - with safe defaults
  final Rx<TripModel?> _trip = Rx<TripModel?>(null);
  final passengerCount = 1.obs;

  TripModel get trip => _trip.value ?? _defaultTrip;

  static final _defaultTrip = TripModel(
    id: 'default',
    operatorName: 'Bus Operator',
    operatorLogo: null,
    busType: 'Standard',
    departureTime: DateTime.now(),
    arrivalTime: DateTime.now().add(const Duration(hours: 6)),
    duration: const Duration(hours: 6),
    fromCity: 'Phnom Penh',
    toCity: 'Siem Reap',
    price: 15.0,
    availableSeats: 20,
    totalSeats: 40,
  );

  // Seat state - using the reusable widget's Seat model
  final seats = <Seat>[].obs;
  final selectedSeatIds = <String>[].obs;
  final isLoading = true.obs;

  // Bus layout - using VehicleLayout presets
  final layout = VehicleLayout.bus2x2;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
    _generateSeats();
  }

  void _loadArguments() {
    try {
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null) {
        _trip.value = args['trip'] as TripModel?;
        passengerCount.value = args['passengers'] as int? ?? 1;
      }
    } catch (e) {
      print('Error loading arguments: $e');
    }
  }

  void _generateSeats() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock booked seats
    final bookedSeatIds = ['seat_0_2', 'seat_1_3', 'seat_3_0', 'seat_4_1', 'seat_5_2', 'seat_7_3', 'seat_8_0'];

    // Use the helper function from seat_layout_widget.dart
    seats.value = generateSeats(
      layout: layout,
      bookedSeatIds: bookedSeatIds,
      basePrice: trip.price,
    );

    isLoading.value = false;
  }

  void toggleSeat(Seat seat) {
    if (seat.state == SeatState.booked || seat.state == SeatState.disabled) return;

    final index = seats.indexWhere((s) => s.id == seat.id);
    if (index == -1) return;

    if (selectedSeatIds.contains(seat.id)) {
      // Deselect
      selectedSeatIds.remove(seat.id);
      seats[index] = seat.copyWith(state: SeatState.available);
    } else {
      // Check max selection
      if (selectedSeatIds.length >= passengerCount.value) {
        Get.snackbar(
          'Maximum seats reached',
          'You can only select ${passengerCount.value} seat(s)',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      // Select
      selectedSeatIds.add(seat.id);
      seats[index] = seat.copyWith(state: SeatState.selected);
    }
    seats.refresh();
  }

  List<Seat> get selectedSeats => seats.where((s) => selectedSeatIds.contains(s.id)).toList();

  double get totalPrice => selectedSeats.length * trip.price;

  String get selectedSeatsLabel {
    if (selectedSeats.isEmpty) return 'No seats selected';
    return selectedSeats.map((s) => s.label).join(', ');
  }

  bool get canProceed => selectedSeatIds.length == passengerCount.value;

  void proceedToPassengerInfo() {
    if (!canProceed) {
      Get.snackbar(
        'Select seats',
        'Please select ${passengerCount.value} seat(s) to continue',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.toNamed('/transport/passenger-info', arguments: {
      'trip': trip,
      'seats': selectedSeats,
      'totalPrice': totalPrice,
    });
  }
}
