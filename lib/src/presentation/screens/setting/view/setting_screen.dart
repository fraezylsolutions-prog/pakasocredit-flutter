import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/all_notification/all_notification.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/change_password/change_password.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/help_and_support/help_and_support.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/id_verification/id_verification.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/profile_setting/profile_setting.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/security_setting/security_setting.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/sub_sections/close_account_alert.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final HomeController homeController = Get.find<HomeController>();

    final List<Map<String, dynamic>> settingsList = [
      {
        "leftIcon": PngAssets.commonSettingsIcon,
        "title": "settings.menuItems.profile".trns(),
        "rightIcon": PngAssets.commonArrowRightIcon,
        "status": "",
        "titleColor":
            themeController.isDarkMode.value
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary,
        "onPressed":
            () => Get.find<NavigationController>().pushPage(ProfileSetting()),
      },
      {
        "leftIcon": PngAssets.commonSecurityLockIcon,
        "title": "settings.menuItems.password".trns(),
        "rightIcon": PngAssets.commonArrowRightIcon,
        "status": "",
        "titleColor":
            themeController.isDarkMode.value
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary,
        "onPressed":
            () => Get.find<NavigationController>().pushPage(ChangePassword()),
      },
      if (homeController.faVerification.value != "0" ||
          homeController.passcodeVerification.value != "0")
        {
          "leftIcon": PngAssets.commonSecurityIcon,
          "title": "settings.menuItems.twoFA".trns(),
          "rightIcon": PngAssets.commonArrowRightIcon,
          "status": "",
          "titleColor":
              themeController.isDarkMode.value
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
          "onPressed":
              () =>
                  Get.find<NavigationController>().pushPage(SecuritySetting()),
        },
      if (homeController.kycVerification.value != "0")
        {
          "leftIcon": PngAssets.commonSecurityCheckIcon,
          "title": "settings.menuItems.idVerification".trns(),
          "rightIcon": PngAssets.commonArrowRightIcon,
          "status":
              homeController.userModel.value.kyc == 0
                  ? "settings.kycStatus.submit".trns()
                  : homeController.userModel.value.kyc == 1
                  ? "settings.kycStatus.approved".trns()
                  : homeController.userModel.value.kyc == 2
                  ? "settings.kycStatus.pending".trns()
                  : "N/A",
          "titleColor":
              themeController.isDarkMode.value
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
          "onPressed":
              () => Get.find<NavigationController>().pushPage(IdVerification()),
        },
      {
        "leftIcon": PngAssets.commonNotificationIcon,
        "title": "settings.menuItems.notifications".trns(),
        "rightIcon": PngAssets.commonArrowRightIcon,
        "status": "",
        "titleColor":
            themeController.isDarkMode.value
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary,
        "onPressed":
            () => Get.find<NavigationController>().pushPage(AllNotification()),
      },
      {
        "leftIcon": PngAssets.commonCustomerSupportIcon,
        "title": "settings.menuItems.helpSupport".trns(),
        "rightIcon": PngAssets.commonArrowRightIcon,
        "status": "",
        "titleColor":
            themeController.isDarkMode.value
                ? AppColors.darkTextPrimary
                : AppColors.textPrimary,
        "onPressed":
            () => Get.find<NavigationController>().pushPage(HelpAndSupport()),
      },
      {
        "leftIcon": PngAssets.commonUserRemoveIcon,
        "title": "settings.menuItems.deleteAccount".trns(),
        "rightIcon": PngAssets.commonArrowRightIcon,
        "status": "",
        "titleColor": AppColors.error,
        "onPressed": () {
          showCloseAccountAlert();
        },
      },
    ];

    Future<void> refreshUser() async {
      homeController.isSettingsLoading.value = true;
      await homeController.fetchUser();
      homeController.isSettingsLoading.value = false;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        final navigationController = Get.find<NavigationController>();
        if (!navigationController.popPage()) {
          navigationController.selectedIndex.value = 0;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 16),
                CommonAppBar(
                  title: "settings.title".trns(),
                  isPopEnabled: false,
                  showRightSideIcon: false,
                  selectedIndex: 0,
                ),
                SizedBox(height: 30),
                RefreshIndicator(
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkPrimary
                          : AppColors.primary,
                  onRefresh: () => refreshUser(),
                  child: Obx(() {
                    if (homeController.isSettingsLoading.value) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const CommonLoading(),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkSecondary
                                : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.separated(
                        physics: AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final setting = settingsList[index];

                          return InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => setting["onPressed"](),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 24,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        setting["leftIcon"],
                                        width: 18,
                                        fit: BoxFit.contain,
                                        color: setting["titleColor"],
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        setting["title"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color: setting["titleColor"],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (setting["status"].isNotEmpty)
                                        Text(
                                          setting["status"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                            color:
                                                homeController
                                                            .userModel
                                                            .value
                                                            .kyc ==
                                                        0
                                                    ? AppColors.error
                                                    : homeController
                                                            .userModel
                                                            .value
                                                            .kyc ==
                                                        1
                                                    ? AppColors.success
                                                    : homeController
                                                            .userModel
                                                            .value
                                                            .kyc ==
                                                        2
                                                    ? AppColors.warning
                                                    : null,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      if (setting["status"].isNotEmpty)
                                        SizedBox(width: 8),
                                      Image.asset(
                                        setting["rightIcon"],
                                        width: 18,
                                        fit: BoxFit.contain,
                                        color: setting["titleColor"],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkCardBorder
                                    : AppColors.textPrimary.withValues(
                                      alpha: 0.06,
                                    ),
                            height: 0,
                          );
                        },
                        itemCount: settingsList.length,
                      ),
                    );
                  }),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: homeController.isDeleteAccountLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCloseAccountAlert() {
    Get.dialog(CloseAccountAlert());
  }
}
