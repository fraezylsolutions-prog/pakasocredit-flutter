import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/app_strings.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_required_label_and_dynamic_field.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/forgot_password/controller/forgot_password_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final forgotPasswordController = Get.find<ForgotPasswordController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    final title = "forgotPassword.title".trns();
    final emailOrUsernameLabel = "forgotPassword.emailOrUsernameLabel".trns();
    final emailOrUsernameValidation =
        "forgotPassword.emailOrUsernameValidation".trns();
    final resetPasswordButton = "forgotPassword.resetPasswordButton".trns();
    final dontHaveAccount = "forgotPassword.dontHaveAccount".trns();
    final signUp = "forgotPassword.signUp".trns();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        surfaceTintColor:
            themeController.isDarkMode.value
                ? AppColors.darkBackground
                : AppColors.primary,
        backgroundColor:
            themeController.isDarkMode.value
                ? AppColors.darkBackground
                : AppColors.primary,
      ),
      body: ColoredBox(
        color:
            themeController.isDarkMode.value
                ? AppColors.darkBackground
                : AppColors.primary,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                themeController.isDarkMode.value
                    ? PngAssets.signInDarkShadow
                    : PngAssets.signInShadow,
              ),
            ),
            Column(
              children: [
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: AppColors.white.withValues(alpha: 0.1),
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.white.withValues(alpha: 0.18),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Image.asset(
                              PngAssets.commonBackArrowIcon,
                              width: 20,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            dontHaveAccount,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => Get.toNamed(BaseRoute.signUp),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8.5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  signUp,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Image.asset(
                  themeController.isDarkMode.value
                      ? AppStrings.darkAppLogo
                      : AppStrings.appLogo,
                  height: 38,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 50),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 28),
                        decoration: BoxDecoration(
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.white.withValues(alpha: 0.10)
                                  : AppColors.white.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 14,
                        right: 16,
                        bottom: 0,
                        left: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkSecondary
                                    : AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            child: Column(
                              children: [
                                SizedBox(height: 6),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 30),
                                        Text(
                                          title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 24,
                                            color:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkTextPrimary
                                                    : AppColors.textPrimary,
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        Form(
                                          key: _formKey,
                                          child: CommonRequiredLabelAndDynamicField(
                                            labelText: emailOrUsernameLabel,
                                            isLabelRequired: true,
                                            dynamicField: CommonTextInputField(
                                              controller:
                                                  forgotPasswordController
                                                      .emailOrUsernameController,
                                              height: null,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return emailOrUsernameValidation;
                                                }
                                                return null;
                                              },
                                              hintText: "",
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 40),
                                        CommonElevatedButton(
                                          fontSize: 16,
                                          buttonName: resetPasswordButton,
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              forgotPasswordController
                                                  .submitForgotPassword();
                                            }
                                          },
                                          fontFamily: "Inter",
                                          rightIcon: Image.asset(
                                            PngAssets.commonArrowLeftIcon,
                                            width: 20,
                                            fit: BoxFit.contain,
                                            color:
                                                themeController.isDarkMode.value
                                                    ? AppColors.black
                                                    : AppColors.white,
                                          ),
                                        ),
                                        SizedBox(height: 50),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: forgotPasswordController.isLoading.value,
                child: ColoredBox(
                  color: AppColors.textPrimary.withValues(alpha: 0.3),
                  child: CommonLoading(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
