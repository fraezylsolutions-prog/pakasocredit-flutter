import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/withdraw/model/account_list_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class WithdrawAccountController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<AccountListData> accountList = <AccountListData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.withdrawAccountEndpoint,
      );
      if (response.status == Status.completed) {
        final accountListModel = AccountListModel.fromJson(response.data!);
        accountList.clear();
        accountList.assignAll(accountListModel.data!);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount({required String accountId}) async {
    try {
      final response = await Get.find<NetworkService>().delete(
        endpoint: "${ApiPath.withdrawAccountEndpoint}/$accountId",
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await fetchAccounts();
      }
    } finally {}
  }
}
