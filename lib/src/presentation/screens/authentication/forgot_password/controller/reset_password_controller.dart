import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = true.obs;
  final RxBool isConfirmPasswordVisible = true.obs;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  Future<void> submitResetPassword({
    required String email,
    required String otp,
  }) async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "email": email,
        "otp": otp,
        "password": passwordController.text,
        "password_confirmation": confirmPasswordController.text,
      };
      final response = await Get.find<NetworkService>().globalPost(
        endpoint: ApiPath.resetPasswordEndpoint,
        data: requestBody,
      );
      if (response.status == Status.completed) {
        Get.offNamed(BaseRoute.signIn);
        resetFields();
        _showToast(response.data!["message"], AppColors.success);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: backgroundColor,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void resetFields() {
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
