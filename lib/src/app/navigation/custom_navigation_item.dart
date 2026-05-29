import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNavigationItem extends StatefulWidget {
  const CustomNavigationItem({super.key});

  @override
  State<CustomNavigationItem> createState() => _CustomNavigationItemState();
}

class _CustomNavigationItemState extends State<CustomNavigationItem> {
  final navigationController = Get.find<NavigationController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ColoredBox(
        color:
            themeController.isDarkMode.value
                ? AppColors.darkBackground
                : AppColors.background,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Obx(() {
            final List<_NavItem> navItems = [
              _NavItem(
                rawIcon: PngAssets.rawBottomNavigationHomeIcon,
                solidIcon: PngAssets.solidBottomNavigationHomeIcon,
                label: 'common.bottomNavBar.home'.trns(),
              ),
              if (navigationController.virtualCard.value != "0")
                _NavItem(
                  rawIcon: PngAssets.rawBottomNavigationCreditCardIcon,
                  solidIcon: PngAssets.solidBottomNavigationCreditCardIcon,
                  label: 'common.bottomNavBar.card'.trns(),
                ),
              if (navigationController.multipleCurrency.value != "0")
                _NavItem(
                  rawIcon: PngAssets.rawBottomNavigationWalletIcon,
                  solidIcon: PngAssets.solidBottomNavigationWalletIcon,
                  label: 'common.bottomNavBar.wallets'.trns(),
                ),
              if (navigationController.userReward.value != "0")
                _NavItem(
                  rawIcon: PngAssets.rawBottomNavigationRewardIcon,
                  solidIcon: PngAssets.solidBottomNavigationRewardIcon,
                  label: 'common.bottomNavBar.reward'.trns(),
                ),
              _NavItem(
                rawIcon: PngAssets.rawBottomNavigationSettingIcon,
                solidIcon: PngAssets.solidBottomNavigationSettingIcon,
                label: 'common.bottomNavBar.settings'.trns(),
              ),
            ];

            return BottomNavigationBar(
              backgroundColor:
                  themeController.isDarkMode.value
                      ? AppColors.darkSecondary
                      : AppColors.white,
              type: BottomNavigationBarType.fixed,
              currentIndex: navigationController.selectedIndex.value,
              onTap: navigationController.onTapItem,
              selectedItemColor:
                  themeController.isDarkMode.value
                      ? AppColors.darkPrimary
                      : AppColors.primary,
              unselectedItemColor:
                  themeController.isDarkMode.value
                      ? AppColors.darkTextTertiary
                      : const Color(0xFF9DB2CE),
              selectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
              items: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isSelected =
                    navigationController.selectedIndex.value == index;
                return BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 4),
                    child: Image.asset(
                      isSelected ? item.solidIcon : item.rawIcon,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      color:
                          themeController.isDarkMode.value
                              ? isSelected
                                  ? AppColors.darkPrimary
                                  : AppColors.darkTextPrimary
                              : isSelected
                              ? AppColors.primary
                              : const Color(0xFF9DB2CE),
                    ),
                  ),
                  label: item.label,
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  final String rawIcon;
  final String solidIcon;
  final String label;

  _NavItem({
    required this.rawIcon,
    required this.solidIcon,
    required this.label,
  });
}
