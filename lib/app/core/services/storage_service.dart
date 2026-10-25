import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Local key-value storage. Registered once in bootstrap, read with `StorageService.to`.
class StorageService extends GetxService {
  static StorageService get to => Get.find();

  static const _introSeenKey = 'intro_seen';
  static const _languageKey = 'language_code';

  late final GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  bool get introSeen => _box.read<bool>(_introSeenKey) ?? false;
  Future<void> setIntroSeen() => _box.write(_introSeenKey, true);

  String? get languageCode => _box.read<String>(_languageKey);
  Future<void> setLanguageCode(String code) => _box.write(_languageKey, code);

  Locale? get locale {
    final code = languageCode;
    return code == null ? null : Locale(code);
  }
}
