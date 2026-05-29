import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/controller/security_setting/security_setting_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/security_setting/sub_sections/disable_and_change_passcode_section.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/security_setting/sub_sections/generate_passcode_dialog_pop_up.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/security_setting/sub_sections/security_card.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/security_setting/sub_sections/two_fa_authentication_section.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecuritySetting extends StatefulWidget {
  const SecuritySetting({super.key});

  @override
  State<SecuritySetting> createState() => _SecuritySettingState();
}

class _SecuritySettingState extends State<SecuritySetting> {
  final ThemeController themeController = Get.find<ThemeController>();
  final SecuritySettingController controller = Get.put(
    SecuritySettingController(),
  );
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    controller.isLoading.value = true;
    await controller.fetchUser();
    controller.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        backgroundColor:
            themeController.isDarkMode.value
                ? AppColors.darkBackground
                : AppColors.background,
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                CommonAppBar(
                  title: "securitySettings.title".trns(),
                  isPopEnabled: false,
                  showRightSideIcon: false,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: RefreshIndicator(
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkPrimary
                            : AppColors.primary,
                    onRefresh: () => loadData(),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const CommonLoading();
                      }

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.darkSecondary
                                  : AppColors.white,
                        ),
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              if (homeController.faVerification.value == "1")
                                Column(
                                  children: [
                                    Obx(() {
                                      return controller
                                                  .userModel
                                                  .value
                                                  .twoFaIntitialized ==
                                              false
                                          ? SecurityCard(
                                            title:
                                                'securitySettings.2fa.title'
                                                    .trns(),
                                            description:
                                                'securitySettings.2fa.description'
                                                    .trns(),
                                            icon: Icons.security,
                                            iconColor:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkPrimary
                                                    : Colors.blue,
                                            buttonText:
                                                'securitySettings.2fa.buttonText'
                                                    .trns(),
                                            onPressed: () {
                                              controller.submitGenerateTwoFa();
                                            },
                                            buttonWidth: 140,
                                          )
                                          : TwoFaAuthenticationSection();
                                    }),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              Obx(() {
                                return homeController
                                            .passcodeVerification
                                            .value ==
                                        "1"
                                    ? controller.userModel.value.passcode ==
                                            null
                                        ? SecurityCard(
                                          title:
                                              'securitySettings.passcode.title'
                                                  .trns(),
                                          description:
                                              'securitySettings.passcode.description'
                                                  .trns(),
                                          icon: Icons.vpn_key,
                                          iconColor:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : Colors.purple,
                                          buttonText:
                                              'securitySettings.passcode.buttonText'
                                                  .trns(),
                                          onPressed: () {
                                            showGeneratePasscodeDialog();
                                          },
                                          buttonWidth: 180,
                                        )
                                        : DisableAndChangePasscodeSection()
                                    : const SizedBox(height: 24);
                              }),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible:
                    controller.isGenerateTwoFaLoading.value ||
                    controller.isEnableTwoFaLoading.value ||
                    controller.isDisableTwoFaLoading.value ||
                    controller.isGeneratePasscodeLoading.value ||
                    controller.isChangePasscodeLoading.value ||
                    controller.isDisablePasscodeLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showGeneratePasscodeDialog() async {
    Get.dialog(GeneratePasscodeDialogPopUp());
  }
}
