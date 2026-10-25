import 'package:get/get.dart';

import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/hotel/bindings/hotel_binding.dart';
import '../modules/hotel/room_selection/bindings/room_selection_binding.dart';
import '../modules/hotel/room_selection/views/room_selection_view.dart';
import '../modules/hotel/views/hotel_view.dart';
import '../modules/locations/bindings/locations_binding.dart';
import '../modules/locations/views/locations_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/package/bindings/package_binding.dart';
import '../modules/package/views/package_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/promotions/bindings/promotions_binding.dart';
import '../modules/promotions/views/promotions_view.dart';
import '../modules/saved/bindings/saved_binding.dart';
import '../modules/saved/views/saved_view.dart';
import '../modules/start/bindings/start_binding.dart';
import '../modules/start/onboard_screen/bindings/onboard_screen_binding.dart';
import '../modules/start/onboard_screen/views/onboard_screen_view.dart';
import '../modules/start/views/start_view.dart';
import '../modules/transport/bindings/transport_binding.dart';
import '../modules/transport/passenger_info/bindings/passenger_info_binding.dart';
import '../modules/transport/passenger_info/views/passenger_info_view.dart';
import '../modules/transport/seat_selection/bindings/seat_selection_binding.dart';
import '../modules/transport/seat_selection/views/seat_selection_view.dart';
import '../modules/transport/trip_list/bindings/trip_list_binding.dart';
import '../modules/transport/trip_list/views/trip_list_view.dart';
import '../modules/transport/views/transport_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TRANSPORT,
      page: () => const TransportView(),
      binding: TransportBinding(),
      children: [
        GetPage(
          name: _Paths.PASSENGER_INFO,
          page: () => const PassengerInfoView(),
          binding: PassengerInfoBinding(),
        ),
        GetPage(
          name: _Paths.SEAT_SELECTION,
          page: () => const SeatSelectionView(),
          binding: SeatSelectionBinding(),
        ),
        GetPage(
          name: _Paths.TRIP_LIST,
          page: () => const TripListView(),
          binding: TripListBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.HOTEL,
      page: () => const HotelView(),
      binding: HotelBinding(),
      children: [
        GetPage(
          name: _Paths.ROOM_SELECTION,
          page: () => const RoomSelectionView(),
          binding: RoomSelectionBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.PACKAGE,
      page: () => const PackageView(),
      binding: PackageBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => const PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: _Paths.SAVED,
      page: () => const SavedView(),
      binding: SavedBinding(),
    ),
    GetPage(
      name: _Paths.PROMOTIONS,
      page: () => const PromotionsView(),
      binding: PromotionsBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.LOCATIONS,
      page: () => const LocationsView(),
      binding: LocationsBinding(),
    ),
    GetPage(
      name: _Paths.START,
      page: () => const StartView(),
      binding: StartBinding(),
      children: [
        GetPage(
          name: _Paths.ONBOARD_SCREEN,
          page: () => const OnboardScreenView(),
          binding: OnboardScreenBinding(),
        ),
      ],
    ),
  ];
}
