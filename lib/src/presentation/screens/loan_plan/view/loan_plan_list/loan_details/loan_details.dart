import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/controller/loan_details_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/view/loan_plan_list/loan_details/loan_installment/loan_installment_lists.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanDetails extends StatefulWidget {
  final String loanId;

  const LoanDetails({super.key, required this.loanId});

  @override
  State<LoanDetails> createState() => _LoanDetailsState();
}

class _LoanDetailsState extends State<LoanDetails> {
  final ThemeController themeController = Get.find<ThemeController>();
  final LoanDetailsController loanDetailsController = Get.put(
    LoanDetailsController(),
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    loanDetailsController.isLoading.value = true;
    await loanDetailsController.fetchLoanDetails(loanId: widget.loanId);
    loanDetailsController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 16),
            Obx(() {
              final status =
                  loanDetailsController.loanDetailsModel.value.data?.status;
              final isRunning = status == "running";

              return CommonAppBar(
                title: "loanPlan.loanPlanList.loanDetails.title".trns(),
                isPopEnabled: false,
                showRightSideIcon: isRunning,
                rightSideIcon: PngAssets.commonClockIcon,
                onPressed:
                    isRunning
                        ? () {
                          Get.find<NavigationController>().pushPage(
                            LoanInstallmentLists(loanId: widget.loanId),
                          );
                        }
                        : null,
              );
            }),
            SizedBox(height: 30),
            Expanded(
              child: Obx(() {
                final loanData =
                    loanDetailsController.loanDetailsModel.value.data;

                if (loanDetailsController.isLoading.value) {
                  return const CommonLoading();
                }
                if (loanData == null) {
                  return CommonNoDataFound(
                    message:
                        "loanPlan.loanPlanList.loanDetails.noDataMessage"
                            .trns(),
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:
                                themeController.isDarkMode.value
                                    ? AppColors.darkSecondary
                                    : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  themeController.isDarkMode.value
                                      ? AppColors.darkCardBorder
                                      : Color(0xFFE6E6E6),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildDetailsValueSection(
                                title:
                                    "loanPlan.loanPlanList.loanDetails.fields.planName"
                                        .trns(),
                                value: loanData.planName ?? "N/A",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "loanPlan.loanPlanList.loanDetails.fields.loanId"
                                        .trns(),
                                value: loanData.loanId ?? "N/A",
                                valueColor: AppColors.error,
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "loanPlan.loanPlanList.loanDetails.fields.status"
                                        .trns(),
                                value:
                                    loanData.status == "running"
                                        ? "loanPlan.loanPlanList.loanDetails.status.running"
                                            .trns()
                                        : loanData.status == "due"
                                        ? "loanPlan.loanPlanList.loanDetails.status.due"
                                            .trns()
                                        : loanData.status == "cancelled"
                                        ? "loanPlan.loanPlanList.loanDetails.status.cancelled"
                                            .trns()
                                        : loanData.status == "completed"
                                        ? "loanPlan.loanPlanList.loanDetails.status.completed"
                                            .trns()
                                        : loanData.status == "reviewing"
                                        ? "loanPlan.loanPlanList.loanDetails.status.reviewing"
                                            .trns()
                                        : loanData.status == "rejected"
                                        ? "loanPlan.loanPlanList.loanDetails.status.rejected"
                                            .trns()
                                        : "N/A",
                                valueColor:
                                    loanData.status == "running"
                                        ? AppColors.primary
                                        : loanData.status == "due"
                                        ? AppColors.warning
                                        : loanData.status == "cancelled" ||
                                            loanData.status == "rejected"
                                        ? AppColors.error
                                        : loanData.status == "completed"
                                        ? AppColors.success
                                        : loanData.status == "reviewing"
                                        ? AppColors.warning
                                        : null,
                                isValueRadius: true,
                                radiusColor:
                                    loanData.status == "running"
                                        ? AppColors.primary.withValues(
                                          alpha: 0.1,
                                        )
                                        : loanData.status == "due"
                                        ? AppColors.warning.withValues(
                                          alpha: 0.1,
                                        )
                                        : loanData.status == "cancelled" ||
                                            loanData.status == "rejected"
                                        ? AppColors.error.withValues(alpha: 0.1)
                                        : loanData.status == "completed"
                                        ? AppColors.success.withValues(
                                          alpha: 0.1,
                                        )
                                        : loanData.status == "reviewing"
                                        ? AppColors.warning.withValues(
                                          alpha: 0.1,
                                        )
                                        : null,
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "loanPlan.loanPlanList.loanDetails.fields.amount"
                                        .trns(),
                                value: loanData.amount ?? "N/A",
                                valueColor: AppColors.error,
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "loanPlan.loanPlanList.loanDetails.fields.perInstallment"
                                        .trns(),
                                value:
                                    "${loanData.perInstallment ?? "N/A"} (${"loanPlan.loanPlanList.loanDetails.fields.everyText".trns()} ${loanData.installmentInterval ?? "N/A"})",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "loanPlan.loanPlanList.loanDetails.fields.numberOfInstallments"
                                        .trns(),
                                value: loanData.totalInstallment ?? "N/A",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "loanPlan.loanPlanList.loanDetails.fields.givenInstallments"
                                        .trns(),
                                value:
                                    loanData.givenInstallment?.toString() ??
                                    "0",
                                isValueRadius: true,
                                radiusColor:
                                    themeController.isDarkMode.value
                                        ? AppColors.darkPrimary.withValues(
                                          alpha: 0.1,
                                        )
                                        : AppColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "loanPlan.loanPlanList.loanDetails.fields.nextInstallment"
                                        .trns(),
                                value: loanData.nextInstallment ?? "N/A",
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "loanPlan.loanPlanList.loanDetails.fields.defermentCharge"
                                        .trns(),
                                value:
                                    "${loanData.defermentCharge ?? "N/A"} / ${loanData.defermentDays ?? 0}",
                                valueColor: AppColors.error,
                              ),
                              _buildDividerSection(),
                              _buildDetailsValueSection(
                                title:
                                    "loanPlan.loanPlanList.loanDetails.fields.totalPayableAmount"
                                        .trns(),
                                value: loanData.totalPayableAmount ?? "N/A",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDividerSection() {
    return Column(
      children: [
        SizedBox(height: 16),
        Divider(
          height: 0,
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkCardBorder
                  : Color(0xFF030306).withValues(alpha: 0.06),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDetailsValueSection({
    required String title,
    required String value,
    Color? valueColor,
    bool? isValueRadius,
    Color? radiusColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title:",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
          ),
        ),
        Container(
          padding:
              isValueRadius == true
                  ? EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                  : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isValueRadius == true ? 30 : 0),
            color: isValueRadius == true ? radiusColor : null,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color:
                  valueColor ??
                  (themeController.isDarkMode.value
                      ? AppColors.darkPrimary
                      : AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
