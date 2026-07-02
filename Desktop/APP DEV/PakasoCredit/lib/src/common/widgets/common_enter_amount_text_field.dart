import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonEnterAmountTextField extends StatelessWidget {
  final String currencyCode;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Color? backgroundColor;
  final Color? currencyBackgroundColor;
  final bool? readOnly;
  final bool? isCurrencyVisible;
  final double? topRightBorderRadius;
  final double? bottomRightBorderRadius;
  final String? hintText;

  const CommonEnterAmountTextField({
    super.key,
    required this.currencyCode,
    required this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.backgroundColor,
    this.readOnly,
    this.isCurrencyVisible,
    this.topRightBorderRadius,
    this.bottomRightBorderRadius,
    this.currencyBackgroundColor,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Row(
      children: [
        Expanded(
          child: CommonTextInputField(
            onChanged: onChanged,
            controller: controller,
            topRightBorderRadius: topRightBorderRadius,
            bottomRightBorderRadius: bottomRightBorderRadius,
            hintText: hintText ?? "",
            validator: validator,
            keyboardType: keyboardType,
            backgroundColor: backgroundColor,
            readOnly: readOnly ?? false,
          ),
        ),
        if (isCurrencyVisible == true)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 45,
            decoration: BoxDecoration(
              color: currencyBackgroundColor,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(10),
              ),
              border: BorderDirectional(
                top: BorderSide(
                  color:
                      themeController.isDarkMode.value
                          ? Color(0xFF5D6765)
                          : AppColors.black.withValues(alpha: 0.20),
                ),
                end: BorderSide(
                  color:
                      themeController.isDarkMode.value
                          ? Color(0xFF5D6765)
                          : AppColors.black.withValues(alpha: 0.20),
                ),
                bottom: BorderSide(
                  color:
                      themeController.isDarkMode.value
                          ? Color(0xFF5D6765)
                          : AppColors.black.withValues(alpha: 0.20),
                ), // Bottom border
              ),
            ),
            child: Text(
              currencyCode,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
              ),
            ),
          ),
      ],
    );
  }
}
