import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Color alertBoxColor;
  final String alertBoxIcon;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final bool? isPop;

  const CommonAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
    this.alertBoxIcon = PngAssets.commonAlertIcon,
    this.alertBoxColor = AppColors.error,
    this.isPop,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return PopScope(
      canPop: isPop ?? true,
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor:
            themeController.isDarkMode.value
                ? AppColors.darkSecondary
                : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                _buildAlertIcon(),
                const SizedBox(height: 16),
                _buildTextSection(themeController),
                const SizedBox(height: 30),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertIcon() {
    return Container(
      padding: const EdgeInsets.all(15),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(52),
        color: alertBoxColor.withValues(alpha: 0.10),
      ),
      child: Image.asset(alertBoxIcon, width: 30, fit: BoxFit.contain),
    );
  }

  Widget _buildTextSection(ThemeController themeController) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          textAlign: TextAlign.center,
          message,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkTextTertiary
                    : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final ThemeController themeController = Get.find<ThemeController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          color: AppColors.error,
          icon: PngAssets.commonCancelIcon,
          text: "common.alertDialog.cancelButton".trns(),
          onTap: onCancel,
          textColor:
              themeController.isDarkMode.value
                  ? AppColors.white
                  : AppColors.white,
        ),
        const SizedBox(width: 10),
        _buildActionButton(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkPrimary
                  : AppColors.primary,
          icon: PngAssets.commonTickIcon,
          text: "common.alertDialog.confirmButton".trns(),
          onTap: onConfirm,
          textColor:
              themeController.isDarkMode.value
                  ? AppColors.black
                  : AppColors.white,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required Color color,
    required String icon,
    required String text,
    required VoidCallback onTap,
    required Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: text == "common.alertDialog.confirmButton".trns() ? 93 : 88,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, width: 14, fit: BoxFit.contain, color: textColor),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
