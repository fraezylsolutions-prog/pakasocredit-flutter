import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PinCodeVerificationController extends GetxController {
  final RxBool isLoading = false.obs;
  late TextEditingController pinCodeController;

  Future<void> submitPinCodeVerification({required String email}) async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "otp": pinCodeController.text,
        "email": email,
      };
      final response = await Get.find<NetworkService>().globalPost(
        endpoint: ApiPath.resetVerifyOtpEndpoint,
        data: requestBody,
      );
      if (response.status == Status.completed) {
        _showToast(response.data!["message"], AppColors.success);
        Get.offNamed(
          BaseRoute.resetPassword,
          arguments: {"email": email, "otp": pinCodeController.text},
        );
        pinCodeController.clear();
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
}
