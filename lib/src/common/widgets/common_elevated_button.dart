import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonElevatedButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color? backgroundColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? textColor;
  final FontStyle fontStyle;
  final String fontFamily;
  final Widget? rightIcon;
  final Widget? leftIcon;
  final double iconSpacing;

  const CommonElevatedButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 45,
    this.backgroundColor,
    this.borderRadius = 12,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w700,
    this.textColor,
    this.fontStyle = FontStyle.normal,
    this.fontFamily = "Plus Jakarta Sans",
    this.rightIcon,
    this.leftIcon,
    this.iconSpacing = 6,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          backgroundColor:
              backgroundColor ??
              (themeController.isDarkMode.value
                  ? AppColors.darkPrimary
                  : AppColors.primary),
        ),
        child: _buildButtonContent(context, themeController),
      ),
    );
  }

  Widget _buildButtonContent(context, ThemeController themeController) {
    if (leftIcon != null || rightIcon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leftIcon != null) leftIcon!,
          if (leftIcon != null) SizedBox(width: iconSpacing),
          Text(
            buttonName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color:
                  textColor ??
                  (themeController.isDarkMode.value
                      ? AppColors.black
                      : AppColors.white),
              fontStyle: fontStyle,
              fontFamily: fontFamily,
            ),
          ),
          if (rightIcon != null) SizedBox(width: iconSpacing),
          if (rightIcon != null) rightIcon!,
        ],
      );
    } else {
      return Text(
        buttonName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color:
              textColor ??
              (themeController.isDarkMode.value
                  ? AppColors.black
                  : AppColors.white),
          fontStyle: fontStyle,
          fontFamily: fontFamily,
        ),
      );
    }
  }
}
