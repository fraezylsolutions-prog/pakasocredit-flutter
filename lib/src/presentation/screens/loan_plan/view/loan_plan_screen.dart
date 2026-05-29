import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/controller/loan_plan_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/model/loan_plan_model.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/view/sub_sections/apply_loan_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class LoanPlanScreen extends StatefulWidget {
  const LoanPlanScreen({super.key});

  @override
  State<LoanPlanScreen> createState() => _LoanPlanScreenState();
}

class _LoanPlanScreenState extends State<LoanPlanScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final LoanPlanController loanPlanController = Get.put(LoanPlanController());
  final ConfirmPasscodeController passcodeController = Get.put(
    ConfirmPasscodeController(),
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        Get.find<NavigationController>().popPage();
      },
      child: Scaffold(
        body: RefreshIndicator(
          color:
              themeController.isDarkMode.value
                  ? AppColors.darkPrimary
                  : AppColors.primary,
          onRefresh: () => loanPlanController.loadData(),
          child: Column(
            children: [
              SizedBox(height: 16),
              CommonAppBar(
                title: "loanPlan.title".trns(),
                isPopEnabled: false,
                showRightSideIcon: true,
                rightSideIcon: PngAssets.commonClockIcon,
                onPressed:
                    () => Get.find<NavigationController>().pushNamed(
                      BaseRoute.loanPlanList,
                    ),
              ),
              Expanded(
                child: Obx(() {
                  if (loanPlanController.isLoading.value) {
                    return const CommonLoading();
                  }

                  if (loanPlanController.loanPlanList.isEmpty) {
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: CommonNoDataFound(
                          message: "loanPlan.noDataMessage".trns(),
                          showTryAgainButton: true,
                          onTryAgain: () => loanPlanController.loadData(),
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                    child: Column(
                      children: List.generate(loanPlanController.loanPlanList.length, (
                        index,
                      ) {
                        final LoanPlanData loan =
                            loanPlanController.loanPlanList[index];

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                loanPlanController.selectedCheckbox.value =
                                    loanPlanController.selectedCheckbox.value ==
                                            index
                                        ? -1
                                        : index;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkSecondary
                                          : AppColors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    topLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(
                                      loanPlanController
                                                  .selectedCheckbox
                                                  .value ==
                                              index
                                          ? 0
                                          : 12,
                                    ),
                                    bottomLeft: Radius.circular(
                                      loanPlanController
                                                  .selectedCheckbox
                                                  .value ==
                                              index
                                          ? 0
                                          : 12,
                                    ),
                                  ),
                                  border: Border.all(
                                    color:
                                        loanPlanController
                                                    .selectedCheckbox
                                                    .value ==
                                                index
                                            ? themeController.isDarkMode.value
                                                ? AppColors.darkSecondary
                                                : AppColors.success.withValues(
                                                  alpha: 0.16,
                                                )
                                            : AppColors.transparent,
                                    width: 1,
                                  ),
                                  boxShadow:
                                      loanPlanController
                                                  .selectedCheckbox
                                                  .value ==
                                              index
                                          ? [
                                            BoxShadow(
                                              color:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors.darkSecondary
                                                      : AppColors.success
                                                          .withValues(
                                                            alpha: 0.10,
                                                          ),
                                              blurRadius: 10,
                                              spreadRadius: 0,
                                              offset: Offset(0, 4),
                                            ),
                                          ]
                                          : [],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        RoundCheckBox(
                                          onTap: (selected) {
                                            loanPlanController
                                                .selectedCheckbox
                                                .value = selected! ? index : -1;
                                          },
                                          checkedColor:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.success,
                                          size: 22,
                                          isChecked:
                                              loanPlanController
                                                  .selectedCheckbox
                                                  .value ==
                                              index,
                                          uncheckedColor:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkSecondary
                                                  : AppColors.white,
                                          borderColor:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkCardBorder
                                                  : Color(
                                                    0xFF000000,
                                                  ).withValues(alpha: 0.10),
                                          checkedWidget: Image.asset(
                                            PngAssets.commonTickIcon,
                                            width: 14,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              loan.name ?? "N/A",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors
                                                            .darkTextPrimary
                                                        : AppColors.textPrimary,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              loan.installmentIntervel ?? "N/A",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors.darkPrimary
                                                        : AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      loan.installmentRate ?? "N/A",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color:
                                            themeController.isDarkMode.value
                                                ? AppColors.darkTextPrimary
                                                : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (loanPlanController.selectedCheckbox.value ==
                                index)
                              Container(
                                padding: EdgeInsets.all(16),
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkSecondary
                                          : AppColors.white,
                                  border:
                                      themeController.isDarkMode.value
                                          ? Border.all(
                                            color: Colors.transparent,
                                          )
                                          : Border.all(
                                            color: Color(0xFFE6E6E6),
                                          ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          loan.name ?? "N/A",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkTextPrimary
                                                    : AppColors.textPrimary,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            loanPlanController
                                                .selectedCheckbox
                                                .value = -1;
                                          },
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor:
                                                themeController.isDarkMode.value
                                                    ? AppColors.white
                                                        .withValues(alpha: 0.06)
                                                    : AppColors.black
                                                        .withValues(
                                                          alpha: 0.06,
                                                        ),
                                            child: Image.asset(
                                              PngAssets.commonCancelIcon,
                                              width: 14,
                                              fit: BoxFit.contain,
                                              color:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors.white
                                                      : AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 24),
                                    _buildPlanBenefitSection(
                                      loanPlan: loan,
                                      titleOne:
                                          "loanPlan.details.fields.minimumLoan"
                                              .trns(),
                                      valueOne: loan.minimumAmount ?? "N/A",
                                      valueColorOne:
                                          themeController.isDarkMode.value
                                              ? AppColors.darkPrimary
                                              : AppColors.primary,
                                      titleTwo:
                                          "loanPlan.details.fields.maximumLoan"
                                              .trns(),
                                      valueTwo: loan.maximumAmount ?? "N/A",
                                      valueColorTwo:
                                          themeController.isDarkMode.value
                                              ? AppColors.darkPrimary
                                              : AppColors.primary,
                                    ),
                                    SizedBox(height: 24),
                                    _buildPlanBenefitSection(
                                      loanPlan: loan,
                                      titleOne:
                                          "loanPlan.details.fields.installmentRate"
                                              .trns(),
                                      valueOne: loan.installmentRate ?? "N/A",
                                      valueColorOne:
                                          themeController.isDarkMode.value
                                              ? AppColors.darkPrimary
                                              : AppColors.primary,
                                      titleTwo:
                                          "loanPlan.details.fields.installmentSlice"
                                              .trns(),
                                      valueTwo:
                                          loan.installmentIntervel ?? "N/A",
                                      valueColorTwo:
                                          themeController.isDarkMode.value
                                              ? AppColors.darkPrimary
                                              : AppColors.primary,
                                    ),
                                    SizedBox(height: 24),
                                    _buildPlanBenefitSection(
                                      loanPlan: loan,
                                      titleOne:
                                          "loanPlan.details.fields.totalInstallment"
                                              .trns(),
                                      valueOne: loan.totalInstallment ?? "N/A",
                                      valueColorOne:
                                          themeController.isDarkMode.value
                                              ? AppColors.darkPrimary
                                              : AppColors.primary,
                                      titleTwo:
                                          "loanPlan.details.fields.loanApplyFee"
                                              .trns(),
                                      valueTwo: loan.loanFee ?? "N/A",
                                      valueColorTwo:
                                          themeController.isDarkMode.value
                                              ? AppColors.darkPrimary
                                              : AppColors.primary,
                                    ),
                                    SizedBox(height: 24),
                                    CommonElevatedButton(
                                      buttonName:
                                          "loanPlan.details.applyLoan".trns(),
                                      onPressed: () {
                                        Get.dialog(
                                          ApplyLoanPopUp(
                                            loanPlanData: loan,
                                            passcodeController:
                                                passcodeController,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            loanPlanController.selectedCheckbox.value != index
                                ? SizedBox(height: 20)
                                : SizedBox(),
                          ],
                        );
                      }),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanBenefitSection({
    required LoanPlanData loanPlan,
    required String titleOne,
    required String valueOne,
    required Color valueColorOne,
    required String titleTwo,
    required String valueTwo,
    required Color valueColorTwo,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleOne,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              valueOne,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: valueColorOne,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              titleTwo,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color:
                    themeController.isDarkMode.value
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6),
            Text(
              valueTwo,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: valueColorTwo,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
