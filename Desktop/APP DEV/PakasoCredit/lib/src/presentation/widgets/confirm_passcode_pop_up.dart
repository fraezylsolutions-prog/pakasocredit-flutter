import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmPasscodePopUp extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressed;

  const ConfirmPasscodePopUp({
    super.key,
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor:
          themeController.isDarkMode.value
              ? AppColors.darkSecondary
              : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 5,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 18),
                    child: Text(
                      'common.confirm_passcode_popup.title'.trns(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Get.back();
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            themeController.isDarkMode.value
                                ? AppColors.white.withValues(alpha: 0.05)
                                : AppColors.black.withValues(alpha: 0.05),
                        child: Image.asset(
                          PngAssets.commonCancelIcon,
                          width: 16,
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: CommonTextInputField(
                  obscureText: true,
                  hintText:
                      "common.confirm_passcode_popup.passcode_label".trns(),
                  controller: controller,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonElevatedButton(
                    borderRadius: 30,
                    backgroundColor: AppColors.error,
                    textColor: AppColors.white,
                    width: 95,
                    height: 34,
                    buttonName:
                        "common.confirm_passcode_popup.close_button".trns(),
                    fontSize: 13,
                    iconSpacing: 3,
                    leftIcon: Icon(
                      Icons.close,
                      color: AppColors.white,
                      size: 15,
                    ),
                    onPressed: () {
                      Get.back();
                      controller.clear();
                    },
                  ),
                  SizedBox(width: 15),
                  CommonElevatedButton(
                    borderRadius: 30,
                    width: 100,
                    height: 34,
                    buttonName:
                        "common.confirm_passcode_popup.confirm_button".trns(),
                    fontSize: 13,
                    iconSpacing: 3,
                    leftIcon: Icon(
                      Icons.check,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.black
                              : AppColors.white,
                      size: 15,
                    ),
                    onPressed: onPressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
