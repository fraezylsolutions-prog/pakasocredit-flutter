import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/model/currencies_model.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/model/beneficiary_model.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/model/user_account_model.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/sub_sections/dynamic_fund_transfer_success.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/model/wallets_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class TransferController extends GetxController {
  final RxBool isSendMoney = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isTransferSubmitLoading = false.obs;
  final RxString bankCharge = "".obs;
  final RxString bankId = "".obs;
  final RxString sendMoneyBankId = "".obs;
  final RxString sendMoneyBeneficiaryId = "".obs;
  final RxString bank = "".obs;
  final RxString wallet = "".obs;
  final RxString walletId = "".obs;
  final RxString beneficiaryId = "".obs;
  final RxString accountNameAndNumber = "".obs;
  final RxString processingTime = "".obs;
  final RxString minimumTransfer = "".obs;
  final RxString maximumTransfer = "".obs;
  final RxString walletCode = "".obs;
  final RxDouble currencyRate = 0.0.obs;
  final RxString amount = "".obs;
  final RxString chargeType = "".obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxDouble chargeAmount = 0.0.obs;
  final RxString payAmount = "".obs;
  final RxString accountNumber = "".obs;
  final RxString isMultipleCurrency = "".obs;
  final RxString siteCurrency = "".obs;
  final RxString minFundTransfer = "".obs;
  final RxString maxFundTransfer = "".obs;
  final RxList<BeneficiaryData> beneficiaryList = <BeneficiaryData>[].obs;
  final bankController = TextEditingController();
  final beneficiaryController = TextEditingController();
  final walletController = TextEditingController();
  final enterAmountController = TextEditingController();
  final accountNumberController = TextEditingController();
  final nameOnAccountController = TextEditingController();
  final branchNameController = TextEditingController();
  final purposeOfTransferController = TextEditingController();
  final RxList<WalletsData> walletsList = <WalletsData>[].obs;
  final RxList<CurrenciesData> currenciesList = <CurrenciesData>[].obs;
  final Rx<UserAccountModel> userAccountModel = UserAccountModel().obs;
  final RxString minimumTransferLocal = "".obs;
  final RxString maximumTransferLocal = "".obs;

  Future<void> loadMultipleCurrencyBool() async {
    final multipleCurrencyValue = await SettingsService.getSettingValue(
      "multiple_currency",
    );
    isMultipleCurrency.value = multipleCurrencyValue ?? "";
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }

  Future<void> loadMinFundTransfer() async {
    final minFundTransferValue = await SettingsService.getSettingValue(
      "min_fund_transfer",
    );
    minFundTransfer.value = minFundTransferValue ?? "";
  }

  Future<void> loadMaxFundTransfer() async {
    final maxFundTransferValue = await SettingsService.getSettingValue(
      "max_fund_transfer",
    );
    maxFundTransfer.value = maxFundTransferValue ?? "";
  }

  Future<void> fetchBeneficiaryByBankID() async {
    clearBeneficiary();
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint:
            "${ApiPath.beneficiaryEndpoint}?bank_id=${isSendMoney.value ? sendMoneyBankId : bankId}",
      );
      if (response.status == Status.completed) {
        final beneficiaryModel = BeneficiaryModel.fromJson(response.data!);
        beneficiaryList.clear();
        beneficiaryList.assignAll(beneficiaryModel.data!);
      }
    } finally {}
  }

  Future<void> fetchGetUserAccountById() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.getAccountEndpoint}/${accountNumber.value}",
      );
      if (response.status == Status.completed) {
        userAccountModel.value = UserAccountModel.fromJson(response.data!);
      }
    } finally {}
  }

  Future<void> fetchWallets() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.walletsEndpoint,
      );

      if (response.status == Status.completed) {
        final walletsModel = WalletsModel.fromJson(response.data!);
        walletsList.clear();
        walletsList.assignAll(walletsModel.data!);
        if (walletsList.isNotEmpty) {
          wallet.value = walletsList.first.name ?? "";
          walletController.text = walletsList.first.name ?? "";
          walletCode.value = walletsList.first.code ?? "";
          walletId.value = walletsList.first.id.toString();
        }
      }
    } finally {}
  }

  Future<void> fetchCurrencies() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.currenciesEndpoint,
      );
      if (response.status == Status.completed) {
        final currenciesModel = CurrenciesModel.fromJson(response.data!);
        currenciesList.clear();
        currenciesList.assignAll(currenciesModel.data!);
        final matchingCurrency = currenciesList.firstWhere(
          (currency) => currency.code == walletCode.value,
        );
        currencyRate.value = 0.0;
        currencyRate.value = matchingCurrency.rate ?? 0.0;

        calculateRateWiseAmount();
      }
    } finally {}
  }

  void calculateRateWiseAmount() {
    final minAmount = double.tryParse(minimumTransfer.value) ?? 0;
    final maxAmount = double.tryParse(maximumTransfer.value) ?? 0;

    minimumTransferLocal.value = (minAmount * currencyRate.value)
        .toStringAsFixed(2);
    maximumTransferLocal.value = (maxAmount * currencyRate.value)
        .toStringAsFixed(2);
  }

  void onAmountChange() {
    final amountText = enterAmountController.text;
    final amountValue = double.tryParse(amountText) ?? 0;
    amount.value = amountValue.toStringAsFixed(2);
    final charge =
        chargeType.value == 'percentage'
            ? calculatePercentage(
              amountValue,
              double.tryParse(bankCharge.value) ?? 0,
            )
            : double.tryParse(bankCharge.value) ?? 0;
    chargeAmount.value = charge;
    totalAmount.value = amountValue + charge;
    payAmount.value = amountValue.toStringAsFixed(2);
  }

  Future<void> submitTransfer() async {
    isTransferSubmitLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "amount": enterAmountController.text,
        "bank_id": bankId.value,
        "beneficiary_id":
            beneficiaryId.value.isNotEmpty ? beneficiaryId.value : null,
        if (isMultipleCurrency.value == "1")
          "wallet_type": walletId.value == "0" ? "default" : walletId.value,

        if (accountNameAndNumber.isEmpty)
          "manual_data": {
            "account_name": nameOnAccountController.text,
            "branch_name": branchNameController.text,
            "account_number": accountNumberController.text,
          },
        "purpose":
            purposeOfTransferController.text.isNotEmpty
                ? purposeOfTransferController.text
                : "",
      };
      final response = await Get.find<NetworkService>().post(
        endpoint: ApiPath.transferEndpoint,
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        clearFields();
        Get.find<NavigationController>().pushPage(
          DynamicFundTransferSuccess(
            amount: response.data?["data"]["amount"] ?? 0,
            accountNumber: response.data?["data"]["account"] ?? "N/A",
            transactionId: response.data?["data"]["tnx"] ?? "N/A",
            currency: response.data?["data"]["currency"] ?? "N/A",
            title: "Fund Transfer Successfully!",
            isAccountVisible: true,
            isCurrencyVisible: true,
          ),
        );
      }
    } finally {
      isTransferSubmitLoading.value = false;
    }
  }

  double calculatePercentage(double amount, double percentage) {
    return amount * (percentage / 100);
  }

  void clearBeneficiary() {
    beneficiaryController.clear();
    accountNameAndNumber.value = "";
  }

  void setSelectedWallet(WalletsData walletData) {
    wallet.value = walletData.name ?? "";
    walletController.text = walletData.name ?? "";
    walletCode.value = walletData.code ?? "";
    walletId.value = walletData.id.toString();
  }

  void clearFields() {
    bankCharge.value = "";
    bankId.value = "";
    bank.value = "";
    amount.value = "";
    chargeAmount.value = 0.0;
    totalAmount.value = 0.0;
    payAmount.value = "";
    accountNameAndNumber.value = "";
    processingTime.value = "";
    minimumTransfer.value = "";
    maximumTransfer.value = "";
    currencyRate.value = 0.0;
    amount.value = "";
    chargeType.value = "";
    totalAmount.value = 0.0;
    chargeAmount.value = 0.0;
    payAmount.value = "";
    bankController.clear();
    beneficiaryController.clear();
    enterAmountController.clear();
    minimumTransferLocal.value = "";
    maximumTransferLocal.value = "";
    accountNumberController.clear();
    nameOnAccountController.clear();
    branchNameController.clear();
    purposeOfTransferController.clear();
    beneficiaryId.value = "";
  }
}
