import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final RxBool isLoading = false.obs;
  final emailOrUsernameController = TextEditingController();

  Future<void> submitForgotPassword() async {
    isLoading.value = true;
    try {
      final String email = emailOrUsernameController.text.trim();
      final Map<String, dynamic> requestBody = {"email": email};
      final response = await Get.find<NetworkService>().globalPost(
        endpoint: ApiPath.forgotPasswordEndpoint,
        data: requestBody,
      );
      isLoading.value = false;
      if (response.status == Status.completed) {
        final String message = response.data?["message"];
        if (message.isNotEmpty) {
          Get.toNamed(
            BaseRoute.pinCodeVerification,
            arguments: {"email": emailOrUsernameController.text},
          );
          resetField();
          _showToast(message, AppColors.success);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  void resetField() {
    emailOrUsernameController.clear();
  }

  @override
  void onClose() {
    super.onClose();
    emailOrUsernameController.dispose();
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: backgroundColor,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
