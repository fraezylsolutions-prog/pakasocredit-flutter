import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/security_setting/security_setting_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TwoFaAuthenticationSection extends StatelessWidget {
  const TwoFaAuthenticationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final controller = Get.find<SecuritySettingController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "securitySettings.securitySettings.twoFa.title".trns(),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
          ),
        ),
        if (controller.userModel.value.twoFa == true)
          Divider(
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkCardBorder
                    : AppColors.black.withValues(alpha: 0.05),
          ),
        if (controller.userModel.value.twoFa == false)
          Column(
            children: [
              SizedBox(height: 10),
              Text(
                "securitySettings.securitySettings.twoFa.description".trns(),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextTertiary
                          : AppColors.textTertiary,
                ),
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: Text(
                  textAlign: TextAlign.center,
                  "securitySettings.securitySettings.twoFa.scanQrText".trns(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkPrimary
                            : AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: SvgPicture.string(
                  controller.userModel.value.twoFaQrCode!,
                ),
              ),
            ],
          ),
        SizedBox(height: controller.userModel.value.twoFa == false ? 20 : 10),
        controller.userModel.value.twoFa == false
            ? CommonTextInputField(
              hintText:
                  "securitySettings.securitySettings.twoFa.enterPin".trns(),
              controller: controller.enable2FaController,
              keyboardType: TextInputType.number,
            )
            : CommonTextInputField(
              hintText:
                  "securitySettings.securitySettings.twoFa.enterPassword"
                      .trns(),
              controller: controller.enterPasswordController,
              keyboardType: TextInputType.visiblePassword,
            ),
        SizedBox(height: 20),
        controller.userModel.value.twoFa == false
            ? CommonElevatedButton(
              width: 110,
              height: 32,
              borderRadius: 8,
              buttonName:
                  "securitySettings.securitySettings.twoFa.enableButton".trns(),
              onPressed: () {
                controller.submitEnableTwoFa();
              },
              backgroundColor: AppColors.success,
              textColor: AppColors.white,
              fontSize: 13,
              iconSpacing: 3,
              leftIcon: Icon(
                Icons.shield_outlined,
                size: 15,
                color: AppColors.white,
              ),
            )
            : CommonElevatedButton(
              width: 110,
              height: 32,
              borderRadius: 8,
              buttonName:
                  "securitySettings.securitySettings.twoFa.disableButton"
                      .trns(),
              onPressed: () {
                controller.submitDisableTwoFa();
              },
              backgroundColor: AppColors.error,
              textColor: AppColors.white,
              fontSize: 13,
              iconSpacing: 3,
              leftIcon: Icon(
                Icons.cancel_outlined,
                size: 15,
                color: AppColors.white,
              ),
            ),
      ],
    );
  }
}
