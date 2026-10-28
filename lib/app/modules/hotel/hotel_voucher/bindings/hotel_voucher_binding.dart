import 'package:get/get.dart';

import '../controllers/hotel_voucher_controller.dart';

class HotelVoucherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HotelVoucherController>(() => HotelVoucherController());
  }
}
