import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:pakaso_credit/src/presentation/screens/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isNewPasswordVisible = false.obs;
  final RxBool confirmPasswordVisible = false.obs;
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> submitChangePassword() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "current_password": currentPasswordController.text,
        "password": newPasswordController.text,
        "password_confirmation": confirmPasswordController.text,
      };

      final response = await Get.find<NetworkService>().post(
        endpoint: "${ApiPath.profileSettingsEndpoint}/change-password",
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Fluttertoast.showToast(
          msg: response.data!["message"],
          backgroundColor: AppColors.success,
        );
        Get.find<HomeController>().submitLogout();
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
