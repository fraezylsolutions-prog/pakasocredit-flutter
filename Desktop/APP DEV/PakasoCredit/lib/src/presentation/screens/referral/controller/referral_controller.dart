import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/referral/model/referral_info_model.dart';
import 'package:get/get.dart';

class ReferralController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<ReferralInfoModel> referralInfoModel = ReferralInfoModel().obs;

  Future<void> fetchReferralInfo() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.referralEndpoint}/info",
      );
      if (response.status == Status.completed) {
        referralInfoModel.value = ReferralInfoModel();
        referralInfoModel.value = ReferralInfoModel.fromJson(response.data!);
      } else {
        referralInfoModel.value = ReferralInfoModel();
      }
    } finally {
      isLoading.value = false;
    }
  }
}
