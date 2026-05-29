import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EarnSection extends StatelessWidget {
  const EarnSection({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final ThemeController themeController = Get.find<ThemeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        final data = homeController.dashboardModel.value.data;
        if (data == null) {
          return const SizedBox();
        }

        // Sanitize branding in server greeting
        String greeting = data.greeting ?? "";
        greeting = greeting.replaceAll("Digi Bank", "Pakaso Credit")
                           .replaceAll("digi Bank", "Pakaso Credit");

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: themeController.isDarkMode.value
                          ? AppColors.darkTextTertiary
                          : const Color(0xFF030306).withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.userName ?? "",
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Get.find<NavigationController>().pushNamed(BaseRoute.referral),
              child: Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: themeController.isDarkMode.value
                      ? AppColors.darkPrimary
                      : AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.15),
                      offset: const Offset(0, 5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      PngAssets.commonGiftIcon,
                      width: 14,
                      fit: BoxFit.contain,
                      color: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data.earnText ?? "Earn \$10",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: themeController.isDarkMode.value ? AppColors.black : AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
