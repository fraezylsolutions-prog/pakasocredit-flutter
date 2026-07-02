import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppStyles {
  // Linear Gradient
  static LinearGradient linearGradient() {
    final ThemeController themeController = Get.find<ThemeController>();

    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        themeController.isDarkMode.value
            ? AppColors.darkSecondary
            : AppColors.white,
        themeController.isDarkMode.value
            ? AppColors.darkSecondary
            : AppColors.white,
        themeController.isDarkMode.value
            ? AppColors.darkBackground
            : AppColors.background,
      ],
      stops: const [0.0, 0.9, 1.0],
    );
  }

  // Box Shadow
  static List<BoxShadow> boxShadow() {
    return [
      BoxShadow(
        color: AppColors.black.withValues(alpha: 0.05),
        offset: const Offset(0, -2),
        blurRadius: 10,
      ),
    ];
  }
}
