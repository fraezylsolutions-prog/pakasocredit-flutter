import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String buttonText;
  final double buttonWidth;
  final VoidCallback onPressed;

  const SecurityCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.buttonText,
    required this.buttonWidth,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color:
            themeController.isDarkMode.value
                ? Color(0xFF1C2E24)
                : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkCardBorder
                  : Color(0xFFE0E0E0).withValues(alpha: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color:
                  themeController.isDarkMode.value
                      ? AppColors.darkTextTertiary
                      : AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 24),

          CommonElevatedButton(
            width: buttonWidth,
            height: 35,
            borderRadius: 8,
            buttonName: buttonText,
            onPressed: onPressed,
            backgroundColor: AppColors.success,
            textColor: AppColors.white,
            fontSize: 13,
            leftIcon: Icon(icon, size: 15, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
