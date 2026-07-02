import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/portfolio/controller/portfolio_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final PortfolioController portfolioController = Get.put(
      PortfolioController(),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 16),
            CommonAppBar(
              title: "portfolio.title".trns(),
              isPopEnabled: false,
              showRightSideIcon: false,
            ),
            Expanded(
              child: RefreshIndicator(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkPrimary
                        : AppColors.primary,
                onRefresh: () => portfolioController.fetchPortfolio(),
                child: Obx(() {
                  if (portfolioController.isLoading.value) {
                    return const CommonLoading();
                  }
                  if (portfolioController.portfolioList.isEmpty) {
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: CommonNoDataFound(
                          message: "portfolio.noData".trns(),
                          showTryAgainButton: true,
                          onTryAgain:
                              () => portfolioController.fetchPortfolio(),
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 30),
                    itemBuilder: (context, index) {
                      final portfolio =
                          portfolioController.portfolioList[index];

                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkCardBorder
                                    : Color(0xFF000000).withValues(alpha: 0.10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  portfolio.icon!,
                                  width: 32,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.error_outline_outlined,
                                      color:
                                          themeController.isDarkMode.value
                                              ? AppColors.darkTextTertiary
                                              : AppColors.textTertiary,
                                    );
                                  },
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      portfolio.name ?? "N/A",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color:
                                            themeController.isDarkMode.value
                                                ? AppColors.darkTextPrimary
                                                : AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      portfolio.description ?? "N/A",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color:
                                            themeController.isDarkMode.value
                                                ? AppColors.darkTextTertiary
                                                : AppColors.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Visibility(
                              visible: portfolio.isLocked == false,
                              replacement: Image.asset(
                                PngAssets.portfolioLockIcon,
                                width: 20,
                                fit: BoxFit.contain,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(3),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: AppColors.success,
                                ),
                                child: Image.asset(
                                  PngAssets.commonTickIcon,
                                  width: 14,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 20);
                    },
                    itemCount: portfolioController.portfolioList.length,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
