import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_pages.dart';

class OnboardScreenController extends GetxController {
  static const pageCount = 3;

  final pageController = PageController();
  final currentPage = 0.obs;

  bool get isLastPage => currentPage.value == pageCount - 1;

  void onPageChanged(int index) => currentPage.value = index;

  void next() {
    if (isLastPage) {
      finish();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> finish() async {
    await StorageService.to.setIntroSeen();
    Get.offAllNamed(Routes.LANGUAGE);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
