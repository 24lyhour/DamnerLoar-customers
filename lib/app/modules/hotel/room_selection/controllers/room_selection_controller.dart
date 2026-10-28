import 'package:get/get.dart';

import '../../../../core/helpers/toast_helper.dart';
import '../../data/models/hotel_model.dart';

class RoomSelectionController extends GetxController {
  late final HotelModel hotel;
  late final DateTime checkIn;
  late final DateTime checkOut;
  late final int roomCount;
  late final int guestCount;

  final selectedRoom = Rxn<RoomType>();
  final selectedRoomCount = 1.obs;

  int get nights => checkOut.difference(checkIn).inDays;

  double get totalPrice {
    if (selectedRoom.value == null) return 0;
    return selectedRoom.value!.pricePerNight * nights * selectedRoomCount.value;
  }

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
      selectedRoomCount.value = roomCount;
    } else {
      // Fallback
      hotel = HotelModel(
        id: 'test',
        name: 'Test Hotel',
        location: 'Siem Reap',
        address: 'Test Address',
        rating: 4.5,
        reviewCount: 100,
        pricePerNight: 100,
      );
      checkIn = DateTime.now().add(const Duration(days: 7));
      checkOut = DateTime.now().add(const Duration(days: 9));
      roomCount = 1;
      guestCount = 2;
    }
  }

  void selectRoom(RoomType room) {
    if (room.isSoldOut) return;
    selectedRoom.value = room;
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

  bool get canProceed => selectedRoom.value != null;

  void viewRoomDetail(RoomType room) {
    if (room.isSoldOut) return;

    Get.toNamed('/hotel/room-detail', arguments: {
      'hotel': hotel,
      'room': room,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'guests': guestCount,
    });
  }

  void proceedToGuestInfo() {
    if (!canProceed) {
      AppToast.info('Please select a room type');
      return;
    }

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
