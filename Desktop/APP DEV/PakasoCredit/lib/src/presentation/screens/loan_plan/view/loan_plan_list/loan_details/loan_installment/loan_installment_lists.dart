import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_alert_dialog.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/controller/loan_installment_list_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/model/loan_installment_list_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanInstallmentLists extends StatefulWidget {
  final String loanId;

  const LoanInstallmentLists({super.key, required this.loanId});

  @override
  State<LoanInstallmentLists> createState() => _LoanInstallmentListsState();
}

class _LoanInstallmentListsState extends State<LoanInstallmentLists> {
  final LoanInstallmentListController loanInstallmentListController = Get.put(
    LoanInstallmentListController(),
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    loanInstallmentListController.isLoading.value = true;
    await loanInstallmentListController.fetchLoanInstallmentList(
      loanId: widget.loanId,
    );
    await loanInstallmentListController.loadSiteCurrency();
    loanInstallmentListController.isLoading.value = false;
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
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  CommonAppBar(
                    title: "loanPlan.loanInstallmentList.appBarTitle".trns(),
                    isPopEnabled: true,
                    showRightSideIcon: false,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        _buildInfoCard(
                          title:
                              "loanPlan.loanInstallmentList.infoCards.totalInstallments"
                                  .trns(),
                          value: Obx(
                            () => Text(
                              "${loanInstallmentListController.loanInstallmentList.length}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          icon: Icons.receipt_long,
                          color: Colors.blue.shade50,
                          iconColor: Colors.blue.shade700,
                        ),
                        SizedBox(width: 12),
                        _buildInfoCard(
                          title:
                              "loanPlan.loanInstallmentList.infoCards.paidInstallments"
                                  .trns(),
                          value: Obx(
                            () => Text(
                              "${loanInstallmentListController.loanInstallmentList.where((i) => i.finalAmount != "0.00" && i.finalAmount != null).length}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                          icon: Icons.check_circle_outline,
                          color: Colors.green.shade50,
                          iconColor: AppColors.success,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            Obx(
              () => Visibility(
                visible:
                    loanInstallmentListController.loanInstallmentList
                        .where(
                          (i) =>
                              i.finalAmount == "0.00" || i.finalAmount == null,
                        )
                        .isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "loanPlan.loanInstallmentList.sectionTitle".trns(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      CommonElevatedButton(
                        width: 140,
                        backgroundColor: AppColors.success,
                        height: 32,
                        borderRadius: 30,
                        iconSpacing: 2,
                        fontSize: 11,
                        buttonName:
                            "loanPlan.loanInstallmentList.payAllButton.text"
                                .trns(),
                        onPressed: () {
                          Get.dialog(
                            CommonAlertDialog(
                              title:
                                  "loanPlan.loanInstallmentList.dialogs.paymentConfirmation.title"
                                      .trns(),
                              message:
                                  "loanPlan.loanInstallmentList.dialogs.paymentConfirmation.message"
                                      .trns(),
                              onConfirm: () {
                                Get.back();
                                loanInstallmentListController
                                    .submitPayInstallment(
                                      loanId: widget.loanId,
                                      isFullInstallmentPay: true,
                                    );
                              },
                              onCancel: () => Get.back(),
                            ),
                          );
                        },
                        leftIcon: Icon(
                          Icons.send_and_archive_rounded,
                          color: AppColors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh:
                        () => loanInstallmentListController
                            .fetchLoanInstallmentList(loanId: widget.loanId),
                    child: Obx(() {
                      if (loanInstallmentListController.isLoading.value) {
                        return const CommonLoading();
                      }

                      if (loanInstallmentListController
                          .loanInstallmentList
                          .isEmpty) {
                        return SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: CommonNoDataFound(
                              message:
                                  "loanPlan.loanInstallmentList.noData.message"
                                      .trns(),
                              showTryAgainButton: true,
                              onTryAgain:
                                  () => loanInstallmentListController
                                      .fetchLoanInstallmentList(
                                        loanId: widget.loanId,
                                      ),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) {
                          final LoanInstallmentListData installment =
                              loanInstallmentListController
                                  .loanInstallmentList[index];

                          final bool isPaid =
                              installment.finalAmount != "0.00" &&
                              installment.finalAmount != null;

                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withValues(
                                    alpha: 0.04,
                                  ),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color:
                                    isPaid
                                        ? AppColors.success.withValues(
                                          alpha: 0.3,
                                        )
                                        : Colors.black.withValues(alpha: 0.05),
                                width: isPaid ? 1 : 0.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    _showInstallmentDetails(
                                      context,
                                      installment,
                                      index,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        isPaid
                                                            ? AppColors.success
                                                                .withValues(
                                                                  alpha: 0.1,
                                                                )
                                                            : AppColors.black
                                                                .withValues(
                                                                  alpha: 0.05,
                                                                ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child:
                                                        isPaid
                                                            ? Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  AppColors
                                                                      .success,
                                                              size: 24,
                                                            )
                                                            : Text(
                                                              "${index + 1}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 16,
                                                                color:
                                                                    AppColors
                                                                        .textPrimary,
                                                              ),
                                                            ),
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .calendar_month_sharp,
                                                          size: 14,
                                                          color: AppColors
                                                              .textPrimary
                                                              .withValues(
                                                                alpha: 0.6,
                                                              ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          "loanPlan.loanInstallmentList.listItems.installmentDate"
                                                              .trns(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 13,
                                                            color:
                                                                AppColors
                                                                    .textPrimary,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      installment
                                                              .installmentDate ??
                                                          "N/A",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14,
                                                        color:
                                                            AppColors
                                                                .textTertiary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        isPaid
                                                            ? AppColors.success
                                                                .withValues(
                                                                  alpha: 0.1,
                                                                )
                                                            : Colors.orange
                                                                .withValues(
                                                                  alpha: 0.1,
                                                                ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    isPaid
                                                        ? "loanPlan.loanInstallmentList.listItems.status.paid"
                                                            .trns()
                                                        : "loanPlan.loanInstallmentList.listItems.status.pending"
                                                            .trns(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      color:
                                                          isPaid
                                                              ? AppColors
                                                                  .success
                                                              : Colors.orange,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                isPaid
                                                    ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          "${installment.finalAmount ?? "N/A"} ${loanInstallmentListController.siteCurrency.value}",
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12,
                                                            color:
                                                                AppColors
                                                                    .success,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                    : CommonElevatedButton(
                                                      width: 110,
                                                      backgroundColor:
                                                          AppColors.success,
                                                      height: 28,
                                                      borderRadius: 30,
                                                      iconSpacing: 2,
                                                      fontSize: 10,
                                                      buttonName:
                                                          "loanPlan.loanInstallmentList.listItems.payButton"
                                                              .trns(),
                                                      onPressed: () {
                                                        Get.dialog(
                                                          CommonAlertDialog(
                                                            title:
                                                                "loanPlan.loanInstallmentList.dialogs.paymentConfirmation.title"
                                                                    .trns(),
                                                            message:
                                                                "loanPlan.loanInstallmentList.dialogs.paymentConfirmation.message"
                                                                    .trns(),
                                                            onConfirm: () {
                                                              Get.back();
                                                              loanInstallmentListController.submitPayInstallment(
                                                                installmentId:
                                                                    installment
                                                                        .id
                                                                        .toString(),
                                                                loanId:
                                                                    widget
                                                                        .loanId,
                                                                isFullInstallmentPay:
                                                                    false,
                                                              );
                                                            },
                                                            onCancel:
                                                                () =>
                                                                    Get.back(),
                                                          ),
                                                        );
                                                      },
                                                      leftIcon: Icon(
                                                        Icons
                                                            .send_and_archive_rounded,
                                                        color: AppColors.white,
                                                        size: 14,
                                                      ),
                                                    ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (isPaid) Divider(height: 24),
                                        if (isPaid)
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.date_range,
                                                size: 14,
                                                color: AppColors.textPrimary,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "loanPlan.loanInstallmentList.listItems.paymentDate"
                                                    .trns(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  installment.givenDate ??
                                                      "N/A",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color:
                                                        AppColors.textTertiary,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 12,
                                                color: AppColors.textTertiary,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount:
                            loanInstallmentListController
                                .loanInstallmentList
                                .length,
                      );
                    }),
                  ),
                  Obx(
                    () => Visibility(
                      visible:
                          loanInstallmentListController
                              .isSubmitInstallmentLoading
                              .value,
                      child: CommonLoading(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required Widget value,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(icon, color: iconColor, size: 20)),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary.withValues(alpha: 0.5),
                    ),
                  ),
                  SizedBox(height: 4),
                  value,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInstallmentDetails(
    BuildContext context,
    LoanInstallmentListData installment,
    int index,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bool isPaid =
            installment.finalAmount != "0.00" &&
            installment.finalAmount != null;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color:
                          isPaid
                              ? AppColors.success.withValues(alpha: 0.1)
                              : Colors.orange.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child:
                          isPaid
                              ? Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                                size: 32,
                              )
                              : Icon(
                                Icons.hourglass_empty,
                                color: Colors.orange,
                                size: 32,
                              ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "${"loanPlan.loanInstallmentList.detailsSheet.installmentText".trns()} #${index + 1} ${"loanPlan.loanInstallmentList.detailsSheet.detailsText".trns()}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                isPaid
                    ? "loanPlan.loanInstallmentList.detailsSheet.status.paid"
                        .trns()
                    : "loanPlan.loanInstallmentList.detailsSheet.status.pending"
                        .trns(),
                style: TextStyle(
                  fontSize: 14,
                  color: isPaid ? AppColors.success : Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 24),

              _buildDetailRow(
                title:
                    "loanPlan.loanInstallmentList.detailsSheet.rows.installmentDate"
                        .trns(),
                value: installment.installmentDate ?? "N/A",
                icon: Icons.calendar_today,
              ),
              Divider(height: 24),

              _buildDetailRow(
                title:
                    "loanPlan.loanInstallmentList.detailsSheet.rows.paymentStatus"
                        .trns(),
                value:
                    isPaid
                        ? "loanPlan.loanInstallmentList.listItems.status.paid"
                            .trns()
                        : "loanPlan.loanInstallmentList.listItems.status.yetToPay"
                            .trns(),
                icon: Icons.payments_outlined,
              ),
              Divider(height: 24),

              _buildDetailRow(
                title:
                    "loanPlan.loanInstallmentList.detailsSheet.rows.amount"
                        .trns(),
                value:
                    isPaid
                        ? "${installment.finalAmount} ${loanInstallmentListController.siteCurrency.value}"
                        : "loanPlan.loanInstallmentList.listItems.status.pending"
                            .trns(),
                icon: Icons.attach_money,
              ),

              if (isPaid) ...[
                Divider(height: 24),
                _buildDetailRow(
                  title:
                      "loanPlan.loanInstallmentList.detailsSheet.rows.givenDate"
                          .trns(),
                  value: installment.givenDate ?? "N/A",
                  icon: Icons.date_range,
                ),
              ],
              Divider(height: 24),
              _buildDetailRow(
                title:
                    "loanPlan.loanInstallmentList.detailsSheet.rows.defermentDays"
                        .trns(),
                value: installment.deferment ?? "0",
                icon: Icons.timer_outlined,
              ),
              Divider(height: 24),
              _buildDetailRow(
                title:
                    "loanPlan.loanInstallmentList.detailsSheet.rows.charge"
                        .trns(),
                value:
                    "${installment.charge ?? "0.00"} ${loanInstallmentListController.siteCurrency.value}",
                icon: Icons.account_balance_wallet,
              ),

              SizedBox(height: 32),
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textPrimary,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "loanPlan.loanInstallmentList.detailsSheet.closeButton"
                          .trns(),
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textTertiary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
