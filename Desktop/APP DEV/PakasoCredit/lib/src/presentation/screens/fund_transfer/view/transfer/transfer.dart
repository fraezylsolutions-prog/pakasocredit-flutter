import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/styles/app_styles.dart';
import 'package:pakaso_credit/src/common/controller/banks_controller.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/theme/theme_controller.dart';
import 'package:pakaso_credit/src/common/widgets/common_elevated_button.dart';
import 'package:pakaso_credit/src/common/widgets/common_enter_amount_text_field.dart';
import 'package:pakaso_credit/src/common/widgets/common_loading.dart';
import 'package:pakaso_credit/src/common/widgets/common_text_input_field.dart';
import 'package:pakaso_credit/src/common/widgets/dropdown_bottom_sheet/common_dropdown_bottom_sheet.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/controller/transfer_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/model/wallets_model.dart';
import 'package:pakaso_credit/src/presentation/widgets/confirm_passcode_pop_up.dart';
import 'package:pakaso_credit/src/utils/extensions/translation_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Transfer extends StatefulWidget {
  final WalletsData? selectedWallet;
  final bool? preSelectWallet;

  const Transfer({super.key, this.selectedWallet, this.preSelectWallet});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  final ThemeController themeController = Get.find<ThemeController>();
  final TransferController transferController = Get.put(TransferController());
  final ConfirmPasscodeController passcodeController = Get.put(
    ConfirmPasscodeController(),
  );
  final BanksController banksController = Get.put(BanksController());

  @override
  void initState() {
    super.initState();
    transferController.clearFields();

    propsWiseLoadData();
    loadData();
  }

  Future<void> propsWiseLoadData() async {
    if (widget.preSelectWallet != null && widget.selectedWallet != null) {
      transferController.setSelectedWallet(widget.selectedWallet!);
      if (transferController.walletId.value != "0") {
        await transferController.fetchCurrencies();
      }
    }
  }

  Future<void> loadData() async {
    transferController.isLoading.value = true;
    await transferController.loadMultipleCurrencyBool();
    await passcodeController.loadPasscodeStatus(
      passcodeType: "fund_transfer_passcode_status",
    );
    if (transferController.isMultipleCurrency.value == "0") {
      await transferController.loadSiteCurrency();
      await transferController.loadMinFundTransfer();
      await transferController.loadMaxFundTransfer();
    }
    if (transferController.isSendMoney.value) {
      await banksController.fetchBanks();
      await transferController.fetchBeneficiaryByBankID();
      final matchBank = banksController.banksList.firstWhere(
        (item) =>
            item.id.toString() == transferController.sendMoneyBankId.value,
      );
      final matchBeneficiary = transferController.beneficiaryList.firstWhere(
        (item) =>
            item.id.toString() ==
            transferController.sendMoneyBeneficiaryId.toString(),
      );
      transferController.bankCharge.value = matchBank.charge?.toString() ?? "";
      transferController.bankId.value = matchBank.id?.toString() ?? "";
      transferController.bank.value = matchBank.name ?? "";
      transferController.bankController.text = matchBank.name ?? "";
      transferController.processingTime.value =
          matchBank.processingTime?.toString() ?? "";
      transferController.minimumTransfer.value =
          matchBank.minimumTransfer?.toString() ?? "";
      transferController.maximumTransfer.value =
          matchBank.maximumTransfer?.toString() ?? "";
      transferController.chargeType.value =
          matchBank.chargeType?.toString() ?? "";
      transferController.beneficiaryId.value =
          matchBeneficiary.id?.toString() ?? "";
      transferController.beneficiaryController.clear();
      List<String> formattedBeneficiaries =
          transferController.beneficiaryList.map((item) {
            String accountNumber = item.accountNumber ?? "";
            String lastFourDigits =
                accountNumber.length >= 4
                    ? accountNumber.substring(accountNumber.length - 4)
                    : accountNumber;
            return "${item.accountName}****$lastFourDigits";
          }).toList();
      String selectedFormattedBeneficiary = formattedBeneficiaries.firstWhere((
        formatted,
      ) {
        int index = formattedBeneficiaries.indexOf(formatted);
        return transferController.beneficiaryList[index].id.toString() ==
            transferController.sendMoneyBeneficiaryId.toString();
      });
      if (selectedFormattedBeneficiary.isNotEmpty) {
        transferController.beneficiaryController.text =
            selectedFormattedBeneficiary;
        transferController.accountNameAndNumber.value =
            selectedFormattedBeneficiary;
      }
      transferController.isSendMoney.value = false;
    } else {
      await banksController.fetchBanks();
    }

    if (transferController.isMultipleCurrency.value == "1") {
      if (widget.preSelectWallet == null && widget.selectedWallet == null) {
        await transferController.fetchWallets();
      }
    }

    transferController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (transferController.isLoading.value) {
        return Expanded(child: const CommonLoading());
      }

      return Expanded(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.only(left: 18, right: 18, top: 18),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
                gradient: AppStyles.linearGradient(),
                boxShadow: AppStyles.boxShadow(),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextInputField(
                          textFontWeight: FontWeight.w600,
                          controller: transferController.bankController,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          onTap: () {
                            Get.bottomSheet(
                              CommonDropdownBottomSheet(
                                title:
                                    "fundTransfer.transfer.labels.selectBank"
                                        .trns(),
                                onValueSelected: (value) async {
                                  int index = banksController.banksList
                                      .indexWhere(
                                        (item) =>
                                            item.name ==
                                            transferController.bank.value,
                                      );
                                  if (index != -1) {
                                    transferController.bankCharge.value =
                                        banksController.banksList[index].charge
                                            .toString();
                                    transferController.bankId.value =
                                        banksController.banksList[index].id
                                            .toString();
                                    transferController.processingTime.value =
                                        banksController
                                            .banksList[index]
                                            .processingTime
                                            .toString();
                                    transferController.minimumTransfer.value =
                                        banksController
                                            .banksList[index]
                                            .minimumTransfer
                                            .toString();
                                    transferController.maximumTransfer.value =
                                        banksController
                                            .banksList[index]
                                            .maximumTransfer
                                            .toString();
                                    transferController.chargeType.value =
                                        banksController
                                            .banksList[index]
                                            .chargeType
                                            .toString();
                                    await transferController
                                        .fetchBeneficiaryByBankID();
                                    transferController.onAmountChange();
                                    transferController.beneficiaryId.value = "";
                                  }
                                },
                                selectedValue:
                                    banksController.banksList
                                        .map((item) => item.name!)
                                        .toList(),
                                dropdownItems:
                                    banksController.banksList
                                        .map((item) => item.name!)
                                        .toList(),
                                selectedItem: transferController.bank,
                                textController:
                                    transferController.bankController,
                                currentlySelectedValue:
                                    transferController.bank.value,
                                bottomSheetHeight: 400,
                              ),
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "fundTransfer.transfer.validators.fieldRequired"
                                  .trns();
                            }
                            return null;
                          },
                          hintText:
                              "fundTransfer.transfer.labels.selectBank".trns(),
                          showSuffixIcon: true,
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: Color(0xFF68686A),
                          ),
                        ),
                        Obx(
                          () => Visibility(
                            visible: transferController.bank.value.isNotEmpty,
                            child: Text(
                              "${"fundTransfer.transfer.info.chargePercentage".trns()} ${transferController.bankCharge.value} %",
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
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonTextInputField(
                          textFontWeight: FontWeight.w600,
                          controller: transferController.beneficiaryController,
                          keyboardType: TextInputType.none,
                          readOnly: true,
                          onTap: () {
                            List<String> formattedBeneficiaries =
                                transferController.beneficiaryList.map((item) {
                                  String accountNumber =
                                      item.accountNumber ?? "";
                                  String lastFourDigits =
                                      accountNumber.length >= 4
                                          ? accountNumber.substring(
                                            accountNumber.length - 4,
                                          )
                                          : accountNumber;
                                  return "${item.accountName}****$lastFourDigits";
                                }).toList();

                            Get.bottomSheet(
                              CommonDropdownBottomSheet(
                                title:
                                    "fundTransfer.transfer.labels.selectBeneficiary"
                                        .trns(),
                                onValueSelected: (value) async {
                                  int index = formattedBeneficiaries.indexOf(
                                    value,
                                  );
                                  if (index != -1) {
                                    final selectedBeneficiary =
                                        transferController
                                            .beneficiaryList[index];
                                    transferController.beneficiaryId.value = "";
                                    transferController.beneficiaryId.value =
                                        selectedBeneficiary.id.toString();
                                    transferController.accountNumberController
                                        .clear();
                                    transferController.nameOnAccountController
                                        .clear();
                                    transferController.branchNameController
                                        .clear();
                                  }
                                },
                                selectedValue: formattedBeneficiaries,
                                dropdownItems: formattedBeneficiaries,
                                selectedItem:
                                    transferController.accountNameAndNumber,
                                textController:
                                    transferController.beneficiaryController,
                                currentlySelectedValue:
                                    transferController
                                        .accountNameAndNumber
                                        .value,
                                bottomSheetHeight: 400,
                              ),
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "fundTransfer.transfer.validators.fieldRequired"
                                  .trns();
                            }
                            return null;
                          },
                          hintText:
                              "fundTransfer.transfer.labels.selectBeneficiary"
                                  .trns(),
                          showSuffixIcon: true,
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: Color(0xFF68686A),
                          ),
                        ),
                        Obx(
                          () => Visibility(
                            visible: transferController.bank.value.isNotEmpty,
                            child: Text(
                              transferController.processingTime.value,
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
                    Visibility(
                      visible:
                          transferController.isMultipleCurrency.value == "1",
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          CommonTextInputField(
                            textFontWeight: FontWeight.w600,
                            controller: transferController.walletController,
                            keyboardType: TextInputType.none,
                            readOnly: true,
                            onTap: () {
                              Get.bottomSheet(
                                CommonDropdownBottomSheet(
                                  title:
                                      "fundTransfer.transfer.labels.selectWallet"
                                          .trns(),
                                  onValueSelected: (value) async {
                                    int index = transferController.walletsList
                                        .indexWhere(
                                          (item) =>
                                              item.name ==
                                              transferController.wallet.value,
                                        );
                                    if (index != -1) {
                                      transferController.walletCode.value =
                                          transferController
                                              .walletsList[index]
                                              .code
                                              .toString();
                                      transferController.walletId.value =
                                          transferController
                                              .walletsList[index]
                                              .id
                                              .toString();
                                      if (transferController.walletId.value !=
                                          "0") {
                                        await transferController
                                            .fetchCurrencies();
                                      }
                                    }
                                  },
                                  selectedValue:
                                      transferController.walletsList
                                          .map((item) => item.name!)
                                          .toList(),
                                  dropdownItems:
                                      transferController.walletsList
                                          .map((item) => item.name!)
                                          .toList(),
                                  selectedItem: transferController.wallet,
                                  textController:
                                      transferController.walletController,
                                  currentlySelectedValue:
                                      transferController.wallet.value,
                                  bottomSheetHeight: 400,
                                ),
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "fundTransfer.transfer.validators.fieldRequired"
                                    .trns();
                              }
                              return null;
                            },
                            hintText:
                                "fundTransfer.transfer.labels.selectWallet"
                                    .trns(),
                            showSuffixIcon: true,
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Color(0xFF68686A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => Visibility(
                        visible:
                            transferController.accountNameAndNumber.isEmpty,
                        child: Column(
                          children: [
                            SizedBox(height: 16),
                            CommonTextInputField(
                              onChanged: (value) async {
                                transferController.accountNumber.value = "";
                                transferController.accountNumber.value = value;
                                if (transferController
                                    .accountNumber
                                    .value
                                    .isNotEmpty) {
                                  await transferController
                                      .fetchGetUserAccountById();
                                  transferController.branchNameController.text =
                                      transferController
                                          .userAccountModel
                                          .value
                                          .data!
                                          .branchName ??
                                      "";
                                  transferController
                                      .nameOnAccountController
                                      .text = transferController
                                          .userAccountModel
                                          .value
                                          .data!
                                          .name ??
                                      "";
                                }
                              },
                              controller:
                                  transferController.accountNumberController,
                              hintText:
                                  "fundTransfer.transfer.labels.accountNumber"
                                      .trns(),
                              keyboardType: TextInputType.text,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonEnterAmountTextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            transferController.amount.value = value;
                            transferController.onAmountChange();
                          },
                          currencyCode:
                              transferController.isMultipleCurrency.value == "1"
                                  ? transferController.walletCode.value
                                  : transferController.siteCurrency.value,
                          controller: transferController.enterAmountController,
                          hintText:
                              "fundTransfer.transfer.labels.enterAmount".trns(),
                        ),
                        Obx(
                          () => Visibility(
                            visible: transferController.bank.value.isNotEmpty,
                            child:
                                transferController.walletId.value == "0"
                                    ? Text(
                                      "fundTransfer.transfer.info.minMaxAmount"
                                          .trnsFormat({
                                            "min_range":
                                                "${transferController.isMultipleCurrency.value == "1" ? transferController.minimumTransfer.value : transferController.minFundTransfer.value} ${transferController.isMultipleCurrency.value == "1" ? transferController.walletCode.value : transferController.siteCurrency.value}",
                                            "max_range":
                                                "${transferController.isMultipleCurrency.value == "1" ? transferController.maximumTransfer.value : transferController.maximumTransfer.value} ${transferController.isMultipleCurrency.value == "1" ? transferController.walletCode.value : transferController.siteCurrency.value}",
                                          }),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.error,
                                        fontSize: 10,
                                      ),
                                    )
                                    : Text(
                                      "fundTransfer.transfer.info.minMaxAmount"
                                          .trnsFormat({
                                            "min_range":
                                                "${transferController.isMultipleCurrency.value == "1" ? transferController.minimumTransferLocal.value : transferController.minFundTransfer.value} ${transferController.isMultipleCurrency.value == "1" ? transferController.walletCode.value : transferController.siteCurrency.value}",
                                            "max_range":
                                                "${transferController.isMultipleCurrency.value == "1" ? transferController.maximumTransferLocal.value : transferController.maximumTransfer.value} ${transferController.isMultipleCurrency.value == "1" ? transferController.walletCode.value : transferController.siteCurrency.value}",
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
                    SizedBox(height: 16),
                    Obx(
                      () => Visibility(
                        visible:
                            transferController.accountNameAndNumber.isEmpty,
                        child: CommonTextInputField(
                          controller:
                              transferController.nameOnAccountController,
                          hintText:
                              "fundTransfer.transfer.labels.nameOnAccount"
                                  .trns(),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    if (transferController.accountNameAndNumber.isEmpty)
                      SizedBox(height: 16),
                    Obx(
                      () => Visibility(
                        visible:
                            transferController.accountNameAndNumber.isEmpty,
                        child: CommonTextInputField(
                          controller: transferController.branchNameController,
                          hintText:
                              "fundTransfer.transfer.labels.branchName".trns(),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                    if (transferController.accountNameAndNumber.isEmpty)
                      SizedBox(height: 16),
                    CommonTextInputField(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      controller:
                          transferController.purposeOfTransferController,
                      height: null,
                      maxLines: 4,
                      hintText:
                          "fundTransfer.transfer.labels.purposeOfTransfer"
                              .trns(),
                      keyboardType: TextInputType.text,
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
                            "fundTransfer.transfer.labels.transferReviewDetails"
                                .trns(),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
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
                                    : Color(0xFF000000).withValues(alpha: 0.10),
                            height: 0,
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "fundTransfer.transfer.labels.amount".trns(),
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
                                  visible: transferController.amount.isNotEmpty,
                                  child: Text(
                                    "${transferController.amount.value.isNotEmpty ? double.tryParse(transferController.amount.value)?.toStringAsFixed(1) : "0"} ${transferController.isMultipleCurrency.value == "1" ? transferController.walletCode.value : transferController.siteCurrency.value}",
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
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "fundTransfer.transfer.labels.charge".trns(),
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
                                  visible: transferController.bank.isNotEmpty,
                                  child: Text(
                                    "${transferController.chargeAmount.value == 0.0 ? "0" : transferController.chargeAmount.value.toStringAsFixed(1)} ${transferController.isMultipleCurrency.value == "1" ? transferController.walletCode.value : transferController.siteCurrency.value}",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "fundTransfer.transfer.labels.bankName".trns(),
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
                                  visible: transferController.bank.isNotEmpty,
                                  child: Text(
                                    transferController.bank.value.isNotEmpty
                                        ? transferController.bank.value
                                        : "",
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
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "fundTransfer.transfer.labels.total".trns(),
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
                                  visible: transferController.bank.isNotEmpty,
                                  child: Text(
                                    "${transferController.totalAmount.value == 0.0 ? "0" : transferController.totalAmount.value.toStringAsFixed(1)} ${transferController.isMultipleCurrency.value == "1" ? transferController.walletCode.value : transferController.siteCurrency.value}",
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
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "fundTransfer.transfer.labels.transferableAmount"
                                    .trns(),
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
                                  visible: transferController.bank.isNotEmpty,
                                  child: Text(
                                    "${transferController.payAmount.value.isNotEmpty ? double.tryParse(transferController.payAmount.value)?.toStringAsFixed(1) : "0"} ${transferController.isMultipleCurrency.value == "1" ? transferController.walletCode.value : transferController.siteCurrency.value}",
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
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          CommonElevatedButton(
                            buttonName:
                                "fundTransfer.transfer.button.submit".trns(),
                            onPressed: () {
                              final homeCtrl = Get.find<HomeController>();
                              final userPasscode =
                                  homeCtrl.userModel.value.passcode;

                              if (userPasscode == null) {
                                transferController.submitTransfer();
                                return;
                              }

                              final needsPasscode =
                                  passcodeController.passcodeStatus.value ==
                                      "1" ||
                                  passcodeController.passcodeStatus.value ==
                                      "null";

                              if (needsPasscode) {
                                Get.dialog(
                                  ConfirmPasscodePopUp(
                                    controller:
                                        passcodeController.passcodeController,
                                    onPressed: () async {
                                      final ok =
                                          await passcodeController
                                              .submitPasscodeVerify();
                                      if (!ok) return;
                                      Get.back();
                                      transferController.submitTransfer();
                                    },
                                  ),
                                );
                              } else {
                                transferController.submitTransfer();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: transferController.isTransferSubmitLoading.value,
                child: CommonLoading(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
