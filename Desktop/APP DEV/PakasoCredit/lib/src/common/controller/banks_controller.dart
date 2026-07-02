import 'package:pakaso_credit/src/common/model/banks_model.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:get/get.dart';

class BanksController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<BanksData> banksList = <BanksData>[].obs;

  Future<void> loadBanks() async {
    isLoading.value = true;
    await fetchBanks();
    isLoading.value = false;
  }

  Future<void> fetchBanks() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.banksEndpoint,
      );
      if (response.status == Status.completed) {
        final BanksModel jsonResponse = BanksModel.fromJson(response.data!);
        banksList.clear();
        banksList.assignAll(jsonResponse.data!);
      }
    } finally {}
  }
}
