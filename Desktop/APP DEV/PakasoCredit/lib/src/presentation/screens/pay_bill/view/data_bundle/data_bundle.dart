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
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/data_bundle_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/controller/pay_bill_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/model/bill_countries_model.dart';
import 'package:pakaso_credit/src/presentation/screens/pay_bill/view/bill_payment_history/bill_payment_history.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DataBundle extends StatefulWidget {
  final String type;

  const DataBundle({super.key, required this.type});

  @override
  State<DataBundle> createState() => _DataBundleState();
}

class _DataBundleState extends State<DataBundle> {
  final ThemeController themeController = Get.find<ThemeController>();
  final DataBundleController dataBundleController = Get.put(
    DataBundleController(),
  );
  final ConfirmPasscodeController passcodeController = Get.put(
    ConfirmPasscodeController(),
  );
  final PayBillController payBillController = Get.find<PayBillController>();

  @override
  void initState() {
    super.initState();
    payBillController.billCountriesModel.value = BillCountriesModel();
    dataBundleController.clearFields();
    dataBundleController.countryController.clear();
    loadData();
  }

  Future<void> loadData() async {
    dataBundleController.isLoading.value = true;
    await payBillController.fetchBillCountries(type: widget.type);
    await dataBundleController.loadSiteCurrency();
    await passcodeController.loadPasscodeStatus(
      passcodeType: "pay_bill_passcode_status",
    );
    dataBundleController.isLoading.value = false;
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
              title: "payBill.dataBundleSection.title".trns(),
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
                    if (dataBundleController.isLoading.value) {
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
                              controller:
                                  dataBundleController.countryController,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTap: () {
                                Get.bottomSheet(
                                  CommonDropdownBottomSheet(
                                    title:
                                        "payBill.dataBundleSection.selectCountry"
                                            .trns(),
                                    onValueSelected: (value) async {
                                      dataBundleController.amountController
                                          .clear();
                                      dataBundleController.serviceId.value = "";
                                      dataBundleController
                                          .serviceCurrency
                                          .value = "";
                                      dataBundleController.serviceRate.value =
                                          0.0;
                                      dataBundleController.serviceAmount.value =
                                          0.0;
                                      dataBundleController.serviceCharge.value =
                                          0.0;
                                      dataBundleController.rateText.value = "";
                                      dataBundleController.chargeText.value =
                                          "";
                                      dataBundleController
                                          .dynamicFieldControllers
                                          .clear();
                                      dataBundleController.payBillServiceList
                                          .clear();
                                      dataBundleController.payableAmount.value =
                                          0.00;
                                      await dataBundleController
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
                                    selectedItem: dataBundleController.country,
                                    textController:
                                        dataBundleController.countryController,
                                    currentlySelectedValue:
                                        dataBundleController.country.value,
                                    bottomSheetHeight: 400,
                                  ),
                                );
                              },
                              hintText:
                                  "payBill.dataBundleSection.selectCountry"
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
                              controller:
                                  dataBundleController.serviceController,
                              keyboardType: TextInputType.none,
                              readOnly: true,
                              onTap: () {
                                Get.bottomSheet(
                                  CommonDropdownBottomSheetThree(
                                    title:
                                        "payBill.dataBundleSection.selectService"
                                            .trns(),
                                    onValueSelected: (value) async {
                                      final serviceId = int.parse(value);
                                      final selectedService =
                                          dataBundleController.getServiceById(
                                            serviceId,
                                          );
                                      dataBundleController.amountController
                                          .clear();
                                      dataBundleController.amountText.value =
                                          "";
                                      if (selectedService != null) {
                                        dataBundleController.serviceId.value =
                                            value;
                                        dataBundleController
                                            .selectedService
                                            .value = selectedService;
                                        dataBundleController
                                            .serviceController
                                            .text = selectedService.name ?? "";
                                        dataBundleController.setupDynamicFields(
                                          selectedService.fields,
                                        );
                                        dataBundleController.serviceRate.value =
                                            selectedService.rate?.toDouble() ??
                                            0;
                                        dataBundleController
                                            .serviceAmount
                                            .value = selectedService.amount
                                                ?.toDouble() ??
                                            0.0;
                                        dataBundleController
                                            .serviceCharge
                                            .value = selectedService.charge
                                                ?.toDouble() ??
                                            0.0;
                                        dataBundleController
                                            .serviceCurrency
                                            .value = "";
                                        dataBundleController
                                                .serviceCurrency
                                                .value =
                                            selectedService.currency.toString();
                                        dataBundleController
                                                .serviceChargeType
                                                .value =
                                            selectedService.chargeType ?? "";
                                        dataBundleController
                                            .calculatePaymentDetails();
                                      }
                                    },
                                    selectedValue:
                                        dataBundleController.payBillServiceList
                                            .asMap()
                                            .entries
                                            .map((entry) => "${entry.value.id}")
                                            .toList(),
                                    dropdownItems:
                                        dataBundleController.payBillServiceList
                                            .map((item) => item.name ?? "")
                                            .toList(),
                                    selectedItem:
                                        dataBundleController.serviceId,
                                    textController:
                                        dataBundleController.serviceController,
                                    currentlySelectedValue:
                                        dataBundleController.serviceId.value,
                                    bottomSheetHeight: 400,
                                  ),
                                );
                              },
                              hintText:
                                  "payBill.dataBundleSection.selectService"
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
                                if (dataBundleController.serviceAmount.value >
                                    0) {
                                  dataBundleController.amountController.text =
                                      dataBundleController.serviceAmount.value
                                          .toInt()
                                          .toString();
                                  dataBundleController.amountText.value =
                                      dataBundleController
                                          .amountController
                                          .text;
                                  dataBundleController
                                      .calculatePaymentDetails();
                                }
                              });

                              return CommonEnterAmountTextField(
                                hintText:
                                    "payBill.dataBundleSection.amount".trns(),
                                currencyBackgroundColor:
                                    dataBundleController.serviceAmount.value >
                                            0.0
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
                                    dataBundleController
                                            .serviceCurrency
                                            .value
                                            .isNotEmpty
                                        ? 0
                                        : 10,
                                topRightBorderRadius:
                                    dataBundleController
                                            .serviceCurrency
                                            .value
                                            .isNotEmpty
                                        ? 0
                                        : 10,

                                onChanged: (value) {
                                  dataBundleController.amountText.value =
                                      dataBundleController
                                          .amountController
                                          .text;

                                  dataBundleController
                                      .calculatePaymentDetails();
                                },
                                isCurrencyVisible:
                                    dataBundleController
                                        .serviceCurrency
                                        .value
                                        .isNotEmpty,
                                currencyCode:
                                    dataBundleController.serviceCurrency.value,
                                controller:
                                    dataBundleController.amountController,
                                backgroundColor:
                                    dataBundleController.serviceAmount.value >
                                            0.0
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
                                    dataBundleController.serviceAmount.value >
                                    0.0,
                                keyboardType: TextInputType.number,
                              );
                            }),
                            SizedBox(height: 20),
                            Obx(() {
                              if (dataBundleController
                                  .dynamicFieldControllers
                                  .isNotEmpty) {
                                return Column(
                                  children:
                                      dataBundleController
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
                                    "${"payBill.dataBundleSection.paymentDetails".trns()}:",
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
                                        "${"payBill.dataBundleSection.amount".trns()}:",
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
                                              dataBundleController
                                                  .amountController
                                                  .text
                                                  .isNotEmpty,
                                          child: Text(
                                            "${dataBundleController.amountText.value.isEmpty ? "0" : dataBundleController.amountText.value} ${dataBundleController.serviceCurrency.value}",
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
                                        "${"payBill.dataBundleSection.charge".trns()}:",
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
                                          dataBundleController.chargeText.value,
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
                                        "${"payBill.dataBundleSection.conversionRate".trns()}:",
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
                                          dataBundleController.rateText.value,
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
                                        "${"payBill.dataBundleSection.payableAmount".trns()}:",
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
                                              dataBundleController
                                                  .amountController
                                                  .text
                                                  .isNotEmpty,
                                          child: Text(
                                            "${dataBundleController.payableAmount.value.toStringAsFixed(2).toString()} ${dataBundleController.siteCurrency.value}",
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
                                        "payBill.dataBundleSection.submit"
                                            .trns(),
                                    onPressed: () {
                                      if (dataBundleController
                                              .countryController
                                              .text
                                              .isNotEmpty &&
                                          dataBundleController
                                              .serviceController
                                              .text
                                              .isNotEmpty &&
                                          dataBundleController
                                              .amountController
                                              .text
                                              .isNotEmpty) {
                                        final homeCtrl =
                                            Get.find<HomeController>();
                                        final userPasscode =
                                            homeCtrl.userModel.value.passcode;

                                        if (userPasscode == null) {
                                          dataBundleController.submitPayBill();
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
                                                dataBundleController
                                                    .submitPayBill();
                                              },
                                            ),
                                          );
                                        } else {
                                          dataBundleController.submitPayBill();
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg:
                                              "payBill.dataBundleSection.common.requiredField2"
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
                      visible: dataBundleController.isSubmitLoading.value,
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
