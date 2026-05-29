import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_enter_amount_text_field.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/controller/loan_plan_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/model/loan_plan_model.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/view/loan_application_form/loan_application_form.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ApplyLoanPopUp extends StatefulWidget {
  final ConfirmPasscodeController passcodeController;
  final LoanPlanData loanPlanData;

  const ApplyLoanPopUp({
    super.key,
    required this.loanPlanData,
    required this.passcodeController,
  });

  @override
  State<ApplyLoanPopUp> createState() => _ApplyLoanPopUpState();
}

class _ApplyLoanPopUpState extends State<ApplyLoanPopUp> {
  final ThemeController themeController = Get.find<ThemeController>();
  final LoanPlanController loanPlanController = Get.find<LoanPlanController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          themeController.isDarkMode.value
              ? AppColors.darkSecondary
              : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "loanPlan.applyLoan.title".trns(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color:
                        themeController.isDarkMode.value
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => Get.back(),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor:
                        themeController.isDarkMode.value
                            ? AppColors.white.withValues(alpha: 0.06)
                            : AppColors.black.withValues(alpha: 0.06),
                    child: Image.asset(
                      PngAssets.commonCancelIcon,
                      width: 14,
                      fit: BoxFit.contain,
                      color:
                          themeController.isDarkMode.value
                              ? AppColors.white
                              : AppColors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => CommonEnterAmountTextField(
                    hintText: "loanPlan.applyLoan.form.amountLabel".trns(),
                    keyboardType: TextInputType.number,
                    currencyCode: loanPlanController.siteCurrency.value,
                    controller: loanPlanController.amountController,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "loanPlan.applyLoan.form.amountLimits".trnsFormat({
                    "min_amount": widget.loanPlanData.minimumAmount ?? "N/A",
                    "max_amount": widget.loanPlanData.maximumAmount ?? "N/A",
                  }),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 8,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            CommonElevatedButton(
              width: 100,
              height: 32,
              buttonName: "loanPlan.applyLoan.form.applyNow".trns(),
              borderRadius: 6,
              leftIcon: Image.asset(
                PngAssets.commonTickIcon,
                width: 14,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.black
                        : AppColors.white,
              ),
              fontWeight: FontWeight.w600,
              fontSize: 11,
              onPressed: () {
                submitApplyNow(passcodeController: widget.passcodeController);
              },
            ),
          ],
        ),
      ),
    );
  }

  void submitApplyNow({required ConfirmPasscodeController passcodeController}) {
    String amountText = loanPlanController.amountController.text.trim();
    amountText = amountText.replaceAll(RegExp(r'[^\d.]'), '');
    double? enteredAmount = double.tryParse(amountText);
    double? minAmount = double.tryParse(
      widget.loanPlanData.minimumAmount?.replaceAll(RegExp(r'[^\d.]'), '') ??
          '0',
    );
    double? maxAmount = double.tryParse(
      widget.loanPlanData.maximumAmount?.replaceAll(RegExp(r'[^\d.]'), '') ??
          '0',
    );
    if (enteredAmount == null) {
      Fluttertoast.showToast(
        msg: "loanPlan.applyLoan.errors.invalidAmount".trns(),
        backgroundColor: AppColors.error,
      );
    } else if (minAmount != null && enteredAmount < minAmount) {
      Fluttertoast.showToast(
        msg:
            "${"loanPlan.applyLoan.errors.belowMinimum".trns()} ${widget.loanPlanData.minimumAmount}",
        backgroundColor: AppColors.error,
      );
    } else if (maxAmount != null && enteredAmount > maxAmount) {
      Fluttertoast.showToast(
        msg:
            "${"loanPlan.applyLoan.errors.aboveMaximum".trns()} ${widget.loanPlanData.maximumAmount}",
        backgroundColor: AppColors.error,
      );
    } else {
      Get.find<NavigationController>().pushPage(
        LoanApplicationForm(
          loanPlanData: widget.loanPlanData,
          passcodeController: passcodeController,
        ),
      );
      Get.back();
    }
  }
}
