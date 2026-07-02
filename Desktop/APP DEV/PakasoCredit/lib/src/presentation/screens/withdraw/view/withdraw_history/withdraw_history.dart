import 'dart:async';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/controller/withdraw_history_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/model/withdraw_history_model.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/view/withdraw_history/sub_sections/withdraw_history_details_pop_up.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/view/withdraw_history/sub_sections/withdraw_history_filter_pop_up.dart';
import 'package:pakaso_credit/src/presentation/widgets/transaction_dynamic_icon/transaction_dynamic_icon.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawHistory extends StatefulWidget {
  const WithdrawHistory({super.key});

  @override
  State<WithdrawHistory> createState() => _WithdrawHistoryState();
}

class _WithdrawHistoryState extends State<WithdrawHistory>
    with WidgetsBindingObserver {
  final ThemeController themeController = Get.find<ThemeController>();
  late WithdrawHistoryController withdrawHistoryController;
  late ScrollController _scrollController;

  Timer? _debounce;
  final Duration debounceDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    withdrawHistoryController = Get.put(WithdrawHistoryController());
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_scrollListener);
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> refreshData() async {
    withdrawHistoryController.isLoading.value = true;
    await withdrawHistoryController.fetchWithdrawHistory();
    withdrawHistoryController.isLoading.value = false;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        withdrawHistoryController.hasMorePages.value &&
        !withdrawHistoryController.isPageLoading.value) {
      withdrawHistoryController.loadMoreWithdrawHistory();
    }
  }

  Future<void> loadData() async {
    if (!withdrawHistoryController.isInitialDataLoaded.value) {
      withdrawHistoryController.isLoading.value = true;
      await withdrawHistoryController.fetchWithdrawHistory();
      withdrawHistoryController.isLoading.value = false;
      withdrawHistoryController.isInitialDataLoaded.value = true;
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(debounceDuration, () {
      withdrawHistoryController.fetchDynamicWithdrawHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        withdrawHistoryController.resetFields();
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
                    showRightSideIcon: false,
                    title: "withdraw.withdrawHistory.title".trns(),
                    isPopEnabled: false,
                    isUtilsBackLogic: true,
                    backLogicFunction: () {
                      withdrawHistoryController.resetFields();
                      Get.find<NavigationController>().popPage();
                    },
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: RefreshIndicator(
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                      onRefresh: () => refreshData(),
                      child:
                          withdrawHistoryController.isLoading.value
                              ? CommonLoading()
                              : Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color:
                                          themeController.isDarkMode.value
                                              ? AppColors.darkSecondary
                                              : AppColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CommonTextInputField(
                                            onChanged: _onSearchChanged,
                                            borderRadius: 8,
                                            controller:
                                                withdrawHistoryController
                                                    .transactionIdController,
                                            hintText:
                                                "withdraw.withdrawHistory.transactionId"
                                                    .trns(),
                                            keyboardType: TextInputType.text,
                                            showPrefixIcon: true,
                                            prefixIcon: Padding(
                                              padding: const EdgeInsets.all(
                                                13.0,
                                              ),
                                              child: Image.asset(
                                                PngAssets.commonSearchIcon,
                                                color:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors
                                                            .darkTextPrimary
                                                        : AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Material(
                                          color: AppColors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            onTap: () {
                                              Get.bottomSheet(
                                                WithdrawHistoryFilterPopUp(),
                                              );
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(11),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? Color(0xFF5D6765)
                                                          : AppColors
                                                              .textPrimary
                                                              .withValues(
                                                                alpha: 0.10,
                                                              ),
                                                ),
                                              ),
                                              child: Image.asset(
                                                PngAssets.commonFilterIcon,
                                                width: 20,
                                                color:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors
                                                            .darkTextPrimary
                                                        : AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  withdrawHistoryController
                                          .withdrawHistoryModel
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
                                                  "withdraw.withdrawHistory.noDataFound"
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
                                                padding: EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  bottom: 20,
                                                ),
                                                itemBuilder: (context, index) {
                                                  final WithdrawHistoryData
                                                  withdraw =
                                                      withdrawHistoryController
                                                          .withdrawHistoryModel
                                                          .value
                                                          .data![index];

                                                  return GestureDetector(
                                                    onTap:
                                                        () =>
                                                            showWithdrawHistoryDialog(
                                                              withdraw,
                                                            ),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 14,
                                                            vertical: 14,
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
                                                        border: Border.all(
                                                          color:
                                                              themeController
                                                                      .isDarkMode
                                                                      .value
                                                                  ? AppColors
                                                                      .darkCardBorder
                                                                  : Color(
                                                                    0xFFE0E0E0,
                                                                  ).withValues(
                                                                    alpha: 0.5,
                                                                  ),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 33,
                                                                height: 33,
                                                                decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        100,
                                                                      ),
                                                                  color:
                                                                      themeController
                                                                              .isDarkMode
                                                                              .value
                                                                          ? AppColors.darkPrimary.withValues(
                                                                            alpha:
                                                                                0.10,
                                                                          )
                                                                          : AppColors.primary.withValues(
                                                                            alpha:
                                                                                0.10,
                                                                          ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                        7.5,
                                                                      ),
                                                                  child: Image.asset(
                                                                    TransactionDynamicIcon.getTransactionIcon(
                                                                      withdraw
                                                                          .type,
                                                                    ),
                                                                    color:
                                                                        themeController.isDarkMode.value
                                                                            ? AppColors.darkPrimary
                                                                            : AppColors.primary,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 8,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        withdraw
                                                                            .type!,
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              13,
                                                                          color:
                                                                              themeController.isDarkMode.value
                                                                                  ? AppColors.darkTextPrimary
                                                                                  : AppColors.textPrimary,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4,
                                                                      ),
                                                                      Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              5,
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                            22,
                                                                          ),
                                                                          color:
                                                                              withdraw.status ==
                                                                                      "Success"
                                                                                  ? AppColors.success.withValues(
                                                                                    alpha:
                                                                                        0.10,
                                                                                  )
                                                                                  : withdraw.status ==
                                                                                      "Pending"
                                                                                  ? Colors.orange.withValues(
                                                                                    alpha:
                                                                                        0.10,
                                                                                  )
                                                                                  : AppColors.error.withValues(
                                                                                    alpha:
                                                                                        0.10,
                                                                                  ),
                                                                        ),
                                                                        child: Text(
                                                                          withdraw
                                                                              .status!,
                                                                          style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                9,
                                                                            color:
                                                                                withdraw.status ==
                                                                                        "Success"
                                                                                    ? AppColors.success
                                                                                    : withdraw.status ==
                                                                                        "Pending"
                                                                                    ? Colors.orange
                                                                                    : AppColors.error,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 6,
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        withdraw
                                                                            .tnx!,
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              10,
                                                                          color:
                                                                              themeController.isDarkMode.value
                                                                                  ? AppColors.darkTextTertiary
                                                                                  : AppColors.textTertiary,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            2,
                                                                      ),
                                                                      Text(
                                                                        withdraw
                                                                            .createdAt!,
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontSize:
                                                                              10,
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
                                                            ],
                                                          ),
                                                          Text(
                                                            "${withdraw.isPlus == true ? "+" : "-"}${withdraw.amount}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14,
                                                              color:
                                                                  withdraw.isPlus ==
                                                                          true
                                                                      ? AppColors
                                                                          .success
                                                                      : AppColors
                                                                          .error,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder: (
                                                  context,
                                                  index,
                                                ) {
                                                  return SizedBox(height: 10);
                                                },
                                                itemCount:
                                                    withdrawHistoryController
                                                        .withdrawHistoryModel
                                                        .value
                                                        .data!
                                                        .length,
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
                    withdrawHistoryController.isTransactionsLoading.value ||
                    withdrawHistoryController.isPageLoading.value,
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

  void showWithdrawHistoryDialog(WithdrawHistoryData withdraw) {
    Get.dialog(WithdrawHistoryDetailsPopUp(withdraw: withdraw));
  }
}
