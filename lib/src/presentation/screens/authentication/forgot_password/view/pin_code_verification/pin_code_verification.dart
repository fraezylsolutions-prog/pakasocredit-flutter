import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/app_strings.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/forgot_password/controller/pin_code_verification_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:pakaso_credit/src/utils/helpers/mask_email_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeVerification extends StatefulWidget {
  const PinCodeVerification({super.key});

  @override
  State<PinCodeVerification> createState() => _PinCodeVerificationState();
}

class _PinCodeVerificationState extends State<PinCodeVerification> {
  final ThemeController themeController = Get.find<ThemeController>();
  final pinCodeVerificationController =
      Get.find<PinCodeVerificationController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    pinCodeVerificationController.pinCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final String email = Get.arguments?['email'] ?? '';

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
                            "pinCodeVerification.alreadyHaveAccount".trns(),
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
                                  "pinCodeVerification.login".trns(),
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
                                SizedBox(height: 30),
                                Text(
                                  "pinCodeVerification.verifyOtp".trns(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color:
                                        themeController.isDarkMode.value
                                            ? AppColors.darkTextPrimary
                                            : AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  textAlign: TextAlign.center,
                                  "pinCodeVerification.codeSent".trnsFormat({
                                    "email": MaskEmailHelper.maskEmail(email),
                                  }),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color:
                                        themeController.isDarkMode.value
                                            ? AppColors.darkTextTertiary
                                            : AppColors.textTertiary,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              PinCodeTextField(
                                                errorTextSpace: 20,
                                                enablePinAutofill: true,
                                                controller:
                                                    pinCodeVerificationController
                                                        .pinCodeController,
                                                keyboardType:
                                                    TextInputType.number,
                                                cursorColor: AppColors.primary,
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                  color:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors
                                                              .darkTextPrimary
                                                          : AppColors
                                                              .textPrimary,
                                                ),
                                                validator:
                                                    (value) =>
                                                        value?.length == 6
                                                            ? null
                                                            : "pinCodeVerification.enter6DigitsError"
                                                                .trns(),
                                                pinTheme: PinTheme(
                                                  borderWidth: 1,
                                                  activeBorderWidth: 1,
                                                  disabledBorderWidth: 1,
                                                  inactiveBorderWidth: 1,
                                                  shape: PinCodeFieldShape.box,
                                                  fieldHeight: 48,
                                                  fieldWidth: 48,
                                                  activeColor:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors
                                                              .darkPrimary
                                                          : AppColors.primary,
                                                  activeFillColor:
                                                      AppColors.transparent,
                                                  inactiveColor:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? Color(0xFF5D6765)
                                                          : Color(
                                                            0xFF222222,
                                                          ).withValues(
                                                            alpha: 0.10,
                                                          ),
                                                  inactiveFillColor:
                                                      AppColors.transparent,
                                                  selectedColor:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors
                                                              .darkPrimary
                                                          : AppColors.primary,
                                                  selectedFillColor:
                                                      AppColors.transparent,
                                                  selectedBorderWidth: 1,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                appContext: context,
                                                length: 6,
                                              ),
                                              SizedBox(height: 30),
                                              CommonElevatedButton(
                                                fontSize: 16,
                                                buttonName:
                                                    "pinCodeVerification.verifyButton"
                                                        .trns(),
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    if (pinCodeVerificationController
                                                            .pinCodeController
                                                            .text
                                                            .length ==
                                                        6) {
                                                      pinCodeVerificationController
                                                          .submitPinCodeVerification(
                                                            email: email,
                                                          );
                                                    }
                                                  }
                                                },
                                                fontFamily: "Inter",
                                                rightIcon: Image.asset(
                                                  PngAssets
                                                      .commonTickDoubleIcon,
                                                  width: 20,
                                                  fit: BoxFit.contain,
                                                  color:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors.black
                                                          : AppColors.white,
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
                visible: pinCodeVerificationController.isLoading.value,
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
