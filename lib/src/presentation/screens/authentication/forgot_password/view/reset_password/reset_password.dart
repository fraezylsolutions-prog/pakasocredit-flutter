import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/app_strings.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_required_label_and_dynamic_field.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/forgot_password/controller/reset_password_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final resetPasswordController = Get.find<ResetPasswordController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    resetPasswordController.passwordController = TextEditingController();
    resetPasswordController.confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final String email = Get.arguments?['email'] ?? '';
    final String otp = Get.arguments?['otp'] ?? '';

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0, backgroundColor: AppColors.primary),
      body: ColoredBox(
        color: AppColors.primary,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(PngAssets.signInShadow),
            ),
            Column(
              children: [
                SizedBox(height: 24),
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
                            "forgotPassword.reset_password.already_have_account"
                                .trns(),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => Get.offNamed(BaseRoute.signIn),
                            child: Container(
                              width: 53,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "forgotPassword.reset_password.login_button"
                                      .trns(),
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
                  AppStrings.appLogo,
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
                          color: AppColors.white.withValues(alpha: 0.2),
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
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 60),
                                  Text(
                                    "forgotPassword.reset_password.screen_title"
                                        .trns(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  Obx(
                                    () => CommonRequiredLabelAndDynamicField(
                                      labelText:
                                          "forgotPassword.reset_password.password"
                                              .trns(),
                                      isLabelRequired: true,
                                      dynamicField: CommonTextInputField(
                                        backgroundColor: AppColors.transparent,
                                        height: null,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "forgotPassword.reset_password.password_required"
                                                .trns();
                                          }
                                          return null;
                                        },
                                        controller:
                                            resetPasswordController
                                                .passwordController,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText:
                                            resetPasswordController
                                                .isPasswordVisible
                                                .value,
                                        hintText: "",
                                        showSuffixIcon: true,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            resetPasswordController
                                                    .isPasswordVisible
                                                    .value =
                                                !resetPasswordController
                                                    .isPasswordVisible
                                                    .value;
                                          },
                                          icon: Image.asset(
                                            PngAssets.commonEyeIcon,
                                            width: 15,
                                            color: Color(0xFF4E4E4E),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Obx(
                                    () => CommonRequiredLabelAndDynamicField(
                                      labelText:
                                          "forgotPassword.reset_password.confirm_password"
                                              .trns(),
                                      isLabelRequired: true,
                                      dynamicField: CommonTextInputField(
                                        backgroundColor: AppColors.transparent,
                                        height: null,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "forgotPassword.reset_password.password_required"
                                                .trns();
                                          }
                                          return null;
                                        },
                                        controller:
                                            resetPasswordController
                                                .confirmPasswordController,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText:
                                            resetPasswordController
                                                .isConfirmPasswordVisible
                                                .value,
                                        hintText: "",
                                        showSuffixIcon: true,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            resetPasswordController
                                                    .isConfirmPasswordVisible
                                                    .value =
                                                !resetPasswordController
                                                    .isConfirmPasswordVisible
                                                    .value;
                                          },
                                          icon: Image.asset(
                                            PngAssets.commonEyeIcon,
                                            width: 15,
                                            color: Color(0xFF4E4E4E),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 35),
                                        CommonElevatedButton(
                                          fontSize: 16,
                                          buttonName:
                                              "forgotPassword.reset_password.reset_button"
                                                  .trns(),
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              resetPasswordController
                                                  .submitResetPassword(
                                                    email: email,
                                                    otp: otp,
                                                  );
                                            }
                                          },
                                          fontFamily: "Inter",
                                          rightIcon: Image.asset(
                                            PngAssets.commonArrowLeftIcon,
                                            width: 20,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                ],
                              ),
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
                visible: resetPasswordController.isLoading.value,
                child: Container(
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
