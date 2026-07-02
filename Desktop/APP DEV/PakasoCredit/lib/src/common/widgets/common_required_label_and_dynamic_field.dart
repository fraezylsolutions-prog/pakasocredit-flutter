import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_label_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonRequiredLabelAndDynamicField extends StatelessWidget {
  final String labelText;
  final double labelFontSize;
  final Color? labelColor;
  final FontWeight labelFontWeight;
  final bool isLabelRequired;
  final Widget dynamicField;

  const CommonRequiredLabelAndDynamicField({
    super.key,
    required this.labelText,
    this.labelFontSize = 13,
    this.labelColor,
    this.labelFontWeight = FontWeight.w600,
    this.isLabelRequired = false,
    required this.dynamicField,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonLabelText(
          text: labelText,
          fontSize: labelFontSize,
          color:
              labelColor ??
              (themeController.isDarkMode.value
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary),
          fontWeight: labelFontWeight,
          isRequired: isLabelRequired,
        ),
        const SizedBox(height: 10),
        dynamicField,
      ],
    );
  }
}
