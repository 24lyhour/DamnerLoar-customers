import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_text_style.dart';

/// Phone input with country code picker using intl_phone_number_input package.
class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onInputValidated,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onInputValidated;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          onChanged?.call(number.phoneNumber ?? '');
        },
        onInputValidated: onInputValidated,
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          useBottomSheetSafeArea: true,
          leadingPadding: 12,
          trailingSpace: false,
          setSelectorButtonAsPrefixIcon: true,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: AppTextStyle.bodyMedium.copyWith(
          color: AppColor.textPrimary,
        ),
        textFieldController: controller,
        formatInput: true,
        keyboardType: TextInputType.phone,
        inputDecoration: InputDecoration(
          hintText: '12 345 678',
          hintStyle: AppTextStyle.bodyMedium.copyWith(
            color: AppColor.textTertiary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
        textStyle: AppTextStyle.bodyMedium.copyWith(
          color: AppColor.textPrimary,
        ),
        initialValue: PhoneNumber(isoCode: 'KH'), // Cambodia default
        countries: const ['KH', 'TH', 'VN', 'LA', 'MM', 'MY', 'SG', 'US'],
      ),
    );
  }
}
