import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/presentation/screens/all_statistics/controller/statistics_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllStatistics extends StatefulWidget {
  const AllStatistics({super.key});

  @override
  State<AllStatistics> createState() => _AllStatisticsState();
}

class _AllStatisticsState extends State<AllStatistics> {
  final ThemeController themeController = Get.find<ThemeController>();
  final StatisticsController statisticsController = Get.put(
    StatisticsController(),
  );
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Obx(() {
          if (statisticsController.isLoading.value) {
            return CommonLoading();
          }

          final List<Map<String, dynamic>> statisticsList = [
            {
              "icon": PngAssets.allTransactionIcon,
              "count":
                  statisticsController
                      .statisticsModel
                      .value
                      .data!
                      .allTransactions
                      .toString(),
              "title": "home.all_statistics.items.all_transactions".trns(),
            },
            if (homeController.userDeposit.value != "0")
              {
                "icon": PngAssets.totalDepositIcon,
                "count":
                    statisticsController
                        .statisticsModel
                        .value
                        .data!
                        .totalDeposit
                        .toString(),
                "title": "home.all_statistics.items.total_deposit".trns(),
              },
            if (homeController.transferStatus.value != "0")
              {
                "icon": PngAssets.totalTransferIcon,
                "count":
                    statisticsController
                        .statisticsModel
                        .value
                        .data!
                        .totalTransfer
                        .toString(),
                "title": "home.all_statistics.items.total_transfer".trns(),
              },
            if (homeController.userPayBill.value != "0")
              {
                "icon": PngAssets.totalPayBillIcon,
                "count":
                    statisticsController.statisticsModel.value.data!.totalBill
                        .toString(),
                "title": "home.all_statistics.items.total_pay_bill".trns(),
              },
            if (homeController.signUpReferral.value != "0")
              {
                "icon": PngAssets.referralBonusIcon,
                "count":
                    statisticsController
                        .statisticsModel
                        .value
                        .data!
                        .totalReferralProfit
                        .toString(),
                "title": "home.all_statistics.items.referral_bonus".trns(),
              },
            if (homeController.userDps.value != "0")
              {
                "icon": PngAssets.totalDpsIcon,
                "count":
                    statisticsController.statisticsModel.value.data!.totalDps
                        .toString(),
                "title": "home.all_statistics.items.total_dps".trns(),
              },
            if (homeController.userFdr.value != "0")
              {
                "icon": PngAssets.totalFdrIcon,
                "count":
                    statisticsController.statisticsModel.value.data!.totalFdr
                        .toString(),
                "title": "home.all_statistics.items.total_fdr".trns(),
              },
            if (homeController.userLoan.value != "0")
              {
                "icon": PngAssets.totalLoanIcon,
                "count":
                    statisticsController.statisticsModel.value.data!.totalLoan
                        .toString(),
                "title": "home.all_statistics.items.total_loan".trns(),
              },
            if (homeController.userDeposit.value != "0")
              {
                "icon": PngAssets.depositBonusIcon,
                "count":
                    statisticsController
                        .statisticsModel
                        .value
                        .data!
                        .depositBonus
                        .toString(),
                "title": "home.all_statistics.items.deposit_bonus".trns(),
              },
            if (homeController.signUpReferral.value != "0")
              {
                "icon": PngAssets.totalReferralIcon,
                "count":
                    statisticsController
                        .statisticsModel
                        .value
                        .data!
                        .totalReferral
                        .toString(),
                "title": "home.all_statistics.items.total_referral".trns(),
              },
            if (homeController.userWithdraw.value != "0")
              {
                "icon": PngAssets.totalWithdrawIcon,
                "count":
                    statisticsController
                        .statisticsModel
                        .value
                        .data!
                        .totalWithdraw
                        .toString(),
                "title": "home.all_statistics.items.total_withdraw".trns(),
              },
            {
              "icon": PngAssets.totalTicketIcon,
              "count":
                  statisticsController.statisticsModel.value.data!.totalTickets
                      .toString(),
              "title": "home.all_statistics.items.total_ticket".trns(),
            },
          ];

          return RefreshIndicator(
            onRefresh: () => statisticsController.fetchStatistics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  CommonAppBar(
                    showRightSideIcon: false,
                    title: "home.all_statistics.title".trns(),
                    isPopEnabled: false,
                    padding: 0,
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: statisticsList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.7,
                                ),
                            itemBuilder: (context, index) {
                              return _buildCardSection(
                                statisticsList[index]["icon"],
                                statisticsList[index]["count"],
                                statisticsList[index]["title"],
                              );
                            },
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCardSection(icon, count, title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            themeController.isDarkMode.value
                ? AppColors.darkSecondary
                : AppColors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, width: 26, height: 26),
          SizedBox(height: 8),
          Text(
            textAlign: TextAlign.center,
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color:
                  themeController.isDarkMode.value
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2),
          Text(
            count,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color:
                  themeController.isDarkMode.value
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
