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
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/controller/fdr_plan_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/model/fdr_plan_model.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/view/sub_sections/subscribe_dialog_section.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class FdrPlanScreen extends StatefulWidget {
  const FdrPlanScreen({super.key});

  @override
  State<FdrPlanScreen> createState() => _FdrPlanScreenState();
}

class _FdrPlanScreenState extends State<FdrPlanScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final FdrPlanController fdrPlanController = Get.put(FdrPlanController());
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
        body: Stack(
          children: [
            RefreshIndicator(
              color:
                  themeController.isDarkMode.value
                      ? AppColors.darkPrimary
                      : AppColors.primary,
              onRefresh: () => fdrPlanController.loadData(),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  CommonAppBar(
                    title: "fdrPlan.title".trns(),
                    isPopEnabled: false,
                    showRightSideIcon: true,
                    rightSideIcon: PngAssets.commonClockIcon,
                    onPressed: () {
                      Get.find<NavigationController>().pushNamed(
                        BaseRoute.fdrPlanList,
                      );
                    },
                  ),
                  Expanded(
                    child: Obx(() {
                      if (fdrPlanController.isLoading.value) {
                        return const CommonLoading();
                      }

                      if (fdrPlanController.fdrPlanList.isEmpty) {
                        return SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: CommonNoDataFound(
                              message: "fdrPlan.noData".trns(),
                              showTryAgainButton: true,
                              onTryAgain: () => fdrPlanController.loadData(),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 30,
                        ),
                        child: Column(
                          children: List.generate(
                            fdrPlanController.fdrPlanList.length,
                            (index) {
                              final FdrPlanData fdrPlan =
                                  fdrPlanController.fdrPlanList[index];

                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      fdrPlanController.selectedCheckbox.value =
                                          fdrPlanController
                                                      .selectedCheckbox
                                                      .value ==
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
                                            fdrPlanController
                                                        .selectedCheckbox
                                                        .value ==
                                                    index
                                                ? 0
                                                : 12,
                                          ),
                                          bottomLeft: Radius.circular(
                                            fdrPlanController
                                                        .selectedCheckbox
                                                        .value ==
                                                    index
                                                ? 0
                                                : 12,
                                          ),
                                        ),
                                        border: Border.all(
                                          color:
                                              fdrPlanController
                                                          .selectedCheckbox
                                                          .value ==
                                                      index
                                                  ? themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors.darkSecondary
                                                      : AppColors.success
                                                          .withValues(
                                                            alpha: 0.16,
                                                          )
                                                  : AppColors.transparent,
                                          width: 1,
                                        ),
                                        boxShadow:
                                            fdrPlanController
                                                        .selectedCheckbox
                                                        .value ==
                                                    index
                                                ? [
                                                  BoxShadow(
                                                    color:
                                                        themeController
                                                                .isDarkMode
                                                                .value
                                                            ? AppColors
                                                                .darkSecondary
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
                                                  fdrPlanController
                                                          .selectedCheckbox
                                                          .value =
                                                      selected! ? index : -1;
                                                },
                                                checkedColor:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors.darkPrimary
                                                        : AppColors.success,
                                                size: 22,
                                                isChecked:
                                                    fdrPlanController
                                                        .selectedCheckbox
                                                        .value ==
                                                    index,
                                                uncheckedColor:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors
                                                            .darkSecondary
                                                        : AppColors.white,
                                                borderColor:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors
                                                            .darkCardBorder
                                                        : Color(
                                                          0xFF000000,
                                                        ).withValues(
                                                          alpha: 0.10,
                                                        ),
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
                                                    fdrPlan.name ?? "N/A",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
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
                                                  SizedBox(height: 5),
                                                  Text(
                                                    fdrPlan.profitIntervel ??
                                                        "N/A",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                      color:
                                                          themeController
                                                                  .isDarkMode
                                                                  .value
                                                              ? AppColors
                                                                  .darkPrimary
                                                              : AppColors
                                                                  .primary,
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
                                              Text(
                                                fdrPlan.profitRate ?? "N/A",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
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
                                              SizedBox(height: 8),
                                              Text(
                                                fdrPlan.badge ?? "N/A",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 11,
                                                  color:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors
                                                              .darkPrimary
                                                          : AppColors.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (fdrPlanController
                                          .selectedCheckbox
                                          .value ==
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
                                                fdrPlan.name ?? "N/A",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
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
                                              InkWell(
                                                onTap: () {
                                                  fdrPlanController
                                                      .selectedCheckbox
                                                      .value = -1;
                                                },
                                                child: CircleAvatar(
                                                  radius: 14,
                                                  backgroundColor:
                                                      themeController
                                                              .isDarkMode
                                                              .value
                                                          ? AppColors.white
                                                              .withValues(
                                                                alpha: 0.06,
                                                              )
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
                                            fdrPlan: fdrPlan,
                                            titleOne:
                                                "fdrPlan.fields.lockInPeriod"
                                                    .trns(),
                                            valueOne: fdrPlan.locked ?? "N/A",
                                            valueColorOne:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkPrimary
                                                    : AppColors.primary,
                                            titleTwo:
                                                "fdrPlan.fields.profitInterval"
                                                    .trns(),
                                            valueTwo:
                                                fdrPlan.profitIntervel ?? "N/A",
                                            valueColorTwo:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkPrimary
                                                    : AppColors.primary,
                                          ),
                                          SizedBox(height: 24),
                                          _buildPlanBenefitSection(
                                            fdrPlan: fdrPlan,
                                            titleOne:
                                                "fdrPlan.fields.profitRate"
                                                    .trns(),
                                            valueOne:
                                                fdrPlan.profitRate ?? "N/A",
                                            valueColorOne: AppColors.error,
                                            titleTwo:
                                                "fdrPlan.fields.minFdr".trns(),
                                            valueTwo:
                                                fdrPlan.minimumAmount ?? "N/A",
                                            valueColorTwo:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkPrimary
                                                    : AppColors.primary,
                                          ),
                                          SizedBox(height: 24),
                                          _buildPlanBenefitSection(
                                            fdrPlan: fdrPlan,
                                            titleOne:
                                                "fdrPlan.fields.maxFdr".trns(),
                                            valueOne:
                                                fdrPlan.maximumAmount ?? "N/A",
                                            valueColorOne:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkPrimary
                                                    : AppColors.primary,
                                            titleTwo:
                                                "fdrPlan.fields.compounding"
                                                    .trns(),
                                            valueTwo:
                                                fdrPlan.compounding ?? "N/A",
                                            valueColorTwo:
                                                fdrPlan.compounding == "Yes"
                                                    ? AppColors.success
                                                    : fdrPlan.compounding ==
                                                        "No"
                                                    ? AppColors.error
                                                    : AppColors.transparent,
                                          ),
                                          if (fdrPlan.canCancel == 1)
                                            SizedBox(height: 24),
                                          if (fdrPlan.canCancel == 1)
                                            _buildPlanBenefitSection(
                                              fdrPlan: fdrPlan,
                                              titleOne:
                                                  "fdrPlan.fields.cancelIn"
                                                      .trns(),
                                              valueOne:
                                                  fdrPlan.cancelIn ?? "N/A",
                                              valueColorOne:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors.darkPrimary
                                                      : AppColors.primary,
                                              titleTwo:
                                                  "fdrPlan.fields.cancelFee"
                                                      .trns(),
                                              valueTwo:
                                                  fdrPlan.cancelFee ?? "N/A",
                                              valueColorTwo: AppColors.error,
                                            ),

                                          SizedBox(height: 24),
                                          _buildPlanBenefitSection(
                                            fdrPlan: fdrPlan,
                                            titleOne:
                                                "fdrPlan.fields.maturityFee"
                                                    .trns(),
                                            valueOne:
                                                fdrPlan.maturityFee ?? "N/A",
                                            valueColorOne: AppColors.error,
                                            titleTwo:
                                                "fdrPlan.fields.increase"
                                                    .trns(),
                                            valueTwo:
                                                fdrPlan.isIncrease == 1
                                                    ? "fdrPlan.fields.yesText"
                                                        .trns()
                                                    : "fdrPlan.fields.noText"
                                                        .trns(),
                                            valueColorTwo:
                                                fdrPlan.isIncrease == 1
                                                    ? AppColors.success
                                                    : AppColors.error,
                                          ),
                                          SizedBox(height: 24),
                                          _buildPlanBenefitSection(
                                            fdrPlan: fdrPlan,
                                            titleOne:
                                                "fdrPlan.fields.increaseCharge"
                                                    .trns(),
                                            valueOne:
                                                fdrPlan.incrementCharge ??
                                                "N/A",
                                            valueColorOne: AppColors.error,
                                            titleTwo:
                                                "fdrPlan.fields.increaseLimit"
                                                    .trns(),
                                            valueTwo:
                                                fdrPlan.increaseLimit ?? "N/A",
                                            valueColorTwo:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkPrimary
                                                    : AppColors.primary,
                                          ),
                                          if (fdrPlan.isIncrease == 1)
                                            SizedBox(height: 24),
                                          if (fdrPlan.isIncrease == 1)
                                            _buildPlanBenefitSection(
                                              fdrPlan: fdrPlan,
                                              titleOne:
                                                  "fdrPlan.fields.minIncrease"
                                                      .trns(),
                                              valueOne:
                                                  fdrPlan.minIncreaseAmount ??
                                                  "N/A",
                                              valueColorOne:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors.darkPrimary
                                                      : AppColors.primary,
                                              titleTwo:
                                                  "fdrPlan.fields.maxIncrease"
                                                      .trns(),
                                              valueTwo:
                                                  fdrPlan.maxIncreaseAmount ??
                                                  "N/A",
                                              valueColorTwo:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors.darkPrimary
                                                      : AppColors.primary,
                                            ),
                                          SizedBox(height: 24),
                                          _buildPlanBenefitSection(
                                            fdrPlan: fdrPlan,
                                            titleOne:
                                                "fdrPlan.fields.decrease"
                                                    .trns(),
                                            valueOne:
                                                fdrPlan.isDecrease == 1
                                                    ? "fdrPlan.fields.yesText"
                                                        .trns()
                                                    : "fdrPlan.fields.noText"
                                                        .trns(),
                                            valueColorOne:
                                                fdrPlan.isDecrease == 1
                                                    ? AppColors.success
                                                    : AppColors.error,
                                            titleTwo:
                                                "fdrPlan.fields.decreaseCharge"
                                                    .trns(),
                                            valueTwo:
                                                fdrPlan.decrementCharge ??
                                                "N/A",
                                            valueColorTwo:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkPrimary
                                                    : AppColors.primary,
                                          ),
                                          SizedBox(height: 24),
                                          _buildPlanBenefitSection(
                                            fdrPlan: fdrPlan,
                                            titleOne:
                                                "fdrPlan.fields.decreaseLimit"
                                                    .trns(),
                                            valueOne:
                                                fdrPlan.decreaseLimit ?? "N/A",
                                            valueColorOne:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkPrimary
                                                    : AppColors.primary,
                                            titleTwo:
                                                fdrPlan.isDecrease == 1
                                                    ? "fdrPlan.fields.minDecrease"
                                                        .trns()
                                                    : "",
                                            valueTwo:
                                                fdrPlan.isDecrease == 1
                                                    ? fdrPlan
                                                            .minDecreaseAmount ??
                                                        "N/A"
                                                    : "",
                                            valueColorTwo:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkPrimary
                                                    : AppColors.primary,
                                          ),
                                          SizedBox(height: 24),
                                          _buildPlanBenefitSection(
                                            fdrPlan: fdrPlan,
                                            titleOne:
                                                fdrPlan.isDecrease == 1
                                                    ? "fdrPlan.fields.maxDecrease"
                                                        .trns()
                                                    : "",
                                            valueOne:
                                                fdrPlan.isDecrease == 1
                                                    ? fdrPlan
                                                            .maxDecreaseAmount ??
                                                        "N/A"
                                                    : "",
                                            valueColorOne:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkPrimary
                                                    : AppColors.primary,
                                            titleTwo: "",
                                            valueTwo: "",
                                            valueColorTwo:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkPrimary
                                                    : AppColors.primary,
                                          ),
                                          SizedBox(height: 24),
                                          CommonElevatedButton(
                                            buttonName:
                                                "fdrPlan.buttons.subscribeNow"
                                                    .trns(),
                                            onPressed: () {
                                              showSubscribeNowDialog(
                                                fdrPlanData: fdrPlan,
                                                passcodeController:
                                                    passcodeController,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  fdrPlanController.selectedCheckbox.value !=
                                          index
                                      ? SizedBox(height: 20)
                                      : SizedBox(),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Obx(
              () => Visibility(
                visible: fdrPlanController.isSubscriptionLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanBenefitSection({
    required FdrPlanData fdrPlan,
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

  void showSubscribeNowDialog({
    required FdrPlanData fdrPlanData,
    required ConfirmPasscodeController passcodeController,
  }) {
    Get.dialog(
      SubscribeDialogSection(
        fdrPlanData: fdrPlanData,
        passcodeController: passcodeController,
      ),
    );
  }
}
