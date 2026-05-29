import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/app_strings.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/services/biometric_auth_service.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/common/widgets/common_alert_dialog.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_required_label_and_dynamic_field.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/sign_in/controller/sign_in_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:pakaso_credit/src/utils/helpers/language_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final signInController = Get.find<SignInController>();
  final LocalAuthentication auth = LocalAuthentication();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setLogInState();
    loadAccountCreation();
    loadSavedEmail();
    loadBiometricStatus();
  }

  Future<void> loadBiometricStatus() async {
    final savedBiometric = await SettingsService.getBiometricEnableOrDisable();
    signInController.isBiometricEnable.value = savedBiometric ?? false;
  }

  Future<void> setLogInState() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await LanguageStorage.saveLoginCurrentState("logged_in");
    });
  }

  Future<void> loadSavedEmail() async {
    final savedEmail = await SettingsService.getLoggedInUserEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      signInController.emailOrUsernameController.text = savedEmail;
    }
  }

  Future<void> loadAccountCreation() async {
    final accountCreationValue = await SettingsService.getSettingValue(
      "account_creation",
    );
    signInController.accountCreation.value = accountCreationValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final noAccountText = "signIn.noAccountText".trns();
    final signUpButton = "signIn.signUpButton".trns();
    final emailLabel = "signIn.emailLabel".trns();
    final passwordLabel = "signIn.passwordLabel".trns();
    final forgotPassword = "signIn.forgotPassword".trns();
    final signInButton = "signIn.signInButton".trns();
    final requiredMessage = "signIn.requiredMessage".trns();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        showExitApplicationAlertDialog();
      },
      child: Scaffold(
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
                  Obx(
                    () => Visibility(
                      visible: signInController.accountCreation.value != "0",
                      child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              noAccountText,
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
                                  color: AppColors.white.withValues(
                                    alpha: 0.16,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    signUpButton,
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
                      ),
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
                            child: Column(
                              children: [
                                SizedBox(height: 6),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 30),
                                          Text(
                                            "Welcome Back!",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 24,
                                              color:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors
                                                          .darkTextPrimary
                                                      : AppColors.textPrimary,
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          Form(
                                            key: _formKey,
                                            child: AutofillGroup(
                                              child: Column(
                                                children: [
                                                  CommonRequiredLabelAndDynamicField(
                                                    labelText: emailLabel,
                                                    isLabelRequired: true,
                                                    labelFontWeight:
                                                        FontWeight.w600,
                                                    labelFontSize: 13,
                                                    dynamicField: CommonTextInputField(
                                                      height: null,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return requiredMessage;
                                                        }
                                                        return null;
                                                      },
                                                      controller:
                                                          signInController
                                                              .emailOrUsernameController,
                                                      hintText: "",
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      autofillHints: const [
                                                        AutofillHints.email,
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Obx(
                                                    () => CommonRequiredLabelAndDynamicField(
                                                      labelText: passwordLabel,
                                                      isLabelRequired: true,
                                                      dynamicField: CommonTextInputField(
                                                        height: null,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return requiredMessage;
                                                          }
                                                          return null;
                                                        },
                                                        controller:
                                                            signInController
                                                                .passwordController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        obscureText:
                                                            signInController
                                                                .isPasswordVisible
                                                                .value,
                                                        hintText: "",
                                                        showSuffixIcon: true,
                                                        suffixIcon: IconButton(
                                                          highlightColor:
                                                              AppColors.primary
                                                                  .withValues(
                                                                    alpha: 0.05,
                                                                  ),
                                                          onPressed: () {
                                                            signInController
                                                                    .isPasswordVisible
                                                                    .value =
                                                                !signInController
                                                                    .isPasswordVisible
                                                                    .value;
                                                          },
                                                          icon: Image.asset(
                                                            !signInController
                                                                    .isPasswordVisible
                                                                    .value
                                                                ? PngAssets
                                                                    .commonRawHideEyeIcon
                                                                : PngAssets
                                                                    .commonRawEyeIcon,
                                                            width: 18,
                                                            color:
                                                                themeController
                                                                        .isDarkMode
                                                                        .value
                                                                    ? AppColors
                                                                        .darkTextPrimary
                                                                    : AppColors
                                                                        .textPrimary,
                                                          ),
                                                        ),
                                                        autofillHints: const [
                                                          AutofillHints
                                                              .password,
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          GestureDetector(
                                            onTap:
                                                () => Get.toNamed(
                                                  BaseRoute.forgotPassword,
                                                ),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                forgotPassword,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors
                                                              .darkPrimary
                                                          : AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 40),
                                          CommonElevatedButton(
                                            fontSize: 16,
                                            buttonName: signInButton,
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                signInController.submitSignIn();
                                              }
                                            },
                                            fontFamily: "Inter",
                                            rightIcon: Image.asset(
                                              PngAssets.commonArrowLeftIcon,
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
                                          SizedBox(height: 40),
                                          Material(
                                            color: AppColors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              onTap: () async {
                                                final savedEmail =
                                                    await SettingsService.getLoggedInUserEmail();
                                                final savedPassword =
                                                    await SettingsService.getLoggedInUserPassword();

                                                if (savedEmail == null ||
                                                    savedPassword == null) {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "First Sign In with Email and Password",
                                                    backgroundColor:
                                                        AppColors.error,
                                                  );
                                                  return;
                                                }

                                                if (!signInController
                                                    .isBiometricEnable
                                                    .value) {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Your biometric is not enabled",
                                                    backgroundColor:
                                                        AppColors.error,
                                                  );
                                                  return;
                                                }

                                                final bioAuth =
                                                    BiometricAuthService();
                                                bool success =
                                                    await bioAuth
                                                        .authenticateWithBiometrics();

                                                if (success) {
                                                  signInController
                                                      .biometricEmail
                                                      .value = savedEmail;
                                                  signInController
                                                      .biometricPassword
                                                      .value = savedPassword;
                                                  await signInController
                                                      .submitSignIn(
                                                        useBiometric: true,
                                                      );
                                                }
                                              },

                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color:
                                                        themeController
                                                                .isDarkMode
                                                                .value
                                                            ? AppColors
                                                                .darkPrimary
                                                            : AppColors.primary,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Icon(
                                                  Icons.fingerprint,
                                                  size: 40,
                                                  color:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors
                                                              .darkPrimary
                                                          : AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 50),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                  visible: signInController.isLoading.value,
                  child: ColoredBox(
                    color: AppColors.textPrimary.withValues(alpha: 0.3),
                    child: CommonLoading(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showExitApplicationAlertDialog() {
    final exitDialogTitle = "signIn.exitDialog.title".trns();
    final exitDialogMessage = "signIn.exitDialog.message".trns();

    Get.dialog(
      CommonAlertDialog(
        title: exitDialogTitle,
        message: exitDialogMessage,
        onConfirm: () => SystemNavigator.pop(),
        onCancel: () => Get.back(),
      ),
    );
  }
}
