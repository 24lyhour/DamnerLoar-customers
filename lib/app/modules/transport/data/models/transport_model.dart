/// Trip/Bus model for transport search results.
class TripModel {
  const TripModel({
    required this.id,
    required this.operatorName,
    required this.operatorLogo,
    required this.busType,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.fromCity,
    required this.toCity,
    required this.price,
    required this.availableSeats,
    required this.totalSeats,
    this.amenities = const [],
    this.rating,
  });

  final String id;
  final String operatorName;
  final String? operatorLogo;
  final String busType;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final Duration duration;
  final String fromCity;
  final String toCity;
  final double price;
  final int availableSeats;
  final int totalSeats;
  final List<String> amenities;
  final double? rating;

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      operatorName: json['operator_name'] as String,
      operatorLogo: json['operator_logo'] as String?,
      busType: json['bus_type'] as String,
      departureTime: DateTime.parse(json['departure_time'] as String),
      arrivalTime: DateTime.parse(json['arrival_time'] as String),
      duration: Duration(minutes: json['duration_minutes'] as int),
      fromCity: json['from_city'] as String,
      toCity: json['to_city'] as String,
      price: (json['price'] as num).toDouble(),
      availableSeats: json['available_seats'] as int,
      totalSeats: json['total_seats'] as int,
      amenities: List<String>.from(json['amenities'] ?? []),
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'operator_name': operatorName,
      'operator_logo': operatorLogo,
      'bus_type': busType,
      'departure_time': departureTime.toIso8601String(),
      'arrival_time': arrivalTime.toIso8601String(),
      'duration_minutes': duration.inMinutes,
      'from_city': fromCity,
      'to_city': toCity,
      'price': price,
      'available_seats': availableSeats,
      'total_seats': totalSeats,
      'amenities': amenities,
      'rating': rating,
    };
  }

  String get durationText {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  bool get hasLowAvailability => availableSeats <= 5;
  bool get isSoldOut => availableSeats == 0;
}
