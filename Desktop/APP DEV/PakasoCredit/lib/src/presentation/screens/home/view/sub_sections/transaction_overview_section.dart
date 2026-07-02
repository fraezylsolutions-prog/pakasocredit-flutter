import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionOverviewSection extends StatelessWidget {
  const TransactionOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Obx(
      () {
        // Safety Check: Don't crash if data or statistics is null
        final data = homeController.dashboardModel.value.data;
        if (data == null || data.statistics == null) {
          return const SizedBox();
        }

        final stats = data.statistics!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    _buildCardSection(
                      PngAssets.commonTransactionIcon2,
                      (stats.totalTransactions ?? 0).toString(),
                      "home.transactionOverview.cards.allTransactions.title".trns(),
                    ),
                    if (homeController.userDeposit.value != "0")
                      const SizedBox(width: 10),
                    if (homeController.userDeposit.value != "0")
                      _buildCardSection(
                        PngAssets.commonBriefcaseIcon4,
                        (stats.totalDeposit ?? "0").toString(),
                        "home.transactionOverview.cards.totalDeposit.title".trns(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (homeController.transferStatus.value != "0")
                    _buildCardSection(
                      PngAssets.commonCircleDataTransferIcon2,
                      (stats.totalTransfer ?? "0").toString(),
                      "home.transactionOverview.cards.totalTransfer.title".trns(),
                    ),
                  if (homeController.transferStatus.value != "0")
                    const SizedBox(width: 10),
                  _buildMoreSection(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoreSection() {
    final ThemeController themeController = Get.find<ThemeController>();

    return Flexible(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Get.find<NavigationController>().pushNamed(BaseRoute.statistics),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: themeController.isDarkMode.value ? AppColors.darkSecondary : AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.03),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0xFF030306).withOpacity(0.10),
                  ),
                ),
                child: Image.asset(
                  PngAssets.commonMoreIcon,
                  color: themeController.isDarkMode.value ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "home.transactionOverview.cards.more.title".trns(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: themeController.isDarkMode.value ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection(String icon, String count, String title) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: themeController.isDarkMode.value ? AppColors.darkSecondary : AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.03),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 26,
              child: Image.asset(icon),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: themeController.isDarkMode.value ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            Text(
              count,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: themeController.isDarkMode.value 
                  ? AppColors.darkTextPrimary.withOpacity(0.80) 
                  : AppColors.textPrimary.withOpacity(0.80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
