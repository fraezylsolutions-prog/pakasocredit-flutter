import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_no_data_found.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/controller/dps_plan_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/model/dps_plan_model.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class DpsPlanScreen extends StatefulWidget {
  const DpsPlanScreen({super.key});

  @override
  State<DpsPlanScreen> createState() => _DpsPlanScreenState();
}

class _DpsPlanScreenState extends State<DpsPlanScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final DpsPlanController dpsPlanController = Get.put(DpsPlanController());
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
              onRefresh: () => dpsPlanController.loadData(),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  CommonAppBar(
                    title: "dpsPlan.title".trns(),
                    isPopEnabled: false,
                    showRightSideIcon: true,
                    rightSideIcon: PngAssets.commonClockIcon,
                    onPressed:
                        () => Get.find<NavigationController>().pushNamed(
                          BaseRoute.dpsPlanList,
                        ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (dpsPlanController.isLoading.value) {
                        return const CommonLoading();
                      }

                      if (dpsPlanController.dpsPlanList.isEmpty) {
                        return SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: CommonNoDataFound(
                              message: "dpsPlan.noData".trns(),
                              showTryAgainButton: true,
                              onTryAgain: () => dpsPlanController.loadData(),
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
                          children: List.generate(dpsPlanController.dpsPlanList.length, (
                            index,
                          ) {
                            final DpsPlanData dpsPlan =
                                dpsPlanController.dpsPlanList[index];

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    dpsPlanController.selectedCheckbox.value =
                                        dpsPlanController
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
                                          dpsPlanController
                                                      .selectedCheckbox
                                                      .value ==
                                                  index
                                              ? 0
                                              : 12,
                                        ),
                                        bottomLeft: Radius.circular(
                                          dpsPlanController
                                                      .selectedCheckbox
                                                      .value ==
                                                  index
                                              ? 0
                                              : 12,
                                        ),
                                      ),
                                      border: Border.all(
                                        color:
                                            dpsPlanController
                                                        .selectedCheckbox
                                                        .value ==
                                                    index
                                                ? themeController
                                                        .isDarkMode
                                                        .value
                                                    ? AppColors.darkSecondary
                                                    : AppColors.success
                                                        .withValues(alpha: 0.16)
                                                : AppColors.transparent,
                                        width: 1,
                                      ),
                                      boxShadow:
                                          dpsPlanController
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
                                                dpsPlanController
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
                                                  dpsPlanController
                                                      .selectedCheckbox
                                                      .value ==
                                                  index,
                                              uncheckedColor:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors.darkSecondary
                                                      : AppColors.white,
                                              borderColor:
                                                  themeController
                                                          .isDarkMode
                                                          .value
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
                                                  dpsPlan.dpsName ?? "N/A",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
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
                                                  dpsPlan.installmentDays ??
                                                      "N/A",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${Get.find<SettingsService>().currencySymbol.value}${dpsPlan.perInstallment?.toString() ?? 0}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors
                                                            .darkTextPrimary
                                                        : AppColors.textPrimary,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              dpsPlan.badge ?? "N/A",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 11,
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
                                  ),
                                ),
                                if (dpsPlanController.selectedCheckbox.value ==
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
                                              dpsPlan.dpsName ?? "N/A",
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
                                            InkWell(
                                              onTap: () {
                                                dpsPlanController
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
                                          dpsPlan: dpsPlan,
                                          titleOne:
                                              "dpsPlan.fields.perInstallment"
                                                  .trns(),
                                          valueOne:
                                              "${dpsPlan.perInstallment?.toString() ?? "0"} ${dpsPlanController.siteCurrency.value}",
                                          valueColorOne:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                          titleTwo:
                                              "dpsPlan.fields.interestRate"
                                                  .trns(),
                                          valueTwo:
                                              dpsPlan.interestRate
                                                  ?.toString() ??
                                              "0",
                                          valueColorTwo: AppColors.error,
                                        ),
                                        SizedBox(height: 24),
                                        _buildPlanBenefitSection(
                                          dpsPlan: dpsPlan,
                                          titleOne:
                                              "dpsPlan.fields.totalInstallments"
                                                  .trns(),
                                          valueOne:
                                              dpsPlan.totalInstallment
                                                  ?.toString() ??
                                              "0",
                                          valueColorOne:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                          titleTwo:
                                              "dpsPlan.fields.totalDeposit"
                                                  .trns(),
                                          valueTwo:
                                              dpsPlan.totalDeposit ?? "N/A",
                                          valueColorTwo:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                        ),
                                        SizedBox(height: 24),
                                        _buildPlanBenefitSection(
                                          dpsPlan: dpsPlan,
                                          titleOne:
                                              "dpsPlan.fields.totalMatureAmount"
                                                  .trns(),
                                          valueOne:
                                              dpsPlan.totalMatureAmount ??
                                              "N/A",
                                          valueColorOne:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                          titleTwo:
                                              "dpsPlan.fields.maturityFee"
                                                  .trns(),
                                          valueTwo:
                                              dpsPlan.maturityFee ?? "N/A",
                                          valueColorTwo:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                        ),
                                        SizedBox(height: 24),
                                        _buildPlanBenefitSection(
                                          dpsPlan: dpsPlan,
                                          titleOne:
                                              "dpsPlan.fields.increase".trns(),
                                          valueOne:
                                              dpsPlan.isIncrease == 1
                                                  ? "dpsPlan.yes".trns()
                                                  : "dpsPlan.no".trns(),
                                          valueColorOne:
                                              dpsPlan.isIncrease == 1
                                                  ? AppColors.success
                                                  : AppColors.error,
                                          titleTwo:
                                              "dpsPlan.fields.increaseCharge"
                                                  .trns(),
                                          valueTwo:
                                              dpsPlan.increaseCharge ?? "N/A",
                                          valueColorTwo: AppColors.error,
                                        ),

                                        SizedBox(height: 24),
                                        _buildPlanBenefitSection(
                                          dpsPlan: dpsPlan,
                                          titleOne:
                                              "dpsPlan.fields.cancelFee".trns(),
                                          valueOne: dpsPlan.cancelFee ?? "N/A",
                                          valueColorOne: AppColors.error,
                                          titleTwo:
                                              "dpsPlan.fields.cancelIn".trns(),
                                          valueTwo: dpsPlan.cancelIn ?? "N/A",
                                          valueColorTwo:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                        ),
                                        SizedBox(height: 24),
                                        _buildPlanBenefitSection(
                                          dpsPlan: dpsPlan,
                                          titleOne:
                                              "dpsPlan.fields.increaseLimit"
                                                  .trns(),
                                          valueOne:
                                              dpsPlan.increaseLimit ?? "N/A",
                                          valueColorOne:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                          titleTwo:
                                              "dpsPlan.fields.minIncreaseAmount"
                                                  .trns(),
                                          valueTwo:
                                              dpsPlan.minIncreaseAmount ??
                                              "N/A",
                                          valueColorTwo:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                        ),
                                        SizedBox(height: 24),
                                        _buildPlanBenefitSection(
                                          dpsPlan: dpsPlan,
                                          titleOne:
                                              "dpsPlan.fields.maxIncreaseAmount"
                                                  .trns(),
                                          valueOne:
                                              dpsPlan.maxIncreaseAmount ??
                                              "N/A",
                                          valueColorOne:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                          titleTwo:
                                              "dpsPlan.fields.decrease".trns(),
                                          valueTwo:
                                              dpsPlan.isDecrease == 1
                                                  ? "dpsPlan.yes".trns()
                                                  : "dpsPlan.no".trns(),
                                          valueColorTwo:
                                              dpsPlan.isDecrease == 1
                                                  ? AppColors.success
                                                  : AppColors.error,
                                        ),
                                        SizedBox(height: 24),
                                        _buildPlanBenefitSection(
                                          dpsPlan: dpsPlan,
                                          titleOne:
                                              "dpsPlan.fields.decreaseCharge"
                                                  .trns(),
                                          valueOne:
                                              dpsPlan.decreaseCharge ?? "N/A",
                                          valueColorOne: AppColors.error,
                                          titleTwo:
                                              "dpsPlan.fields.decreaseLimit"
                                                  .trns(),
                                          valueTwo:
                                              dpsPlan.decreaseLimit ?? "N/A",
                                          valueColorTwo:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                        ),
                                        SizedBox(height: 24),
                                        _buildPlanBenefitSection(
                                          dpsPlan: dpsPlan,
                                          titleOne:
                                              "dpsPlan.fields.minDecreaseAmount"
                                                  .trns(),
                                          valueOne:
                                              dpsPlan.minDecreaseAmount ??
                                              "N/A",
                                          valueColorOne:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                          titleTwo:
                                              "dpsPlan.fields.maxDecreaseAmount"
                                                  .trns(),
                                          valueTwo:
                                              dpsPlan.maxDecreaseAmount ??
                                              "N/A",
                                          valueColorTwo:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkPrimary
                                                  : AppColors.primary,
                                        ),
                                        SizedBox(height: 24),
                                        CommonElevatedButton(
                                          buttonName:
                                              "dpsPlan.buttons.subscribe"
                                                  .trns(),
                                          onPressed: () {
                                            final homeCtrl =
                                                Get.find<HomeController>();
                                            final userPasscode =
                                                homeCtrl
                                                    .userModel
                                                    .value
                                                    .passcode;

                                            if (userPasscode == null) {
                                              dpsPlanController.submitSubscribe(
                                                planId: dpsPlan.id.toString(),
                                              );
                                              return;
                                            }

                                            final needsPasscode =
                                                passcodeController
                                                        .passcodeStatus
                                                        .value ==
                                                    "1" ||
                                                passcodeController
                                                        .passcodeStatus
                                                        .value ==
                                                    "null";

                                            if (needsPasscode) {
                                              Get.dialog(
                                                ConfirmPasscodePopUp(
                                                  controller:
                                                      passcodeController
                                                          .passcodeController,
                                                  onPressed: () async {
                                                    final ok =
                                                        await passcodeController
                                                            .submitPasscodeVerify();
                                                    if (!ok) return;
                                                    Get.back();
                                                    dpsPlanController
                                                        .submitSubscribe(
                                                          planId:
                                                              dpsPlan.id
                                                                  .toString(),
                                                        );
                                                  },
                                                ),
                                              );
                                            } else {
                                              dpsPlanController.submitSubscribe(
                                                planId: dpsPlan.id.toString(),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                dpsPlanController.selectedCheckbox.value !=
                                        index
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
            Obx(
              () => Visibility(
                visible: dpsPlanController.isSubscriptionLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanBenefitSection({
    required DpsPlanData dpsPlan,
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
