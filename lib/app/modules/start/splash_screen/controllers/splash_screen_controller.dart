import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {
  /// How long the logo stays on screen after its entrance animation starts.
  static const showDuration = Duration(milliseconds: 2000);

  /// Exit animation: content zooms forward and fades out before navigating.
  static const exitDuration = Duration(milliseconds: 450);

  final version = ''.obs;
  final isExiting = false.obs;

  @override
  void onReady() {
    super.onReady();
    _start();
  }

  Future<void> _start() async {
    final info = await PackageInfo.fromPlatform();
    version.value = 'v${info.version}';

    await Future.delayed(showDuration);

    isExiting.value = true;
    await Future.delayed(exitDuration);

    final storage = StorageService.to;
    if (!storage.introSeen) {
      Get.offAllNamed(Routes.ONBOARD_SCREEN);
    } else if (storage.languageCode == null) {
      Get.offAllNamed(Routes.LANGUAGE);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }
}
