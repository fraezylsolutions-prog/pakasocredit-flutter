import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/model/beneficiary_details_model.dart';
import 'package:pakaso_credit/src/presentation/screens/fund_transfer/model/beneficiary_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class BeneficiaryController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isBeneficiaryDetailsLoading = false.obs;
  final RxBool isBeneficiaryEditLoading = false.obs;
  final RxBool isBeneficiaryDeleteLoading = false.obs;
  final RxString bankId = "".obs;
  final RxString editBankId = "".obs;
  final RxString bank = "".obs;
  final RxString editBank = "".obs;
  final RxList<BeneficiaryData> beneficiaryList = <BeneficiaryData>[].obs;
  final Rx<BeneficiaryDetailsModel> beneficiaryDetailsModel =
      BeneficiaryDetailsModel().obs;
  final bankController = TextEditingController();
  final editBankController = TextEditingController();
  final accountNumberController = TextEditingController();
  final editAccountNumberController = TextEditingController();
  final nameOnAccountController = TextEditingController();
  final editNameOnAccountController = TextEditingController();
  final branchNameController = TextEditingController();
  final editBranchNameController = TextEditingController();
  final nickNameController = TextEditingController();
  final editNickNameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchBeneficiary();
  }

  Future<void> fetchBeneficiary() async {
    isLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: ApiPath.beneficiaryEndpoint,
      );
      if (response.status == Status.completed) {
        final beneficiaryModel = BeneficiaryModel.fromJson(response.data!);
        beneficiaryList.clear();
        beneficiaryList.assignAll(beneficiaryModel.data!);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBeneficiaryDetails({required String beneficiaryId}) async {
    isBeneficiaryDetailsLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.beneficiaryEndpoint}/$beneficiaryId",
      );
      if (response.status == Status.completed) {
        beneficiaryDetailsModel.value = BeneficiaryDetailsModel();
        beneficiaryDetailsModel.value = BeneficiaryDetailsModel.fromJson(
          response.data!,
        );
      } else {
        beneficiaryDetailsModel.value = BeneficiaryDetailsModel();
      }
    } finally {
      isBeneficiaryDetailsLoading.value = false;
    }
  }

  Future<void> deleteBeneficiary({required String beneficiaryId}) async {
    isBeneficiaryDeleteLoading.value = true;
    try {
      final response = await Get.find<NetworkService>().delete(
        endpoint: "${ApiPath.beneficiaryEndpoint}/$beneficiaryId",
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        await fetchBeneficiary();
      }
    } finally {
      isBeneficiaryDeleteLoading.value = false;
    }
  }

  Future<void> createNewBeneficiary() async {
    try {
      final Map<String, String> requestBody = {
        "bank_id": bankId.value,
        "account_name": nameOnAccountController.text,
        "account_number": accountNumberController.text,
        "branch_name": branchNameController.text,
        "nick_name": nickNameController.text,
      };
      final response = await Get.find<NetworkService>().post(
        endpoint: ApiPath.beneficiaryEndpoint,
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        clearFields();
        await fetchBeneficiary();
      } else {
        clearFields();
      }
    } finally {}
  }

  Future<void> updateBeneficiary({required String beneficiaryId}) async {
    try {
      final Map<String, String> requestBody = {
        "bank_id": editBankId.value,
        "account_name": editNameOnAccountController.text,
        "account_number": editAccountNumberController.text,
        "branch_name": editBranchNameController.text,
        "nick_name": editNickNameController.text,
      };
      final response = await Get.find<NetworkService>().put(
        endpoint: "${ApiPath.beneficiaryEndpoint}/$beneficiaryId",
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        clearEditFields();
        await fetchBeneficiary();
      } else {
        clearEditFields();
      }
    } finally {}
  }

  void clearFields() {
    bankId.value = "";
    bank.value = "";
    bankController.clear();
    nameOnAccountController.clear();
    accountNumberController.clear();
    branchNameController.clear();
    nickNameController.clear();
  }

  void clearEditFields() {
    editBankId.value = "";
    editBank.value = "";
    editBankController.clear();
    editNameOnAccountController.clear();
    editAccountNumberController.clear();
    editBranchNameController.clear();
    editNickNameController.clear();
  }
}
