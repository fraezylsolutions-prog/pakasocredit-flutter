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
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet_three.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/pay_bill_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/tool_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/model/bill_countries_model.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/bill_payment_history/bill_payment_history.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Tool extends StatefulWidget {
  final String type;

  const Tool({super.key, required this.type});

  @override
  State<Tool> createState() => _ToolState();
}

class _ToolState extends State<Tool> {
  final ThemeController themeController = Get.find<ThemeController>();
  final ToolController toolController = Get.put(ToolController());
  final ConfirmPasscodeController passcodeController = Get.put(
    ConfirmPasscodeController(),
  );
  final PayBillController payBillController = Get.find<PayBillController>();

  @override
  void initState() {
    super.initState();
    payBillController.billCountriesModel.value = BillCountriesModel();
    toolController.clearFields();
    toolController.countryController.clear();
    loadData();
  }

  Future<void> loadData() async {
    toolController.isLoading.value = true;
    await passcodeController.loadPasscodeStatus(
      passcodeType: "pay_bill_passcode_status",
    );
    await payBillController.fetchBillCountries(type: widget.type);
    await toolController.loadSiteCurrency();
    toolController.isLoading.value = false;
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
            CommonAppBar(
              title: "payBill.tollSection.title".trns(),
              isPopEnabled: false,
              showRightSideIcon: true,
              rightSideIcon: PngAssets.commonClockIcon,
              pushPage: BillPaymentHistory(),
            ),
            SizedBox(height: 30),
            Expanded(
              child: Stack(
                children: [
                  Obx(() {
                    if (toolController.isLoading.value) {
                      return CommonLoading();
                    }

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.only(left: 18, right: 18, top: 20),
                      decoration: BoxDecoration(
                        color:
                            themeController.isDarkMode.value
                                ? AppColors.darkSecondary
                                : AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: AppStyles.boxShadow(),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextInputField(
                              textFontWeight: FontWeight.w600,
                              controller: toolController.countryController,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTap: () {
                                Get.bottomSheet(
                                  CommonDropdownBottomSheet(
                                    title:
                                        "payBill.tollSection.selectCountry"
                                            .trns(),
                                    onValueSelected: (value) async {
                                      toolController.amountController.clear();
                                      toolController.serviceId.value = "";
                                      toolController.serviceCurrency.value = "";
                                      toolController.serviceRate.value = 0.0;
                                      toolController.serviceAmount.value = 0.0;
                                      toolController.serviceCharge.value = 0.0;
                                      toolController.rateText.value = "";
                                      toolController.chargeText.value = "";
                                      toolController.dynamicFieldControllers
                                          .clear();
                                      toolController.payBillServiceList.clear();
                                      toolController.payableAmount.value = 0.00;
                                      await toolController
                                          .fetchPayBillServices();
                                    },
                                    selectedValue:
                                        Get.find<PayBillController>()
                                            .billCountriesModel
                                            .value
                                            .data!
                                            .map((item) => item)
                                            .toList(),
                                    dropdownItems:
                                        Get.find<PayBillController>()
                                            .billCountriesModel
                                            .value
                                            .data!
                                            .map((item) => item)
                                            .toList(),
                                    selectedItem: toolController.country,
                                    textController:
                                        toolController.countryController,
                                    currentlySelectedValue:
                                        toolController.country.value,
                                    bottomSheetHeight: 400,
                                  ),
                                );
                              },
                              hintText:
                                  "payBill.tollSection.selectCountry".trns(),
                              showSuffixIcon: true,
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: Colors.grey.withValues(alpha: 0.8),
                              ),
                            ),
                            SizedBox(height: 16),
                            CommonTextInputField(
                              textFontWeight: FontWeight.w600,
                              controller: toolController.serviceController,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTap: () {
                                Get.bottomSheet(
                                  CommonDropdownBottomSheetThree(
                                    title:
                                        "payBill.tollSection.selectService"
                                            .trns(),
                                    onValueSelected: (value) async {
                                      final serviceId = int.parse(value);
                                      final selectedService = toolController
                                          .getServiceById(serviceId);
                                      toolController.amountController.clear();
                                      toolController.amountText.value = "";
                                      if (selectedService != null) {
                                        toolController.serviceId.value = value;
                                        toolController.selectedService.value =
                                            selectedService;
                                        toolController.serviceController.text =
                                            selectedService.name ?? "";
                                        toolController.setupDynamicFields(
                                          selectedService.fields,
                                        );
                                        toolController.serviceRate.value =
                                            selectedService.rate?.toDouble() ??
                                            0;
                                        toolController.serviceAmount.value =
                                            selectedService.amount
                                                ?.toDouble() ??
                                            0.0;
                                        toolController.serviceCharge.value =
                                            selectedService.charge
                                                ?.toDouble() ??
                                            0.0;
                                        toolController.serviceCurrency.value =
                                            "";
                                        toolController.serviceCurrency.value =
                                            selectedService.currency.toString();
                                        toolController.serviceChargeType.value =
                                            selectedService.chargeType ?? "";
                                        toolController
                                            .calculatePaymentDetails();
                                      }
                                    },
                                    selectedValue:
                                        toolController.payBillServiceList
                                            .asMap()
                                            .entries
                                            .map((entry) => "${entry.value.id}")
                                            .toList(),
                                    dropdownItems:
                                        toolController.payBillServiceList
                                            .map((item) => item.name ?? "")
                                            .toList(),
                                    selectedItem: toolController.serviceId,
                                    textController:
                                        toolController.serviceController,
                                    currentlySelectedValue:
                                        toolController.serviceId.value,
                                    bottomSheetHeight: 400,
                                  ),
                                );
                              },
                              hintText:
                                  "payBill.tollSection.selectService".trns(),
                              showSuffixIcon: true,
                              suffixIcon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: Colors.grey.withValues(alpha: 0.8),
                              ),
                            ),
                            SizedBox(height: 16),
                            Obx(() {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (toolController.serviceAmount.value > 0) {
                                  toolController.amountController.text =
                                      toolController.serviceAmount.value
                                          .toInt()
                                          .toString();
                                  toolController.amountText.value =
                                      toolController.amountController.text;
                                  toolController.calculatePaymentDetails();
                                }
                              });

                              return CommonEnterAmountTextField(
                                hintText: "payBill.tollSection.amount".trns(),
                                currencyBackgroundColor:
                                    toolController.serviceAmount.value > 0.0
                                        ? themeController.isDarkMode.value
                                            ? AppColors.darkTextTertiary
                                                .withValues(alpha: 0.15)
                                            : AppColors.textTertiary.withValues(
                                              alpha: 0.15,
                                            )
                                        : themeController.isDarkMode.value
                                        ? AppColors.transparent
                                        : AppColors.white,
                                bottomRightBorderRadius:
                                    toolController
                                            .serviceCurrency
                                            .value
                                            .isNotEmpty
                                        ? 0
                                        : 10,
                                topRightBorderRadius:
                                    toolController
                                            .serviceCurrency
                                            .value
                                            .isNotEmpty
                                        ? 0
                                        : 10,
                                onChanged: (value) {
                                  toolController.amountText.value =
                                      toolController.amountController.text;

                                  toolController.calculatePaymentDetails();
                                },
                                isCurrencyVisible:
                                    toolController
                                        .serviceCurrency
                                        .value
                                        .isNotEmpty,
                                currencyCode:
                                    toolController.serviceCurrency.value,
                                controller: toolController.amountController,
                                backgroundColor:
                                    toolController.serviceAmount.value > 0.0
                                        ? themeController.isDarkMode.value
                                            ? AppColors.darkTextTertiary
                                                .withValues(alpha: 0.1)
                                            : AppColors.textTertiary.withValues(
                                              alpha: 0.1,
                                            )
                                        : themeController.isDarkMode.value
                                        ? AppColors.transparent
                                        : AppColors.white,
                                readOnly:
                                    toolController.serviceAmount.value > 0.0,
                                keyboardType: TextInputType.number,
                              );
                            }),
                            SizedBox(height: 20),
                            Obx(() {
                              if (toolController
                                  .dynamicFieldControllers
                                  .isNotEmpty) {
                                return Column(
                                  children:
                                      toolController
                                          .dynamicFieldControllers
                                          .entries
                                          .map((entry) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 20,
                                              ),
                                              child: CommonTextInputField(
                                                controller: entry.value,
                                                hintText: entry.key,
                                                keyboardType:
                                                    TextInputType.text,
                                              ),
                                            );
                                          })
                                          .toList(),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }),
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
                                    "${"payBill.tollSection.paymentDetails".trns()}:",
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
                                        "${"payBill.tollSection.amount".trns()}:",
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
                                              toolController
                                                  .amountController
                                                  .text
                                                  .isNotEmpty,
                                          child: Text(
                                            "${toolController.amountText.value.isEmpty ? "0" : toolController.amountText.value} ${toolController.serviceCurrency.value}",
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
                                        "${"payBill.tollSection.charge".trns()}:",
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
                                        () => Text(
                                          toolController.chargeText.value,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                            color: AppColors.error,
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
                                        "${"payBill.tollSection.conversionRate".trns()}:",
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
                                        () => Text(
                                          toolController.rateText.value,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 11,
                                            color:
                                                themeController.isDarkMode.value
                                                    ? AppColors.darkTextPrimary
                                                    : AppColors.textPrimary,
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
                                        "${"payBill.tollSection.payableAmount".trns()}:",
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
                                              toolController
                                                  .amountController
                                                  .text
                                                  .isNotEmpty,
                                          child: Text(
                                            "${toolController.payableAmount.value.toStringAsFixed(2).toString()} ${toolController.siteCurrency.value}",
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
                                        "payBill.tollSection.submit".trns(),
                                    onPressed: () {
                                      if (toolController
                                              .countryController
                                              .text
                                              .isNotEmpty &&
                                          toolController
                                              .serviceController
                                              .text
                                              .isNotEmpty &&
                                          toolController
                                              .amountController
                                              .text
                                              .isNotEmpty) {
                                        final homeCtrl =
                                            Get.find<HomeController>();
                                        final userPasscode =
                                            homeCtrl.userModel.value.passcode;

                                        if (userPasscode == null) {
                                          toolController.submitPayBill();
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
                                                toolController.submitPayBill();
                                              },
                                            ),
                                          );
                                        } else {
                                          toolController.submitPayBill();
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              "payBill.tollSection.common.requiredField2"
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
                  Obx(
                    () => Visibility(
                      visible: toolController.isSubmitLoading.value,
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
}
