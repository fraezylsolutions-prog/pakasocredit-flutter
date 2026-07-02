import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/deposit/controller/deposit_controller.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepositWalletAndGatewaySection extends StatelessWidget {
  final DepositController depositController;

  const DepositWalletAndGatewaySection({
    super.key,
    required this.depositController,
  });

  @override
  Widget build(BuildContext context) {
    final DepositController depositController = Get.find<DepositController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: depositController.isMultipleCurrency.value == "1",
          child: Column(
            children: [
              CommonTextInputField(
                textFontWeight: FontWeight.w600,
                controller: depositController.walletController,
                keyboardType: TextInputType.none,
                readOnly: true,
                onTap: () {
                  Get.bottomSheet(
                    CommonDropdownBottomSheet(
                      title: "deposit.wallet.select_title".trns(),
                      onValueSelected: (value) async {
                        int index = depositController.walletsList.indexWhere(
                          (item) => item.name == value,
                        );

                        if (index != -1) {
                          depositController.walletId.value =
                              depositController.walletsList[index].id
                                  ?.toString() ??
                              "";
                          depositController.currencyCode.value =
                              depositController.walletsList[index].code
                                  ?.toString() ??
                              "";
                          depositController.depositMethodsList.clear();

                          await depositController.fetchDepositMethods();

                          depositController.gateway.value = "";
                          depositController.gatewayCode.value = "";
                          depositController.gatewayController.clear();
                          depositController.gatewayCharge.value = "";
                          depositController.maximumDeposit.value = "";
                          depositController.minimumDeposit.value = "";
                        }
                      },
                      selectedValue:
                          depositController.walletsList
                              .map((item) => item.name.toString())
                              .toList(),
                      dropdownItems:
                          depositController.walletsList
                              .map((item) => item.name.toString())
                              .toList(),
                      selectedItem: depositController.wallet,
                      textController: depositController.walletController,
                      currentlySelectedValue: depositController.wallet.value,
                      bottomSheetHeight: 400,
                    ),
                  );
                },
                hintText: "deposit.wallet.hint".trns(),
                showSuffixIcon: true,
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Colors.grey.withValues(alpha: 0.8),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextInputField(
              textFontWeight: FontWeight.w600,
              controller: depositController.gatewayController,
              keyboardType: TextInputType.none,
              readOnly: true,
              onTap: () {
                Get.bottomSheet(
                  CommonDropdownBottomSheet(
                    title: "deposit.gateway.select_title".trns(),
                    onValueSelected: (value) async {
                      int index = depositController.depositMethodsList
                          .indexWhere((item) => item.name == value);

                      if (index != -1) {
                        depositController.gatewayCode.value =
                            depositController
                                .depositMethodsList[index]
                                .gatewayCode
                                ?.toString() ??
                            "";
                        depositController.paymentType.value =
                            depositController.depositMethodsList[index].type
                                ?.toString() ??
                            "";
                        depositController.gatewayCharge.value =
                            depositController.depositMethodsList[index].charge
                                ?.toString() ??
                            "";
                        depositController.minimumDeposit.value =
                            depositController
                                .depositMethodsList[index]
                                .minimumDeposit
                                ?.toString() ??
                            "";
                        depositController.maximumDeposit.value =
                            depositController
                                .depositMethodsList[index]
                                .maximumDeposit
                                ?.toString() ??
                            "";
                        depositController.chargeType.value =
                            depositController
                                .depositMethodsList[index]
                                .chargeType
                                ?.toString() ??
                            "";
                        depositController.paymentDetails.value =
                            depositController
                                .depositMethodsList[index]
                                .paymentDetails
                                ?.toString() ??
                            "";
                        depositController.gatewayLogo.value =
                            depositController
                                .depositMethodsList[index]
                                .gatewayLogo
                                ?.toString() ??
                            "";
                        depositController.gatewayFieldOptions.value =
                            depositController
                                        .depositMethodsList[index]
                                        .fieldOptions !=
                                    null
                                ? depositController
                                    .depositMethodsList[index]
                                    .fieldOptions
                                    .toString()
                                : "";
                        depositController.paymentDetails.value =
                            depositController
                                    .depositMethodsList[index]
                                    .paymentDetails ??
                            "";
                        depositController.isGatewayRate.value =
                            depositController.depositMethodsList[index].rate ??
                            0;
                        depositController.gatewayCurrencyCode.value =
                            depositController.depositMethodsList[index].currency
                                ?.toString() ??
                            "";
                        depositController.onAmountChange();
                      }
                    },
                    selectedValue:
                        depositController.depositMethodsList
                            .map((item) => item.name.toString())
                            .toList(),
                    dropdownItems:
                        depositController.depositMethodsList
                            .map((item) => item.name.toString())
                            .toList(),
                    selectedItem: depositController.gateway,
                    textController: depositController.gatewayController,
                    currentlySelectedValue: depositController.gateway.value,
                    bottomSheetHeight: 400,
                  ),
                );
              },
              hintText: "deposit.gateway.hint".trns(),
              showSuffixIcon: true,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: Colors.grey.withValues(alpha: 0.8),
              ),
            ),
            Obx(
              () => Visibility(
                visible: depositController.gateway.value.isNotEmpty,
                child: Text(
                  "${"deposit.gateway.charge".trns()} ${depositController.gatewayCharge.value} %",
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
      ],
    );
  }
}
