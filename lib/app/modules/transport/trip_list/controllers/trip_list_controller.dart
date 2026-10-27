import 'package:get/get.dart';

import '../../data/models/transport_model.dart';

enum SortOption { departure, price, duration }

class TripListController extends GetxController {
  // Search params from home
  final fromCity = 'Phnom Penh'.obs;
  final toCity = 'Siem Reap'.obs;
  final departureDate = DateTime.now().add(const Duration(days: 1)).obs;
  final passengerCount = 2.obs;

  // State
  final isLoading = true.obs;
  final trips = <TripModel>[].obs;
  final sortOption = SortOption.departure.obs;
  final selectedFilters = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSearchParams();
    fetchTrips();
  }

  void _loadSearchParams() {
    // Get search params from arguments if passed
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      fromCity.value = args['from'] ?? fromCity.value;
      toCity.value = args['to'] ?? toCity.value;
      departureDate.value = args['date'] ?? departureDate.value;
      passengerCount.value = args['passengers'] ?? passengerCount.value;
    }
  }

  Future<void> fetchTrips() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data
    final now = departureDate.value;
    trips.value = [
      TripModel(
        id: '1',
        operatorName: 'Giant Ibis',
        operatorLogo: null,
        busType: 'VIP Sleeper',
        departureTime: DateTime(now.year, now.month, now.day, 7, 30),
        arrivalTime: DateTime(now.year, now.month, now.day, 13, 30),
        duration: const Duration(hours: 6),
        fromCity: fromCity.value,
        toCity: toCity.value,
        price: 18.0,
        availableSeats: 12,
        totalSeats: 40,
        amenities: ['wifi', 'ac', 'toilet', 'snack'],
        rating: 4.8,
      ),
      TripModel(
        id: '2',
        operatorName: 'Mekong Express',
        operatorLogo: null,
        busType: 'Express',
        departureTime: DateTime(now.year, now.month, now.day, 8, 0),
        arrivalTime: DateTime(now.year, now.month, now.day, 14, 30),
        duration: const Duration(hours: 6, minutes: 30),
        fromCity: fromCity.value,
        toCity: toCity.value,
        price: 15.0,
        availableSeats: 8,
        totalSeats: 45,
        amenities: ['ac', 'wifi'],
        rating: 4.5,
      ),
      TripModel(
        id: '3',
        operatorName: 'Capitol Bus',
        operatorLogo: null,
        busType: 'Standard',
        departureTime: DateTime(now.year, now.month, now.day, 9, 0),
        arrivalTime: DateTime(now.year, now.month, now.day, 15, 30),
        duration: const Duration(hours: 6, minutes: 30),
        fromCity: fromCity.value,
        toCity: toCity.value,
        price: 12.0,
        availableSeats: 25,
        totalSeats: 50,
        amenities: ['ac'],
        rating: 4.2,
      ),
      TripModel(
        id: '4',
        operatorName: 'Virak Buntham',
        operatorLogo: null,
        busType: 'VIP',
        departureTime: DateTime(now.year, now.month, now.day, 10, 30),
        arrivalTime: DateTime(now.year, now.month, now.day, 16, 30),
        duration: const Duration(hours: 6),
        fromCity: fromCity.value,
        toCity: toCity.value,
        price: 14.0,
        availableSeats: 3,
        totalSeats: 35,
        amenities: ['wifi', 'ac', 'usb'],
        rating: 4.4,
      ),
      TripModel(
        id: '5',
        operatorName: 'Sorya Bus',
        operatorLogo: null,
        busType: 'Night Bus',
        departureTime: DateTime(now.year, now.month, now.day, 22, 0),
        arrivalTime: DateTime(now.year, now.month, now.day + 1, 5, 0),
        duration: const Duration(hours: 7),
        fromCity: fromCity.value,
        toCity: toCity.value,
        price: 16.0,
        availableSeats: 18,
        totalSeats: 40,
        amenities: ['ac', 'blanket', 'pillow'],
        rating: 4.0,
      ),
    ];

    _sortTrips();
    isLoading.value = false;
  }

  void setSortOption(SortOption option) {
    sortOption.value = option;
    _sortTrips();
  }

  void _sortTrips() {
    switch (sortOption.value) {
      case SortOption.departure:
        trips.sort((a, b) => a.departureTime.compareTo(b.departureTime));
        break;
      case SortOption.price:
        trips.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.duration:
        trips.sort((a, b) => a.duration.compareTo(b.duration));
        break;
    }
  }

  void selectTrip(TripModel trip) {
    if (trip.isSoldOut) return;
    Get.toNamed('/transport/seat-selection', arguments: {
      'trip': trip,
      'passengers': passengerCount.value,
    });
  }

  void swapCities() {
    final temp = fromCity.value;
    fromCity.value = toCity.value;
    toCity.value = temp;
    fetchTrips();
  }
}
