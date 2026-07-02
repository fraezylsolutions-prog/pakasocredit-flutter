import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/constants/assets_path/png/png_assets.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_app_bar.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_enter_amount_text_field.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/controller/withdraw_money_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/view/withdraw_account/withdraw_account.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/view/withdraw_history/withdraw_history.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final ThemeController themeController = Get.find<ThemeController>();
  final WithdrawMoneyController controller = Get.put(WithdrawMoneyController());
  final ConfirmPasscodeController passcodeController = Get.put(
    ConfirmPasscodeController(),
  );

  @override
  void initState() {
    super.initState();
    controller.clearFields();
    loadData();
  }

  Future<void> loadData() async {
    controller.isLoading.value = true;
    try {
      await controller.fetchAccounts();
      await controller.loadSiteCurrency();
      await passcodeController.loadPasscodeStatus(
        passcodeType: "withdraw_passcode_status",
      );
    } catch (e) {
      debugPrint('Withdraw load error: $e');
    } finally {
      controller.isLoading.value = false;
    }
  }

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
            Column(
              children: [
                SizedBox(height: 16),
                CommonAppBar(
                  title: "withdraw.title".trns(),
                  isPopEnabled: false,
                  showRightSideIcon: true,
                  rightSideIcon: PngAssets.commonClockIcon,
                  pushPage: WithdrawHistory(),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const CommonLoading();
                    }

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.only(left: 18, right: 18, top: 18),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkSecondary
                                : AppColors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                        ),
                        gradient: AppStyles.linearGradient(),
                        boxShadow: AppStyles.boxShadow(),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap:
                                  () => Get.find<NavigationController>()
                                      .pushPage(WithdrawAccount()),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color:
                                        themeController.isDarkMode.value
                                            ? AppColors.darkPrimary
                                            : Color(0xFFF6F6F6),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Image.asset(
                                    PngAssets.withdrawBookIcon,
                                    width: 20,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonTextInputField(
                                  textFontWeight: FontWeight.w600,
                                  controller: controller.accountController,
                                  keyboardType: TextInputType.none,
                                  readOnly: true,
                                  onTap: () {
                                    Get.bottomSheet(
                                      CommonDropdownBottomSheet(
                                        title: "withdraw.selectAccount".trns(),
                                        onValueSelected: (value) {
                                          int index = controller.accountList
                                              .indexWhere(
                                                (item) =>
                                                    item.methodName ==
                                                    controller.account.value,
                                              );
                                          if (index != -1) {
                                            controller.methodType.value = "";
                                            controller.methodType.value =
                                                controller
                                                    .accountList[index]
                                                    .method!
                                                    .type
                                                    .toString();
                                            controller.minWithdraw.value = "";
                                            controller.minWithdraw.value =
                                                controller
                                                    .accountList[index]
                                                    .method!
                                                    .minWithdraw
                                                    .toString();
                                            controller.maxWithdraw.value = "";
                                            controller.maxWithdraw.value =
                                                controller
                                                    .accountList[index]
                                                    .method!
                                                    .maxWithdraw
                                                    .toString();
                                            controller.methodTime.value = "";
                                            controller.methodTime.value =
                                                controller
                                                    .accountList[index]
                                                    .method!
                                                    .time
                                                    .toString();
                                            controller.chargeType.value = "";
                                            controller.chargeType.value =
                                                controller
                                                    .accountList[index]
                                                    .method!
                                                    .chargeType
                                                    .toString();
                                            controller.accountCharge.value = "";
                                            controller.accountCharge.value =
                                                controller
                                                    .accountList[index]
                                                    .method!
                                                    .charge
                                                    .toString();
                                            controller.accountRate.value = 0.0;
                                            controller.accountRate.value =
                                                controller
                                                    .accountList[index]
                                                    .method!
                                                    .rate ??
                                                0;
                                            controller.accountCurrency.value =
                                                "";
                                            controller.accountCurrency.value =
                                                controller
                                                    .accountList[index]
                                                    .currency
                                                    .toString();
                                            controller.paymentMethodIcon.value =
                                                "";
                                            controller.paymentMethodIcon.value =
                                                controller
                                                    .accountList[index]
                                                    .method!
                                                    .icon
                                                    .toString();
                                            controller.accountId.value = "";
                                            controller.accountId.value =
                                                controller.accountList[index].id
                                                    .toString();
                                            controller.onAmountChange();
                                          } else {
                                            controller.methodType.value = "";
                                            controller.minWithdraw.value = "";
                                            controller.maxWithdraw.value = "";
                                            controller.methodTime.value = "";
                                            controller.chargeType.value = "";
                                            controller.accountCharge.value = "";
                                            controller.accountId.value = "";
                                            controller.accountCurrency.value =
                                                "";
                                            controller.paymentMethodIcon.value =
                                                "";
                                            controller.accountRate.value = 0.0;
                                          }
                                        },
                                        selectedValue:
                                            controller.accountList
                                                .map((item) => item.methodName!)
                                                .toList(),
                                        dropdownItems:
                                            controller.accountList
                                                .map((item) => item.methodName!)
                                                .toList(),
                                        selectedItem: controller.account,
                                        textController:
                                            controller.accountController,
                                        currentlySelectedValue:
                                            controller.account.value,
                                        bottomSheetHeight: 400,
                                      ),
                                    );
                                  },
                                  hintText: "withdraw.selectAccount".trns(),
                                  showSuffixIcon: true,
                                  suffixIcon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 20,
                                    color: Colors.grey.withValues(alpha: 0.8),
                                  ),
                                ),
                                Obx(
                                  () => Visibility(
                                    visible:
                                        controller.account.value.isNotEmpty,
                                    child: Text(
                                      controller.methodType.value == "auto"
                                          ? "withdraw.methodTypes.auto".trns()
                                          : controller.methodType.value ==
                                              "manual"
                                          ? "${"withdraw.methodTypes.manual".trns()}${controller.methodTime.value}"
                                          : "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.error,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonEnterAmountTextField(
                                  onChanged: (value) {
                                    controller.amount.value = value;
                                    controller.onAmountChange();
                                  },
                                  keyboardType: TextInputType.number,
                                  isCurrencyVisible: true,
                                  currencyCode: controller.siteCurrency.value,
                                  controller: controller.enterAmountController,
                                  topRightBorderRadius: 0,
                                  bottomRightBorderRadius: 0,
                                  currencyBackgroundColor:
                                      themeController.isDarkMode.value
                                          ? AppColors.transparent
                                          : AppColors.white,
                                  hintText: "withdraw.enterAmount".trns(),
                                ),
                                Obx(
                                  () => Visibility(
                                    visible:
                                        controller.account.value.isNotEmpty,
                                    child: Text(
                                      "withdraw.limits".trnsFormat({
                                        "min_limit":
                                            "${controller.minWithdraw.value} ${controller.siteCurrency.value}",
                                        "max_limit":
                                            "${controller.maxWithdraw.value} ${controller.siteCurrency.value}",
                                      }),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.error,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      themeController.isDarkMode.value
                                          ? AppColors.darkCardBorder
                                          : Color(0xFFE6E6E6),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${"withdraw.preview".trns()}:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color:
                                          themeController.isDarkMode.value
                                              ? AppColors.darkTextPrimary
                                              : AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Divider(
                                    color:
                                        themeController.isDarkMode.value
                                            ? AppColors.darkCardBorder
                                            : Color(
                                              0xFF000000,
                                            ).withValues(alpha: 0.10),
                                    height: 0,
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${"withdraw.amount".trns()}:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.textPrimary,
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible:
                                              controller.amount.value !=
                                                  "0.00" &&
                                              controller
                                                  .account
                                                  .value
                                                  .isNotEmpty,
                                          child: Text(
                                            "${controller.amount.value.isNotEmpty ? double.tryParse(controller.amount.value)?.toStringAsFixed(0) : "0"} ${controller.siteCurrency.value}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
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
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${"withdraw.charge".trns()}:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.textPrimary,
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible:
                                              controller.amount.value !=
                                                  "0.00" &&
                                              controller
                                                  .account
                                                  .value
                                                  .isNotEmpty,
                                          child: Text(
                                            "${controller.chargeAmount.value == 0.0 ? "0" : controller.chargeAmount.value.toStringAsFixed(2)} ${controller.siteCurrency.value}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                              color: AppColors.error,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${"withdraw.paymentMethod".trns()}:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.textPrimary,
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible:
                                              controller.amount.value !=
                                                  "0.00" &&
                                              controller
                                                  .account
                                                  .value
                                                  .isNotEmpty,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 5,
                                            ),

                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors.darkPrimary
                                                          .withValues(
                                                            alpha: 0.1,
                                                          )
                                                      : AppColors.primary
                                                          .withValues(
                                                            alpha: 0.1,
                                                          ),
                                            ),
                                            child: Text(
                                              controller.account.value,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11,
                                                color:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors.darkPrimary
                                                        : AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${"withdraw.paymentMethodLogo".trns()}:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.textPrimary,
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible:
                                              controller.amount.value !=
                                                  "0.00" &&
                                              controller
                                                  .account
                                                  .value
                                                  .isNotEmpty,
                                          child: Image.network(
                                            controller.paymentMethodIcon.value,
                                            width: 80,
                                            fit: BoxFit.contain,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Icon(
                                                Icons.error_outline_outlined,
                                                color:
                                                    themeController
                                                            .isDarkMode
                                                            .value
                                                        ? AppColors
                                                            .darkTextTertiary
                                                        : AppColors
                                                            .textTertiary,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${"withdraw.conversionRate".trns()}:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.textPrimary,
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible:
                                              controller.amount.value !=
                                                  "0.00" &&
                                              controller
                                                  .account
                                                  .value
                                                  .isNotEmpty,
                                          child: Text(
                                            "1 ${controller.siteCurrency.value} = ${controller.accountRate.value.toInt()} ${controller.accountCurrency.value}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
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
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${"withdraw.total".trns()}:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.textPrimary,
                                        ),
                                      ),
                                      Obx(
                                        () => Visibility(
                                          visible:
                                              controller.amount.value !=
                                                  "0.00" &&
                                              controller
                                                  .account
                                                  .value
                                                  .isNotEmpty,
                                          child: Text(
                                            "${controller.enterAmountController.text} ${controller.accountCurrency.value}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
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
                                  SizedBox(height: 40),
                                  CommonElevatedButton(
                                    buttonName:
                                        "withdraw.withdrawButton".trns(),
                                    onPressed: () {
                                      if (controller
                                              .enterAmountController
                                              .text
                                              .isNotEmpty &&
                                          controller
                                              .accountController
                                              .text
                                              .isNotEmpty) {
                                        final homeCtrl =
                                            Get.find<HomeController>();
                                        final userPasscode =
                                            homeCtrl.userModel.value.passcode;

                                        if (userPasscode == null) {
                                          controller.submitWithdrawMoney();
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
                                                controller
                                                    .submitWithdrawMoney();
                                              },
                                            ),
                                          );
                                        } else {
                                          controller.submitWithdrawMoney();
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              "withdraw.validation.requiredField"
                                                  .trns(),
                                          backgroundColor: AppColors.error,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: controller.isWithdrawMoneyLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
