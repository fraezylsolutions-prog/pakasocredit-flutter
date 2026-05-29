import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/controller/withdraw_history_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/model/account_list_model.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/view/withdraw_history/withdraw_history.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class WithdrawMoneyController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isWithdrawMoneyLoading = false.obs;
  final RxString account = "".obs;
  final RxString accountId = "".obs;
  final RxString methodType = "".obs;
  final RxString minWithdraw = "".obs;
  final RxString maxWithdraw = "".obs;
  final RxString paymentMethodIcon = "".obs;
  final RxString methodTime = "".obs;
  final RxString siteCurrency = "".obs;
  final RxString accountCurrency = "".obs;
  final RxList<AccountListData> accountList = <AccountListData>[].obs;
  final accountController = TextEditingController();
  final enterAmountController = TextEditingController();
  final RxString amount = "".obs;
  final RxString chargeType = "".obs;
  final RxString accountCharge = "".obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxDouble chargeAmount = 0.0.obs;
  final RxDouble payAmount = 0.0.obs;
  final RxDouble accountRate = 0.0.obs;

  Future<void> fetchAccounts() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.withdrawAccountEndpoint,
      );
      if (response.status == Status.completed) {
        final accountListModel = AccountListModel.fromJson(response.data!);
        accountList.clear();
        accountList.assignAll(accountListModel.data!);
      }
    } finally {}
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }

  Future<void> submitWithdrawMoney() async {
    isWithdrawMoneyLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "amount": enterAmountController.text,
        "withdraw_account_id": accountId.value,
      };
      final response = await Get.find<NetworkService>().post(
        endpoint: ApiPath.withdrawEndpoint,
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        resetFields();
        Get.find<NavigationController>().pushPage(WithdrawHistory());
        final WithdrawHistoryController withdrawHistoryController = Get.put(
          WithdrawHistoryController(),
        );
        await withdrawHistoryController.fetchWithdrawHistory();
      }
    } finally {
      isWithdrawMoneyLoading.value = false;
    }
  }

  void onAmountChange() {
    final amountText = enterAmountController.text;
    final amountValue = double.tryParse(amountText) ?? 0;
    amount.value = amountValue.toStringAsFixed(2);
    final charge =
        chargeType.value == 'percentage'
            ? calculatePercentage(
              amountValue,
              double.tryParse(accountCharge.value) ?? 0,
            )
            : double.tryParse(accountCharge.value) ?? 0;
    chargeAmount.value = charge;
    totalAmount.value = amountValue + charge;
    payAmount.value = totalAmount * accountRate.value;
  }

  double calculatePercentage(double amount, double percentage) {
    return amount * (percentage / 100);
  }

  void clearFields() {
    account.value = "";
    methodType.value = "";
    accountId.value = "";
    minWithdraw.value = "";
    maxWithdraw.value = "";
    paymentMethodIcon.value = "";
    methodTime.value = "";
    siteCurrency.value = "";
    accountCurrency.value = "";
    accountController.clear();
    enterAmountController.clear();
    amount.value = "";
    chargeType.value = "";
    accountCharge.value = "";
    totalAmount.value = 0.0;
    chargeAmount.value = 0.0;
    payAmount.value = 0.0;
    accountRate.value = 0.0;
  }

  void resetFields() {
    account.value = "";
    methodType.value = "";
    accountId.value = "";
    minWithdraw.value = "";
    maxWithdraw.value = "";
    paymentMethodIcon.value = "";
    methodTime.value = "";
    accountCurrency.value = "";
    accountController.clear();
    enterAmountController.clear();
    amount.value = "";
    chargeType.value = "";
    accountCharge.value = "";
    totalAmount.value = 0.0;
    chargeAmount.value = 0.0;
    payAmount.value = 0.0;
    accountRate.value = 0.0;
  }
}
