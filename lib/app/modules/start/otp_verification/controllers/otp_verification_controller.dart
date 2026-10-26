import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';

class OtpVerificationController extends GetxController {
  static const otpLength = 6;
  static const resendCountdownSeconds = 45;

  final phone = ''.obs;
  final otp = List.filled(otpLength, '').obs;
  final currentIndex = 0.obs;
  final countdown = resendCountdownSeconds.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Timer? _timer;
  final focusNodes = List.generate(otpLength, (_) => FocusNode());
  final controllers = List.generate(otpLength, (_) => TextEditingController());

  bool get canVerify => otp.every((digit) => digit.isNotEmpty);
  bool get canResend => countdown.value == 0;
  String get otpValue => otp.join();

  @override
  void onInit() {
    super.onInit();
    phone.value = Get.arguments?['phone'] ?? '+855 XX XXX XXX';
    _startCountdown();
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (final node in focusNodes) {
      node.dispose();
    }
    for (final ctrl in controllers) {
      ctrl.dispose();
    }
    super.onClose();
  }

  void _startCountdown() {
    countdown.value = resendCountdownSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void onDigitChanged(int index, String value) {
    errorMessage.value = '';

    if (value.length == 1) {
      otp[index] = value;
      if (index < otpLength - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        // Last digit entered, auto-verify
        focusNodes[index].unfocus();
        if (canVerify) {
          verify();
        }
      }
    } else if (value.isEmpty && index > 0) {
      otp[index] = '';
      focusNodes[index - 1].requestFocus();
    } else {
      otp[index] = '';
    }
  }

  void onKeyPressed(int index, KeyEvent event) {
    if (event.logicalKey.keyLabel == 'Backspace' &&
        controllers[index].text.isEmpty &&
        index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verify() async {
    if (!canVerify) return;

    isLoading.value = true;
    errorMessage.value = '';

    // TODO: Call auth provider to verify OTP
    await Future.delayed(const Duration(milliseconds: 800));

    // Simulate verification (in real app, check response)
    final isValid = otpValue == '123456'; // Demo: accept 123456

    isLoading.value = false;

    if (isValid) {
      Get.offAllNamed(Routes.COMPLETE_PROFILE);
    } else {
      errorMessage.value = 'Invalid code. Please try again.';
      // Clear OTP fields
      for (var i = 0; i < otpLength; i++) {
        otp[i] = '';
        controllers[i].clear();
      }
      focusNodes[0].requestFocus();
    }
  }

  Future<void> resendCode() async {
    if (!canResend) return;

    // TODO: Call auth provider to resend OTP
    await Future.delayed(const Duration(milliseconds: 500));

    _startCountdown();
    Get.snackbar(
      'Code sent',
      'A new verification code has been sent.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void changePhone() {
    Get.back();
  }

  String formatCountdown() {
    final minutes = countdown.value ~/ 60;
    final seconds = countdown.value % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
