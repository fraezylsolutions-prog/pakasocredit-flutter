import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/controller/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CreateNewWalletController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isCreateWalletLoading = false.obs;
  final RxString currency = "".obs;
  final RxString currencyId = "".obs;
  final currencyController = TextEditingController();

  Future<void> createWallet() async {
    isCreateWalletLoading.value = true;
    try {
      final Map<String, String> requestBody = {"currency_id": currencyId.value};
      final response = await Get.find<NetworkService>().post(
        endpoint: ApiPath.walletsEndpoint,
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        clearFields();
        Get.find<NavigationController>().popPage();
        Get.find<WalletController>().fetchWallets();
      }
    } finally {
      isCreateWalletLoading.value = false;
    }
  }

  void clearFields() {
    currency.value = "";
    currencyId.value = "";
    currencyController.clear();
  }

  @override
  void onClose() {
    super.onClose();
    currencyController.dispose();
  }
}
