import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CloseAccountAlert extends StatefulWidget {
  const CloseAccountAlert({super.key});

  @override
  State<CloseAccountAlert> createState() => _CloseAccountAlertState();
}

class _CloseAccountAlertState extends State<CloseAccountAlert> {
  final ThemeController themeController = Get.find<ThemeController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          themeController.isDarkMode.value
              ? AppColors.darkSecondary
              : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            _buildAlertIcon(),
            const SizedBox(height: 16),
            _buildTextSection(),
            const SizedBox(height: 16),
            _buildReasonInputFieldSection(),
            const SizedBox(height: 30),
            _buildActionButtons(),
          ],
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
        color: AppColors.error.withValues(alpha: 0.10),
      ),
      child: Image.asset(
        PngAssets.commonAlertIcon,
        width: 30,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildTextSection() {
    return Column(
      children: [
        Text(
          "settings.close_account_alert.title".trns(),
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
          "settings.close_account_alert.subtitle".trns(),
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkTextTertiary
                    : AppColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton(
          color: AppColors.error,
          icon: PngAssets.commonCancelIcon,
          text: "settings.close_account_alert.cancel".trns(),
          onTap: () => Get.back(),
          buttonTextColor: AppColors.white,
        ),
        const SizedBox(width: 10),
        _buildActionButton(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkPrimary
                  : AppColors.primary,
          icon: PngAssets.commonTickIcon,
          text: "settings.close_account_alert.confirm".trns(),
          onTap: () {
            Get.back();
            homeController.submitCloseAccount();
          },
          buttonTextColor:
              themeController.isDarkMode.value
                  ? AppColors.black
                  : AppColors.white,
        ),
      ],
    );
  }

  Widget _buildReasonInputFieldSection() {
    return CommonTextInputField(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      hintText: "settings.close_account_alert.reason_placeholder".trns(),
      controller: homeController.reasonController,
      maxLines: 4,
      height: null,
    );
  }

  Widget _buildActionButton({
    required Color color,
    required String icon,
    required String text,
    required VoidCallback onTap,
    required buttonTextColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: text == "settings.close_account_alert.confirm".trns() ? 93 : 88,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 14,
              fit: BoxFit.contain,
              color: buttonTextColor,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: buttonTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
