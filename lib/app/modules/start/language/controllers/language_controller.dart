import 'dart:ui';

import 'package:get/get.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_pages.dart';

class LanguageController extends GetxController {
  static const khmer = 'km';
  static const english = 'en';

  final selected = english.obs;

  @override
  void onInit() {
    super.onInit();
    selected.value =
        StorageService.to.languageCode ?? Get.locale?.languageCode ?? english;
  }

  /// Switches the app language right away so the screen previews it.
  void select(String code) {
    selected.value = code;
    Get.updateLocale(Locale(code));
  }

  Future<void> confirm() async {
    await StorageService.to.setLanguageCode(selected.value);
    Get.offAllNamed(Routes.HOME);
  }

  /// Guests can search and browse everything; login is only needed at checkout.
  Future<void> browseAsGuest() => confirm();
}
