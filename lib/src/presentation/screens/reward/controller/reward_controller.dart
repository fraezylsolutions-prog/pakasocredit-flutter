import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/reward/model/reward_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RewardController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isRedeemNowLoading = false.obs;
  final Rx<RewardModel> rewardModel = RewardModel().obs;
  final RxList<Earnings> earningList = <Earnings>[].obs;
  final RxList<Redeems> redeemsList = <Redeems>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRewards();
  }

  Future<void> fetchRewards() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.rewardsEndpoint,
      );
      if (response.status == Status.completed) {
        rewardModel.value = RewardModel();
        rewardModel.value = RewardModel.fromJson(response.data!);
        earningList.clear();
        earningList.assignAll(rewardModel.value.data!.earnings!);
        redeemsList.clear();
        redeemsList.assignAll(rewardModel.value.data!.redeems!);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitRedeemNow() async {
    isRedeemNowLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.rewardsEndpoint}/redeem",
        data: null,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await fetchRewards();
      }
    } finally {
      isRedeemNowLoading.value = false;
    }
  }
}
