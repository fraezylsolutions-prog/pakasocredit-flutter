import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/app_strings.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/two_fa/controller/two_fa_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class TwoFaScreen extends StatefulWidget {
  const TwoFaScreen({super.key});

  @override
  State<TwoFaScreen> createState() => _TwoFaScreenState();
}

class _TwoFaScreenState extends State<TwoFaScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final twoFaController = Get.find<TwoFaController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    twoFaController.pinCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final alreadyHaveAccount = "twoFa.alreadyHaveAccount".trns();
    final login = "twoFa.login".trns();
    final title = "twoFa.title".trns();
    final subtitle = "twoFa.subtitle".trns();
    final pinError = "twoFa.pinError".trns();
    final verifyButton = "twoFa.verifyButton".trns();

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
                            alreadyHaveAccount,
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
                                  login,
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
                                        SizedBox(height: 16),
                                        Text(
                                          subtitle,
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
                                        Column(
                                          children: [
                                            Form(
                                              key: _formKey,
                                              child: Column(
                                                children: [
                                                  PinCodeTextField(
                                                    errorTextSpace: 20,
                                                    enablePinAutofill: true,
                                                    controller:
                                                        twoFaController
                                                            .pinCodeController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    cursorColor:
                                                        AppColors.primary,
                                                    textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
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
                                                                : pinError,
                                                    pinTheme: PinTheme(
                                                      borderWidth: 1,
                                                      activeBorderWidth: 1,
                                                      disabledBorderWidth: 1,
                                                      inactiveBorderWidth: 1,
                                                      shape:
                                                          PinCodeFieldShape.box,
                                                      fieldHeight: 48,
                                                      fieldWidth: 48,
                                                      activeColor:
                                                          themeController
                                                                  .isDarkMode
                                                                  .value
                                                              ? AppColors
                                                                  .darkPrimary
                                                              : AppColors
                                                                  .primary,
                                                      activeFillColor:
                                                          AppColors.transparent,
                                                      inactiveColor:
                                                          themeController
                                                                  .isDarkMode
                                                                  .value
                                                              ? Color(
                                                                0xFF5D6765,
                                                              )
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
                                                              : AppColors
                                                                  .primary,
                                                      selectedFillColor:
                                                          AppColors.transparent,
                                                      selectedBorderWidth: 1,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    appContext: context,
                                                    length: 6,
                                                  ),
                                                  SizedBox(height: 30),
                                                  CommonElevatedButton(
                                                    fontSize: 16,
                                                    buttonName: verifyButton,
                                                    onPressed: () {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        if (twoFaController
                                                                .pinCodeController
                                                                .text
                                                                .length ==
                                                            6) {
                                                          twoFaController
                                                              .submitTwoFaVerification();
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
                visible: twoFaController.isLoading.value,
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
