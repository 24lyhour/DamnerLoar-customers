import 'package:get/get.dart';

import '../controllers/passenger_info_controller.dart';

class PassengerInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassengerInfoController>(
      () => PassengerInfoController(),
    );
  }
}
