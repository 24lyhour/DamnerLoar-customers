import 'package:get/get.dart';

import '../controllers/guest_info_controller.dart';

class GuestInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuestInfoController>(() => GuestInfoController());
  }
}
