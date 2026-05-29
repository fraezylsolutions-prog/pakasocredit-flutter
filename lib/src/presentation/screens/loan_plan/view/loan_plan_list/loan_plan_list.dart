import 'dart:async';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_alert_dialog.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/controller/loan_plan_list_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/model/loan_plan_list_model.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/view/loan_plan_list/loan_details/loan_details.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/view/loan_plan_list/sub_sections/loan_plan_list_filter_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanPlanList extends StatefulWidget {
  const LoanPlanList({super.key});

  @override
  State<LoanPlanList> createState() => _LoanPlanListState();
}

class _LoanPlanListState extends State<LoanPlanList>
    with WidgetsBindingObserver {
  final ThemeController themeController = Get.find<ThemeController>();
  late LoanPlanListController loanPlanListController;
  late ScrollController _scrollController;

  Timer? _debounce;
  final Duration debounceDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loanPlanListController = Get.put(LoanPlanListController());
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
    loanPlanListController.isLoading.value = true;
    await loanPlanListController.fetchLoanPlanLists();
    loanPlanListController.isLoading.value = false;
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        loanPlanListController.hasMorePages.value &&
        !loanPlanListController.isPageLoading.value) {
      loanPlanListController.loadMoreLoanPlanLists();
    }
  }

  Future<void> loadData() async {
    if (!loanPlanListController.isInitialDataLoaded.value) {
      loanPlanListController.isLoading.value = true;
      await loanPlanListController.fetchLoanPlanLists();
      loanPlanListController.isLoading.value = false;
      loanPlanListController.isInitialDataLoaded.value = true;
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(debounceDuration, () {
      loanPlanListController.fetchDynamicLoanPlanLists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        loanPlanListController.resetFields();
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
                    title: "loanPlan.loanPlanList.title".trns(),
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
                          loanPlanListController.isLoading.value
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
                                                loanPlanListController
                                                    .loanIdController,
                                            hintText:
                                                "loanPlan.loanPlanList.form.loanId"
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
                                                LoanPlanListFilterPopUp(),
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
                                  loanPlanListController
                                          .loanPlanListModel
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
                                                  "loanPlan.loanPlanList.noDataMessage"
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
                                                  final LoanPlanListData loan =
                                                      loanPlanListController
                                                          .loanPlanListModel
                                                          .value
                                                          .data![index];

                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 22,
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
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      loan.planName ??
                                                                          "N/A",
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color:
                                                                            themeController.isDarkMode.value
                                                                                ? AppColors.darkTextPrimary
                                                                                : AppColors.textPrimary,
                                                                        fontSize:
                                                                            13,
                                                                      ),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          4,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          loan.status ==
                                                                                  "running"
                                                                              ? themeController.isDarkMode.value
                                                                                  ? AppColors.success.withValues(
                                                                                    alpha:
                                                                                        0.1,
                                                                                  )
                                                                                  : AppColors.primary.withValues(
                                                                                    alpha:
                                                                                        0.1,
                                                                                  )
                                                                              : loan.status ==
                                                                                  "due"
                                                                              ? AppColors.warning.withValues(
                                                                                alpha:
                                                                                    0.1,
                                                                              )
                                                                              : loan.status ==
                                                                                      "cancelled" ||
                                                                                  loan.status ==
                                                                                      "rejected"
                                                                              ? AppColors.error.withValues(
                                                                                alpha:
                                                                                    0.1,
                                                                              )
                                                                              : loan.status ==
                                                                                  "completed"
                                                                              ? AppColors.success.withValues(
                                                                                alpha:
                                                                                    0.1,
                                                                              )
                                                                              : loan.status ==
                                                                                  "reviewing"
                                                                              ? AppColors.warning.withValues(
                                                                                alpha:
                                                                                    0.1,
                                                                              )
                                                                              : null,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            30,
                                                                          ),
                                                                    ),
                                                                    child: Text(
                                                                      loan.status ==
                                                                              "running"
                                                                          ? "loanPlan.loanPlanList.status.running"
                                                                              .trns()
                                                                          : loan.status ==
                                                                              "due"
                                                                          ? "loanPlan.loanPlanList.status.due"
                                                                              .trns()
                                                                          : loan.status ==
                                                                              "cancelled"
                                                                          ? "loanPlan.loanPlanList.status.cancelled"
                                                                              .trns()
                                                                          : loan.status ==
                                                                              "completed"
                                                                          ? "loanPlan.loanPlanList.status.completed"
                                                                              .trns()
                                                                          : loan.status ==
                                                                              "reviewing"
                                                                          ? "loanPlan.loanPlanList.status.reviewing"
                                                                              .trns()
                                                                          : loan.status ==
                                                                              "rejected"
                                                                          ? "loanPlan.loanPlanList.status.rejected"
                                                                              .trns()
                                                                          : "N/A",
                                                                      style: TextStyle(
                                                                        color:
                                                                            loan.status ==
                                                                                    "running"
                                                                                ? themeController.isDarkMode.value
                                                                                    ? AppColors.success
                                                                                    : AppColors.primary
                                                                                : loan.status ==
                                                                                    "due"
                                                                                ? AppColors.warning
                                                                                : loan.status ==
                                                                                        "cancelled" ||
                                                                                    loan.status ==
                                                                                        "rejected"
                                                                                ? AppColors.error
                                                                                : loan.status ==
                                                                                    "completed"
                                                                                ? AppColors.success
                                                                                : loan.status ==
                                                                                    "reviewing"
                                                                                ? AppColors.warning
                                                                                : null,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            10,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      loan.loanId ??
                                                                          "N/A",
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
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  CircleAvatar(
                                                                    radius: 2.5,
                                                                    backgroundColor:
                                                                        themeController.isDarkMode.value
                                                                            ? AppColors.darkTextTertiary
                                                                            : AppColors.textTertiary,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4,
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                      loan.createdAt ??
                                                                          "N/A",
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
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 20,
                                                              ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Get.find<
                                                                        NavigationController
                                                                      >()
                                                                      .pushPage(
                                                                        LoanDetails(
                                                                          loanId:
                                                                              loan.loanId.toString(),
                                                                        ),
                                                                      );
                                                                },
                                                                child: Container(
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                        6,
                                                                      ),
                                                                  width: 28,
                                                                  height: 28,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          6,
                                                                        ),
                                                                    color: AppColors
                                                                        .success
                                                                        .withValues(
                                                                          alpha:
                                                                              0.10,
                                                                        ),
                                                                  ),
                                                                  child: Image.asset(
                                                                    PngAssets
                                                                        .commonEyeIcon,
                                                                    color:
                                                                        AppColors
                                                                            .success,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                    loan.isCancellable ==
                                                                    true,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    Get.dialog(
                                                                      CommonAlertDialog(
                                                                        title:
                                                                            "loanPlan.loanPlanList.cancelLoan.title".trns(),
                                                                        message:
                                                                            "loanPlan.loanPlanList.cancelLoan.message".trns(),
                                                                        onConfirm: () {
                                                                          Get.back();
                                                                          loanPlanListController.deleteLoan(
                                                                            loanId:
                                                                                loan.loanId.toString(),
                                                                          );
                                                                        },
                                                                        onCancel:
                                                                            () {
                                                                              Get.back();
                                                                            },
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                          6,
                                                                        ),
                                                                    width: 28,
                                                                    height: 28,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            6,
                                                                          ),
                                                                      color: AppColors
                                                                          .error
                                                                          .withValues(
                                                                            alpha:
                                                                                0.10,
                                                                          ),
                                                                    ),
                                                                    child: Image.asset(
                                                                      PngAssets
                                                                          .commonCancelIcon,
                                                                      color:
                                                                          AppColors
                                                                              .error,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
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
                                                    loanPlanListController
                                                        .loanPlanListModel
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
                    loanPlanListController.isTransactionsLoading.value ||
                    loanPlanListController.isPageLoading.value,
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
}
