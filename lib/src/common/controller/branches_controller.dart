import 'package:pakaso_credit/src/common/model/branches_model.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:get/get.dart';

class BranchesController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<BranchesData> branchesList = <BranchesData>[].obs;

  Future<void> loadBranches() async {
    isLoading.value = true;
    await fetchBranches();
    isLoading.value = false;
  }

  Future<void> fetchBranches() async {
    try {
      final response = await Get.find<NetworkService>().globalGet(
        endpoint: ApiPath.branchesEndpoint,
      );
      if (response.status == Status.completed) {
        final BranchesModel jsonResponse = BranchesModel.fromJson(
          response.data!,
        );
        branchesList.clear();
        branchesList.assignAll(jsonResponse.data!);
      }
    } finally {}
  }
}
