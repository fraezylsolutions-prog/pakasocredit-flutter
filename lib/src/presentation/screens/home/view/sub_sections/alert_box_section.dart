import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/view/id_verification/id_verification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlertBoxSection extends StatelessWidget {
  const AlertBoxSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() {
      final user = homeController.userModel.value;
      // Safety check: only show if user is loaded and needs verification
      if (user.kyc == null || user.kyc == 1) return const SizedBox.shrink();

      return Column(
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: user.kyc == 0
                  ? AppColors.error.withOpacity(0.10)
                  : AppColors.warning.withOpacity(0.10),
              border: Border.all(
                color: user.kyc == 0 ? AppColors.error : AppColors.warning,
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  user.kyc == 0 ? PngAssets.commonErrorIcon : PngAssets.commonWarningIcon,
                  color: user.kyc == 0 ? AppColors.error : AppColors.warning,
                  width: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.kyc == 0
                            ? "Need to submit your information"
                            : "Your documents are awaiting approval",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: themeController.isDarkMode.value
                              ? AppColors.darkTextPrimary
                              : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (user.kyc == 0)
                        GestureDetector(
                          onTap: () {
                            Get.find<NavigationController>().selectedIndex.value = 4;
                            Get.find<NavigationController>().pushPage(const IdVerification());
                          },
                          child: Text(
                            "Submit Now",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: themeController.isDarkMode.value
                                  ? AppColors.darkPrimary
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
