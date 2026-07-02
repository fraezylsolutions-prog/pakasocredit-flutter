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
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/cables_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/pay_bill_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/model/bill_countries_model.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/bill_payment_history/bill_payment_history.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Cables extends StatefulWidget {
  final String type;

  const Cables({super.key, required this.type});

  @override
  State<Cables> createState() => _CablesState();
}

class _CablesState extends State<Cables> {
  final ThemeController themeController = Get.find<ThemeController>();
  final CablesController cablesController = Get.put(CablesController());
  final ConfirmPasscodeController passcodeController = Get.put(
    ConfirmPasscodeController(),
  );
  final PayBillController payBillController = Get.find<PayBillController>();

  @override
  void initState() {
    super.initState();
    payBillController.billCountriesModel.value = BillCountriesModel();
    cablesController.clearFields();
    cablesController.countryController.clear();
    loadData();
  }

  Future<void> loadData() async {
    cablesController.isLoading.value = true;
    await passcodeController.loadPasscodeStatus(
      passcodeType: "pay_bill_passcode_status",
    );
    await payBillController.fetchBillCountries(type: widget.type);
    await cablesController.loadSiteCurrency();
    cablesController.isLoading.value = false;
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
              title: "payBill.cablesSection.title".trns(),
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
                    if (cablesController.isLoading.value) {
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
                              controller: cablesController.countryController,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTap: () {
                                Get.bottomSheet(
                                  CommonDropdownBottomSheet(
                                    title:
                                        "payBill.cablesSection.selectCountry"
                                            .trns(),
                                    onValueSelected: (value) async {
                                      cablesController.amountController.clear();
                                      cablesController.serviceId.value = "";
                                      cablesController.serviceCurrency.value =
                                          "";
                                      cablesController.serviceRate.value = 0.0;
                                      cablesController.serviceAmount.value =
                                          0.0;
                                      cablesController.serviceCharge.value =
                                          0.0;
                                      cablesController.rateText.value = "";
                                      cablesController.chargeText.value = "";
                                      cablesController.dynamicFieldControllers
                                          .clear();
                                      cablesController.payBillServiceList
                                          .clear();
                                      cablesController.payableAmount.value =
                                          0.00;
                                      await cablesController
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
                                    selectedItem: cablesController.country,
                                    textController:
                                        cablesController.countryController,
                                    currentlySelectedValue:
                                        cablesController.country.value,
                                    bottomSheetHeight: 400,
                                  ),
                                );
                              },
                              hintText:
                                  "payBill.cablesSection.selectCountry".trns(),
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
                              controller: cablesController.serviceController,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTap: () {
                                Get.bottomSheet(
                                  CommonDropdownBottomSheetThree(
                                    title:
                                        "payBill.cablesSection.selectService"
                                            .trns(),
                                    onValueSelected: (value) async {
                                      final serviceId = int.parse(value);
                                      final selectedService = cablesController
                                          .getServiceById(serviceId);
                                      cablesController.amountController.clear();
                                      cablesController.amountText.value = "";
                                      if (selectedService != null) {
                                        cablesController.serviceId.value =
                                            value;
                                        cablesController.selectedService.value =
                                            selectedService;
                                        cablesController
                                            .serviceController
                                            .text = selectedService.name ?? "";
                                        cablesController.setupDynamicFields(
                                          selectedService.fields,
                                        );
                                        cablesController.serviceRate.value =
                                            selectedService.rate?.toDouble() ??
                                            0;
                                        cablesController.serviceAmount.value =
                                            selectedService.amount
                                                ?.toDouble() ??
                                            0.0;
                                        cablesController.serviceCharge.value =
                                            selectedService.charge
                                                ?.toDouble() ??
                                            0.0;
                                        cablesController.serviceCurrency.value =
                                            "";
                                        cablesController.serviceCurrency.value =
                                            selectedService.currency.toString();
                                        cablesController
                                                .serviceChargeType
                                                .value =
                                            selectedService.chargeType ?? "";
                                        cablesController
                                            .calculatePaymentDetails();
                                      }
                                    },
                                    selectedValue:
                                        cablesController.payBillServiceList
                                            .asMap()
                                            .entries
                                            .map((entry) => "${entry.value.id}")
                                            .toList(),
                                    dropdownItems:
                                        cablesController.payBillServiceList
                                            .map((item) => item.name ?? "")
                                            .toList(),
                                    selectedItem: cablesController.serviceId,
                                    textController:
                                        cablesController.serviceController,
                                    currentlySelectedValue:
                                        cablesController.serviceId.value,
                                    bottomSheetHeight: 400,
                                  ),
                                );
                              },
                              hintText:
                                  "payBill.cablesSection.selectService".trns(),
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
                                if (cablesController.serviceAmount.value > 0) {
                                  cablesController.amountController.text =
                                      cablesController.serviceAmount.value
                                          .toInt()
                                          .toString();
                                  cablesController.amountText.value =
                                      cablesController.amountController.text;
                                  cablesController.calculatePaymentDetails();
                                }
                              });

                              return CommonEnterAmountTextField(
                                hintText: "payBill.cablesSection.amount".trns(),
                                currencyBackgroundColor:
                                    cablesController.serviceAmount.value > 0.0
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
                                    cablesController
                                            .serviceCurrency
                                            .value
                                            .isNotEmpty
                                        ? 0
                                        : 10,
                                topRightBorderRadius:
                                    cablesController
                                            .serviceCurrency
                                            .value
                                            .isNotEmpty
                                        ? 0
                                        : 10,
                                onChanged: (value) {
                                  cablesController.amountText.value =
                                      cablesController.amountController.text;

                                  cablesController.calculatePaymentDetails();
                                },
                                isCurrencyVisible:
                                    cablesController
                                        .serviceCurrency
                                        .value
                                        .isNotEmpty,
                                currencyCode:
                                    cablesController.serviceCurrency.value,
                                controller: cablesController.amountController,
                                backgroundColor:
                                    cablesController.serviceAmount.value > 0.0
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
                                    cablesController.serviceAmount.value > 0.0,
                                keyboardType: TextInputType.number,
                              );
                            }),
                            SizedBox(height: 20),
                            Obx(() {
                              if (cablesController
                                  .dynamicFieldControllers
                                  .isNotEmpty) {
                                return Column(
                                  children:
                                      cablesController
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
                                    "${"payBill.cablesSection.paymentDetails".trns()}:",
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
                                        "${"payBill.cablesSection.amount".trns()}:",
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
                                              cablesController
                                                  .amountController
                                                  .text
                                                  .isNotEmpty,
                                          child: Text(
                                            "${cablesController.amountText.value.isEmpty ? "0" : cablesController.amountText.value} ${cablesController.serviceCurrency.value}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                              color:
                                                  themeController
                                                          .isDarkMode
                                                          .value
                                                      ? AppColors
                                                          .darkTextTertiary
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
                                        "${"payBill.cablesSection.charge".trns()}:",
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
                                          cablesController.chargeText.value,
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
                                        "${"payBill.cablesSection.conversionRate".trns()}:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color:
                                              themeController.isDarkMode.value
                                                  ? AppColors.darkTextTertiary
                                                  : AppColors.textPrimary,
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          cablesController.rateText.value,
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
                                        "${"payBill.cablesSection.payableAmount".trns()}:",
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
                                              cablesController
                                                  .amountController
                                                  .text
                                                  .isNotEmpty,
                                          child: Text(
                                            "${cablesController.payableAmount.value.toStringAsFixed(2).toString()} ${cablesController.siteCurrency.value}",
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
                                        "payBill.cablesSection.submit".trns(),
                                    onPressed: () {
                                      if (cablesController
                                              .countryController
                                              .text
                                              .isNotEmpty &&
                                          cablesController
                                              .serviceController
                                              .text
                                              .isNotEmpty &&
                                          cablesController
                                              .amountController
                                              .text
                                              .isNotEmpty) {
                                        final homeCtrl =
                                            Get.find<HomeController>();
                                        final userPasscode =
                                            homeCtrl.userModel.value.passcode;

                                        if (userPasscode == null) {
                                          cablesController.submitPayBill();
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
                                                cablesController
                                                    .submitPayBill();
                                              },
                                            ),
                                          );
                                        } else {
                                          cablesController.submitPayBill();
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              "payBill.cablesSection.common.requiredField2"
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
                      visible: cablesController.isSubmitLoading.value,
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
