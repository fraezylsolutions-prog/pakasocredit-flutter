import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/reward/controller/reward_summery_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/reward/model/redeem_summery_model.dart';
import 'package:pakaso_credit/src/presentation/screens/reward/view/reward_summery/sub_sections/all_redeem_summery_dialog.dart';
import 'package:pakaso_credit/src/presentation/widgets/transaction_dynamic_icon/transaction_dynamic_icon.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RewardSummary extends StatefulWidget {
  const RewardSummary({super.key});

  @override
  State<RewardSummary> createState() => _RewardSummaryState();
}

class _RewardSummaryState extends State<RewardSummary>
    with WidgetsBindingObserver {
  final ThemeController themeController = Get.find<ThemeController>();
  late RewardSummeryController rewardSummeryController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    rewardSummeryController = Get.put(RewardSummeryController());
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  Future<void> refreshData() async {
    rewardSummeryController.isLoading.value = true;
    await rewardSummeryController.fetchRedeemSummery();
    rewardSummeryController.isLoading.value = false;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        rewardSummeryController.hasMorePages.value &&
        !rewardSummeryController.isPageLoading.value) {
      rewardSummeryController.loadMoreRedeemSummery();
    }
  }

  Future<void> loadData() async {
    if (!rewardSummeryController.isInitialDataLoaded.value) {
      rewardSummeryController.isLoading.value = true;
      await rewardSummeryController.fetchRedeemSummery();
      rewardSummeryController.isLoading.value = false;
      rewardSummeryController.isInitialDataLoaded.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        rewardSummeryController.resetFields();
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Obx(
          () => Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 16),
                  CommonAppBar(
                    title: "rewards.rewardSummary.title".trns(),
                    isPopEnabled: true,
                    showRightSideIcon: false,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: RefreshIndicator(
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                      onRefresh: () => refreshData(),
                      child:
                          rewardSummeryController.isLoading.value
                              ? CommonLoading()
                              : Column(
                                children: [
                                  rewardSummeryController
                                          .redeemSummeryModel
                                          .value
                                          .data!
                                          .isEmpty
                                      ? Expanded(
                                        child: SingleChildScrollView(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          child: SizedBox(
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.7,
                                            child: CommonNoDataFound(
                                              message:
                                                  "rewards.rewardSummary.noData"
                                                      .trns(),
                                              showTryAgainButton: true,
                                              onTryAgain: () => refreshData(),
                                            ),
                                          ),
                                        ),
                                      )
                                      : Expanded(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView.separated(
                                                controller: _scrollController,
                                                padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  bottom: 20,
                                                ),
                                                itemCount:
                                                    rewardSummeryController
                                                        .redeemSummeryModel
                                                        .value
                                                        .data!
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  final RedeemSummeryData
                                                  summery =
                                                      rewardSummeryController
                                                          .redeemSummeryModel
                                                          .value
                                                          .data![index];

                                                  return GestureDetector(
                                                    onTap:
                                                        () =>
                                                            showTransactionDialog(
                                                              summery,
                                                            ),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 20,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                        color:
                                                            themeController
                                                                    .isDarkMode
                                                                    .value
                                                                ? AppColors
                                                                    .darkSecondary
                                                                : AppColors
                                                                    .white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: AppColors
                                                                .black
                                                                .withValues(
                                                                  alpha: 0.05,
                                                                ),
                                                            blurRadius: 5,
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  2,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Icon
                                                          Container(
                                                            width: 40,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    100,
                                                                  ),
                                                              color:
                                                                  themeController
                                                                          .isDarkMode
                                                                          .value
                                                                      ? AppColors
                                                                          .darkPrimary
                                                                          .withAlpha(
                                                                            25,
                                                                          )
                                                                      : AppColors
                                                                          .primary
                                                                          .withAlpha(
                                                                            25,
                                                                          ),
                                                            ),
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  10,
                                                                ),
                                                            child: Image.asset(
                                                              TransactionDynamicIcon.getTransactionIcon(
                                                                summery.type,
                                                              ),
                                                              color:
                                                                  themeController
                                                                          .isDarkMode
                                                                          .value
                                                                      ? AppColors
                                                                          .darkPrimary
                                                                      : AppColors
                                                                          .primary,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 12,
                                                          ),

                                                          // Title + Subtitle
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  summery.type ??
                                                                      "N/A",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        13,
                                                                    color:
                                                                        themeController.isDarkMode.value
                                                                            ? AppColors.darkTextPrimary
                                                                            : AppColors.textPrimary,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 6,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Flexible(
                                                                      child: Text(
                                                                        summery.tnx ??
                                                                            "",
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              9,
                                                                          color:
                                                                              themeController.isDarkMode.value
                                                                                  ? AppColors.darkTextTertiary
                                                                                  : AppColors.textTertiary,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    CircleAvatar(
                                                                      radius: 2,
                                                                      backgroundColor:
                                                                          themeController.isDarkMode.value
                                                                              ? AppColors.darkCardBorder
                                                                              : Color(
                                                                                0xFF999999,
                                                                              ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 4,
                                                                    ),
                                                                    Text(
                                                                      summery.createdAt ??
                                                                          "",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            9,
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
                                                          ),

                                                          // Status and Amount
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          4,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        22,
                                                                      ),
                                                                  color:
                                                                      summery.status ==
                                                                              "Success"
                                                                          ? AppColors
                                                                              .success
                                                                              .withAlpha(25)
                                                                          : summery.status ==
                                                                              "Pending"
                                                                          ? Colors
                                                                              .orange
                                                                              .withAlpha(25)
                                                                          : AppColors
                                                                              .error
                                                                              .withAlpha(
                                                                                25,
                                                                              ),
                                                                ),
                                                                child: Text(
                                                                  summery.status ??
                                                                      '',
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 9,
                                                                    color:
                                                                        summery.status ==
                                                                                "Success"
                                                                            ? AppColors.success
                                                                            : summery.status ==
                                                                                "Pending"
                                                                            ? Colors.orange
                                                                            : AppColors.error,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 6,
                                                              ),
                                                              ConstrainedBox(
                                                                constraints:
                                                                    const BoxConstraints(
                                                                      maxWidth:
                                                                          100,
                                                                    ),
                                                                child: Text(
                                                                  "${summery.isPlus == true ? "+" : "-"}${summery.amount}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        summery.isPlus ==
                                                                                true
                                                                            ? AppColors.success
                                                                            : AppColors.error,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                ],
                              ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible:
                    rewardSummeryController.isTransactionsLoading.value ||
                    rewardSummeryController.isPageLoading.value,
                child: Container(
                  color: AppColors.textPrimary.withValues(alpha: 0.3),
                  child: CommonLoading(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showTransactionDialog(RedeemSummeryData summery) {
    Get.dialog(AllRedeemSummeryDialog(controller: summery));
  }
}
