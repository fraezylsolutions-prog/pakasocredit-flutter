import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/dps_plan/model/installment_list_model.dart';
import 'package:get/get.dart';

class InstallmentListController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString siteCurrency = "".obs;
  final RxList<InstallmentListData> installmentList =
      <InstallmentListData>[].obs;

  Future<void> fetchInstallmentList({required String dpsId}) async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.dpsEndpoint}/installments/$dpsId",
      );
      if (response.status == Status.completed) {
        final installmentListModel = InstallmentListModel.fromJson(
          response.data!,
        );
        installmentList.clear();
        installmentList.assignAll(installmentListModel.data!);
      }
    } finally {}
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }
}
