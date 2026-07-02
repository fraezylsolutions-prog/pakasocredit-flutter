import 'package:confetti/confetti.dart';
import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/authentication/congrats/controller/congrats_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CongratsScreen extends StatefulWidget {
  const CongratsScreen({super.key});

  @override
  CongratsScreenState createState() => CongratsScreenState();
}

class CongratsScreenState extends State<CongratsScreen> {
  final CongratsController congratsController = Get.find<CongratsController>();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    congratsController.fetchSettings();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 10),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor:
            themeController.isDarkMode.value
                ? AppColors.darkBackground
                : AppColors.primary,
      ),
      body: Obx(
        () =>
            congratsController.isLoading.value
                ? CommonLoading()
                : Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16, top: 18),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Image.asset(
                              PngAssets.commonSplashLogo,
                              width: 40,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 28,
                                right: 28,
                                top: 80,
                              ),
                              child: Text(
                                "congrats.congratsMessage".trnsFormat({
                                  "amount":
                                      "${Get.find<SettingsService>().currencySymbol.value}${congratsController.settingsData["data"]}",
                                }),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkTextPrimary
                                          : AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 53),
                        CommonElevatedButton(
                          width: 200,
                          buttonName: "congrats.buttonText".trns(),
                          onPressed:
                              () => Get.offAllNamed(BaseRoute.navigation),
                          fontFamily: "Inter",
                          fontSize: 16,
                        ),
                        Spacer(),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        emissionFrequency: 0.03,
                        numberOfParticles: 20,
                        maxBlastForce: 5,
                        minBlastForce: 1,
                        gravity: 0.1,
                        colors: const [
                          Colors.green,
                          Colors.blue,
                          Colors.pink,
                          Colors.orange,
                          Colors.purple,
                        ],
                        shouldLoop: true,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
