import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

import '../helpers/toast_helper.dart';

/// Reusable service for capturing and saving screenshots.
/// Used for e-tickets, receipts, vouchers, etc.
class ScreenshotService {
  ScreenshotService._();

  /// Capture a widget and save to gallery.
  /// Returns true if successful.
  static Future<bool> captureAndSave({
    required ScreenshotController controller,
    required String filename,
    String? successMessage,
    String? errorMessage,
  }) async {
    try {
      AppToast.loading('Saving...');

      // Capture screenshot
      final Uint8List? imageBytes = await controller.capture(
        delay: const Duration(milliseconds: 100),
        pixelRatio: 3.0,
      );

      if (imageBytes == null) {
        AppToast.dismiss();
        AppToast.error(errorMessage ?? 'Failed to capture image');
        return false;
      }

      // Save to gallery
      final result = await ImageGallerySaver.saveImage(
        imageBytes,
        quality: 100,
        name: filename,
      );

      AppToast.dismiss();

      if (result['isSuccess'] == true) {
        AppToast.success(successMessage ?? 'Saved to gallery');
        return true;
      } else {
        AppToast.error(errorMessage ?? 'Failed to save');
        return false;
      }
    } catch (e) {
      AppToast.dismiss();
      AppToast.error('Failed to save: ${e.toString()}');
      return false;
    }
  }

  /// Capture a widget and return bytes (for sharing as image).
  static Future<Uint8List?> capture({
    required ScreenshotController controller,
    double pixelRatio = 3.0,
  }) async {
    try {
      return await controller.capture(
        delay: const Duration(milliseconds: 100),
        pixelRatio: pixelRatio,
      );
    } catch (e) {
      return null;
    }
  }
}
