import 'package:flutter/material.dart';

import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:get/get.dart';

import 'app/config/flavor_config.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

/// Shared startup for every flavor entry point (main_dev / main_staging / main_prod).
void bootstrap(AppFlavor flavor) {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.init(flavor);

  runApp(
    FlavorBanner(
      child: GetMaterialApp(
        title: "DamnerLoar",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );
}
