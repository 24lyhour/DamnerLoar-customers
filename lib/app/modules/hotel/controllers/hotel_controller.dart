import 'package:get/get.dart';

import '../data/models/hotel_model.dart';

enum HotelSortOption { recommended, priceLow, priceHigh, rating }

class HotelController extends GetxController {
  // Search params
  final location = 'Siem Reap'.obs;
  final checkInDate = DateTime.now().add(const Duration(days: 7)).obs;
  final checkOutDate = DateTime.now().add(const Duration(days: 9)).obs;
  final roomCount = 1.obs;
  final guestCount = 2.obs;

  // State
  final isLoading = true.obs;
  final allHotels = <HotelModel>[].obs;
  final hotels = <HotelModel>[].obs;
  final sortOption = HotelSortOption.recommended.obs;

  // Filters
  final minPrice = 0.0.obs;
  final maxPrice = 500.0.obs;
  final selectedAmenities = <String>[].obs;
  final minRating = 0.0.obs;
  final hasActiveFilters = false.obs;

  static const availableAmenities = ['wifi', 'pool', 'spa', 'restaurant', 'gym', 'parking', 'breakfast'];

  int get nights => checkOutDate.value.difference(checkInDate.value).inDays;

  @override
  void onInit() {
    super.onInit();
    _loadSearchParams();
    fetchHotels();
  }

  void _loadSearchParams() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      location.value = args['location'] ?? location.value;
      checkInDate.value = args['checkIn'] ?? checkInDate.value;
      checkOutDate.value = args['checkOut'] ?? checkOutDate.value;
      roomCount.value = args['rooms'] ?? roomCount.value;
      guestCount.value = args['guests'] ?? guestCount.value;
    }
  }

  Future<void> fetchHotels() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));

    hotels.value = [
      HotelModel(
        id: '1',
        name: 'Sokha Angkor Resort',
        imageUrl: null,
        location: location.value,
        address: 'National Road 6, Siem Reap',
        rating: 4.8,
        reviewCount: 1250,
        pricePerNight: 120,
        amenities: ['wifi', 'pool', 'spa', 'restaurant', 'gym', 'parking'],
        description: 'Luxury resort near Angkor Wat with world-class amenities.',
        roomTypes: [
          const RoomType(
            id: 'r1',
            name: 'Deluxe Room',
            pricePerNight: 120,
            maxGuests: 2,
            bedType: 'King Bed',
            roomSize: 35,
            amenities: ['wifi', 'ac', 'tv', 'minibar'],
            availableRooms: 5,
          ),
          const RoomType(
            id: 'r2',
            name: 'Premier Suite',
            pricePerNight: 180,
            maxGuests: 3,
            bedType: 'King Bed + Sofa',
            roomSize: 55,
            amenities: ['wifi', 'ac', 'tv', 'minibar', 'bathtub', 'balcony'],
            availableRooms: 3,
          ),
        ],
      ),
      HotelModel(
        id: '2',
        name: 'Raffles Grand Hotel d\'Angkor',
        imageUrl: null,
        location: location.value,
        address: '1 Vithei Charles de Gaulle, Siem Reap',
        rating: 4.9,
        reviewCount: 890,
        pricePerNight: 250,
        amenities: ['wifi', 'pool', 'spa', 'restaurant', 'gym', 'parking', 'butler'],
        description: 'Historic landmark hotel with colonial elegance.',
        roomTypes: [
          const RoomType(
            id: 'r3',
            name: 'State Room',
            pricePerNight: 250,
            maxGuests: 2,
            bedType: 'King Bed',
            roomSize: 45,
            amenities: ['wifi', 'ac', 'tv', 'minibar', 'bathtub'],
            availableRooms: 8,
          ),
          const RoomType(
            id: 'r4',
            name: 'Landmark Suite',
            pricePerNight: 450,
            maxGuests: 4,
            bedType: '2 King Beds',
            roomSize: 90,
            amenities: ['wifi', 'ac', 'tv', 'minibar', 'bathtub', 'living room', 'butler'],
            availableRooms: 2,
          ),
        ],
      ),
      HotelModel(
        id: '3',
        name: 'Park Hyatt Siem Reap',
        imageUrl: null,
        location: location.value,
        address: 'Sivatha Boulevard, Siem Reap',
        rating: 4.7,
        reviewCount: 650,
        pricePerNight: 180,
        amenities: ['wifi', 'pool', 'spa', 'restaurant', 'gym'],
        description: 'Contemporary luxury in the heart of Siem Reap.',
        roomTypes: [
          const RoomType(
            id: 'r5',
            name: 'Park Room',
            pricePerNight: 180,
            maxGuests: 2,
            bedType: 'King Bed',
            roomSize: 40,
            amenities: ['wifi', 'ac', 'tv', 'minibar'],
            availableRooms: 10,
          ),
        ],
      ),
      HotelModel(
        id: '4',
        name: 'Templation Angkor',
        imageUrl: null,
        location: location.value,
        address: 'Wat Polanka, Siem Reap',
        rating: 4.5,
        reviewCount: 420,
        pricePerNight: 85,
        amenities: ['wifi', 'pool', 'restaurant', 'parking'],
        description: 'Boutique hotel with modern Khmer design.',
        roomTypes: [
          const RoomType(
            id: 'r6',
            name: 'Superior Room',
            pricePerNight: 85,
            maxGuests: 2,
            bedType: 'Queen Bed',
            roomSize: 28,
            amenities: ['wifi', 'ac', 'tv'],
            availableRooms: 12,
          ),
        ],
      ),
      HotelModel(
        id: '5',
        name: 'Golden Temple Villa',
        imageUrl: null,
        location: location.value,
        address: 'Old Market Area, Siem Reap',
        rating: 4.3,
        reviewCount: 280,
        pricePerNight: 45,
        amenities: ['wifi', 'pool', 'breakfast'],
        description: 'Budget-friendly with great location.',
        roomTypes: [
          const RoomType(
            id: 'r7',
            name: 'Standard Room',
            pricePerNight: 45,
            maxGuests: 2,
            bedType: 'Double Bed',
            roomSize: 22,
            amenities: ['wifi', 'ac', 'tv'],
            availableRooms: 6,
          ),
        ],
      ),
    ];

    allHotels.value = hotels.toList();
    _applyFilters();
    isLoading.value = false;
  }

  void setSortOption(HotelSortOption option) {
    sortOption.value = option;
    _sortHotels();
  }

  void _sortHotels() {
    switch (sortOption.value) {
      case HotelSortOption.recommended:
        hotels.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case HotelSortOption.priceLow:
        hotels.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
        break;
      case HotelSortOption.priceHigh:
        hotels.sort((a, b) => b.pricePerNight.compareTo(a.pricePerNight));
        break;
      case HotelSortOption.rating:
        hotels.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
  }

  // Filter methods
  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }
  }

  void setPriceRange(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
  }

  void setMinRating(double rating) {
    minRating.value = rating;
  }

  void applyFilters() {
    _applyFilters();
  }

  void _applyFilters() {
    hotels.value = allHotels.where((hotel) {
      // Price filter
      if (hotel.pricePerNight < minPrice.value || hotel.pricePerNight > maxPrice.value) {
        return false;
      }

      // Rating filter
      if (hotel.rating < minRating.value) {
        return false;
      }

      // Amenities filter
      if (selectedAmenities.isNotEmpty) {
        final hasAllAmenities = selectedAmenities.every(
          (amenity) => hotel.amenities.contains(amenity),
        );
        if (!hasAllAmenities) return false;
      }

      return true;
    }).toList();

    hasActiveFilters.value = minPrice.value > 0 ||
        maxPrice.value < 500 ||
        minRating.value > 0 ||
        selectedAmenities.isNotEmpty;

    _sortHotels();
  }

  void clearFilters() {
    minPrice.value = 0;
    maxPrice.value = 500;
    minRating.value = 0;
    selectedAmenities.clear();
    hasActiveFilters.value = false;
    hotels.value = allHotels.toList();
    _sortHotels();
  }

  void selectHotel(HotelModel hotel) {
    Get.toNamed('/hotel/hotel-detail', arguments: {
      'hotel': hotel,
      'checkIn': checkInDate.value,
      'checkOut': checkOutDate.value,
      'rooms': roomCount.value,
      'guests': guestCount.value,
    });
  }
}
