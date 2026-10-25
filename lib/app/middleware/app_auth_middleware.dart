import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

// import '../core/services/storage_service.dart';
import '../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // if (route == Routes.AUTH ||
    //     route == Routes.SPLASH ||
    //     route == Routes.LANGUAGE) {
    //   return null;
    // }
    // if (StorageService.to.hasToken()) return null;
    // return const RouteSettings(name: Routes.AUTH);
  }
}
