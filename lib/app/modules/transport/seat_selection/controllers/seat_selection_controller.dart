import 'package:get/get.dart';

import '../../../../core/helpers/toast_helper.dart';
import '../../../../core/widgets/seat_layout_widget.dart';
import '../../../../routes/app_pages.dart';
import '../../data/models/transport_model.dart';
import '../../trip_list/controllers/trip_list_controller.dart';

class SeatSelectionController extends GetxController {
  // Trip info - with safe defaults
  final Rx<TripModel?> _trip = Rx<TripModel?>(null);
  final passengerCount = 1.obs;

  // Round-trip state
  final isRoundTrip = false.obs;
  final Rxn<DateTime> returnDate = Rxn<DateTime>();
  final isSelectingReturn = false.obs;
  BookingLeg? outboundLeg;

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
        isRoundTrip.value = args['isRoundTrip'] as bool? ?? false;
        returnDate.value = args['returnDate'] as DateTime?;
        isSelectingReturn.value = args['isSelectingReturn'] as bool? ?? false;
        outboundLeg = args['outboundLeg'] as BookingLeg?;
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
        AppToast.warning(
          'You can only select ${passengerCount.value} seat(s)',
          title: 'Maximum seats reached',
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

  /// Screen title based on round-trip state
  String get screenTitle {
    if (isSelectingReturn.value) {
      return 'Return Seats';
    }
    return isRoundTrip.value ? 'Outbound Seats' : 'Select Seats';
  }

  void proceedToPassengerInfo() {
    if (!canProceed) {
      AppToast.info(
        'Please select ${passengerCount.value} seat(s) to continue',
        title: 'Select seats',
      );
      return;
    }

    // If round-trip and selecting outbound, go to return trip list
    if (isRoundTrip.value && !isSelectingReturn.value) {
      final currentLeg = BookingLeg(trip: trip, seats: selectedSeats);

      // Delete old TripListController to force recreation with new arguments
      Get.delete<TripListController>(force: true);

      // Navigate to return trip list
      Get.offNamed(Routes.TRIP_LIST, arguments: {
        'from': trip.toCity, // Swap for return
        'to': trip.fromCity,
        'date': returnDate.value,
        'passengers': passengerCount.value,
        'isRoundTrip': true,
        'returnDate': returnDate.value,
        'outboundLeg': currentLeg, // Pass outbound selection
      });
      return;
    }

    // If selecting return, combine both legs
    if (isSelectingReturn.value && outboundLeg != null) {
      final returnLeg = BookingLeg(trip: trip, seats: selectedSeats);

      Get.toNamed(Routes.PASSENGER_INFO, arguments: {
        'trip': outboundLeg!.trip, // Primary trip is outbound
        'seats': outboundLeg!.seats,
        'totalPrice': _calculateTotalPrice(outboundLeg!, returnLeg),
        'isRoundTrip': true,
        'outboundLeg': outboundLeg,
        'returnLeg': returnLeg,
      });
      return;
    }

    // One-way: go directly to passenger info
    Get.toNamed(Routes.PASSENGER_INFO, arguments: {
      'trip': trip,
      'seats': selectedSeats,
      'totalPrice': totalPrice,
      'isRoundTrip': false,
    });
  }

  double _calculateTotalPrice(BookingLeg outbound, BookingLeg returnLeg) {
    final outboundTotal = outbound.seats.length * outbound.trip.price;
    final returnTotal = returnLeg.seats.length * returnLeg.trip.price;
    return outboundTotal + returnTotal;
  }
}
