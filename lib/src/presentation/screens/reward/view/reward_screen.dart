import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/reward/controller/reward_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/reward/model/reward_model.dart';
import 'package:pakaso_credit/src/presentation/screens/reward/view/reward_summery/reward_summary.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final RewardController rewardController = Get.put(RewardController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        final navigationController = Get.find<NavigationController>();
        navigationController.selectedIndex.value = 0;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                CommonAppBar(
                  title: "rewards.title".trns(),
                  isPopEnabled: false,
                  showRightSideIcon: true,
                  rightSideIcon: PngAssets.commonClockIcon,
                  selectedIndex: 0,
                  onPressed: () {
                    final navigationController =
                        Get.find<NavigationController>();
                    navigationController.pushPage(RewardSummary());
                  },
                ),
                Expanded(
                  child: RefreshIndicator(
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkPrimary
                            : AppColors.primary,
                    onRefresh: () => rewardController.fetchRewards(),
                    child: Obx(() {
                      if (rewardController.isLoading.value) {
                        return const CommonLoading();
                      }

                      return SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 30,
                            top: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible:
                                    rewardController
                                        .rewardModel
                                        .value
                                        .data!
                                        .isPortfolio!,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 30),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(PngAssets.rewardShape),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.network(
                                        rewardController
                                            .rewardModel
                                            .value
                                            .data!
                                            .portfolioIcon!,
                                        width: 50,
                                        fit: BoxFit.contain,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Icon(
                                            Icons.error_outline_outlined,
                                            color: AppColors.white,
                                          );
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        rewardController
                                                .rewardModel
                                                .value
                                                .data!
                                                .portfolio ??
                                            "N/A",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "${"rewards.portfolio.pointsLabel".trns()} = ${rewardController.rewardModel.value.data!.points ?? 0}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      SizedBox(height: 24),
                                      CommonElevatedButton(
                                        buttonName:
                                            "rewards.portfolio.redeemButton"
                                                .trns(),
                                        fontWeight: FontWeight.w700,
                                        onPressed:
                                            () =>
                                                rewardController
                                                    .submitRedeemNow(),
                                        width: 112,
                                        height: 32,
                                        backgroundColor: AppColors.success,
                                        fontSize: 12,
                                        borderRadius: 8,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        rewardController
                                                .rewardModel
                                                .value
                                                .data!
                                                .text ??
                                            "N/A",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (rewardController
                                  .rewardModel
                                  .value
                                  .data!
                                  .isPortfolio!)
                                SizedBox(height: 30),
                              Text(
                                "rewards.sections.earnings".trns(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                ),
                              ),
                              if (rewardController.earningList.isNotEmpty)
                                SizedBox(height: 10),
                              rewardController.earningList.isEmpty
                                  ? CommonNoDataFound(
                                    message:
                                        "rewards.sections.noEarnings".trns(),
                                  )
                                  : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color:
                                            themeController.isDarkMode.value
                                                ? AppColors.darkCardBorder
                                                : Color(
                                                  0xFF030306,
                                                ).withValues(alpha: 0.10),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 15,
                                            bottom: 12,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "rewards.tableHeaders.portfolioList"
                                                    .trns(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors
                                                              .darkTextPrimary
                                                          : AppColors
                                                              .textPrimary,
                                                ),
                                              ),
                                              Text(
                                                "rewards.tableHeaders.transactions"
                                                    .trns(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors
                                                              .darkTextPrimary
                                                          : AppColors
                                                              .textPrimary,
                                                ),
                                              ),
                                              Text(
                                                "rewards.tableHeaders.reward"
                                                    .trns(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors
                                                              .darkTextPrimary
                                                          : AppColors
                                                              .textPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkCardBorder
                                                  : Color(
                                                    0xFF030306,
                                                  ).withValues(alpha: 0.10),
                                          height: 5,
                                        ),
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final Earnings earning =
                                                rewardController
                                                    .earningList[index];
                                            return Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      earning.portfolio ??
                                                          "N/A",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 11,
                                                        color:
                                                            themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? AppColors
                                                                    .darkTextTertiary
                                                                : AppColors
                                                                    .textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Transform.translate(
                                                      offset: Offset(10, 0),
                                                      child: Text(
                                                        earning.amountOfTransactions ??
                                                            "N/A",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 11,
                                                          color:
                                                              themeController
                                                                      .isDarkMode
                                                                      .value
                                                                  ? AppColors
                                                                      .darkTextTertiary
                                                                  : AppColors
                                                                      .textPrimary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      earning.point ?? "N/A",
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 11,
                                                        color:
                                                            themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? AppColors
                                                                    .darkTextTertiary
                                                                : AppColors
                                                                    .textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              color:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors.darkCardBorder
                                                      : Color(
                                                        0xFF030306,
                                                      ).withValues(alpha: 0.10),
                                              height: 5,
                                            );
                                          },
                                          itemCount:
                                              rewardController
                                                  .earningList
                                                  .length,
                                        ),
                                      ],
                                    ),
                                  ),
                              SizedBox(height: 30),
                              Text(
                                "rewards.sections.redeems".trns(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkTextPrimary
                                          : AppColors.textPrimary,
                                ),
                              ),
                              if (rewardController.redeemsList.isNotEmpty)
                                SizedBox(height: 10),
                              rewardController.redeemsList.isEmpty
                                  ? CommonNoDataFound(
                                    message:
                                        "rewards.sections.noRedeems".trns(),
                                  )
                                  : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color:
                                            themeController.isDarkMode.value
                                                ? AppColors.darkCardBorder
                                                : Color(
                                                  0xFF030306,
                                                ).withValues(alpha: 0.10),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 15,
                                            bottom: 12,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "rewards.tableHeaders.portfolioList"
                                                    .trns(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors
                                                              .darkTextPrimary
                                                          : AppColors
                                                              .textPrimary,
                                                ),
                                              ),
                                              Transform.translate(
                                                offset: Offset(10, 0),
                                                child: Text(
                                                  "rewards.tableHeaders.perPoints"
                                                      .trns(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10,
                                                    color:
                                                        themeController
                                                                .isDarkMode
                                                                .value
                                                            ? AppColors
                                                                .darkTextPrimary
                                                            : AppColors
                                                                .textPrimary,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "rewards.tableHeaders.redeemAmount"
                                                    .trns(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors
                                                              .darkTextPrimary
                                                          : AppColors
                                                              .textPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkCardBorder
                                                  : Color(
                                                    0xFF030306,
                                                  ).withValues(alpha: 0.10),
                                          height: 5,
                                        ),
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final Redeems redeem =
                                                rewardController
                                                    .redeemsList[index];
                                            return Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      redeem.portfolio ?? "N/A",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 11,
                                                        color:
                                                            themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? AppColors
                                                                    .darkTextTertiary
                                                                : AppColors
                                                                    .textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      redeem.point ?? "N/A",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 11,
                                                        color:
                                                            themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? AppColors
                                                                    .darkTextTertiary
                                                                : AppColors
                                                                    .textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      redeem.amount ?? "N/A",
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 11,
                                                        color:
                                                            themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? AppColors
                                                                    .darkTextTertiary
                                                                : AppColors
                                                                    .textPrimary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              color:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors.darkCardBorder
                                                      : Color(
                                                        0xFF030306,
                                                      ).withValues(alpha: 0.10),
                                              height: 5,
                                            );
                                          },
                                          itemCount:
                                              rewardController
                                                  .redeemsList
                                                  .length,
                                        ),
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: rewardController.isRedeemNowLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
