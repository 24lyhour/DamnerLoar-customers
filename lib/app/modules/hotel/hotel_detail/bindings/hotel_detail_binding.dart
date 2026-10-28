import 'package:get/get.dart';

import '../controllers/hotel_detail_controller.dart';

class HotelDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HotelDetailController>(() => HotelDetailController());
  }
}
