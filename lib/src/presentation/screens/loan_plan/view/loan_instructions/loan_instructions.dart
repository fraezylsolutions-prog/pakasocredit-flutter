import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/controller/loan_plan_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/model/loan_plan_model.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanInstructions extends StatefulWidget {
  final LoanPlanData loanPlanData;

  const LoanInstructions({super.key, required this.loanPlanData});

  @override
  State<LoanInstructions> createState() => _LoanInstructionsState();
}

class _LoanInstructionsState extends State<LoanInstructions> {
  final LoanPlanController loanPlanController = Get.find();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    calculateLoan();
  }

  void calculateLoan() {
    final double userAmount =
        double.tryParse(loanPlanController.amountController.text) ?? 0.0;
    final int totalInstallment =
        widget.loanPlanData.planData!.totalInstallment ?? 0;
    final int interestRate = widget.loanPlanData.planData!.interestRate ?? 0;

    final double interestAmount = (userAmount * interestRate) / 100;
    loanPlanController.interestAmount.value = interestAmount;
    final double totalPayableAmount = userAmount + interestAmount;
    loanPlanController.totalPayableAmount.value = totalPayableAmount;
    final double perInstallment = totalPayableAmount / totalInstallment;
    loanPlanController.perInstallment.value = perInstallment;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              CommonAppBar(
                title: "loanPlan.loanInstructions.appBarTitle".trns(),
                isPopEnabled: false,
                showRightSideIcon: false,
              ),
              const SizedBox(height: 16),
              _buildInstructionsSection(),
              const SizedBox(height: 10),
              _buildLoanDetailsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Column(
      children: [
        _buildTitleSection(
          title: "loanPlan.loanInstructions.contentOne.title".trns(),
        ),
        _buildContentContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              widget.loanPlanData.instructions ?? "",
              style: _textStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoanDetailsSection() {
    return Column(
      children: [
        _buildTitleSection(
          title: "loanPlan.loanInstructions.contentTwo.title".trnsFormat({
            "loan_name": widget.loanPlanData.name,
          }),
        ),
        _buildContentContainer(
          child: Column(
            children: [
              _buildDetailRow(
                label:
                    "loanPlan.loanInstructions.contentTwo.contentTable.contentKeyOne"
                        .trns(),
                value: widget.loanPlanData.name ?? "N/A",
              ),
              _buildDivider(),
              _buildDetailRow(
                label:
                    "loanPlan.loanInstructions.contentTwo.contentTable.contentKeyTwo"
                        .trns(),
                value:
                    "${loanPlanController.amountController.text} ${loanPlanController.siteCurrency.value}",
              ),
              _buildDivider(),
              _buildDetailRow(
                label:
                    "loanPlan.loanInstructions.contentTwo.contentTable.contentKeyThree"
                        .trns(),
                value: widget.loanPlanData.totalInstallment ?? "N/A",
                valueColor:
                    themeController.isDarkMode.value
                        ? AppColors.darkPrimary
                        : AppColors.primary,
              ),
              _buildDivider(),
              _buildDetailRow(
                label:
                    "loanPlan.loanInstructions.contentTwo.contentTable.contentKeyFour"
                        .trns(),
                value:
                    "${loanPlanController.perInstallment.value.toStringAsFixed(2)} ${loanPlanController.siteCurrency.value}",
              ),
              _buildDivider(),
              _buildDetailRow(
                label:
                    "loanPlan.loanInstructions.contentTwo.contentTable.contentKeyFive"
                        .trns(),
                value:
                    "${loanPlanController.interestAmount.value.toInt()} ${loanPlanController.siteCurrency.value}",
                valueColor: AppColors.error,
              ),
              _buildDivider(),
              _buildDetailRow(
                label:
                    "loanPlan.loanInstructions.contentTwo.contentTable.contentKeySix"
                        .trns(),
                value:
                    "${loanPlanController.totalPayableAmount.value.toInt()} ${loanPlanController.siteCurrency.value}",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection({required String title}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        border: Border.all(color: _borderColor),
      ),
      child: Text(
        title,
        style: _textStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }

  Widget _buildContentContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border(
          top: BorderSide.none,
          left: BorderSide(color: _borderColor),
          right: BorderSide(color: _borderColor),
          bottom: BorderSide(color: _borderColor),
        ),
      ),
      child: child,
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: _textStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
          Text(
            value,
            style: _textStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Divider(height: 0, color: _borderColor),
        const SizedBox(height: 12),
      ],
    );
  }

  TextStyle _textStyle({
    required FontWeight fontWeight,
    required double fontSize,
    Color? color,
  }) {
    return TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color:
          color ??
          (themeController.isDarkMode.value
              ? AppColors.darkTextPrimary
              : AppColors.textPrimary),
    );
  }

  Color get _borderColor =>
      themeController.isDarkMode.value
          ? AppColors.darkCardBorder
          : AppColors.textTertiary.withValues(alpha: 0.2);
}
