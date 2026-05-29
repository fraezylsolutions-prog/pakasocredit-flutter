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
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/air_time_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/pay_bill_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/model/bill_countries_model.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/bill_payment_history/bill_payment_history.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Airtime extends StatefulWidget {
  final String type;

  const Airtime({super.key, required this.type});

  @override
  State<Airtime> createState() => _AirtimeState();
}

class _AirtimeState extends State<Airtime> {
  final ThemeController themeController = Get.find<ThemeController>();
  final AirTimeController airTimeController = Get.put(AirTimeController());
  final ConfirmPasscodeController passcodeController = Get.put(
    ConfirmPasscodeController(),
  );
  final PayBillController payBillController = Get.find<PayBillController>();

  @override
  void initState() {
    super.initState();
    payBillController.billCountriesModel.value = BillCountriesModel();
    airTimeController.clearFields();
    airTimeController.countryController.clear();
    loadData();
  }

  Future<void> loadData() async {
    airTimeController.isLoading.value = true;
    await payBillController.fetchBillCountries(type: widget.type);
    await airTimeController.loadSiteCurrency();
    await passcodeController.loadPasscodeStatus(
      passcodeType: "pay_bill_passcode_status",
    );
    airTimeController.isLoading.value = false;
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
              title: "payBill.airtimeSection.title".trns(),
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
                    if (airTimeController.isLoading.value) {
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
                              controller: airTimeController.countryController,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTap: () {
                                Get.bottomSheet(
                                  CommonDropdownBottomSheet(
                                    title:
                                        "payBill.airtimeSection.selectCountry"
                                            .trns(),
                                    onValueSelected: (value) async {
                                      airTimeController.amountController
                                          .clear();
                                      airTimeController.serviceId.value = "";
                                      airTimeController.serviceCurrency.value =
                                          "";
                                      airTimeController.serviceRate.value = 0.0;
                                      airTimeController.serviceAmount.value =
                                          0.0;
                                      airTimeController.serviceCharge.value =
                                          0.0;
                                      airTimeController.rateText.value = "";
                                      airTimeController.chargeText.value = "";
                                      airTimeController.dynamicFieldControllers
                                          .clear();
                                      airTimeController.payBillServiceList
                                          .clear();
                                      airTimeController.payableAmount.value =
                                          0.00;
                                      await airTimeController
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
                                    selectedItem: airTimeController.country,
                                    textController:
                                        airTimeController.countryController,
                                    currentlySelectedValue:
                                        airTimeController.country.value,
                                    bottomSheetHeight: 400,
                                  ),
                                );
                              },
                              hintText:
                                  "payBill.airtimeSection.selectCountry".trns(),
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
                              controller: airTimeController.serviceController,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTap: () {
                                Get.bottomSheet(
                                  CommonDropdownBottomSheetThree(
                                    title:
                                        "payBill.airtimeSection.selectService"
                                            .trns(),
                                    onValueSelected: (value) async {
                                      final serviceId = int.parse(value);
                                      final selectedService = airTimeController
                                          .getServiceById(serviceId);
                                      airTimeController.amountController
                                          .clear();
                                      airTimeController.amountText.value = "";
                                      if (selectedService != null) {
                                        airTimeController.serviceId.value =
                                            value;
                                        airTimeController
                                            .selectedService
                                            .value = selectedService;
                                        airTimeController
                                            .serviceController
                                            .text = selectedService.name ?? "";
                                        airTimeController.setupDynamicFields(
                                          selectedService.fields,
                                        );
                                        airTimeController.serviceRate.value =
                                            selectedService.rate?.toDouble() ??
                                            0;
                                        airTimeController.serviceAmount.value =
                                            selectedService.amount
                                                ?.toDouble() ??
                                            0.0;
                                        airTimeController.serviceCharge.value =
                                            selectedService.charge
                                                ?.toDouble() ??
                                            0.0;
                                        airTimeController
                                            .serviceCurrency
                                            .value = "";
                                        airTimeController
                                                .serviceCurrency
                                                .value =
                                            selectedService.currency.toString();
                                        airTimeController
                                                .serviceChargeType
                                                .value =
                                            selectedService.chargeType ?? "";
                                        airTimeController
                                            .calculatePaymentDetails();
                                      }
                                    },
                                    selectedValue:
                                        airTimeController.payBillServiceList
                                            .asMap()
                                            .entries
                                            .map((entry) => "${entry.value.id}")
                                            .toList(),
                                    dropdownItems:
                                        airTimeController.payBillServiceList
                                            .map((item) => item.name ?? "")
                                            .toList(),
                                    selectedItem: airTimeController.serviceId,
                                    textController:
                                        airTimeController.serviceController,
                                    currentlySelectedValue:
                                        airTimeController.serviceId.value,
                                    bottomSheetHeight: 400,
                                  ),
                                );
                              },
                              hintText:
                                  "payBill.airtimeSection.selectService".trns(),
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
                                if (airTimeController.serviceAmount.value > 0) {
                                  airTimeController.amountController.text =
                                      airTimeController.serviceAmount.value
                                          .toInt()
                                          .toString();
                                  airTimeController.amountText.value =
                                      airTimeController.amountController.text;
                                  airTimeController.calculatePaymentDetails();
                                }
                              });

                              return CommonEnterAmountTextField(
                                hintText:
                                    "payBill.airtimeSection.amount".trns(),
                                currencyBackgroundColor:
                                    airTimeController.serviceAmount.value > 0.0
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
                                    airTimeController
                                            .serviceCurrency
                                            .value
                                            .isNotEmpty
                                        ? 0
                                        : 10,
                                topRightBorderRadius:
                                    airTimeController
                                            .serviceCurrency
                                            .value
                                            .isNotEmpty
                                        ? 0
                                        : 10,
                                onChanged: (value) {
                                  airTimeController.amountText.value =
                                      airTimeController.amountController.text;

                                  airTimeController.calculatePaymentDetails();
                                },
                                isCurrencyVisible:
                                    airTimeController
                                        .serviceCurrency
                                        .value
                                        .isNotEmpty,
                                currencyCode:
                                    airTimeController.serviceCurrency.value,
                                controller: airTimeController.amountController,
                                backgroundColor:
                                    airTimeController.serviceAmount.value > 0.0
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
                                    airTimeController.serviceAmount.value > 0.0,
                                keyboardType: TextInputType.number,
                              );
                            }),
                            SizedBox(height: 20),
                            Obx(() {
                              if (airTimeController
                                  .dynamicFieldControllers
                                  .isNotEmpty) {
                                return Column(
                                  children:
                                      airTimeController
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
                                    "${"payBill.airtimeSection.paymentDetails".trns()}:",
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
                                        "${"payBill.airtimeSection.amount".trns()}:",
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
                                              airTimeController
                                                  .amountController
                                                  .text
                                                  .isNotEmpty,
                                          child: Text(
                                            "${airTimeController.amountText.value.isEmpty ? "0" : airTimeController.amountText.value} ${airTimeController.serviceCurrency.value}",
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
                                        "${"payBill.airtimeSection.charge".trns()}:",
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
                                          airTimeController.chargeText.value,
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
                                        "${"payBill.airtimeSection.conversionRate".trns()}:",
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
                                          airTimeController.rateText.value,
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
                                        "${"payBill.airtimeSection.payableAmount".trns()}:",
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
                                              airTimeController
                                                  .amountController
                                                  .text
                                                  .isNotEmpty,
                                          child: Text(
                                            "${airTimeController.payableAmount.value.toStringAsFixed(2).toString()} ${airTimeController.siteCurrency.value}",
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
                                        "payBill.airtimeSection.submit".trns(),
                                    onPressed: () {
                                      if (airTimeController
                                              .countryController
                                              .text
                                              .isNotEmpty &&
                                          airTimeController
                                              .serviceController
                                              .text
                                              .isNotEmpty &&
                                          airTimeController
                                              .amountController
                                              .text
                                              .isNotEmpty) {
                                        final homeCtrl =
                                            Get.find<HomeController>();
                                        final userPasscode =
                                            homeCtrl.userModel.value.passcode;

                                        if (userPasscode == null) {
                                          airTimeController.submitPayBill();
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
                                                airTimeController
                                                    .submitPayBill();
                                              },
                                            ),
                                          );
                                        } else {
                                          airTimeController.submitPayBill();
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              "payBill.airtimeSection.common.requiredField2"
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
                      visible: airTimeController.isSubmitLoading.value,
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
