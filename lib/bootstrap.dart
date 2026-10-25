import 'package:flutter/material.dart';

import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';

import 'app/config/flavor_config.dart';
import 'app/core/constants/app_string.dart';
import 'app/core/services/storage_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

/// Shared startup for every flavor entry point (main_dev / main_staging / main_prod).
Future<void> bootstrap(AppFlavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(flavor);
  await Get.putAsync(() => StorageService().init(), permanent: true);

  runApp(
    FlavorBanner(
      child: GetMaterialApp(
        title: AppString.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        translations: AppTranslations(),
        locale: StorageService.to.locale ?? const Locale('en'),
        fallbackLocale: const Locale('en'),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );
}
