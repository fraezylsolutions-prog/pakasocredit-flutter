import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/referral/model/referral_tree_model.dart';
import 'package:get/get.dart';

class ReferralTreeController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<ReferralTreeModel> referralTreeModel = ReferralTreeModel().obs;

  @override
  void onInit() {
    super.onInit();
    fetchReferralTree();
  }

  Future<void> fetchReferralTree() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.referralEndpoint}/tree",
      );
      if (response.status == Status.completed) {
        referralTreeModel.value = ReferralTreeModel();
        referralTreeModel.value = ReferralTreeModel.fromJson(response.data!);
      } else {
        referralTreeModel.value = ReferralTreeModel();
      }
    } finally {
      isLoading.value = false;
    }
  }
}
