import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/model/loan_installment_list_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoanInstallmentListController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSubmitInstallmentLoading = false.obs;
  final RxString siteCurrency = "".obs;
  final RxList<LoanInstallmentListData> loanInstallmentList =
      <LoanInstallmentListData>[].obs;

  Future<void> fetchLoanInstallmentList({required String loanId}) async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.loanEndpoint}/installments/$loanId",
      );
      if (response.status == Status.completed) {
        final loanInstallmentListModel = LoanInstallmentListModel.fromJson(
          response.data!,
        );
        loanInstallmentList.clear();
        loanInstallmentList.assignAll(loanInstallmentListModel.data!);
      }
    } finally {}
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }

  Future<void> submitPayInstallment({
    String? installmentId,
    required String loanId,
    required bool isFullInstallmentPay,
  }) async {
    isSubmitInstallmentLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "trans_id": isFullInstallmentPay ? null : installmentId,
        "loan_id": loanId,
      };

      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.loanEndpoint}/pay-installment",
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await fetchLoanInstallmentList(loanId: loanId);
      }
    } finally {
      isSubmitInstallmentLoading.value = false;
    }
  }
}
