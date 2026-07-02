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
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/internet_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/pay_bill_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/model/bill_countries_model.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/bill_payment_history/bill_payment_history.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Internet extends StatefulWidget {
  final String type;

  const Internet({super.key, required this.type});

  @override
  State<Internet> createState() => _InternetState();
}

class _InternetState extends State<Internet> {
  final ThemeController themeController = Get.find<ThemeController>();
  final InternetController internetController = Get.put(InternetController());
  final ConfirmPasscodeController passcodeController = Get.put(
    ConfirmPasscodeController(),
  );
  final PayBillController payBillController = Get.find<PayBillController>();

  @override
  void initState() {
    super.initState();
    payBillController.billCountriesModel.value = BillCountriesModel();
    internetController.clearFields();
    internetController.countryController.clear();
    loadData();
  }

  Future<void> loadData() async {
    internetController.isLoading.value = true;
    await payBillController.fetchBillCountries(type: widget.type);
    await internetController.loadSiteCurrency();
    await passcodeController.loadPasscodeStatus(
      passcodeType: "pay_bill_passcode_status",
    );
    internetController.isLoading.value = false;
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
              title: "payBill.internetSection.title".trns(),
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
                    if (internetController.isLoading.value) {
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
                              controller: internetController.countryController,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTap: () {
                                Get.bottomSheet(
                                  CommonDropdownBottomSheet(
                                    title:
                                        "payBill.internetSection.selectCountry"
                                            .trns(),
                                    onValueSelected: (value) async {
                                      internetController.amountController
                                          .clear();
                                      internetController.serviceId.value = "";
                                      internetController.serviceCurrency.value =
                                          "";
                                      internetController.serviceRate.value =
                                          0.0;
                                      internetController.serviceAmount.value =
                                          0.0;
                                      internetController.serviceCharge.value =
                                          0.0;
                                      internetController.rateText.value = "";
                                      internetController.chargeText.value = "";
                                      internetController.dynamicFieldControllers
                                          .clear();
                                      internetController.payBillServiceList
                                          .clear();
                                      internetController.payableAmount.value =
                                          0.00;
                                      await internetController
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
                                    selectedItem: internetController.country,
                                    textController:
                                        internetController.countryController,
                                    currentlySelectedValue:
                                        internetController.country.value,
                                    bottomSheetHeight: 400,
                                  ),
                                );
                              },
                              hintText:
                                  "payBill.internetSection.selectCountry"
                                      .trns(),
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
                              controller: internetController.serviceController,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTap: () {
                                Get.bottomSheet(
                                  CommonDropdownBottomSheetThree(
                                    title:
                                        "payBill.internetSection.selectService"
                                            .trns(),
                                    onValueSelected: (value) async {
                                      final serviceId = int.parse(value);
                                      final selectedService = internetController
                                          .getServiceById(serviceId);
                                      internetController.amountController
                                          .clear();
                                      internetController.amountText.value = "";
                                      if (selectedService != null) {
                                        internetController.serviceId.value =
                                            value;
                                        internetController
                                            .selectedService
                                            .value = selectedService;
                                        internetController
                                            .serviceController
                                            .text = selectedService.name ?? "";
                                        internetController.setupDynamicFields(
                                          selectedService.fields,
                                        );
                                        internetController.serviceRate.value =
                                            selectedService.rate?.toDouble() ??
                                            0;
                                        internetController.serviceAmount.value =
                                            selectedService.amount
                                                ?.toDouble() ??
                                            0.0;
                                        internetController.serviceCharge.value =
                                            selectedService.charge
                                                ?.toDouble() ??
                                            0.0;
                                        internetController
                                            .serviceCurrency
                                            .value = "";
                                        internetController
                                                .serviceCurrency
                                                .value =
                                            selectedService.currency.toString();
                                        internetController
                                                .serviceChargeType
                                                .value =
                                            selectedService.chargeType ?? "";
                                        internetController
                                            .calculatePaymentDetails();
                                      }
                                    },
                                    selectedValue:
                                        internetController.payBillServiceList
                                            .asMap()
                                            .entries
                                            .map((entry) => "${entry.value.id}")
                                            .toList(),
                                    dropdownItems:
                                        internetController.payBillServiceList
                                            .map((item) => item.name ?? "")
                                            .toList(),
                                    selectedItem: internetController.serviceId,
                                    textController:
                                        internetController.serviceController,
                                    currentlySelectedValue:
                                        internetController.serviceId.value,
                                    bottomSheetHeight: 400,
                                  ),
                                );
                              },
                              hintText:
                                  "payBill.internetSection.selectService"
                                      .trns(),
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
                                if (internetController.serviceAmount.value >
                                    0) {
                                  internetController.amountController.text =
                                      internetController.serviceAmount.value
                                          .toInt()
                                          .toString();
                                  internetController.amountText.value =
                                      internetController.amountController.text;
                                  internetController.calculatePaymentDetails();
                                }
                              });

                              return CommonEnterAmountTextField(
                                hintText:
                                    "payBill.internetSection.amount".trns(),
                                currencyBackgroundColor:
                                    internetController.serviceAmount.value > 0.0
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
                                    internetController
                                            .serviceCurrency
                                            .value
                                            .isNotEmpty
                                        ? 0
                                        : 10,
                                topRightBorderRadius:
                                    internetController
                                            .serviceCurrency
                                            .value
                                            .isNotEmpty
                                        ? 0
                                        : 10,
                                onChanged: (value) {
                                  internetController.amountText.value =
                                      internetController.amountController.text;

                                  internetController.calculatePaymentDetails();
                                },
                                isCurrencyVisible:
                                    internetController
                                        .serviceCurrency
                                        .value
                                        .isNotEmpty,
                                currencyCode:
                                    internetController.serviceCurrency.value,
                                controller: internetController.amountController,
                                backgroundColor:
                                    internetController.serviceAmount.value > 0.0
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
                                    internetController.serviceAmount.value >
                                    0.0,
                                keyboardType: TextInputType.number,
                              );
                            }),
                            SizedBox(height: 20),
                            Obx(() {
                              if (internetController
                                  .dynamicFieldControllers
                                  .isNotEmpty) {
                                return Column(
                                  children:
                                      internetController
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
                                border: Border.all(color: Color(0xFFE6E6E6)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${"payBill.internetSection.paymentDetails".trns()}:",
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
                                        "${"payBill.internetSection.amount".trns()}:",
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
                                              internetController
                                                  .amountController
                                                  .text
                                                  .isNotEmpty,
                                          child: Text(
                                            "${internetController.amountText.value.isEmpty ? "0" : internetController.amountText.value} ${internetController.serviceCurrency.value}",
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
                                        "${"payBill.internetSection.charge".trns()}:",
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
                                          internetController.chargeText.value,
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
                                        "${"payBill.internetSection.conversionRate".trns()}:",
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
                                          internetController.rateText.value,
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
                                        "${"payBill.internetSection.payableAmount".trns()}:",
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
                                              internetController
                                                  .amountController
                                                  .text
                                                  .isNotEmpty,
                                          child: Text(
                                            "${internetController.payableAmount.value.toStringAsFixed(2).toString()} ${internetController.siteCurrency.value}",
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
                                        "payBill.internetSection.submit".trns(),
                                    onPressed: () {
                                      if (internetController
                                              .countryController
                                              .text
                                              .isNotEmpty &&
                                          internetController
                                              .serviceController
                                              .text
                                              .isNotEmpty &&
                                          internetController
                                              .amountController
                                              .text
                                              .isNotEmpty) {
                                        final homeCtrl =
                                            Get.find<HomeController>();
                                        final userPasscode =
                                            homeCtrl.userModel.value.passcode;

                                        if (userPasscode == null) {
                                          internetController.submitPayBill();
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
                                                internetController
                                                    .submitPayBill();
                                              },
                                            ),
                                          );
                                        } else {
                                          internetController.submitPayBill();
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              "payBill.internetSection.common.requiredField2"
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
                      visible: internetController.isSubmitLoading.value,
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
