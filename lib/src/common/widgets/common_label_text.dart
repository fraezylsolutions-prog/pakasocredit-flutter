import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonLabelText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final bool isRequired;

  const CommonLabelText({
    super.key,
    required this.text,
    this.fontSize = 13,
    this.color,
    this.fontWeight = FontWeight.w600,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Text.rich(
      TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color:
              color ??
              (themeController.isDarkMode.value
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary),
          fontWeight: fontWeight,
        ),
        children:
            isRequired
                ? [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                ]
                : [],
      ),
    );
  }
}
