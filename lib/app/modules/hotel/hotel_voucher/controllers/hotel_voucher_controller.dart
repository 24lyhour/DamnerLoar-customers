import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/helpers/toast_helper.dart';
import '../../../../core/services/screenshot_service.dart';
import '../../../../routes/app_pages.dart';
import '../../data/models/hotel_model.dart';

class HotelVoucherController extends GetxController {
  late final String bookingId;
  late final HotelBooking booking;
  late final List<Map<String, dynamic>> guests;
  late final String contactPhone;
  late final String? specialRequests;
  late final double totalPaid;
  late final String paymentMethod;

  final screenshotController = ScreenshotController();
  final isDownloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      bookingId = args['bookingId'] as String;
      booking = args['booking'] as HotelBooking;
      guests = (args['guests'] as List).map((g) => g as Map<String, dynamic>).toList();
      contactPhone = args['contactPhone'] as String? ?? '';
      specialRequests = args['specialRequests'] as String?;
      totalPaid = args['totalPaid'] as double? ?? booking.totalPrice;
      paymentMethod = args['paymentMethod'] as String? ?? 'Unknown';
    } else {
      // Fallback
      bookingId = 'DL-H-2026102700001';
      booking = HotelBooking(
        hotel: HotelModel(
          id: 'test',
          name: 'Sokha Angkor Resort',
          location: 'Siem Reap',
          address: 'National Road 6, Siem Reap',
          rating: 4.8,
          reviewCount: 1250,
          pricePerNight: 120,
        ),
        room: const RoomType(
          id: 'r1',
          name: 'Deluxe Room',
          pricePerNight: 120,
          maxGuests: 2,
          bedType: 'King Bed',
          roomSize: 35,
          availableRooms: 5,
        ),
        checkIn: DateTime.now().add(const Duration(days: 7)),
        checkOut: DateTime.now().add(const Duration(days: 9)),
        rooms: 1,
        guests: 2,
      );
      guests = [
        {'name': 'John Doe', 'email': 'john@example.com'},
      ];
      contactPhone = '+855 12 345 678';
      specialRequests = null;
      totalPaid = 240;
      paymentMethod = 'Credit Card';
    }
  }

  String get qrData => 'DAMNERLOAR:HOTEL:$bookingId:${booking.hotel.id}';

  String get primaryGuestName => guests.isNotEmpty ? guests.first['name'] as String : 'Guest';

  Future<void> downloadVoucher() async {
    if (isDownloading.value) return;
    isDownloading.value = true;

    await ScreenshotService.captureAndSave(
      controller: screenshotController,
      filename: 'DamnerLoar_Hotel_$bookingId',
      successMessage: 'Voucher saved to gallery',
      errorMessage: 'Failed to save voucher',
    );

    isDownloading.value = false;
  }

  void shareVoucher() async {
    try {
      final text = '''
🏨 DamnerLoar Hotel Voucher

Booking ID: $bookingId

📍 ${booking.hotel.name}
📌 ${booking.hotel.address}

📅 Check-in: ${_formatDate(booking.checkIn)}
📅 Check-out: ${_formatDate(booking.checkOut)}
🌙 ${booking.nights} night(s)

🛏️ ${booking.room.name}
👤 Guest: $primaryGuestName
📧 ${guests.first['email']}

💰 Total Paid: \$${totalPaid.toStringAsFixed(2)}

ℹ️ Please present this voucher at check-in.

Booked via DamnerLoar App
''';

      await SharePlus.instance.share(
        ShareParams(text: text, subject: 'DamnerLoar Hotel Voucher'),
      );
    } catch (e) {
      AppToast.info('Restart app to enable sharing');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void goToHome() {
    Get.offAllNamed(Routes.HOME);
  }
}
