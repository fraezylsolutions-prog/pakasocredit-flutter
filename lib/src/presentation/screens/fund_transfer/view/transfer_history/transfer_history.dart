import 'dart:async';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/transfer_history_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/model/transfer_history_model.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/transfer_history/sub_sections/all_transfer_history_dialog.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/transfer_history/sub_sections/transfer_history_filter_pop_up.dart';
import 'package:pakaso_credit/src/presentation/widgets/transaction_dynamic_icon/transaction_dynamic_icon.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferHistory extends StatefulWidget {
  const TransferHistory({super.key});

  @override
  State<TransferHistory> createState() => _TransferHistoryState();
}

class _TransferHistoryState extends State<TransferHistory>
    with WidgetsBindingObserver {
  final ThemeController themeController = Get.find<ThemeController>();
  late TransferHistoryController transferHistoryController;
  late ScrollController _scrollController;

  Timer? _debounce;
  final Duration debounceDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    transferHistoryController = Get.put(TransferHistoryController());
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
    transferHistoryController.isLoading.value = true;
    await transferHistoryController.fetchTransferHistories();
    transferHistoryController.isLoading.value = false;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        transferHistoryController.hasMorePages.value &&
        !transferHistoryController.isPageLoading.value) {
      transferHistoryController.loadMoreTransferHistories();
    }
  }

  Future<void> loadData() async {
    if (!transferHistoryController.isInitialDataLoaded.value) {
      transferHistoryController.isLoading.value = true;
      await transferHistoryController.fetchTransferHistories();
      transferHistoryController.isLoading.value = false;
      transferHistoryController.isInitialDataLoaded.value = true;
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(debounceDuration, () {
      transferHistoryController.fetchDynamicTransferHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        transferHistoryController.resetFields();
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
                    title: "fundTransfer.transferHistory.title".trns(),
                    isPopEnabled: false,
                    isUtilsBackLogic: true,
                    backLogicFunction: () {
                      transferHistoryController.resetFields();
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
                          transferHistoryController.isLoading.value
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
                                                transferHistoryController
                                                    .transactionIdController,
                                            hintText:
                                                "fundTransfer.transferHistory.search.transactionId"
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
                                                TransferHistoryFilterPopUp(),
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
                                  transferHistoryController
                                          .transferHistoryModel
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
                                                0.5,
                                            child: CommonNoDataFound(
                                              message:
                                                  "fundTransfer.transferHistory.noData"
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
                                                  final TransferHistoryData
                                                  transaction =
                                                      transferHistoryController
                                                          .transferHistoryModel
                                                          .value
                                                          .data![index];

                                                  return InkWell(
                                                    onTap: () {
                                                      showTransactionDialog(
                                                        transaction,
                                                      );
                                                    },
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
                                                          Expanded(
                                                            child: Row(
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
                                                                        themeController.isDarkMode.value
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
                                                                        transaction
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
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            transaction.type!,
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
                                                                                  transaction.status ==
                                                                                          "Success"
                                                                                      ? AppColors.success.withValues(
                                                                                        alpha:
                                                                                            0.10,
                                                                                      )
                                                                                      : transaction.status ==
                                                                                          "Pending"
                                                                                      ? AppColors.warning.withValues(
                                                                                        alpha:
                                                                                            0.10,
                                                                                      )
                                                                                      : AppColors.error.withValues(
                                                                                        alpha:
                                                                                            0.10,
                                                                                      ),
                                                                            ),
                                                                            child: Text(
                                                                              transaction.status!,
                                                                              style: TextStyle(
                                                                                fontWeight:
                                                                                    FontWeight.w600,
                                                                                fontSize:
                                                                                    9,
                                                                                color:
                                                                                    transaction.status ==
                                                                                            "Success"
                                                                                        ? AppColors.success
                                                                                        : transaction.status ==
                                                                                            "Pending"
                                                                                        ? AppColors.warning
                                                                                        : AppColors.error,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            6,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            transaction.tnx!,
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
                                                                            transaction.createdAt!,
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
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Text(
                                                            "${transaction.isPlus == true ? "+" : "-"}${transaction.amount}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 14,
                                                              color:
                                                                  transaction.isPlus ==
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
                                                    transferHistoryController
                                                        .transferHistoryModel
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
                    transferHistoryController.isTransactionsLoading.value ||
                    transferHistoryController.isPageLoading.value,
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

  void showTransactionDialog(TransferHistoryData transaction) {
    Get.dialog(AllTransferHistoryDialog(controller: transaction));
  }
}
