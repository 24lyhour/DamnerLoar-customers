import 'package:get/get.dart';

import '../controllers/trip_list_controller.dart';

class TripListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TripListController>(
      () => TripListController(),
    );
  }
}
