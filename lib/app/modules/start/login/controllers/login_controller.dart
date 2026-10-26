import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final agreedToTerms = false.obs;
  final isLoading = false.obs;

  /// Phone number with country code for display
  String get formattedPhone => '+855 ${phoneController.text}';

  /// Whether the form is valid for submission
  bool get canSubmit =>
      phoneController.text.length >= 8 && agreedToTerms.value;

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  void toggleTerms(bool? value) {
    agreedToTerms.value = value ?? false;
  }

  Future<void> sendCode() async {
    if (!canSubmit) return;

    isLoading.value = true;

    // TODO: Call auth provider to send OTP
    await Future.delayed(const Duration(milliseconds: 800));

    isLoading.value = false;

    Get.toNamed(
      Routes.OTP_VERIFICATION,
      arguments: {'phone': formattedPhone},
    );
  }

  Future<void> continueWithGoogle() async {
    // TODO: Implement Google sign-in
    Get.snackbar('Google', 'Google sign-in coming soon');
  }

  Future<void> continueWithApple() async {
    // TODO: Implement Apple sign-in
    Get.snackbar('Apple', 'Apple sign-in coming soon');
  }
}
