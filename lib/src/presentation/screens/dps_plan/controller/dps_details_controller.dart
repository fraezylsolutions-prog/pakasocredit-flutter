import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/model/dps_details_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DpsDetailsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString siteCurrency = "".obs;
  final increaseAmountController = TextEditingController();
  final decreaseAmountController = TextEditingController();
  final Rx<DpsDetailsModel> dpsDetailsModel = DpsDetailsModel().obs;

  Future<void> fetchDpsDetails({required String dpsId}) async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.dpsEndpoint}/details/$dpsId",
      );
      if (response.status == Status.completed) {
        dpsDetailsModel.value = DpsDetailsModel.fromJson(response.data!);
      }
    } finally {}
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }

  Future<void> increaseDps({required String id, required String dpsId}) async {
    try {
      final Map<String, String> requestBody = {
        "increase_amount": increaseAmountController.text,
        "id": id,
      };

      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.dpsEndpoint}/increase",
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        increaseAmountController.clear();
        await fetchDpsDetails(dpsId: dpsId);
      } else {
        increaseAmountController.clear();
      }
    } finally {}
  }

  Future<void> decreaseDps({required String id, required String dpsId}) async {
    try {
      final Map<String, String> requestBody = {
        "decrease_amount": decreaseAmountController.text,
        "id": id,
      };

      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.dpsEndpoint}/decrease",
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        decreaseAmountController.clear();
        await fetchDpsDetails(dpsId: dpsId);
      } else {
        decreaseAmountController.clear();
      }
    } finally {}
  }
}
