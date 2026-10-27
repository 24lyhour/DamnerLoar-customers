import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

enum SearchTab { transport, hotel, package }

class HomeController extends GetxController {
  // Bottom nav
  final currentNavIndex = 0.obs;

  // Search tabs
  final currentTab = SearchTab.transport.obs;
  final isTabLoading = false.obs;

  // Transport form
  final isRoundTrip = true.obs;
  final fromCity = 'Phnom Penh'.obs;
  final toCity = 'Siem Reap'.obs;
  final departureDate = DateTime.now().add(const Duration(days: 1)).obs;
  final returnDateValue = DateTime.now().add(const Duration(days: 5)).obs;
  final adultCount = 2.obs;

  // Hotel form
  final hotelDestination = 'Siem Reap, Cambodia'.obs;
  final checkInDate = DateTime.now().add(const Duration(days: 4)).obs;
  final checkOutDate = DateTime.now().add(const Duration(days: 6)).obs;
  final guestCount = 2.obs;
  final roomCount = 1.obs;

  // User info (from profile or guest)
  final userName = 'Siev Chhing'.obs;

  void setNavIndex(int index) {
    currentNavIndex.value = index;
  }

  void setTab(SearchTab tab) async {
    if (currentTab.value == tab) return;

    isTabLoading.value = true;
    currentTab.value = tab;
    await Future.delayed(const Duration(milliseconds: 300));
    isTabLoading.value = false;
  }

  void toggleTripType() {
    isRoundTrip.value = !isRoundTrip.value;
  }

  void swapCities() {
    final temp = fromCity.value;
    fromCity.value = toCity.value;
    toCity.value = temp;
  }

  void searchBuses() {
    Get.toNamed(Routes.TRIP_LIST, arguments: {
      'from': fromCity.value,
      'to': toCity.value,
      'date': departureDate.value,
      'passengers': adultCount.value,
    });
  }

  void searchHotels() {
    // TODO: Navigate to hotel results
    Get.toNamed('/hotel');
  }

  void searchPackages() {
    // TODO: Navigate to package results
    Get.toNamed('/package');
  }
}
