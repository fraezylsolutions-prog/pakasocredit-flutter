import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/bill_payment_history_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/model/bill_payment_history_model.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/bill_payment_history/sub_sections/all_pay_bill_history_dialog.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillPaymentHistory extends StatefulWidget {
  const BillPaymentHistory({super.key});

  @override
  State<BillPaymentHistory> createState() => _BillPaymentHistoryState();
}

class _BillPaymentHistoryState extends State<BillPaymentHistory>
    with WidgetsBindingObserver {
  final ThemeController themeController = Get.find<ThemeController>();
  late BillPaymentHistoryController billPaymentHistoryController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    billPaymentHistoryController = Get.put(BillPaymentHistoryController());
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    billPaymentHistoryController.isLoading.value = true;
    await billPaymentHistoryController.fetchBillPaymentHistories();
    billPaymentHistoryController.isLoading.value = false;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        billPaymentHistoryController.hasMorePages.value &&
        !billPaymentHistoryController.isPageLoading.value) {
      billPaymentHistoryController.loadMoreBillPaymentHistories();
    }
  }

  Future<void> loadData() async {
    billPaymentHistoryController.isLoading.value = true;
    await billPaymentHistoryController.loadSiteCurrency();
    await billPaymentHistoryController.fetchBillPaymentHistories();
    billPaymentHistoryController.isLoading.value = false;
    billPaymentHistoryController.isInitialDataLoaded.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        billPaymentHistoryController.resetFields();
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Obx(
          () => Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),
                  CommonAppBar(
                    showRightSideIcon: false,
                    title: "payBill.billPaymentHistory.title".trns(),
                    isPopEnabled: false,
                    isUtilsBackLogic: true,
                    backLogicFunction: () {
                      billPaymentHistoryController.resetFields();
                      Get.find<NavigationController>().popPage();
                    },
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: RefreshIndicator(
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                      onRefresh: () => refreshData(),
                      child:
                          billPaymentHistoryController.isLoading.value
                              ? const CommonLoading()
                              : Column(
                                children: [
                                  if (billPaymentHistoryController
                                      .billPaymentHistoryModel
                                      .value
                                      .data!
                                      .isEmpty)
                                    Expanded(
                                      child: SingleChildScrollView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        child: SizedBox(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.5,
                                          child: CommonNoDataFound(
                                            message:
                                                "payBill.billPaymentHistory.noDataFound"
                                                    .trns(),
                                            showTryAgainButton: true,
                                            onTryAgain: () => refreshData(),
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    Expanded(
                                      child: SingleChildScrollView(
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        child: Column(
                                          children: [
                                            ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              controller: _scrollController,
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                bottom: 20,
                                              ),
                                              itemBuilder: (context, index) {
                                                final BillPaymentHistoryData
                                                transaction =
                                                    billPaymentHistoryController
                                                        .billPaymentHistoryModel
                                                        .value
                                                        .data![index];

                                                return GestureDetector(
                                                  onTap:
                                                      () =>
                                                          showTransactionDialog(
                                                            transaction,
                                                          ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 23,
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
                                                              : AppColors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: AppColors.black
                                                              .withAlpha(25),
                                                          blurRadius: 2,
                                                          offset: const Offset(
                                                            0,
                                                            3,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  transaction
                                                                      .serviceName!,
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
                                                                  width: 4,
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            5,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          22,
                                                                        ),
                                                                    color: AppColors
                                                                        .success
                                                                        .withValues(
                                                                          alpha:
                                                                              0.1,
                                                                        ),
                                                                  ),
                                                                  child: Text(
                                                                    transaction
                                                                        .status!,
                                                                    style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          9,
                                                                      color:
                                                                          AppColors
                                                                              .success,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                            Text(
                                                              transaction
                                                                  .createdAt!,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 10,
                                                                color:
                                                                    themeController
                                                                            .isDarkMode
                                                                            .value
                                                                        ? AppColors.darkTextPrimary.withValues(
                                                                          alpha:
                                                                              0.60,
                                                                        )
                                                                        : AppColors.textPrimary.withValues(
                                                                          alpha:
                                                                              0.60,
                                                                        ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              "${transaction.amount} ${billPaymentHistoryController.siteCurrency.value}",
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14,
                                                                color:
                                                                    AppColors
                                                                        .success,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                            Text(
                                                              "${"payBill.billPaymentHistory.transactionItem.charge".trns()}: ${transaction.charge!}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 10,
                                                                color:
                                                                    themeController
                                                                            .isDarkMode
                                                                            .value
                                                                        ? AppColors.darkTextPrimary.withValues(
                                                                          alpha:
                                                                              0.60,
                                                                        )
                                                                        : AppColors.textPrimary.withValues(
                                                                          alpha:
                                                                              0.60,
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
                                              separatorBuilder: (
                                                context,
                                                index,
                                              ) {
                                                return const SizedBox(
                                                  height: 10,
                                                );
                                              },
                                              itemCount:
                                                  billPaymentHistoryController
                                                      .billPaymentHistoryModel
                                                      .value
                                                      .data!
                                                      .length,
                                            ),
                                          ],
                                        ),
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
                    billPaymentHistoryController.isTransactionsLoading.value ||
                    billPaymentHistoryController.isPageLoading.value,
                child: Container(
                  color: AppColors.textPrimary.withValues(alpha: 0.3),
                  child: const CommonLoading(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showTransactionDialog(BillPaymentHistoryData billPaymentHistoryData) {
    Get.dialog(
      AllPayBillHistoryDialog(billPaymentHistoryData: billPaymentHistoryData),
    );
  }
}
