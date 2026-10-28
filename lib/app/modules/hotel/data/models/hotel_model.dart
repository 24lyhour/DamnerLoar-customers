class HotelModel {
  final String id;
  final String name;
  final String? imageUrl;
  final List<String> images;
  final String location;
  final String address;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final List<String> amenities;
  final String description;
  final List<RoomType> roomTypes;

  const HotelModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.images = const [],
    required this.location,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    this.amenities = const [],
    this.description = '',
    this.roomTypes = const [],
  });

  String get priceText => '\$${pricePerNight.toStringAsFixed(0)}';
  String get ratingText => rating.toStringAsFixed(1);
}

class RoomType {
  final String id;
  final String name;
  final String? imageUrl;
  final double pricePerNight;
  final int maxGuests;
  final String bedType;
  final double roomSize;
  final List<String> amenities;
  final int availableRooms;
  final bool isRefundable;

  const RoomType({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.pricePerNight,
    required this.maxGuests,
    required this.bedType,
    required this.roomSize,
    this.amenities = const [],
    required this.availableRooms,
    this.isRefundable = true,
  });

  String get priceText => '\$${pricePerNight.toStringAsFixed(0)}';
  String get sizeText => '${roomSize.toStringAsFixed(0)} m²';
  bool get isSoldOut => availableRooms == 0;
}

class HotelBooking {
  final HotelModel hotel;
  final RoomType room;
  final DateTime checkIn;
  final DateTime checkOut;
  final int rooms;
  final int guests;

  const HotelBooking({
    required this.hotel,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.rooms,
    required this.guests,
  });

  int get nights => checkOut.difference(checkIn).inDays;
  double get totalPrice => room.pricePerNight * nights * rooms;
}
