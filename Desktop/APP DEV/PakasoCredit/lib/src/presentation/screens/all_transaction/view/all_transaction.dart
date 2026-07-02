import 'dart:async';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/all_transaction/controller/transaction_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/all_transaction/model/transactions_model.dart';
import 'package:pakaso_credit/src/presentation/screens/all_transaction/view/sub_sections/all_transaction_dialog.dart';
import 'package:pakaso_credit/src/presentation/screens/all_transaction/view/sub_sections/transaction_filter_pop_up.dart';
import 'package:pakaso_credit/src/presentation/widgets/transaction_dynamic_icon/transaction_dynamic_icon.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTransaction extends StatefulWidget {
  const AllTransaction({super.key});

  @override
  State<AllTransaction> createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction>
    with WidgetsBindingObserver {
  final ThemeController themeController = Get.find<ThemeController>();
  late TransactionController transactionController;
  late ScrollController _scrollController;

  Timer? _debounce;
  final Duration debounceDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    transactionController = Get.put(TransactionController());
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    loadData();
    transactionController.transactionTypeController.text = "All Type";
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_scrollListener);
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> refreshData() async {
    transactionController.isLoading.value = true;
    await transactionController.fetchTransactionType();
    await transactionController.fetchTransactions();
    transactionController.isLoading.value = false;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        transactionController.hasMorePages.value &&
        !transactionController.isPageLoading.value) {
      transactionController.loadMoreTransactions();
    }
  }

  Future<void> loadData() async {
    if (!transactionController.isInitialDataLoaded.value) {
      transactionController.isLoading.value = true;
      await transactionController.fetchTransactionType();
      await transactionController.fetchTransactions();
      transactionController.isLoading.value = false;
      transactionController.isInitialDataLoaded.value = true;
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(debounceDuration, () {
      transactionController.fetchDynamicTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        transactionController.resetFields();
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
                    showRightSideIcon: true,
                    title: "transactions.title".trns(),
                    isPopEnabled: false,
                    isUtilsBackLogic: true,
                    backLogicFunction: () {
                      transactionController.resetFields();
                      Get.find<NavigationController>().popPage();
                    },
                    rightSideIcon: PngAssets.commonFileDownloadIcon,
                    onPressed: () {
                      transactionController.transactionDownloadCsvFile();
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
                          transactionController.isLoading.value
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
                                                transactionController
                                                    .transactionIdController,
                                            hintText:
                                                "transactions.transactionId"
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
                                                TransactionFilterPopUp(),
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
                                  transactionController
                                          .transactionsModel
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
                                                  "transactions.noDataFound"
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
                                                  final TransactionsData
                                                  transaction =
                                                      transactionController
                                                          .transactionsModel
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
                                                    transactionController
                                                        .transactionsModel
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
                    transactionController.isTransactionsLoading.value ||
                    transactionController.isPageLoading.value ||
                    transactionController.isTransactionDownload.value,
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

  void showTransactionDialog(TransactionsData transaction) {
    Get.dialog(AllTransactionDialog(controller: transaction));
  }
}
