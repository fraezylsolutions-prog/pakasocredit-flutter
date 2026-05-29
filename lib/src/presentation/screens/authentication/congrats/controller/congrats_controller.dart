import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:get/get.dart';

class CongratsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> settingsData = <String, dynamic>{}.obs;

  Future<void> fetchSettings() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().globalGet(
        endpoint: ApiPath.settingsEndpoint(endPointType: "signup_bonus"),
      );
      if (response.status == Status.completed) {
        settingsData.assignAll(response.data!);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
