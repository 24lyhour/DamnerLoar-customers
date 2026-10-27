/// Generic payment data model for both transport and hotel bookings
class PaymentData {
  final String bookingType; // 'transport' or 'hotel'
  final String title; // e.g., "Phnom Penh → Siem Reap" or "Luxury Suite"
  final String subtitle; // e.g., "Giant Ibis · VIP Sleeper" or "2 nights"
  final DateTime date;
  final DateTime? endDate; // For hotel check-out
  final String? time; // Departure time for transport
  final int itemCount; // Seats or rooms
  final String itemLabel; // "seat(s)" or "room(s)"
  final List<String> itemDetails; // Seat labels or room names
  final double unitPrice;
  final double totalPrice;
  final String contactEmail;
  final String contactPhone;
  final String successRoute; // Where to go after payment
  final Map<String, dynamic> successArguments; // Arguments for success route

  const PaymentData({
    required this.bookingType,
    required this.title,
    required this.subtitle,
    required this.date,
    this.endDate,
    this.time,
    required this.itemCount,
    required this.itemLabel,
    required this.itemDetails,
    required this.unitPrice,
    required this.totalPrice,
    required this.contactEmail,
    required this.contactPhone,
    required this.successRoute,
    required this.successArguments,
  });

  bool get isTransport => bookingType == 'transport';
  bool get isHotel => bookingType == 'hotel';
}
