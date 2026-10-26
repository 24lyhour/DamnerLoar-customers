import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../routes/app_pages.dart';

class CompleteProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final photoPath = Rxn<String>();
  final selectedGender = Rxn<String>();
  final selectedNationality = 'Cambodian'.obs;
  final tripNotifications = true.obs;
  final isLoading = false.obs;

  final genderOptions = ['Male', 'Female', 'Other'];
  final nationalityOptions = [
    'Cambodian',
    'Thai',
    'Vietnamese',
    'Laotian',
    'Chinese',
    'Other',
  ];

  bool get canSave =>
      nameController.text.trim().isNotEmpty &&
      emailController.text.trim().isNotEmpty &&
      selectedGender.value != null;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (image != null) {
      photoPath.value = image.path;
    }
  }

  void setGender(String? value) {
    selectedGender.value = value;
  }

  void setNationality(String? value) {
    if (value != null) {
      selectedNationality.value = value;
    }
  }

  void toggleNotifications(bool value) {
    tripNotifications.value = value;
  }

  Future<void> saveAndContinue() async {
    if (!canSave) return;

    isLoading.value = true;

    // TODO: Call user provider to save profile
    await Future.delayed(const Duration(milliseconds: 800));

    isLoading.value = false;

    // Navigate to home
    Get.offAllNamed(Routes.HOME);
  }
}
