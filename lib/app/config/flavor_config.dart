import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

enum AppFlavor { dev, staging, prod }

/// Per-flavor settings. Read anywhere with `AppConfig.baseUrl`, `AppConfig.isProd`...
abstract class AppConfig {
  const AppConfig._();

  static late final AppFlavor flavor;

  static void init(AppFlavor value) {
    flavor = value;
    switch (value) {
      case AppFlavor.dev:
        FlavorConfig(
          name: 'DEV',
          color: Colors.red,
          location: BannerLocation.topStart,
          variables: {
            // TODO: set the dev API url
            'baseUrl': 'https://dev-api.damnerloar.com',
          },
        );
      case AppFlavor.staging:
        FlavorConfig(
          name: 'STAGING',
          color: Colors.orange,
          location: BannerLocation.topStart,
          variables: {
            // TODO: set the staging API url
            'baseUrl': 'https://staging-api.damnerloar.com',
          },
        );
      case AppFlavor.prod:
        // no name = no banner in prod
        FlavorConfig(
          variables: {
            // TODO: set the production API url
            'baseUrl': 'https://api.damnerloar.com',
          },
        );
    }
  }

  static String get baseUrl => FlavorConfig.instance.variables['baseUrl'];

  static bool get isDev => flavor == AppFlavor.dev;
  static bool get isProd => flavor == AppFlavor.prod;
}
