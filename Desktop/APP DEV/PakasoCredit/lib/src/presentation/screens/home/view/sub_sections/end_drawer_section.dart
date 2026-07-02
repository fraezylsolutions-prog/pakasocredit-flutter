import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/gif/gif_assets.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/languages_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/services/translation_service.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EndDrawerSection extends StatefulWidget {
  const EndDrawerSection({super.key});

  @override
  State<EndDrawerSection> createState() => _EndDrawerSectionState();
}

class _EndDrawerSectionState extends State<EndDrawerSection> {
  final ThemeController themeController = Get.find<ThemeController>();
  final homeController = Get.find<HomeController>();

  Future<void> refreshUser() async {
    homeController.isSettingsLoading.value = true;
    await homeController.fetchUser();
    homeController.isSettingsLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Drawer(
        width: 334,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor:
            themeController.isDarkMode.value
                ? AppColors.darkSecondary
                : AppColors.white,
        child: RefreshIndicator(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkPrimary
                  : AppColors.primary,
          onRefresh: () => refreshUser(),
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Obx(
                  () => Column(
                    children: [
                      _buildProfileHeader(homeController),
                      SizedBox(height: 20),
                      _buildMenuItems(homeController),
                      if (homeController.languageSwitcher.value != "0")
                        Column(
                          children: [
                            _buildDivider(),
                            _buildLanguageSection(),
                            _buildDivider(),
                          ],
                        ),
                      _buildBiometricSection(),
                      _buildDivider(),
                      _buildDarkModeSection(themeController),
                      _buildDivider(),
                      _buildSignOutSection(),
                    ],
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible:
                      homeController.isSettingsLoading.value ||
                      homeController.isDashboardLoading.value,
                  child: CommonLoading(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.fingerprint,
                size: 20,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
              ),
              SizedBox(width: 16),
              Text(
                "Biometric",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Obx(
            () => Transform.scale(
              scale: 0.7,
              child: Switch(
                padding: EdgeInsets.zero,
                value: homeController.isBiometricEnable.value,
                activeThumbColor:
                    themeController.isDarkMode.value
                        ? AppColors.darkPrimary
                        : AppColors.primary,
                inactiveThumbColor:
                    themeController.isDarkMode.value
                        ? AppColors.darkTextTertiary
                        : AppColors.textTertiary,
                inactiveTrackColor:
                    themeController.isDarkMode.value
                        ? AppColors.darkBackground
                        : Color(0xFFE6E1E9),
                onChanged: (_) async {
                  await homeController.toggleBiometric();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkModeSection(ThemeController themeController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                !themeController.isDarkMode.value
                    ? PngAssets.commonMoonIcon
                    : PngAssets.commonSunRiseIcon,
                width: 20,
                color:
                    themeController.isDarkMode.value
                        ? Colors.yellow
                        : AppColors.textPrimary,
              ),
              SizedBox(width: 16),
              Text(
                "Dark Mode",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              padding: EdgeInsets.zero,
              value: themeController.isDarkMode.value,
              activeThumbColor:
                  themeController.isDarkMode.value
                      ? AppColors.darkPrimary
                      : AppColors.primary,
              inactiveThumbColor:
                  themeController.isDarkMode.value
                      ? AppColors.darkTextTertiary
                      : AppColors.textTertiary,
              inactiveTrackColor:
                  themeController.isDarkMode.value
                      ? AppColors.darkBackground
                      : Color(0xFFE6E1E9),
              onChanged: (_) async {
                themeController.toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(HomeController homeController) {
    final user = homeController.userModel.value;

    return Container(
      decoration: BoxDecoration(
        color:
            themeController.isDarkMode.value
                ? AppColors.darkPrimary.withValues(alpha: 0.10)
                : AppColors.primary.withValues(alpha: 0.10),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 60,
            spreadRadius: 0,
            offset: Offset(34, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 28, top: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                homeController.userModel.value.avatarPath != null
                    ? ClipOval(
                      child: FadeInImage(
                        placeholder: AssetImage(GifAssets.loadingGif),
                        image: NetworkImage(
                          homeController.userModel.value.avatarPath!,
                        ),
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            PngAssets.profileImage,
                            width: 40,
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    )
                    : ClipOval(
                      child: Image.asset(
                        PngAssets.endDrawerProfile,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                SizedBox(height: 16),
                Text(
                  user.fullName ?? 'No Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  user.email ?? 'No Email',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextPrimary.withValues(alpha: 0.80)
                            : AppColors.textPrimary.withValues(alpha: 0.80),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 14, right: 14),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Image.asset(
                PngAssets.endDrawerCancelIcon,
                width: 20,
                fit: BoxFit.contain,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(HomeController homeController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          _buildDrawerItem(
            PngAssets.commonSettingsIcon,
            "home.end_drawer.menu_items.profile_settings".trns(),
            BaseRoute.profileSetting,
            4,
          ),
          _buildDrawerItem(
            PngAssets.commonSecurityLockIcon,
            "home.end_drawer.menu_items.change_password".trns(),
            BaseRoute.changePassword,
            4,
          ),
          if (homeController.faVerification.value != "0" ||
              homeController.passcodeVerification.value != "0")
            _buildDrawerItem(
              PngAssets.commonSecurityIcon,
              "home.end_drawer.menu_items.two_fa".trns(),
              BaseRoute.securitySetting,
              4,
            ),
          if (homeController.kycVerification.value != "0")
            _buildDrawerItemWithStatus(
              PngAssets.commonSecurityCheckIcon,
              "home.end_drawer.menu_items.id_verification.title".trns(),
              homeController.userModel.value.kyc == 1
                  ? "home.end_drawer.menu_items.id_verification.status.approved"
                      .trns()
                  : homeController.userModel.value.kyc == 2
                  ? "home.end_drawer.menu_items.id_verification.status.pending"
                      .trns()
                  : homeController.userModel.value.kyc == 0
                  ? "home.end_drawer.menu_items.id_verification.status.submit"
                      .trns()
                  : "N/A",
              homeController.userModel.value.kyc == 1
                  ? AppColors.success
                  : homeController.userModel.value.kyc == 2
                  ? AppColors.warning
                  : homeController.userModel.value.kyc == 0
                  ? AppColors.error
                  : AppColors.transparent,
            ),
          _buildDrawerItem(
            PngAssets.commonNotificationIcon,
            "home.end_drawer.menu_items.notifications".trns(),
            BaseRoute.notification,
            4,
          ),
          _buildDrawerItem(
            PngAssets.commonCustomerSupportIcon,
            "home.end_drawer.menu_items.help_support".trns(),
            BaseRoute.helpAndSupport,
            4,
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    String iconPath,
    String title,
    String pushNamedPage,
    int selectedIndex,
  ) {
    return InkWell(
      onTap: () {
        Get.back();
        final navigationController = Get.find<NavigationController>();
        navigationController.selectedIndex.value = selectedIndex;
        navigationController.pushNamed(pushNamedPage);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 20,
              fit: BoxFit.contain,
              color:
                  themeController.isDarkMode.value
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItemWithStatus(
    String iconPath,
    String title,
    String status,
    Color statusColor,
  ) {
    return InkWell(
      onTap: () {
        Get.back();
        final navigationController = Get.find<NavigationController>();
        navigationController.selectedIndex.value = 4;
        navigationController.pushNamed(BaseRoute.idVerification);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 20,
                  fit: BoxFit.contain,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              status,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: statusColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color:
          themeController.isDarkMode.value
              ? AppColors.darkCardBorder.withValues(alpha: 0.5)
              : Color(0xFF000000).withValues(alpha: 0.06),
      height: 0,
    );
  }

  Widget _buildLanguageSection() {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          CommonDropdownBottomSheet(
            onValueSelected: (value) async {
              Get.back();
              final languageController = Get.find<LanguagesController>();
              languageController.locale.value = value.toString();
              languageController.changeLanguage(
                languageController.locale.value,
              );
              final translationService = Get.put(TranslationService());
              await translationService.loadTranslations(value);
              await homeController.loadData();
            },
            selectedValue:
                Get.find<LanguagesController>().languagesList
                    .map((item) => item.locale!)
                    .toList(),
            dropdownItems:
                Get.find<LanguagesController>().languagesList
                    .map((item) => item.name!)
                    .toList(),
            selectedItem: homeController.language,
            textController: homeController.languageController,
            title: "home.end_drawer.language.select_language".trns(),
            bottomSheetHeight: 400,
            currentlySelectedValue: homeController.language.value,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  PngAssets.endDrawerLanguageIcon,
                  width: 20,
                  fit: BoxFit.contain,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
                SizedBox(width: 16),
                Text(
                  "home.end_drawer.language.title".trns(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Obx(
                  () => Text(
                    homeController.language.value,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Image.asset(
                  PngAssets.endDrawerRightArrowIcon,
                  width: 18,
                  fit: BoxFit.contain,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutSection() {
    return InkWell(
      onTap: () {
        Get.back();
        Get.find<HomeController>().submitLogout();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Row(
          children: [
            Image.asset(
              PngAssets.commonSignOutIcon,
              width: 20,
              fit: BoxFit.contain,
              color: AppColors.error,
            ),
            SizedBox(width: 16),
            Text(
              "home.end_drawer.logOut".trns(),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
