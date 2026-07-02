import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/fdr_plan/model/fdr_installment_list_model.dart';
import 'package:get/get.dart';

class FdrInstallmentListController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<FdrInstallmentListData> fdrInstallmentList =
      <FdrInstallmentListData>[].obs;

  Future<void> fetchFdrInstallmentList({required String fdrId}) async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.fdrEndpoint}/installments/$fdrId",
      );
      if (response.status == Status.completed) {
        final fdrInstallmentListModel = FdrInstallmentListModel.fromJson(
          response.data!,
        );
        fdrInstallmentList.clear();
        fdrInstallmentList.assignAll(fdrInstallmentListModel.data!);
      }
    } finally {}
  }
}
