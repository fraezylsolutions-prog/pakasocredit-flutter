import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_alert_dialog.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    // Hardcoding strings to prevent old branding from server translations
    const title = "Welcome to";
    const appName = "Pakaso Credit";
    final tagline = "welcome.tagline".trns();
    final buttonText = "welcome.buttonText".trns();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        showExitApplicationAlertDialog();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor:
              themeController.isDarkMode.value
                  ? AppColors.darkBackground
                  : AppColors.primary,
        ),
        body: ColoredBox(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkBackground
                  : AppColors.background,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                bottom: 0,
                child: Image.asset(
                  PngAssets.welcomeShapeFive,
                  color:
                      themeController.isDarkMode.value
                          ? const Color(0xFF1C2E24)
                          : const Color(0xFFF2EAFF),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  themeController.isDarkMode.value
                      ? PngAssets.welcomeDarkShapeSix
                      : PngAssets.welcomeShapeSix,
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(PngAssets.welcomeBanner, width: 220),
                          Positioned(
                            right: -60,
                            bottom: -60,
                            child: Image.asset(
                              themeController.isDarkMode.value
                                  ? PngAssets.welcomeDarkShapeOne
                                  : PngAssets.welcomeShapeOne,
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.grey.withOpacity(0.7)
                                      : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8E8E8E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    appName,
                    style: TextStyle(
                      fontFamily: "Qanelas Soft",
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      tagline,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkTextTertiary
                                : AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CommonElevatedButton(
                    buttonName: buttonText,
                    onPressed: () => Get.toNamed(BaseRoute.onboarding),
                    width: 200,
                    fontSize: 16,
                    fontFamily: "Inter",
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showExitApplicationAlertDialog() {
    final title = "welcome.exitDialog.title".trns();
    final message = "welcome.exitDialog.message".trns();
    Get.dialog(
      CommonAlertDialog(
        title: title,
        message: message,
        onConfirm: () => SystemNavigator.pop(),
        onCancel: () => Get.back(),
      ),
    );
  }
}
