import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Local key-value storage. Registered once in bootstrap, read with `StorageService.to`.
class StorageService extends GetxService {
  static StorageService get to => Get.find();

  static const _introSeenKey = 'intro_seen';
  static const _languageKey = 'language_code';
  static const _userNameKey = 'user_name';
  static const _userPhoneKey = 'user_phone';
  static const _userEmailKey = 'user_email';

  late final GetStorage _box;

  Future<StorageService> init({bool seedDevData = false}) async {
    await GetStorage.init();
    _box = GetStorage();

    // Seed test user data for development
    if (seedDevData && userName == null) {
      await setUserName('Kouch Lyhour');
      await setUserPhone('+855 12 345 678');
      await setUserEmail('lyhour@example.com');
    }

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

  // User profile
  String? get userName => _box.read<String>(_userNameKey);
  Future<void> setUserName(String name) => _box.write(_userNameKey, name);

  String? get userPhone => _box.read<String>(_userPhoneKey);
  Future<void> setUserPhone(String phone) => _box.write(_userPhoneKey, phone);

  String? get userEmail => _box.read<String>(_userEmailKey);
  Future<void> setUserEmail(String email) => _box.write(_userEmailKey, email);
}
