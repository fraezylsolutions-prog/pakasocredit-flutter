import 'dart:io';

import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/common/controller/confirm_passcode_controller.dart';
import 'package:pakaso_credit/src/common/controller/navigation/navigation_controller.dart';
import 'package:pakaso_credit/src/common/services/settings_service.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/network/service/token_service.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/controller/loan_plan_list_controller.dart';
import 'package:pakaso_credit/src/presentation/screens/loan_plan/model/loan_plan_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class LoanPlanController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isApplyNowLoading = false.obs;
  final RxString siteCurrency = "".obs;
  final RxString gender = "".obs;
  final RxDouble interestAmount = 0.0.obs;
  final RxDouble totalPayableAmount = 0.0.obs;
  final RxDouble perInstallment = 0.0.obs;
  final RxInt selectedCheckbox = (-1).obs;
  final ImagePicker _picker = ImagePicker();
  final amountController = TextEditingController();
  final genderController = TextEditingController();
  final TokenService tokenService = Get.find<TokenService>();
  final RxList<LoanPlanData> loanPlanList = <LoanPlanData>[].obs;
  final RxMap<String, dynamic> formData = <String, dynamic>{}.obs;
  final RxMap<String, File?> selectedImages = <String, File?>{}.obs;
  final ConfirmPasscodeController passcodeController = Get.put(
    ConfirmPasscodeController(),
  );
  final Rx<LoanPlanModel> loanPlanModel = LoanPlanModel().obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await passcodeController.loadPasscodeStatus(
      passcodeType: "loan_passcode_status",
    );
    await loadSiteCurrency();
    await fetchLoanPlans();
    isLoading.value = false;
  }

  Future<void> fetchLoanPlans() async {
    try {
      final response = await Get.find<NetworkService>().get(
        endpoint: "${ApiPath.loanEndpoint}/plans",
      );
      if (response.status == Status.completed) {
        loanPlanModel.value = LoanPlanModel.fromJson(response.data!);
        loanPlanList.clear();
        loanPlanList.assignAll(loanPlanModel.value.data!);
      }
    } finally {}
  }

  Future<void> loadSiteCurrency() async {
    final siteCurrencyValue = await SettingsService.getSettingValue(
      "site_currency",
    );
    siteCurrency.value = siteCurrencyValue ?? "";
  }

  Future<void> submitApplyLoanForm(int loanId) async {
    isApplyNowLoading.value = true;
    try {
      final dioInstance = dio.Dio();
      final formDataPayload = dio.FormData.fromMap({
        'plan_id': loanId,
        "amount": amountController.text,
      });
      formData.forEach((key, value) {
        String fieldKey = 'submitted_data[$key]';
        if (value is File) {
          formDataPayload.files.add(
            MapEntry(
              fieldKey,
              dio.MultipartFile.fromFileSync(
                value.path,
                filename: value.path.split('/').last,
              ),
            ),
          );
        } else if (value != null) {
          formDataPayload.fields.add(MapEntry(fieldKey, value.toString()));
        }
      });

      final response = await dioInstance.post(
        "${ApiPath.baseUrl}${ApiPath.loanEndpoint}/subscribe",
        data: formDataPayload,
        options: dio.Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${tokenService.accessToken.value}',
          },
        ),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: response.data["message"],
          backgroundColor: AppColors.success,
        );
        formData.clear();
        selectedImages.clear();
        amountController.clear();
        Get.find<NavigationController>().pushOffNamed(BaseRoute.loanPlanList);
        final LoanPlanListController loanPlanListController = Get.put(
          LoanPlanListController(),
        );
        await loanPlanListController.fetchLoanPlanLists();
      }
    } finally {
      isApplyNowLoading.value = false;
    }
  }

  Future<void> pickImage(String fieldName, ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedImage != null) {
        selectedImages[fieldName] = File(pickedImage.path);
        formData[fieldName] = File(pickedImage.path);
        Get.back();
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to pick image",
        backgroundColor: AppColors.error,
      );
    }
  }

  void setFormData(String fieldName, dynamic value) {
    formData[fieldName] = value;
  }
}
