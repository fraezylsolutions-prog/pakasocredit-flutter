import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/model/loan_details_model.dart';
import 'package:get/get.dart';

class LoanDetailsController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<LoanDetailsModel> loanDetailsModel = LoanDetailsModel().obs;

  Future<void> fetchLoanDetails({required String loanId}) async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.loanEndpoint}/details/$loanId",
      );
      if (response.status == Status.completed) {
        loanDetailsModel.value = LoanDetailsModel.fromJson(response.data!);
      }
    } finally {}
  }
}
