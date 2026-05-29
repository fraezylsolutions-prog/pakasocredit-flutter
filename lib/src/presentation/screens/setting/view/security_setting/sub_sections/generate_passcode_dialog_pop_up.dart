import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/security_setting/security_setting_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class GeneratePasscodeDialogPopUp extends StatelessWidget {
  const GeneratePasscodeDialogPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final controller = Get.find<SecuritySettingController>();

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor:
          themeController.isDarkMode.value
              ? AppColors.darkSecondary
              : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 380,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "securitySettings.securitySettings.generatePopup.title"
                        .trns(),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(10, -5),
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () => Get.back(),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor:
                              themeController.isDarkMode.value
                                  ? AppColors.darkTextPrimary.withValues(
                                    alpha: 0.08,
                                  )
                                  : AppColors.textPrimary.withValues(
                                    alpha: 0.08,
                                  ),
                          child: Image.asset(
                            PngAssets.commonCancelIcon,
                            width: 14,
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              CommonTextInputField(
                hintText:
                    "securitySettings.securitySettings.generatePopup.passcodeLabel"
                        .trns(),
                controller: controller.passcodeController,
              ),
              SizedBox(height: 10),
              CommonTextInputField(
                hintText:
                    "securitySettings.securitySettings.generatePopup.confirmPasscodeLabel"
                        .trns(),
                controller: controller.confirmPasscodeController,
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonElevatedButton(
                      width: 80,
                      height: 32,
                      borderRadius: 8,
                      buttonName:
                          "securitySettings.securitySettings.generatePopup.close"
                              .trns(),
                      onPressed: () {
                        Get.back();
                        controller.passcodeController.clear();
                        controller.confirmPasscodeController.clear();
                      },
                      backgroundColor: AppColors.error,
                      textColor: AppColors.white,
                      fontSize: 13,
                      iconSpacing: 3,
                      leftIcon: Icon(
                        Icons.close,
                        size: 15,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    CommonElevatedButton(
                      width: 90,
                      height: 32,
                      borderRadius: 8,
                      buttonName:
                          "securitySettings.securitySettings.generatePopup.confirm"
                              .trns(),
                      onPressed: () {
                        if (controller.passcodeController.text.isNotEmpty &&
                            controller
                                .confirmPasscodeController
                                .text
                                .isNotEmpty) {
                          if (controller.passcodeController.text ==
                              controller.confirmPasscodeController.text) {
                            Get.back();
                            controller.submitGeneratePasscode();
                          } else {
                            Fluttertoast.showToast(
                              msg:
                                  "securitySettings.securitySettings.generatePopup.passcodeMismatchError"
                                      .trns(),
                              backgroundColor: AppColors.error,
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg:
                                "securitySettings.securitySettings.generatePopup.requiredFieldsError"
                                    .trns(),
                            backgroundColor: AppColors.error,
                          );
                        }
                      },
                      backgroundColor:
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                      fontSize: 13,
                      iconSpacing: 3,
                      leftIcon: Icon(
                        Icons.check,
                        size: 15,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.black
                                : AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
