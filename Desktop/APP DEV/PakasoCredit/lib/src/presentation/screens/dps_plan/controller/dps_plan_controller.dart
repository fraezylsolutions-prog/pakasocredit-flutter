import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/model/dps_plan_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DpsPlanController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSubscriptionLoading = false.obs;
  final RxString siteCurrency = "".obs;
  final RxInt selectedCheckbox = (-1).obs;
  final RxList<DpsPlanData> dpsPlanList = <DpsPlanData>[].obs;
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
      passcodeType: "dps_passcode_status",
    );
    await loadSiteCurrency();
    await fetchDpsPlans();
    isLoading.value = false;
  }

  Future<void> fetchDpsPlans() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.dpsEndpoint,
      );
      if (response.status == Status.completed) {
        final dpsPlanModel = DpsPlanModel.fromJson(response.data!);
        dpsPlanList.clear();
        dpsPlanList.assignAll(dpsPlanModel.data!);
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
      final Map<String, String> requestBody = {"plan_id": planId};

      final response = await Get.find<NetworkService>().post(
        endpoint: ApiPath.dpsEndpoint,
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        Get.find<NavigationController>().pushNamed(BaseRoute.dpsPlanList);
      }
    } finally {
      isSubscriptionLoading.value = false;
    }
  }
}
