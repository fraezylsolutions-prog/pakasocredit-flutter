import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/change_password/change_password_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final ThemeController themeController = Get.find<ThemeController>();
  final ChangePasswordController controller = Get.put(
    ChangePasswordController(),
  );
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  CommonAppBar(
                    padding: 0,
                    title: "changePassword.title".trns(),
                    isPopEnabled: false,
                    showRightSideIcon: false,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            Obx(
                              () => CommonTextInputField(
                                showSuffixIcon: true,
                                suffixIcon: IconButton(
                                  highlightColor: AppColors.primary.withValues(
                                    alpha: 0.05,
                                  ),
                                  onPressed: () {
                                    controller.isPasswordVisible.value =
                                        !controller.isPasswordVisible.value;
                                  },
                                  icon: Image.asset(
                                    controller.isPasswordVisible.value
                                        ? PngAssets.commonRawHideEyeIcon
                                        : PngAssets.commonRawEyeIcon,
                                    width: 18,
                                    color:
                                        themeController.isDarkMode.value
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textPrimary,
                                  ),
                                ),
                                height: null,
                                controller:
                                    controller.currentPasswordController,
                                obscureText: controller.isPasswordVisible.value,
                                hintText:
                                    "changePassword.formFields.currentPassword"
                                        .trns(),
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'changePassword.validation.currentPasswordRequired'
                                        .trns();
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            Obx(
                              () => CommonTextInputField(
                                showSuffixIcon: true,
                                suffixIcon: IconButton(
                                  highlightColor: AppColors.primary.withValues(
                                    alpha: 0.05,
                                  ),
                                  onPressed: () {
                                    controller.isNewPasswordVisible.value =
                                        !controller.isNewPasswordVisible.value;
                                  },
                                  icon: Image.asset(
                                    controller.isNewPasswordVisible.value
                                        ? PngAssets.commonRawHideEyeIcon
                                        : PngAssets.commonRawEyeIcon,
                                    width: 18,
                                    color:
                                        themeController.isDarkMode.value
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textPrimary,
                                  ),
                                ),
                                controller: controller.newPasswordController,
                                obscureText:
                                    controller.isNewPasswordVisible.value,
                                hintText:
                                    "changePassword.formFields.newPassword"
                                        .trns(),
                                keyboardType: TextInputType.visiblePassword,
                                height: null,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'changePassword.validation.newPasswordRequired'
                                        .trns();
                                  }
                                  if (value.length < 8) {
                                    return 'changePassword.validation.passwordLength'
                                        .trns();
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            Obx(
                              () => CommonTextInputField(
                                showSuffixIcon: true,
                                suffixIcon: IconButton(
                                  highlightColor: AppColors.primary.withValues(
                                    alpha: 0.05,
                                  ),
                                  onPressed: () {
                                    controller.confirmPasswordVisible.value =
                                        !controller
                                            .confirmPasswordVisible
                                            .value;
                                  },
                                  icon: Image.asset(
                                    controller.confirmPasswordVisible.value
                                        ? PngAssets.commonRawHideEyeIcon
                                        : PngAssets.commonRawEyeIcon,
                                    width: 18,
                                    color:
                                        themeController.isDarkMode.value
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textPrimary,
                                  ),
                                ),
                                controller:
                                    controller.confirmPasswordController,
                                obscureText:
                                    controller.confirmPasswordVisible.value,
                                hintText:
                                    "changePassword.formFields.confirmPassword"
                                        .trns(),
                                keyboardType: TextInputType.visiblePassword,
                                height: null,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'changePassword.validation.confirmPasswordRequired'
                                        .trns();
                                  }
                                  if (value !=
                                      controller.newPasswordController.text) {
                                    return 'changePassword.validation.passwordMismatch'
                                        .trns();
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CommonElevatedButton(
                    buttonName: "changePassword.buttons.changePassword".trns(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.submitChangePassword();
                      }
                    },
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.isLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
