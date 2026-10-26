import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_string.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';

/// Circular photo picker for profile.
class PhotoPicker extends StatelessWidget {
  const PhotoPicker({
    super.key,
    required this.photoPath,
    required this.onTap,
  });

  final String? photoPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: AppColor.border,
                  width: 2,
                ),
              ),
              child: photoPath != null
                  ? ClipOval(
                      child: Image.file(
                        File(photoPath!),
                        width: 88,
                        height: 88,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.camera_alt_outlined,
                      size: 32,
                      color: AppColor.primary,
                    ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${AppString.addPhoto.tr} (${AppString.optional.tr})',
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColor.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
