import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/referral/model/referred_friends_model.dart';
import 'package:get/get.dart';

class ReferredFriendsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<ReferredFriendsData> referredFriendsList =
      <ReferredFriendsData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReferredFriends();
  }

  Future<void> fetchReferredFriends() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.referralEndpoint}/direct",
      );
      if (response.status == Status.completed) {
        final referredFriendsModel = ReferredFriendsModel.fromJson(
          response.data!,
        );
        referredFriendsList.clear();
        referredFriendsList.assignAll(referredFriendsModel.data!);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
