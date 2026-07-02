import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/controller/fdr_installment_list_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/model/fdr_installment_list_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FdrInstallmentList extends StatefulWidget {
  final String fdrId;

  const FdrInstallmentList({super.key, required this.fdrId});

  @override
  State<FdrInstallmentList> createState() => _FdrInstallmentListState();
}

class _FdrInstallmentListState extends State<FdrInstallmentList> {
  final ThemeController themeController = Get.find<ThemeController>();
  final FdrInstallmentListController fdrInstallmentListController = Get.put(
    FdrInstallmentListController(),
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    fdrInstallmentListController.isLoading.value = true;
    await fdrInstallmentListController.fetchFdrInstallmentList(
      fdrId: widget.fdrId,
    );
    fdrInstallmentListController.isLoading.value = false;
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
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkSecondary
                        : AppColors.white,
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
                    title: "fdrPlan.fdrPlanList.fdrInstallment.title".trns(),
                    isPopEnabled: true,
                    showRightSideIcon: false,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Row(
                      children: [
                        _buildInfoCard(
                          title:
                              "fdrPlan.fdrPlanList.fdrInstallment.summary.totalInstallments"
                                  .trns(),
                          value: Obx(
                            () => Text(
                              "${fdrInstallmentListController.fdrInstallmentList.length}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    themeController.isDarkMode.value
                                        ? AppColors.darkTextPrimary
                                        : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          icon: Icons.receipt_long,
                          color:
                              themeController.isDarkMode.value
                                  ? Color(0xFF1C2E24)
                                  : Colors.blue.shade50,
                          iconColor: Colors.blue.shade700,
                        ),
                        SizedBox(width: 12),
                        _buildInfoCard(
                          title:
                              "fdrPlan.fdrPlanList.fdrInstallment.summary.paidInstallments"
                                  .trns(),
                          value: Obx(
                            () => Text(
                              "${fdrInstallmentListController.fdrInstallmentList.where((i) => i.paidAmount != "N/A" && i.paidAmount != null).length}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                          icon: Icons.check_circle_outline,
                          color:
                              themeController.isDarkMode.value
                                  ? Color(0xFF1C2E24)
                                  : Colors.green.shade50,
                          iconColor: AppColors.success,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkPrimary
                        : AppColors.primary,
                onRefresh:
                    () => fdrInstallmentListController.fetchFdrInstallmentList(
                      fdrId: widget.fdrId,
                    ),
                child: Obx(() {
                  if (fdrInstallmentListController.isLoading.value) {
                    return const CommonLoading();
                  }

                  if (fdrInstallmentListController.fdrInstallmentList.isEmpty) {
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: CommonNoDataFound(
                          message:
                              "fdrPlan.fdrPlanList.fdrInstallment.noDataMessage"
                                  .trns(),
                          showTryAgainButton: true,
                          onTryAgain:
                              () => fdrInstallmentListController
                                  .fetchFdrInstallmentList(fdrId: widget.fdrId),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemBuilder: (context, index) {
                      final FdrInstallmentListData installment =
                          fdrInstallmentListController
                              .fdrInstallmentList[index];

                      final bool isPaid =
                          installment.paidAmount != "N/A" &&
                          installment.paidAmount != null;

                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color:
                              themeController.isDarkMode.value
                                  ? AppColors.darkSecondary
                                  : AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color:
                                isPaid
                                    ? AppColors.success.withValues(alpha: 0.3)
                                    : themeController.isDarkMode.value
                                    ? AppColors.darkCardBorder
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
                                                        : themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors.white
                                                            .withValues(
                                                              alpha: 0.05,
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
                                                          Icons.check_circle,
                                                          color:
                                                              AppColors.success,
                                                          size: 24,
                                                        )
                                                        : Text(
                                                          "${index + 1}",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 16,
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
                                            ),
                                            SizedBox(width: 16),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.money_outlined,
                                                      size: 14,
                                                      color:
                                                          themeController
                                                                  .isDarkMode
                                                                  .value
                                                              ? AppColors
                                                                  .darkTextPrimary
                                                                  .withValues(
                                                                    alpha: 0.6,
                                                                  )
                                                              : AppColors
                                                                  .textPrimary
                                                                  .withValues(
                                                                    alpha: 0.6,
                                                                  ),
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      "${"fdrPlan.fdrPlanList.fdrInstallment.details.fields.interest".trns()}:",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
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
                                                SizedBox(height: 4),
                                                Text(
                                                  installment.interestAmount ??
                                                      "N/A",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color:
                                                        themeController
                                                                .isDarkMode
                                                                .value
                                                            ? AppColors.success
                                                            : AppColors.success
                                                                .withValues(
                                                                  alpha: 0.5,
                                                                ),
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
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                isPaid
                                                    ? "fdrPlan.fdrPlanList.fdrInstallment.status.paid"
                                                        .trns()
                                                    : "fdrPlan.fdrPlanList.fdrInstallment.status.pending"
                                                        .trns(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                      isPaid
                                                          ? AppColors.success
                                                          : Colors.orange,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              installment.returnDate ?? "N/A",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors
                                                            .darkTextTertiary
                                                        : AppColors
                                                            .textTertiary,
                                              ),
                                            ),
                                          ],
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
                        fdrInstallmentListController.fdrInstallmentList.length,
                  );
                }),
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
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkPrimary.withValues(alpha: 0.1)
                        : AppColors.white,
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
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.darkTextPrimary.withValues(alpha: 0.5)
                              : AppColors.textPrimary.withValues(alpha: 0.5),
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
    FdrInstallmentListData installment,
    int index,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bool isPaid =
            installment.paidAmount != "N/A" && installment.paidAmount != null;

        return Container(
          decoration: BoxDecoration(
            color:
                themeController.isDarkMode.value
                    ? AppColors.darkSecondary
                    : AppColors.white,
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
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkCardBorder
                          : Colors.grey.shade300,
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
                "${"fdrPlan.fdrPlanList.fdrInstallment.details.installmentText".trns()} #${index + 1} ${"fdrPlan.fdrPlanList.fdrInstallment.details.detailsText".trns()}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                isPaid
                    ? "fdrPlan.fdrPlanList.fdrInstallment.details.paymentComplete"
                        .trns()
                    : "fdrPlan.fdrPlanList.fdrInstallment.details.paymentPending"
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
                    "fdrPlan.fdrPlanList.fdrInstallment.details.fields.returnDate"
                        .trns(),
                value: installment.returnDate ?? "N/A",
                icon: Icons.calendar_today,
              ),
              Divider(
                height: 24,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkCardBorder
                        : AppColors.black.withValues(alpha: 0.05),
              ),

              _buildDetailRow(
                title:
                    "fdrPlan.fdrPlanList.fdrInstallment.details.fields.interest"
                        .trns(),
                value: installment.interestAmount ?? "N/A",
                icon: Icons.money_outlined,
              ),
              Divider(
                height: 24,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkCardBorder
                        : AppColors.black.withValues(alpha: 0.05),
              ),

              _buildDetailRow(
                title:
                    "fdrPlan.fdrPlanList.fdrInstallment.details.fields.paidAmount"
                        .trns(),
                value:
                    installment.paidAmount == "N/A"
                        ? "fdrPlan.fdrPlanList.fdrInstallment.details.fields.none"
                            .trns()
                        : installment.paidAmount ?? "N/A",
                icon: Icons.attach_money,
              ),

              if (isPaid) ...[
                Divider(
                  height: 24,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkCardBorder
                          : AppColors.black.withValues(alpha: 0.05),
                ),
                _buildDetailRow(
                  title:
                      "fdrPlan.fdrPlanList.fdrInstallment.details.fields.paymentDate"
                          .trns(),
                  value: installment.returnDate ?? "N/A",
                  icon: Icons.date_range,
                ),
              ],
              SizedBox(height: 32),
              SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          themeController.isDarkMode.value
                              ? AppColors.darkPrimary
                              : AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "fdrPlan.fdrPlanList.fdrInstallment.details.close".trns(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.black
                                : AppColors.white,
                      ),
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
            color:
                themeController.isDarkMode.value
                    ? Color(0xFF1C2E24)
                    : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color:
                  themeController.isDarkMode.value
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
              size: 20,
            ),
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color:
                      themeController.isDarkMode.value
                          ? AppColors.darkTextTertiary
                          : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
