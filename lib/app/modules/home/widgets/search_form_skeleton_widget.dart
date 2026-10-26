import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/app_spacing.dart';

/// Skeleton loading placeholder for search forms using skeletonizer package.
class SearchFormSkeleton extends StatelessWidget {
  const SearchFormSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Location field 1
            _buildSkeletonField(),
            const SizedBox(height: AppSpacing.sm),
            // Location field 2
            _buildSkeletonField(),
            const SizedBox(height: AppSpacing.sm),
            // Date and passengers row
            Row(
              children: [
                Expanded(child: _buildSkeletonField()),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildSkeletonField()),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Search button
            _buildSkeletonButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonField() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          const Bone.circle(size: 24),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone.text(words: 1, fontSize: 12),
                const SizedBox(height: 4),
                Bone.text(words: 2, fontSize: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: const Center(
        child: Bone.text(words: 2),
      ),
    );
  }
}
