import 'package:pakaso_credit/src/app/constants/app_colors.dart';
import 'package:pakaso_credit/src/app/routes/routes.dart';
import 'package:pakaso_credit/src/network/api/api_path.dart';
import 'package:pakaso_credit/src/network/response/status.dart';
import 'package:pakaso_credit/src/network/service/network_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class TwoFaController extends GetxController {
  final RxBool isLoading = false.obs;
  late TextEditingController pinCodeController;

  @override
  void onInit() {
    pinCodeController = TextEditingController();
    super.onInit();
  }

  Future<void> submitTwoFaVerification() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {"code": pinCodeController.text};
      final response = await Get.find<NetworkService>().post(
        endpoint: ApiPath.twoFaEndpoint,
        data: requestBody,
      );
      if (response.status == Status.completed) {
        _showToast(response.data!["message"], AppColors.success);
        Get.offAllNamed(BaseRoute.navigation);
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
