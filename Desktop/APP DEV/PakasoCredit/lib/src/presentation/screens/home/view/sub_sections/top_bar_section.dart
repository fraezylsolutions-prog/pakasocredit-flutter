import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBarSection extends StatelessWidget {
  const TopBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final HomeController homeController = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => homeController.openDrawer(),
            child: Obx(
              () => Image.asset(
                PngAssets.commonMenuIcon,
                width: 30,
                fit: BoxFit.contain,
                color: themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
          ),
          Row(
            children: [
              Obx(
                () => Material(
                  color: AppColors.transparent,
                  child: GestureDetector(
                    onTap: () => themeController.toggleTheme(),
                    child: Image.asset(
                      !themeController.isDarkMode.value
                          ? PngAssets.commonMoonIcon
                          : PngAssets.commonSunRiseIcon,
                      width: 24,
                      color: themeController.isDarkMode.value
                          ? Colors.yellow
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Obx(
                () => GestureDetector(
                  onTap: () {
                    final navigationController = Get.find<NavigationController>();
                    navigationController.selectedIndex.value = 4;
                    navigationController.pushNamed(BaseRoute.notification);
                  },
                  child: Badge(
                    smallSize: homeController.userModel.value.isUnreadNotification == true ? 8 : 0,
                    backgroundColor: const Color(0xFFE5544F),
                    child: Image.asset(
                      PngAssets.commonNotificationIcon,
                      width: 24,
                      fit: BoxFit.contain,
                      color: themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Obx(
                () => GestureDetector(
                  onTap: () => homeController.openDrawer(), // Clicking profile now also opens the drawer as per menu expectation
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: homeController.userModel.value.avatarPath != null && homeController.userModel.value.avatarPath!.isNotEmpty
                        ? Image.network(
                            homeController.userModel.value.avatarPath!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              PngAssets.profileImage,
                              width: 40,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image.asset(
                            PngAssets.profileImage,
                            width: 40,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
