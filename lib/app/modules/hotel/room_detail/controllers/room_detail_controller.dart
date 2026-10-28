import 'package:get/get.dart';

import '../../data/models/hotel_model.dart';

class RoomDetailController extends GetxController {
  late final HotelModel hotel;
  late final RoomType room;
  late final DateTime checkIn;
  late final DateTime checkOut;
  late final int guestCount;

  final selectedRoomCount = 1.obs;

  int get nights => checkOut.difference(checkIn).inDays;
  double get totalPrice => room.pricePerNight * nights * selectedRoomCount.value;

  List<RoomType> get otherRooms =>
      hotel.roomTypes.where((r) => r.id != room.id).toList();

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      hotel = args['hotel'] as HotelModel;
      room = args['room'] as RoomType;
      checkIn = args['checkIn'] as DateTime;
      checkOut = args['checkOut'] as DateTime;
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
      );
      room = const RoomType(
        id: 'r1',
        name: 'Deluxe Room',
        pricePerNight: 120,
        maxGuests: 2,
        bedType: 'King Bed',
        roomSize: 35,
        amenities: ['wifi', 'ac', 'tv', 'minibar', 'bathtub'],
        availableRooms: 5,
      );
      checkIn = DateTime.now().add(const Duration(days: 7));
      checkOut = DateTime.now().add(const Duration(days: 9));
      guestCount = 2;
    }
  }

  void increaseRoomCount() {
    if (selectedRoomCount.value < room.availableRooms) {
      selectedRoomCount.value++;
    }
  }

  void decreaseRoomCount() {
    if (selectedRoomCount.value > 1) {
      selectedRoomCount.value--;
    }
  }

  void proceedToGuestInfo() {
    final booking = HotelBooking(
      hotel: hotel,
      room: room,
      checkIn: checkIn,
      checkOut: checkOut,
      rooms: selectedRoomCount.value,
      guests: guestCount,
    );

    Get.toNamed('/hotel/guest-info', arguments: {
      'booking': booking,
    });
  }

  void viewOtherRoom(RoomType otherRoom) {
    // Replace current page to avoid back stack buildup when browsing rooms
    Get.offNamed('/hotel/room-detail', arguments: {
      'hotel': hotel,
      'room': otherRoom,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'guests': guestCount,
    });
  }
}
