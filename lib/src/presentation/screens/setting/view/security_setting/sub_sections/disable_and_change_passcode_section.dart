import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/security_setting/sub_sections/change_passcode_pop_up.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/security_setting/sub_sections/disable_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisableAndChangePasscodeSection extends StatelessWidget {
  const DisableAndChangePasscodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "securitySettings.securitySettings.passcode.title".trns(),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
          ),
        ),
        Divider(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkCardBorder
                  : AppColors.black.withValues(alpha: 0.08),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonElevatedButton(
              width: 150,
              height: 32,
              borderRadius: 8,
              buttonName:
                  "securitySettings.securitySettings.passcode.disable".trns(),
              onPressed: () {
                showDisablePasscodePopUp();
              },
              backgroundColor: AppColors.error,
              textColor: AppColors.white,
              fontSize: 13,
              iconSpacing: 3,
              leftIcon: Icon(Icons.close, size: 15, color: AppColors.white),
            ),
            SizedBox(width: 10),
            CommonElevatedButton(
              width: 160,
              height: 32,
              borderRadius: 8,
              buttonName:
                  "securitySettings.securitySettings.passcode.change".trns(),
              onPressed: () {
                showChangePasscodePopUp();
              },
              backgroundColor: AppColors.success,
              textColor: AppColors.white,
              fontSize: 13,
              iconSpacing: 3,
              leftIcon: Icon(
                Icons.vpn_key_sharp,
                size: 15,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void showChangePasscodePopUp() {
    Get.dialog(ChangePasscodePopUp());
  }

  void showDisablePasscodePopUp() {
    Get.dialog(DisablePasscodePopUp());
  }
}
