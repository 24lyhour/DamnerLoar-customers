import 'package:get/get.dart';

import '../controllers/room_selection_controller.dart';

class RoomSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoomSelectionController>(
      () => RoomSelectionController(),
    );
  }
}
