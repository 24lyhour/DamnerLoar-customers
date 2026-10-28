import 'package:get/get.dart';

import '../../data/models/hotel_model.dart';

class HotelDetailController extends GetxController {
  late final HotelModel hotel;
  late final DateTime checkIn;
  late final DateTime checkOut;
  late final int roomCount;
  late final int guestCount;

  final currentImageIndex = 0.obs;
  final isFavorite = false.obs;

  // Room selection state
  final selectedRoom = Rxn<RoomType>();
  final selectedRoomCount = 1.obs;

  int get nights => checkOut.difference(checkIn).inDays;

  double get totalPrice {
    if (selectedRoom.value == null) return 0;
    return selectedRoom.value!.pricePerNight * nights * selectedRoomCount.value;
  }

  bool get hasSelection => selectedRoom.value != null;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      hotel = args['hotel'] as HotelModel;
      checkIn = args['checkIn'] as DateTime;
      checkOut = args['checkOut'] as DateTime;
      roomCount = args['rooms'] as int? ?? 1;
      guestCount = args['guests'] as int? ?? 2;
    } else {
      // Fallback
      hotel = HotelModel(
        id: 'test',
        name: 'Sokha Angkor Resort',
        location: 'Siem Reap',
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
        ],
      );
      checkIn = DateTime.now().add(const Duration(days: 7));
      checkOut = DateTime.now().add(const Duration(days: 9));
      roomCount = 1;
      guestCount = 2;
    }
  }

  void toggleFavorite() {
    isFavorite.toggle();
  }

  void selectRoom(RoomType room) {
    if (room.isSoldOut) return;
    selectedRoom.value = room;
    selectedRoomCount.value = 1;
  }

  void clearSelection() {
    selectedRoom.value = null;
    selectedRoomCount.value = 1;
  }

  void increaseRoomCount() {
    if (selectedRoom.value == null) return;
    if (selectedRoomCount.value < selectedRoom.value!.availableRooms) {
      selectedRoomCount.value++;
    }
  }

  void decreaseRoomCount() {
    if (selectedRoomCount.value > 1) {
      selectedRoomCount.value--;
    }
  }

  void viewRoomDetail(RoomType room) {
    Get.toNamed('/hotel/room-detail', arguments: {
      'hotel': hotel,
      'room': room,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'guests': guestCount,
    });
  }

  void proceedToGuestInfo() {
    if (selectedRoom.value == null) return;

    final booking = HotelBooking(
      hotel: hotel,
      room: selectedRoom.value!,
      checkIn: checkIn,
      checkOut: checkOut,
      rooms: selectedRoomCount.value,
      guests: guestCount,
    );

    Get.toNamed('/hotel/guest-info', arguments: {
      'booking': booking,
    });
  }
}
