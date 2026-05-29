import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/model/wire_transfer_settings_model.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/view/sub_sections/dynamic_fund_transfer_success.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class WireTransferController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isWireTransferLoading = false.obs;
  final RxString siteCurrency = "".obs;
  final RxMap<String, dynamic> formData = <String, dynamic>{}.obs;
  final amountController = TextEditingController();
  final Rx<WireTransferSettingsModel> wireTransferSettingsModel =
      WireTransferSettingsModel().obs;

  Future<void> fetchWireTransferSettings() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.wireTransferSettingsEndpoint,
      );
      if (response.status == Status.completed) {
        wireTransferSettingsModel.value = WireTransferSettingsModel.fromJson(
          response.data!,
        );
      }
    } finally {}
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }

  Future<void> submitWireTransfer() async {
    isWireTransferLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "data": formData,
        "amount": amountController.text,
      };
      final response = await Get.find<NetworkService>().post(
        endpoint: ApiPath.wireTransferEndpoint,
        data: requestBody,
      );

      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        Get.find<NavigationController>().pushPage(
          DynamicFundTransferSuccess(
            amount: response.data?["data"]["amount"] ?? 0,
            accountNumber: "N/A",
            transactionId: response.data?["data"]["tnx"] ?? "N/A",
            currency: "N/A",
            title: "Wire Transfer Successfully!",
            isCurrencyVisible: false,
            isAccountVisible: false,
          ),
        );
      }
    } finally {
      isWireTransferLoading.value = false;
    }
  }

  void setFormData(String fieldName, dynamic value) {
    formData[fieldName] = value;
  }
}
