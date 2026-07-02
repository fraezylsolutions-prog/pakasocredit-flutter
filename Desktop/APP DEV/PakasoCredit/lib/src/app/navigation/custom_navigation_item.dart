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

  // Navy always — matches wallet card color
  static const Color _navBg = Color(0xFF0D2150);
  static const Color _activeColor = Color(0xFFF47920); // Orange
  static const Color _inactiveColor = Color(0x66FFFFFF); // White 40%

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<_NavItem> navItems = [
        _NavItem(
          rawIcon: PngAssets.rawBottomNavigationHomeIcon,
          solidIcon: PngAssets.solidBottomNavigationHomeIcon,
          label: 'common.bottomNavBar.home'.trns(),
        ),
        if (navigationController.virtualCard.value != '0')
          _NavItem(
            rawIcon: PngAssets.rawBottomNavigationCreditCardIcon,
            solidIcon: PngAssets.solidBottomNavigationCreditCardIcon,
            label: 'common.bottomNavBar.card'.trns(),
          ),
        if (navigationController.multipleCurrency.value != '0')
          _NavItem(
            rawIcon: PngAssets.rawBottomNavigationWalletIcon,
            solidIcon: PngAssets.solidBottomNavigationWalletIcon,
            label: 'common.bottomNavBar.wallets'.trns(),
          ),
        if (navigationController.userReward.value != '0')
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

      return Container(
        decoration: const BoxDecoration(
          color: _navBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isSelected =
                    navigationController.selectedIndex.value == index;

                return GestureDetector(
                  onTap: () => navigationController.onTapItem(index),
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / navItems.length,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Orange indicator line on top
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: isSelected ? 36 : 0,
                          height: 3,
                          decoration: BoxDecoration(
                            color: _activeColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          margin: const EdgeInsets.only(bottom: 6),
                        ),
                        // Icon
                        Image.asset(
                          isSelected ? item.solidIcon : item.rawIcon,
                          width: 22,
                          height: 22,
                          fit: BoxFit.contain,
                          color: isSelected ? Colors.white : _inactiveColor,
                        ),
                        const SizedBox(height: 4),
                        // Label
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isSelected ? Colors.white : _inactiveColor,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}

class _NavItem {
  final String rawIcon;
  final String solidIcon;
  final String label;
  _NavItem(
      {required this.rawIcon,
      required this.solidIcon,
      required this.label});
}
