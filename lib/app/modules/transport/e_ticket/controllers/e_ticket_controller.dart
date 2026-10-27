import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/helpers/toast_helper.dart';
import '../../../../core/services/screenshot_service.dart';
import '../../../../core/widgets/seat_layout_widget.dart';
import '../../../../routes/app_pages.dart';
import '../../data/models/transport_model.dart';
import '../../passenger_info/controllers/passenger_info_controller.dart';

class ETicketController extends GetxController {
  late final String bookingId;
  late final TripModel trip;
  late final List<Seat> seats;
  late final List<PassengerModel> passengers;

  // Round-trip data
  final isRoundTrip = false.obs;
  final currentPage = 0.obs; // 0 = outbound, 1 = return
  String? returnBookingId;
  TripModel? returnTrip;
  List<Seat>? returnSeats;

  late final PageController pageController;

  // Screenshot controllers for each ticket
  final outboundScreenshotController = ScreenshotController();
  final returnScreenshotController = ScreenshotController();

  final isDownloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    _loadArguments();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void _loadArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      bookingId = args['bookingId'] as String;
      trip = args['trip'] as TripModel;
      final seatsList = args['seats'] as List;
      seats = seatsList.map((s) => s as Seat).toList();
      final passengersList = args['passengers'] as List?;
      passengers = passengersList?.map((p) => p as PassengerModel).toList() ?? [];

      // Round-trip data
      isRoundTrip.value = args['isRoundTrip'] as bool? ?? false;
      returnBookingId = args['returnBookingId'] as String?;
      returnTrip = args['returnTrip'] as TripModel?;
      final returnSeatsList = args['returnSeats'] as List?;
      returnSeats = returnSeatsList?.map((s) => s as Seat).toList();
    } else {
      // Fallback for testing
      bookingId = 'DL-2026102700001';
      trip = TripModel(
        id: 'test',
        operatorName: 'Giant Ibis',
        operatorLogo: null,
        busType: 'VIP Sleeper',
        departureTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
        arrivalTime: DateTime.now().add(const Duration(days: 1, hours: 8)),
        duration: const Duration(hours: 6),
        fromCity: 'Phnom Penh',
        toCity: 'Siem Reap',
        price: 18.0,
        availableSeats: 20,
        totalSeats: 40,
      );
      seats = [
        const Seat(id: '1', row: 6, column: 0, label: '7A'),
        const Seat(id: '2', row: 6, column: 1, label: '7B'),
      ];
      passengers = [];
    }
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  // Get the correct screenshot controller based on current page
  ScreenshotController get currentScreenshotController =>
      currentPage.value == 0 ? outboundScreenshotController : returnScreenshotController;

  // Current booking ID based on page
  String get currentBookingId =>
      currentPage.value == 0 ? outboundBookingId : returnTicketBookingId;

  // Outbound ticket data
  String get outboundBookingId => bookingId;
  TripModel get outboundTrip => trip;
  List<Seat> get outboundSeats => seats;
  String get outboundSeatLabels => outboundSeats.map((s) => s.label).join(', ');
  String get outboundQrData => 'DAMNERLOAR:$outboundBookingId:${outboundTrip.id}:$outboundSeatLabels';

  // Return ticket data
  String get returnTicketBookingId => returnBookingId ?? '';
  TripModel? get returnTicketTrip => returnTrip;
  List<Seat> get returnTicketSeats => returnSeats ?? [];
  String get returnSeatLabels => returnTicketSeats.map((s) => s.label).join(', ');
  String get returnQrData => 'DAMNERLOAR:$returnTicketBookingId:${returnTicketTrip?.id ?? ''}:$returnSeatLabels';

  /// Generate shareable ticket text
  String _generateTicketText(TripModel ticketTrip, String ticketBookingId, String seatLabels, int seatCount) {
    final dateFormat = DateFormat('EEE, d MMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return '''
🎫 DamnerLoar E-Ticket

Booking ID: $ticketBookingId

📍 ${ticketTrip.fromCity} → ${ticketTrip.toCity}
📅 ${dateFormat.format(ticketTrip.departureTime)}
🕐 ${timeFormat.format(ticketTrip.departureTime)} - ${timeFormat.format(ticketTrip.arrivalTime)}

🚌 ${ticketTrip.operatorName} (${ticketTrip.busType})
💺 Seat(s): $seatLabels
👥 $seatCount passenger(s)

ℹ️ Please arrive 15 minutes before departure.
Show QR code to the driver.

Booked via DamnerLoar App
''';
  }

  Future<void> downloadTicket() async {
    if (isDownloading.value) return;
    isDownloading.value = true;

    await ScreenshotService.captureAndSave(
      controller: currentScreenshotController,
      filename: 'DamnerLoar_$currentBookingId',
      successMessage: 'E-Ticket saved to gallery',
      errorMessage: 'Failed to save ticket',
    );

    isDownloading.value = false;
  }

  void shareTicket() async {
    try {
      final ticketText = currentPage.value == 0
          ? _generateTicketText(outboundTrip, outboundBookingId, outboundSeatLabels, outboundSeats.length)
          : _generateTicketText(returnTicketTrip!, returnTicketBookingId, returnSeatLabels, returnTicketSeats.length);

      await SharePlus.instance.share(
        ShareParams(text: ticketText, subject: 'DamnerLoar E-Ticket'),
      );
    } catch (e) {
      AppToast.info('Restart app to enable sharing');
    }
  }

  void goToHome() {
    Get.offAllNamed(Routes.HOME);
  }
}
