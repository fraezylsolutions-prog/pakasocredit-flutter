import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/model/fdr_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FdrPlanController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSubscriptionLoading = false.obs;
  final RxString siteCurrency = "".obs;
  final RxInt selectedCheckbox = (-1).obs;
  final amountController = TextEditingController();
  final RxList<FdrPlanData> fdrPlanList = <FdrPlanData>[].obs;
  final ConfirmPasscodeController passcodeController = Get.put(
    ConfirmPasscodeController(),
  );

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await passcodeController.loadPasscodeStatus(
      passcodeType: "fdr_passcode_status",
    );
    await loadSiteCurrency();
    await fetchFdrPlans();
    isLoading.value = false;
  }

  Future<void> fetchFdrPlans() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.fdrEndpoint,
      );
      if (response.status == Status.completed) {
        final fdrPlanModel = FdrPlanModel.fromJson(response.data!);
        fdrPlanList.clear();
        fdrPlanList.assignAll(fdrPlanModel.data!);
      }
    } finally {}
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }

  Future<void> submitSubscribe({required String planId}) async {
    isSubscriptionLoading.value = true;
    try {
      final Map<String, String> requestBody = {
        "plan_id": planId,
        "amount": amountController.text,
      };

      final response = await Get.find<NetworkService>().post(
        endpoint: ApiPath.fdrEndpoint,
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        amountController.clear();
        Get.find<NavigationController>().pushNamed(BaseRoute.fdrPlanList);
      } else {
        amountController.clear();
      }
    } finally {
      isSubscriptionLoading.value = false;
    }
  }
}
