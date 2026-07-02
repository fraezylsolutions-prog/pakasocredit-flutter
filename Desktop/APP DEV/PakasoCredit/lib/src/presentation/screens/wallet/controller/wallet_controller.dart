import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/wallet/model/wallets_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isVisibleBalance = true.obs;
  final RxList<WalletsData> walletsList = <WalletsData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWallets();
  }

  Future<void> fetchWallets() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.walletsEndpoint,
      );

      if (response.status == Status.completed) {
        final walletsModel = WalletsModel.fromJson(response.data!);
        walletsList.clear();
        walletsList.value = walletsModel.data ?? [];
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteWallet({required walletId}) async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().delete(
        endpoint: "${ApiPath.walletsEndpoint}/$walletId",
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await fetchWallets();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void toggleVisibleBalance() {
    isVisibleBalance.value = !isVisibleBalance.value;
  }
}
