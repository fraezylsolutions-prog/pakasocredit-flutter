import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/model/fdr_details_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FdrDetailsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString siteCurrency = "".obs;
  final increaseAmountController = TextEditingController();
  final decreaseAmountController = TextEditingController();
  final Rx<FdrDetailsModel> fdrDetailsModel = FdrDetailsModel().obs;

  Future<void> fetchFdrDetails({required String fdrId}) async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.fdrEndpoint}/details/$fdrId",
      );
      if (response.status == Status.completed) {
        fdrDetailsModel.value = FdrDetailsModel.fromJson(response.data!);
      }
    } finally {}
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }

  Future<void> increaseFdr({required String id, required String fdrId}) async {
    try {
      final Map<String, String> requestBody = {
        "increase_amount": increaseAmountController.text,
        "id": id,
      };

      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.fdrEndpoint}/increase",
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        increaseAmountController.clear();
        await fetchFdrDetails(fdrId: fdrId);
      } else {
        increaseAmountController.clear();
      }
    } finally {}
  }

  Future<void> decreaseFdr({required String id, required String fdrId}) async {
    try {
      final Map<String, String> requestBody = {
        "decrease_amount": decreaseAmountController.text,
        "id": id,
      };

      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.fdrEndpoint}/decrease",
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        decreaseAmountController.clear();
        await fetchFdrDetails(fdrId: fdrId);
      } else {
        decreaseAmountController.clear();
      }
    } finally {}
  }
}
