import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/setting/model/id_verification/kyc_history_model.dart';
import 'package:get/get.dart';

class KycHistoryController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<KycHistoryData> kycHistoryList = <KycHistoryData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchKycHistory();
  }

  Future<void> fetchKycHistory() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.kycEndpoint}-histories",
      );
      if (response.status == Status.completed) {
        final kycHistoryModel = KycHistoryModel.fromJson(response.data!);
        kycHistoryList.clear();
        kycHistoryList.assignAll(kycHistoryModel.data!);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
